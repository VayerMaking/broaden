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


DIR = "/home/vayermaking/github/broaden/api"

CATEGORIES = ["Animals", "Others"]
IMAGE_SIZE = 40

def prepare(filepath):
	image_array = cv2.imread(filepath, cv2.IMREAD_GRAYSCALE)
	new_array = cv2.resize(image_array, (IMAGE_SIZE, IMAGE_SIZE))
	return new_array.reshape(-1, IMAGE_SIZE, IMAGE_SIZE, 1)

def run():
	model = tf.keras.models.load_model('Animal-CNN.model')
	path = os.path.join(DIR, "uploads")
	res = []
	for image in os.listdir(path):
		if image != 'just_to_keep_project_structure.txt':
			prediction = model.predict([prepare("uploads/" + image)])
			res.append({image : int(prediction[0][0])})
			print(image)
			print(prediction)
			#print(CATEGORIES[int(prediction[0][0])])
			print()
	return res

'''prediction = model.predict([prepare("Pictures/Test/at.jpeg")])
print(prediction)'''
