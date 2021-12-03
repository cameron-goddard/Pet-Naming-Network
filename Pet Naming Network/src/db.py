import string
import re
import random
from PIL import Image
import os
from mimetypes import guess_extension, guess_type
from io import BytesIO
import datetime
import boto3
import base64
from enum import Enum
from flask_sqlalchemy import SQLAlchemy
db = SQLAlchemy()
# Image relevant stuff


class State(Enum):
    NAMING = 1
    VOTING = 2
    FEATURED = 3


def e2s(s):
    if s == State.NAMING:
        return "State.NAMING"
    elif s == State.VOTING:
        return "State.VOTING"
    elif s == State.FEATURED:
        return "State.FEATURED"
    else:
        return s


# Adapted from Michael Cho
# Source: https://michaelcho.me/article/using-python-enums-in-sqlalchemy-models
class IntEnum(db.TypeDecorator):
    """
    Enables passing in a Python enum and storing the enum's *value* in the db.
    The default would have stored the enum's *name* (ie the string).
    """
    impl = db.Integer

    def __init__(self, enumtype, *args, **kwargs):
        super(IntEnum, self).__init__(*args, **kwargs)
        self._enumtype = enumtype

    def process_bind_param(self, value, dialect):
        if isinstance(value, int):
            return value

        return value.value

    def process_result_value(self, value, dialect):
        return self._enumtype(value)


# More image stuff
EXTENSIONS = ["png", "gif", "jpg", "jpeg"]
BASE_DIR = os.getcwd()
S3_BUCKET = "ncb48demo2"  # We just gonna use my demo bucket to do this ok.
# It's very insecure so when this app becomes a global phenomenon we will need
# a different bucket
S3_BASE_URL = f"https://{S3_BUCKET}.s3-us-east-2.amazonaws.com"


# PET table

class Pet(db.Model):

    __tablename__ = "pet"

    id = db.Column(db.Integer, primary_key=True)
    state = db.Column(IntEnum(State), nullable=False)
    pic_id = db.Column(db.Integer, db.ForeignKey("asset.id"))
    user = db.Column(db.Integer, db.ForeignKey("user.id"))
    names = db.relationship("Names", cascade="delete")
    date_created = db.Column(db.Integer, nullable=False)
    voted = db.Column(db.Integer, nullable=False)

    def __init__(self, **kwargs):

        self.state = State.NAMING
        self.pic_id = kwargs.get("pic_id")
        self.user = kwargs.get("user")
        self.date_created = kwargs.get("time")
        self.voted = 0

    def serialize(self):

        return {
            "id": self.id,
            "state": e2s(self.state),
            "pic": Asset.query.filter_by(id=self.pic_id).first().getURL(),
            "user": self.user,
            "names": [s.sub_serialize() for s in self.names],
            "date_created": self.date_created
        }

    def sub_serialize(self):
        return {
            "id": self.id,
            "state": e2s(self.state),
            "pic": Asset.query.filter_by(id=self.pic_id).first().getURL(),
            "names": [s.serialize() for s in self.names],
            "date_created": self.date_created
        }

    def update_state(self, state):
        self.state = state

    def update_vote(self):
        self.voted = self.voted + 1

    def get_votes(self):
        return self.voted

# USER table


class Users(db.Model):

    __tablename__ = "user"

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String, nullable=False)
    pets = db.relationship("Pet", cascade="delete")
    names = db.relationship("Names", cascade="delete")
    logged_in = db.Column(db.Boolean, nullable=False)

    def __init__(self, **kwargs):
        self.username = kwargs.get("username")
        self.logged_in = False

    def serialize(self):
        return {
            "id": self.id,
            "username": self.username,
            "pets": [s.sub_serialize for s in self.pets],
            "names": [s.serialize for s in self.names],
            "logged_in": self.logged_in
        }

    def login(self):
        self.logged_in = True

    def logout(self):
        self.logged_in = False

    def getID(self):
        return self.id


# NAME table

class Names(db.Model):

    __tablename__ = "name"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    pet = db.Column(db.Integer, db.ForeignKey("pet.id"))
    # db.Column(db.ARRAY(db.Integer, dimensions=2), nullable=False)
    votes = db.Column(db.Integer, nullable=False)
    user = db.Column(db.Integer, db.ForeignKey("user.id"))

    def __init__(self, **kwargs):
        self.name = kwargs.get("name")
        self.pet = kwargs.get("pet")
        self.votes = 0
        self.user = kwargs.get("user")

    def serialize(self):
        return {
            "id": self.id,
            "name": self.name,
            "pet": self.pet,
            "votes": self.votes
        }

    def sub_serialize(self):
        return {
            "id": self.id,
            "name": self.name,
            "votes": self.votes
        }

    def update_vote(self):
        self.votes = self.votes+1

    def get_votes(self):
        return self.votes

# Image class
# For all the random details images have, they should have their own table.


class Asset(db.Model):
    __tablename__ = "asset"

    id = db.Column(db.Integer, primary_key=True)
    base_url = db.Column(db.String, nullable=True)
    salt = db.Column(db.String, nullable=False)
    extension = db.Column(db.String, nullable=False)
    width = db.Column(db.Integer, nullable=False)
    height = db.Column(db.Integer, nullable=False)
    created_at = db.Column(db.DateTime, nullable=False)

    def __init__(self, **kwargs):
        self.create(kwargs.get("image_data"))

    def getURL(self):
        return f"{self.base_url}/{self.salt}.{self.extension}"

    def getID(self):
        return self.id

    def serialize(self):
        return {
            "url": self.getURL,
            "created_at": str(self.created_at),
        }

    def create(self, image_data):
        try:
            ext = guess_extension(guess_type(image_data)[0])[1:]
            if ext not in EXTENSIONS:
                raise Exception(f"Extension {ext} not supported!")

            salt = "".join(
                random.SystemRandom().choice(
                    string.ascii_uppercase + string.digits
                )
                for _ in range(16)
            )

            # Remove header of base64 string and open image
            img_str = re.sub("^data:image/.+;base64,", "", image_data)
            img_data = base64.b64decode(img_str)
            img = Image.open(BytesIO(img_data))

            self.base_url = S3_BASE_URL
            self.salt = salt
            self.extension = ext
            self.width = img.width
            self.height = img.height
            self.created_at = datetime.datetime.now()

            img_filename = f"{salt}.{ext}"
            self.upload(img, img_filename)
        except Exception as e:
            print(f"Unable to create image due to {e}")

    def upload(self, img, img_filename):
        try:
            # Save image temporarily on server
            img_temploc = f"{BASE_DIR}/{img_filename}"
            img.save(img_temploc)

            s3_client = boto3.client("s3")
            s3_client.upload_file(img_temploc, S3_BUCKET, img_filename)

            s3_resource = boto3.resource("s3")
            object_acl = s3_resource.ObjectAcl(S3_BUCKET, img_filename)
            object_acl.put(ACL="public-read")
        except Exception as e:
            print(f"Unable to upload image due to {e}")
