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
    pets = Pet.query.filter_by(state=State.Naming)

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

@app.route("/home/naming/<int:pet_id>/", methods=["POST"])
def upload_name(pet_id):

    body = json.loads(request.data)

    name = body.get("name")
    pet = Pet.query.filter_by(id = pet_id).first()

    if name is None: return failure_response("Please provide a name.", 400)

    name = Names( name = name, pet = pet_id )

    pet.names.append(name)

    db.session.add(name)
    db.session.commit()

    return success_response(name.serialize(), 201)


# voting on names

#@app.route("/home/voting/<int:pet_id>/", methods=["POST"])
#def vote(pet_id):

#    body = json.loads(request.data)

#    name = body.get("name")

#    pet = Pet.query.filter_id(id = pet_id).first()
#    if pet is None: return failure_response("Pet not found!", 404)

    # increment name by one 



# create an account


@app.route("/home/account/", methods=["POST"])
def create_account():

    body = json.loads(request.data)
    username = body.get("username")

    if(username is None): return failure_response("Please provide a username.", 400)

    already_exists = Users.query.filter_by( username = username ).first()
    if already_exists is not None: return failure_response("A user by this name already exists.", 400)

    new_user = Users( username = username )
    db.session.add(new_user)
    db.session.commit()

    return success_response(new_user.serialize(), 201)


# log in to the app

@app.route("/home/login/", methods=["POST"])
def login():
    
    body = json.loads(request.data)
    username = body.get("username")
    current_user = Users.query.filter_by( username = username ).first()

    if current_user is None: return failure_response("User not found.", 404)

    # TODO: how do we want to store current_user? 


########### FRONTEND 

# Get names based on pet_id

# Get a user based on a pet id

# Get pets where state == names and User != current_user 

# Get pets where state == voting and User != current user 

# Get pets where user == current user and get names with user == current user 

# Get pet's image