import numpy as np
import os
from PIL import Image 
import tensorflow as tf
from tensorflow.keras.preprocessing import image
from tensorflow.keras.applications import imagenet_utils
import cv2
import matplotlib.pyplot as plt
import time
filename = 'Pictures/3.jpg' # Temporary wolf picture 


#Read image using opencv-python library
img = cv2.imread(filename)
#Resize image 
img = cv2.resize(img, (224, 224))
#Print image
cv2.imshow('Image', img)
cv2.waitKey(5000)
cv2.destroyAllWindows()


#TODO
# Get pictures from database and return the name of animal on the picture

#Load DL model
train_model = tf.keras.applications.mobilenet_v2.MobileNetV2()


# GEt image in format
img = image.load_img(filename, target_size = (224, 224))
prepared_image = image.img_to_array(img)
prepared_image = np.expand_dims(prepared_image, axis = 0)
prepared_image = tf.keras.applications.mobilenet.preprocess_input(prepared_image)

predictions = train_model.predict(prepared_image)

result = imagenet_utils.decode_predictions(predictions)


accurate_answer = result[0][0][1]
print(result)
print(accurate_answer)



