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

DIR = "/home/petar/Documents/broaden/ml/Pictures/"

CATEGORIES = ["Animals", "Others"]

IMAGE_SIZE = 40

training_data = []

X = []
# feature set that help to predict the output variable.
y = []
# label is simple classification

def get_training_data():
	for category in CATEGORIES:
		# Get categories path
		path = os.path.join(DIR, category)
		class_number = CATEGORIES.index(category)
		# Get every image from curr dir
		for image in os.listdir(path):
			print(image)
			try:
				# Converting image to grayscale array
				image_array = cv2.imread(os.path.join(path, image), cv2.IMREAD_GRAYSCALE)
				new_array = cv2.resize(image_array, (IMAGE_SIZE, IMAGE_SIZE)) 
				training_data.append([new_array, class_number])
			except Exception as e:
				print("Image convertion failed!")


get_training_data()

# Shuffle all data from training_data.
random.shuffle(training_data)

for feature, label in training_data:
	X.append(feature)
	y.append(label)

X = np.array(X).reshape(-1, IMAGE_SIZE, IMAGE_SIZE, 1)

# Create file which will be (pickleing)saving our features 
outfile = open("X.pickle", 'wb')
pickle.dump(X, outfile)
outfile.close()

outfile = open("y.pickle", 'wb')
pickle.dump(y, outfile)
outfile.close()

# Open pickled ile and get information
infile = open("X.pickle", 'rb') 
X = pickle.load(infile)
infile.close()

infile = open("y.pickle", 'rb')
y = pickle.load(infile)
infile.close()

X=np.array(X/255.0)
y=np.array(y)

#Create model 
model = Sequential()
model.add(Conv2D(64, (3, 3), input_shape=X.shape[1:]))
model.add(Activation('relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))

# Redoing Convolutional and MaxPooling for better accuracy
model.add(Conv2D(64, (3, 3)))
model.add(Activation('relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Flatten())
model.add(Dense(64))
model.add(Activation('relu'))

model.add(Dense(1))
model.add(Activation('sigmoid'))

model.compile(loss="binary_crossentropy", optimizer="adam", metrics=['accuracy']) # For more than two outputs use: categorical_crossentropy
print(type(y))
model.fit(X, y, batch_size=40, validation_split=0.2, epochs=2)


model.save('Animal-CNN.model')

