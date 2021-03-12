from flask import Flask
from flask import render_template, request, flash, redirect, url_for, session, jsonify
from flask_sqlalchemy import SQLAlchemy
import time
from datetime import datetime
import config
import hashlib
import random
import string
import os
from dataclasses import dataclass

UPLOAD_FOLDER = 'uploads'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}

app = Flask(__name__)
app.config['SECRET_KEY'] = config.secret_key
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///todo.db'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
db = SQLAlchemy(app)

class User(db.Model):
    id = db.Column(db.Integer, primary_key = True)
    user_id = db.Column(db.String(40))
    username = db.Column(db.String(30))
    points = db.Column(db.Integer, default = 0)

@dataclass
class Map(db.Model):
    id: int
    x: int
    y: int
    count: int

    id = db.Column(db.Integer, primary_key = True)
    x = db.Column(db.Integer)
    y = db.Column(db.Integer)
    count = db.Column(db.Integer)

@app.route('/', methods = ['GET'])
def index():
    map = Map.query.all()
    return jsonify(map)

if __name__ == '__main__':
	db.create_all()
	app.run(host="0.0.0.0",port = "5000", debug=True)
