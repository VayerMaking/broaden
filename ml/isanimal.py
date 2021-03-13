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

DIR = "/home/petar/Documents/broaden/ml/Pictures"

CATEGORIES = ["Cats", "Dogs", "Others"]
IMAGE_SIZE = 70

def prepare(filepath):
	image_array = cv2.imread(filepath, cv2.IMREAD_GRAYSCALE)
	new_array = cv2.resize(image_array, (IMAGE_SIZE, IMAGE_SIZE))
	return new_array.reshape(-1, IMAGE_SIZE, IMAGE_SIZE, 1)

model = tf.keras.models.load_model('AnimalSpecies-CNN.model')
path = os.path.join(DIR, "CDTest")
for image in os.listdir(path):
	prediction = model.predict([prepare("Pictures/CDTest/" + image)])
	print(image)
	print(prediction)
	#print(CATEGORIES[int(prediction[0][0])])
	print()


'''prediction = model.predict([prepare("Pictures/Test/at.jpeg")])
print(prediction)'''



