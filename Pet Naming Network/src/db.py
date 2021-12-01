from enum import Enum
from flask_sqlalchemy import SQLAlchemy
db = SQLAlchemy()


class State(Enum):
    NAMING = 1
    VOTING = 2
    FEATURED = 3


# PET table 

class Pet(db.Model):

    __tablename__ = "pet"

    id = db.Column(db.Integer, primary_key=True)
    state = db.Column(db.Integer, nullable=False)
    picture = db.Column(db.String, nullable=False)
    user = db.Column(db.Integer, db.ForeignKey("user.id"))
    names = db.relationship( "Names", cascade = "delete" )
    date_created = db.Column(db.Integer, nullable=False)

    def __init__(self, **kwargs):

        self.state = State.NAMING
        self.picture = kwargs.get("picture")
        self.user = kwargs.get("user")
        self.date_created = kwargs.get("date_created")

    def serialize(self):

        return {
            "id": self.id,
            "state": self.state,
            "picture": self.picture,
            "user": self.user,
            "names": [s.sub_serialize() for s in self.names],
            "date_created": self.date_created
        }
    
    def sub_serialize(self):
        return {
            "id": self.id,
            "state": self.state,
            "picture": self.picture,
            "names": [s.serialize() for s in self.names],
            "date_created": self.date_created
        }

# USER table


class Users(db.Model):

    __tablename__ = "user"

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String, nullable=False)
    pets = db.relationship("Pet", cascade = "delete")
    names = db.relationship("Names", cascade = "delete")

    def __init__(self, **kwargs):

        self.username = kwargs.get("username")

    def serialize(self):
        return {
            "id":self.id,
            "username":self.username,
            "pets": [s.sub_serialize for s in self.pets],
            "names": [s.serialize for s in self.names]
        }


# NAME table

class Names(db.Model):

    __tablename__ = "name"

    id = db.Column(db.Integer, primary_key = True)
    name = db.Column(db.String, nullable = False)
    pet = db.Column(db.Integer, db.ForeignKey("pet.id"))
    votes = db.Column( db.ARRAY(db.Integer, dimensions = 2), nullable = False )
    user = db.Column(db.Integer, db.ForeignKey("user.id"))

    def __init__(self, **kwargs):
        self.name = kwargs.get("name")
        self.pet = kwargs.get("pet")
        self.votes = [0, 0]

    def serialize(self):
        return {
            "id":self.id,
            "name":self.name,
            "pet":self.pet,
            "votes":self.votes
        }

    def sub_serialize(self):
        return {
            "id":self.id,
            "name":self.name,
            "votes":self.votes
        }
        