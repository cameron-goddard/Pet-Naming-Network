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


@app.route("/home/naming/<int:pet_id>/", methods=["POST"])
def upload_name():
    pass
    # get pet 

    # get name you're adding (body)

    # add to name with name, pet

    # if pet names == 3, then change state VOTING


# voting on names


@app.route("/home/voting/<int:pet_id>/", methods=["POST"])
def vote():
    pass

    # get pet 

    # get name you're voting for (body)

    # update name[vote]

    # if name[vote] >= 3, change state to FEATURED

# create an account


@app.route("/home/account/", methods=["POST"])
def create_account():
    pass

    # get name (from body)

    # check that it doesn't exist already 

    # add to Users table 

    # set as true 

# log in to the app


@app.route("/home/login/", methods=["POST"])
def login():
    pass

    # get user (body)

    # check user exists

    # check if someone is already logged in
        # set them to false 

    # set user to current 

# Get the next votable pet
# Its names will be part of the success response


@app.route("/home/voting/", methods=["GET"])
def getvotable():
    # TODO: change to be consistent wih current name
    notmypets = Pet.query.filter(Pet.user != 0).all()
    pet = notmypets.query.filter_by(state=State.VOTING).first()
    # ^^ Not sure if this works
    if (pet == None):
        return failure_response("There are no nameable pets at this time.")
    return success_response(pet.serialize(), 201)

# Get the pets you have contributed


@app.route("/home/account/pets/", methods=["GET"])
def getmypets():
    return success_response(
        {"Your Pets": [p.serialize()
                       for p in Pet.query.filter_by(user=0).all()]}
        # TODO change this to work with current user
    )

# Get the names you have contributed


@app.route("/home/account/names/", methods=["GET"])
def getmynames():
    return success_response(
        {"Your Names": [n.serialize()
                        for n in Names.query.filter_by(user=0).all()]}
        # TODO change this to work with current user
    )

# Get featured pets 


@app.route("/home/", methods=["GET"])
def getfeaturedpets():
    return success_response(
        {"Featured Pets":
         [p.serialize()
          for p in Pet.query.filter_by(state=State.FEATURED).all()]}
    )


############### PET INFORMATION