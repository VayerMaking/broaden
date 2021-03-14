from flask import Flask
from flask import render_template, request, flash, redirect, url_for, session, jsonify, send_from_directory
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import relationship
import time
from datetime import datetime
import config
import hashlib
import random
import string
import os
from dataclasses import dataclass
import werkzeug
import requests
import isanimal

UPLOAD_FOLDER = 'uploads'
APP_IMAGES_FOLDER = 'app_images'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}

app = Flask(__name__)
app.config['SECRET_KEY'] = config.secret_key
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///todo.db'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
db = SQLAlchemy(app)

@dataclass
class User(db.Model):
    id: int
    #user_id: str
    #email: str
    points: int
    verified: bool
    author_email: str
    author_id: str
    name: str

    id = db.Column(db.Integer, primary_key = True)
    #user_id = db.Column(db.String(40))
    #email = db.Column(db.String(50))
    points = db.Column(db.Integer, default = 0)
    verified = db.Column(db.Boolean, default = False)
    author_id = db.Column(db.String(50))
    author_email = db.Column(db.String(50))
    name = db.Column(db.String(20))

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
    filename: str
    timestamp: datetime
    lat: str
    log: str
    verified: bool
    author_email: str
    author_id: str
    classified_as: str

    id = db.Column(db.Integer, primary_key = True)
    filename = db.Column(db.String(64))
    timestamp = db.Column(db.DateTime(timezone=True), default=datetime.utcnow)
    lat = db.Column(db.String(20))
    log = db.Column(db.String(20))
    verified = db.Column(db.Boolean, default = False)
    author_email = db.Column(db.String(50))
    author_id = db.Column(db.String(30))
    classified_as = db.Column(db.String(40))

@app.route('/', methods = ['GET'])
def index():
    map = Map.query.all()
    return jsonify(map)

@app.route('/user/', methods = ['GET'])
def user():
    user = User.query.filter_by(author_id = request.args.get('user_id')).all()
    return jsonify(user)

@app.route('/news', methods = ['GET'])
def news():
    news = News.query.order_by(News.timestamp.asc()).limit(10).all()
    return jsonify(news)

@app.route('/img/<path:filename>')
def send_file(filename):
    return send_from_directory(APP_IMAGES_FOLDER, filename)

@app.route('/verify_img/<path:filename>')
def verify_img_send_file(filename):
    return send_from_directory(UPLOAD_FOLDER, filename)

@app.route('/upload', methods = ['GET', 'POST'])
def upload():
    imagefile = request.files['image']
    lat  = request.form.get('lat')
    log  = request.form.get('log')
    author_email  = request.form.get('user_email')
    author_id  = request.form.get('user_id')
    print(lat, log)
    filename = werkzeug.utils.secure_filename(imagefile.filename)
    print("\nReceived image File name : " + imagefile.filename)
    file_extension = os.path.splitext(filename)[1]
    new_filename = random_string(64) #+ file_extension
    imagefile.save(os.path.join("uploads", new_filename))

    upload = Upload(filename = new_filename, lat = lat, log = log, author_email = author_email, author_id = author_id)

    db.session.add(upload)
    db.session.commit()

    redirection(new_filename)

    return "Image Uploaded Successfully"

@app.route('/verify', methods = ['GET', 'POST'])
def verify():
	uploads = Upload.query.filter_by(verified = False).all()
	return render_template("verify.html", uploads=uploads)

@app.route('/verify/<path:filename>', methods = ['GET', 'POST'])
def verify_upload(filename):
    upload = Upload.query.filter_by(filename = filename).first()
    user = User.query.filter_by(author_id = upload.author_id).first()
    user.points += 1
    upload.verified = True
    db.session.add(user)
    db.session.add(upload)
    db.session.commit()
    return redirect('/verify')

@app.route('/set_user_id', methods = ['GET', 'POST'])
def set_user_id():
    user_id  = request.form.get('user_id')
    user = User.query.filter_by(user_id = user_id).first()
    return jsonify(user)

@app.route('/leaderboard', methods = ['GET', 'POST'])
def leaderboard():
    users = User.query.order_by(User.points.desc()).all()

    return jsonify(users)

@app.route('/app_image/<path:filename>')
def send_app_image(filename):
    return send_from_directory(APP_IMAGES_FOLDER, filename)

@app.route('/classify/<path:filename>', methods = ['GET'])
def classify(filename):
    res = isanimal.run(filename)
    upload = Upload.query.filter_by(filename = filename).first()
    if res == 1:
        upload.classified_as = "Others"
    elif res == 0:
        upload.classified_as = "Animals"

    db.session.add(upload)
    db.session.commit()

    return "success"

def redirection(new_filename):
    redirect_to = "http://0.0.0.0:5000/classify/" + new_filename
    #print(redirect_to)
    requests.get(redirect_to)
    #return redirect(redirect_to)

def random_string(length):
    return ''.join(random.choice(string.ascii_letters) for x in range(length))

if __name__ == '__main__':
    db.session.execute('pragma foreign_keys=on')
    db.create_all()
    app.run(host="0.0.0.0",port = "5000", debug=True)
