from enum import Enum
from flask_sqlalchemy import SQLAlchemy
db = SQLAlchemy()


class State(Enum):
    NAMING = 1
    VOTING = 2
    FEATURED = 3


user_pets_association_table = db.Table(
    "user_pets_association",
    db.Model.metadata,
    db.Column("user_id", db.Integer, db.ForeignKey("user.id")),
    db.Column("name_id", db.Integer, db.ForeignKey("name.id"))
)

pets_names_association_table = db.Table(
    "pets_names_association",
    db.Model.metadata,
    db.Column("pet_id", db.Integer, db.ForeignKey("pet.id")),
    db.Column("name_id", db.Integer, db.ForeignKey("user.id"))
)


# PET table

class Pet(db.Model):

    __tablename__ = "pet"

    id = db.Column(db.Integer, primary_key=True)
    state = db.Column(db.Integer, nullable=False)
    picture = db.Column(db.String, nullable=False)
    user = db.Column(db.Integer, db.ForeignKey("user.id"))
    # names = db.Column( db.String, nullable = False )
    date_created = db.Column(db.Integer, nullable=False)

    def __init__(self, **kwargs):

        self.state = State.NAMING
        self.picture = kwargs.get("picture")
        self.user = kwargs.get("user")
        # self.names =
        self.date_created = kwargs.get("date_created")

    def serialize(self):

        return {

            "id": self.id,
            "state": self.state,
            "picture": self.picture,
            "user": self.user,
            # TODO: ^^^ Once we make the user table change this to subserialize
            "date_created": self.date_created

        }


# USER table


class Users(db.Model):

    __tablename__ = "user"

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String, nullable=False)
    pets = db.Column(db.Integer, db.ForeignKey("pet.id"))


# NAME table

class Names(db.Model):

    __tablename__ = "name"
