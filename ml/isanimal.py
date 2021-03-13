import numpy as np
import os
from PIL import Image 
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout, Activation, Flatten, Conv2D, MaxPooling2D
from tensorflow.keras.applications import imagenet_utils
import cv2
import matplotlib.pyplot as plt
import random
import pickle

DIR = "/home/petar/Desktop/broaden/AnimalRecognition/Pictures/"

CATEGORIES = ["Animals", "Others"]

IMAGE_SIZE = 40

training_data = []

X = []
# feature set that help to predict the output variable.
y = []
# label is simple classification

filepath = ''
def prepare(filepath):
	image_array = cv2.imread(filepath, cv2.IMREAD_GRAYSCALE)
	new_array = cv2.resize(image_array, (IMAGE_SIZE, IMAGE_SIZE))
	return new_array.reshape(-1, IMAGE_SIZE, IMAGE_SIZE, 1)

model = tf.keras.models.load_model('Animal-CNN.model')

prediction = model.predict([prepare('Pictures/Animals/test1.jpg')])

print(prediction)


