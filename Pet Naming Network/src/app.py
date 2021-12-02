import os
import json
from datetime import datetime
from db import db, Pet, Names, Users, State, Asset
from flask import Flask, request

app = Flask(__name__)

db_filename = "pet_naming_network.db"


db.init_app(app)
with app.app_context():
    db.create_all()
    anonuser = Users(username="Anonymous")
    # Not sure if this works at all


def success_response(data, code=200):
    return json.dumps(data), code


def failure_response(message, code=404):
    return json.dumps({"error": message}), code

# get all nameable pets


@app.route("/home/naming/")
def get_nameable_pets():
    pets = Pet.query.filter_by(state=State.Naming)

    if pets is None:
        return failure_response("No pets to name!")

    return success_response(pets.serialize())


# upload your own pets
@app.route("/home/uploading/", methods=["POST"])
def upload_pet():
    body = json.loads(request.data)
    user = body.get("user")
    time = datetime.datetime.today()

    image_data = body.get("image_data")  # This should be a base64 url
    if image_data is None:
        return failure_response("No base64 URL found!")
    asset = Asset(image_data=image_data)
    db.session.add(asset)
    # THIS should be an id for a picture
    pic_id = asset.getID

    if (user == None):
        user = 0
    new_pet = Pet(pic_id=pic_id, user=user, time=time)
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
