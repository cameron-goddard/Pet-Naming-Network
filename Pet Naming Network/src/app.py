import os
import json
from datetime import datetime
from db import db, Pets, Names, Users, State
from flask import Flask, request 

app = Flask(__name__)

db_filename = "pet_naming_network.db"


db.init_app(app)
with app.app_context():
    db.create_all()

def success_response(data, code = 200):
    return json.dumps(data), code 


def failure_response(message, code = 404):
    return json.dumps( {"error":message} ), code 

# get all nameable pets
@app.route("/home/naming/")
def get_nameable_pets():
    pets = Pets.query.filter_by( state = State.Naming ) 

    if pets is None:
        return failure_response("No pets to name!")

    return success_response(pets.serialize())


# upload your own pets 
@app.route("/home/uploading/", methods = ["POST"])
def upload_pet():
    pass 

# add a name to a pet 
@app.route("/home/naming/", methods = ["POST"])
def upload_name():
    pass

# voting on names
@app.route("/home/voting/", methods = ["POST"])
def vote():
    pass 

# create an account 
@app.route("/home/account/", methods = ["POST"])
def create_account():
    pass

# log in to the app
@app.route("/home/login/", methods = ["POST"])
def login():
    pass
