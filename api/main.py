from flask import Flask
from flask import render_template, request, flash, redirect, url_for, session, jsonify, send_from_directory
from flask_sqlalchemy import SQLAlchemy
import time
from datetime import datetime
import config
import hashlib
import random
import string
import os
from dataclasses import dataclass
import werkzeug


UPLOAD_FOLDER = 'uploads'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}

app = Flask(__name__)
app.config['SECRET_KEY'] = config.secret_key
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///todo.db'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
db = SQLAlchemy(app)

@dataclass
class User(db.Model):
    id: int
    user_id: str
    username: str
    points: int

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

@dataclass
class News(db.Model):
    id: int
    title: str
    text: str
    image: str
    timestamp: datetime

    id = db.Column(db.Integer, primary_key = True)
    title = db.Column(db.String(20))
    text = db.Column(db.String(400))
    image = db.Column(db.String(64))
    timestamp = db.Column(db.DateTime(timezone=True), default=datetime.utcnow)

@dataclass
class Upload(db.Model):
    id: int
    title: str
    timestamp: datetime

    id = db.Column(db.Integer, primary_key = True)
    title = db.Column(db.String(20))
    timestamp = db.Column(db.DateTime(timezone=True), default=datetime.utcnow)

@app.route('/', methods = ['GET'])
def index():
    map = Map.query.all()
    return jsonify(map)

@app.route('/user/', methods = ['GET'])
def user():
    user = User.query.filter_by(user_id = request.args.get('user_id')).first()
    return jsonify(user)

@app.route('/news', methods = ['GET'])
def news():
    news = News.query.order_by(News.timestamp.asc()).limit(10).all()
    return jsonify(news)

@app.route('/img/<path:filename>')
def send_file(filename):
    return send_from_directory(UPLOAD_FOLDER, filename)

@app.route('/upload', methods = ['GET', 'POST'])
def upload():
    imagefile = request.files['image']
    filename = werkzeug.utils.secure_filename(imagefile.filename)
    print("\nReceived image File name : " + imagefile.filename)
    imagefile.save(os.path.join("uploads", filename))
    return "Image Uploaded Successfully"

if __name__ == '__main__':
	db.create_all()
	app.run(host="0.0.0.0",port = "5000", debug=True)
