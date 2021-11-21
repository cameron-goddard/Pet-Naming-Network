import os
import json
from datetime import datetime
from db import db, Pet, Names, Users, State
from flask import Flask, request

app = Flask(__name__)

db_filename = "pet_naming_network.db"


db.init_app(app)
with app.app_context():
    db.create_all()


def success_response(data, code=200):
    return json.dumps(data), code


def failure_response(message, code=404):
    return json.dumps({"error": message}), code

# get all nameable pets


@app.route("/home/naming/")
def get_nameable_pets():
    pets = Pets.query.filter_by(state=State.Naming)

    if pets is None:
        return failure_response("No pets to name!")

    return success_response(pets.serialize())


# upload your own pets
@app.route("/home/uploading/", methods=["POST"])
def upload_pet():
    body = json.loads(request.data)
    picture = body.get("picture")  # Will change this from a string eventually
    # vv Should autofill unless the user is using the app for the first time
    user = body.get("user")
    time = datetime.datetime.today()
    if (picture == None):
        return failure_response("Picture required!")
    elif (user == None):
        user = 0
        # TODO: I was thinking that if people want to submit pets / names
        # anonymously then we could have index 0 of the user table always be
        # "anonymous"
    new_pet = Pet(picture=picture, user=user, time=time)
    db.session.add(new_pet)
    db.session.commit()
    return success_response(new_pet.serialize(), 201)

# add a name to a pet


@app.route("/home/naming/", methods=["POST"])
def upload_name():
    pass

# voting on names


@app.route("/home/voting/", methods=["POST"])
def vote():
    pass

# create an account


@app.route("/home/account/", methods=["POST"])
def create_account():
    pass

# log in to the app


@app.route("/home/login/", methods=["POST"])
def login():
    pass
