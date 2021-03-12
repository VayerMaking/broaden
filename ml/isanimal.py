import numpy as np
import os
from PIL import Image 
import tensorflow as tf
from tensorflow.keras.preprocessing import image
from tensorflow.keras.applications import imagenet_utils
import cv2
import matplotlib.pyplot as plt
import time
import random


DIR = "/home/petar/Desktop/broaden/AnimalRecognition/Pictures/"

CATEGORIES = ["Animals", "Others"]

IMAGE_SIZE = 50

training_data = []

def get_training_data():
	for category in CATEGORIES:
		path = os.path.join(DIR, category) # Get categories path
		class_number = CATEGORIES.index(category)
		for image in os.listdir(path): # Get every image from curr dir
			try:
				image_array = cv2.imread(os.path.join(path, image), cv2.IMREAD_GRAYSCALE) # Converting image to grayscale array
				new_array = cv2.resize(image_array, (IMAGE_SIZE, IMAGE_SIZE)) 
				training_data.append([new_array, class_number])
			except Exception as e:
				print("Image convertion failed!")

get_training_data()
print(len(training_data))

random.shuffle(training_data)# Shuffle all data from training_data.

for data in training_data:
	