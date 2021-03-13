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

CATEGORIES = ["Others", "Mammals"]

IMAGE_SIZE = 70

training_data = []

X = []
# feature set that help to predict the output variable.
y = []
# label is simple classification

depth = 1 # end Layers count

def get_training_data():
	for category in CATEGORIES:
		# Get categories path
		path = os.path.join(DIR, category)
		class_number = CATEGORIES.index(category)

		layers = tf.one_hot(class_number, depth, on_value=None, off_value=None, axis=None, dtype=None, name=None)

		# Get every image from curr dir
		for image in os.listdir(path):
			try:
				# Converting image to grayscale array
				image_array = cv2.imread(os.path.join(path, image), cv2.IMREAD_GRAYSCALE)
				new_array = cv2.resize(image_array, (IMAGE_SIZE, IMAGE_SIZE)) 
				training_data.append([new_array, layers])
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

dense_layers = [1]
layer_sizes = [8]
conv_layers = [3]

for dense_layer in dense_layers:
	for layer_size in layer_sizes:
		for conv_layer in conv_layers:
			#Create model 
			model = Sequential()

			model.add(Conv2D(layer_size, (3, 3), input_shape=X.shape[1:]))
			model.add(Activation('relu'))
			model.add(MaxPooling2D(pool_size=(2, 2)))

			for l in range(conv_layer - 1):
				# Redoing Convolutional and MaxPooling for better accuracy
				model.add(Conv2D(layer_size, (3, 3)))
				model.add(Activation('relu'))
				model.add(MaxPooling2D(pool_size=(2, 2)))

			model.add(Flatten())

			for l in range(dense_layer):
				model.add(Dense(layer_size, activation='relu'))
				model.add(Dropout(0.2))
			'''model.add(Dense(64))
			model.add(Activation('relu'))

			model.add(Dense(64))
			model.add(Activation('relu'))


			model.add(Dense(64))
			model.add(Activation('relu'))'''

			model.add(Dense(depth))
			model.add(Activation('sigmoid'))
			# For better accuracy I chould have more layers

			model.compile(loss='binary_crossentropy', optimizer="adam", metrics=['accuracy']) # For more than two outputs use: categorical_crossentropy 'mean_squared_error'

			model.fit(X, y, batch_size=32, validation_split=0.2, epochs=20)


			model.save('BinaryMammalRecognition-CNN.model')