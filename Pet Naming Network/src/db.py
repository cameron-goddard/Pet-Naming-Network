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
    state = db.Column(db.Integer, nullable=False)
    pic_id = db.Column(db.Integer, db.ForeignKey("asset.id"))
    user = db.Column(db.Integer, db.ForeignKey("user.id"))
    names = db.relationship("Names", cascade="delete")
    date_created = db.Column(db.Integer, nullable=False)

    def __init__(self, **kwargs):

        self.state = State.NAMING
        # Make sure this matches with pic creation
        self.pic_id = kwargs.get("picture")
        self.user = kwargs.get("user")
        self.date_created = kwargs.get("date_created")

    def serialize(self):

        return {
            "id": self.id,
            "state": self.state,
            "pic": Asset.query.filter_by(id=self.pic_id).first().getURL(),
            "user": self.user,
            "names": [s.sub_serialize() for s in self.names],
            "date_created": self.date_created
        }

    def sub_serialize(self):
        return {
            "id": self.id,
            "state": self.state,
            "pic": Asset.query.filter_by(id=self.pic_id).first().getURL(),
            "names": [s.serialize() for s in self.names],
            "date_created": self.date_created
        }

# USER table


class Users(db.Model):

    __tablename__ = "user"

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String, nullable=False)
    pets = db.relationship("Pet", cascade="delete")
    names = db.relationship("Names", cascade="delete")
    current = db.Column(db.Boolean, nullable=False)

    def __init__(self, **kwargs):
        self.username = kwargs.get("username")
        self.current = False

    def serialize(self):
        return {
            "id": self.id,
            "username": self.username,
            "pets": [s.sub_serialize for s in self.pets],
            "names": [s.serialize for s in self.names],
            "current":self.current
        }


# NAME table

class Names(db.Model):

    __tablename__ = "name"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    pet = db.Column(db.Integer, db.ForeignKey("pet.id"))
    votes = db.Column(db.ARRAY(db.Integer, dimensions=2), nullable=False)
    user = db.Column(db.Integer, db.ForeignKey("user.id"))

    def __init__(self, **kwargs):
        self.name = kwargs.get("name")
        self.pet = kwargs.get("pet")
        self.votes = [0, 0]

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
