import os
import json
from datetime import datetime
from db import db, Pet, Names, Users, State, Asset
from flask import Flask, request
from sqlalchemy import func

app = Flask(__name__)

db_filename = "pet_naming_network.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()
    anonuser = Users(username="Anonymous")
    # Not sure if this works at all


def success_response(data, code=200):
    return json.dumps(data), code


def failure_response(message, code=404):
    return json.dumps({"error": message}), code


VOTE_CAP = 10
NAME_CAP = 3

# upload your own pets


@app.route("/home/uploading/", methods=["POST"])
def upload_pet():
    body = json.loads(request.data)
    user = Users.query.filter_by(logged_in=True).first()
    time = datetime.today()

    image_data = body.get("image_data")  # This should be a base64 url
    if image_data is None:
        return failure_response("No base64 URL found!")
    asset = Asset(image_data=image_data)
    db.session.add(asset)
    db.session.commit()
    # THIS should be an id for a picture
    pic_id = asset.getID()
    user_id = 1
    if (user != None):
        user_id = user.getID()
    print("1")
    new_pet = Pet(pic_id=pic_id, user=user_id, time=time)
    print("2")
    db.session.add(new_pet)
    print("3")
    db.session.commit()
    print("4")
    return success_response(new_pet.serialize(), 201)


# add a name to a pet

@app.route("/home/naming/<int:pet_id>/", methods=["POST"])
def upload_name(pet_id):
    pet = Pet.query.filter_by(pet_id=pet_id)

    body = json.loads(request.data)
    name = body.get("name")

    if not name:
        return failure_response("No name recieved.", 400)

    current_user = Users.query.filter_by(logged_in=True)

    if not current_user:
        return failure_response("Please log in to upload a name.", 400)
        #current_user = "anonymous"

    name = Names(name=name, pet=pet_id,
                 user=current_user.serialize().get("id"))
    current_user.names.append(name)
    pet.names.append(name)

    if(len(pet.serialize().get("names")) >= NAME_CAP):
        pet.update_state(state=State.VOTING)

    db.session.add(name)
    db.session.commit()

    return success_response(name.serialize(), 201)


# get most popular name based on pet_id
@app.route("/home/<int:pet_id>/popular/", methods=["GET"])
def most_popular_name(pet_id):
    names = Names(pet=pet_id).all()
    top_name = names.query(func.max(Names.votes)).first()
    return success_response(top_name.serialize())


# voting on names

@app.route("/home/voting/<int:pet_id>/", methods=["POST"])
def vote(pet_id):
    pet = Pet.query.filter_by(pet_id=pet_id)

    body = json.loads(request.data)
    name_id = body.get("name_id")
    
    if not name_id:
        return failure_response("Name not given.", 500)

    name = Names.query.filter_by(id=name_id)
    if not name:
        return failure_response("Name not found.", 500)

    name.update_vote()
    pet.update_vote()

    # get most voted pet names

    if(pet.get_votes() >= VOTE_CAP):

        pet_names = Names.query.filter_by(pet=pet_id).all()
        top_name = pet_names.query(func.max(Names.votes))
        same_votes = pet_names.query.filter_by(
            votes=top_name.sub_serialize().get("votes"))

        if(len(same_votes) == 1):
            pet.update_state(state=State.FEATURED)

    return success_response(pet.serialize(), 201)


# Get pet names from pet id


@app.route("/home/<int:pet_id>/names/", methods=["GET"])
def get_pet_names(pet_id):

    names = Names(pet=pet_id).all()

    return success_response([n.serialize() for n in names])

# Get user from pet id


@app.route("/home/<int:pet_id>/user/")
def get_user_from_pet(pet_id):

    pet = Pet.query.filter_by(id=pet_id)
    user_id = pet.serialize().get("user")
    user = Users.query.filter_by(id=user_id)
    return success_response(user.serialize())

# create an account


@app.route("/home/account/", methods=["POST"])
def create_account():
    body = json.loads(request.data)
    username = body.get("username")

    if username is None:
        return failure_response("Please provide a username.")

    already_exists = Users.query.filter_by(username=username).all()
    if len(already_exists) != 0:
        return failure_response("this already exists", 400)

    new_user = Users(username=username)

    db.session.add(new_user)
    db.session.commit()

    return success_response(new_user.serialize(), 201)


# log in to the app


@app.route("/home/login/", methods=["POST"])
def login():
    body = json.loads(request.data)
    username = body.get("username")

    if not username:
        return failure_response("Please provide your username.")

    login_user = Users.query.filter_by(username=username).first()
    if login_user is None:
        return failure_response("User not found. Please create an account.", 400)

    current_user = Users.query.filter_by(logged_in=True).first()
    if current_user:
        current_user.logout()

    login_user.login()

    return success_response(login_user.serialize())


# Get the next nameable pet
# Its names will be part of the success response


@app.route("/home/naming/")
def get_nameable_pet():
    current_user = Users.query.filter_by(logged_in=True)
    pets = Pet.query.filter_by(
        Pet.state == State.NAMING and Pet.user != current_user.getID())

    if pets is None:
        return failure_response("There are no pets to name at this time.")

    return success_response(pets.serialize())

# Get the next votable pet
# Its names will be part of the success response


@app.route("/home/voting/", methods=["GET"])
def getvotable():
    current_user = Users.query.filter_by(logged_in=True).first()
    if current_user == None:
        return failure_response("Please create an account to vote on pets!")
    pet = Pet.query.filter_by(
        state=State.VOTING and Pet.user != current_user.getID())

    if (pet == None):
        return failure_response("There are no pets to vote on at this time.")

    return success_response(pet.serialize())

# Get the pets you have contributed


@app.route("/home/account/pets/", methods=["GET"])
def getmypets():
    current_user = Users.query.filter_by(logged_in=True)
    if not current_user:
        return failure_response("Please log in.", 400)

    pets = Pet.query.filter_by(user=current_user.getID()).all()

    if (pets is None):
        return failure_response("You haven't created any pets yet!")

    return success_response(
        {"Your Pets": [p.sub_serialize() for p in pets]}
    )


# Get the names you have contributed

@app.route("/home/account/names/", methods=["GET"])
def getmynames():
    current_user = Users.query.filter_by(logged_in=True)
    if not current_user:
        return failure_response("Please log in.", 400)

    names = Names.query.filter_by(user=current_user.getID()).all()

    if (names is None):
        return failure_response("You haven't named any pets yet!")

    return success_response(
        {"Your Names": [n.sub_serialize() for n in names]}
    )

# Get featured pets


@app.route("/home/", methods=["GET"])
def getfeaturedpets():
    return success_response(
        {"Featured Pets":
         [p.serialize()
          for p in Pet.query.filter_by(state=State.FEATURED).all()]}
    )


@app.route("/reset/")
def reset():
    db.drop_all()
    db.create_all()
    return success_response("yes")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
