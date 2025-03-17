import math
import os
import numpy as np
import tensorflow as tf

from keras import backend as K
from tensorflow.keras.models import Sequential
from tensorflow.keras.utils import to_categorical
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Flatten, Dense

classes = ['setosa', 'versicolor', 'virginica']

def load_dataset():
  # reading data file
  data_file = open('iris.data', 'r')
  data_lines = data_file.readlines()
  x_data = []
  y_data = []
  for i, line in enumerate(data_lines):
    if len(line) < 5: continue
    line = line.split(',')
    x_data.append([float(line[0]), float(line[1]), float(line[2]), float(line[3])])
    class_name = line[4].removeprefix('Iris-').rstrip('\n')
    y_data.append([float(class_name == classes[0]), float(class_name == classes[1]), float(class_name == classes[2])])
  data_file.close()
  # convert to numpy array
  x_data = np.array(x_data, dtype=np.float32)
  y_data = np.array(y_data, dtype=np.float32)
  # normalize data
  x_data = (x_data - np.min(x_data)) / (np.max(x_data) - np.min(x_data))
  # 10% of data for testing
  test_size = int(len(data_lines) * 0.1)
  # split data 10% from each class
  x_test = []
  y_test = []
  for i in range(test_size):
    if y_data[i][0] == 1:
      x_test.append(x_data[i])
      y_test.append(y_data[i])
      x_data = np.delete(x_data, i, 0)
      y_data = np.delete(y_data, i, 0)
      if len(x_test) == math.floor(test_size): break
  for i in range(test_size):
    if y_data[i][1] == 1:
      x_test.append(x_data[i])
      y_test.append(y_data[i])
      x_data = np.delete(x_data, i, 0)
      y_data = np.delete(y_data, i, 0)
      if len(x_test) == math.floor(test_size) * 2: break
  for i in range(test_size):
    if y_data[i][2] == 1:
      x_test.append(x_data[i])
      y_test.append(y_data[i])
      x_data = np.delete(x_data, i, 0)
      y_data = np.delete(y_data, i, 0)
      if len(x_test) == test_size: break
  x_test = np.array(x_test, dtype=np.float32)
  y_test = np.array(y_test, dtype=np.float32)
  x_train = np.array(x_data, dtype=np.float32)
  y_train = np.array(y_data, dtype=np.float32)
  return (x_train, y_train), (x_test, y_test)

def main():
  # region load data
  (x_train, y_train), (x_test, y_test) = load_dataset()
  # endregion
  # region Create the models
  # Create the CNN model 4, 4, 3 with relu activation
  model1 = Sequential([
    Dense(4, activation='relu', input_shape=(4,)),
    Dense(4, activation='relu'),
    Dense(3, activation='softmax')
  ])

  # create the CNN model 4, 3, 3, 3 with relu activation
  model2 = Sequential([
    Dense(4, activation='relu', input_shape=(4,)),
    Dense(3, activation='relu'),
    Dense(3, activation='relu'),
    Dense(3, activation='softmax')
  ])

  # create the CNN model 4, 5, 3 with relu activation
  model3 = Sequential([
    Dense(4, activation='relu', input_shape=(4,)),
    Dense(5, activation='relu'),
    Dense(3, activation='softmax')
  ])
  # endregion
  # region Compile all the models
  model1.compile(optimizer='sgd', loss='categorical_crossentropy', metrics=['accuracy'])
  model2.compile(optimizer='sgd', loss='categorical_crossentropy', metrics=['accuracy'])
  model3.compile(optimizer='sgd', loss='categorical_crossentropy', metrics=['accuracy'])
  # endregion
  # region Train the models
  if not os.path.exists('model1_iris_dnn.h5'):
    model1.fit(x_train, y_train, epochs=100, batch_size=1, verbose=1)
    model1.save('model1_iris_dnn.h5')
  else: model1 = tf.keras.models.load_model('model1_iris_dnn.h5')

  if not os.path.exists('model2_iris_dnn.h5'):
    model2.fit(x_train, y_train, epochs=100, batch_size=1, verbose=1)
    model2.save('model2_iris_dnn.h5')
  else: model2 = tf.keras.models.load_model('model2_iris_dnn.h5')

  if not os.path.exists('model3_iris_dnn.h5'):
    model3.fit(x_train, y_train, epochs=100, batch_size=1, verbose=1)
    model3.save('model3_iris_dnn.h5')
  else: model3 = tf.keras.models.load_model('model3_iris_dnn.h5')
  # endregion
  # region Evaluate the models with test data
  # Evaluate the models with test data
  loss1, acc1 = model1.evaluate(x_test, y_test, verbose=0)
  loss2, acc2 = model2.evaluate(x_test, y_test, verbose=0)
  loss3, acc3 = model3.evaluate(x_test, y_test, verbose=0)

  print('the test data is:')
  # Print the accuracy up to 2 decimal places in %
  print(f'Accuracy of model1: {acc1 * 100:.2f}%, '
        f'Accuracy of model2: {acc2 * 100:.2f}%, '
        f'Accuracy of model3: {acc3 * 100:.2f}%')

  # Print the loss up to 2 decimal places in %
  print(f'Loss of model1: {loss1 * 100:.2f}%, '
        f'Loss of model2: {loss2 * 100:.2f}%, '
        f'Loss of model3: {loss3 * 100:.2f}%\n')
  # endregion
  # region Evaluate the models with train data
  # Evaluate the models with train data
  loss1, acc1 = model1.evaluate(x_train, y_train, verbose=0)
  loss2, acc2 = model2.evaluate(x_train, y_train, verbose=0)
  loss3, acc3 = model3.evaluate(x_train, y_train, verbose=0)

  print('the train data is:')
  # Print the accuracy up to 2 decimal places in %
  print(f'Accuracy of model1: {acc1 * 100:.2f}%, '
        f'Accuracy of model2: {acc2 * 100:.2f}%, '
        f'Accuracy of model3: {acc3 * 100:.2f}%')

  # Print the loss up to 2 decimal places in %
  print(f'Loss of model1: {loss1 * 100:.2f}%, '
        f'Loss of model2: {loss2 * 100:.2f}%, '
        f'Loss of model3: {loss3 * 100:.2f}%\n')
  # endregion
  # region Evaluate the models with all data
  x_data = np.concatenate((x_train, x_test), axis=0)
  y_data = np.concatenate((y_train, y_test), axis=0)
  # Evaluate the models with all data
  loss1, acc1 = model1.evaluate(x_data, y_data, verbose=0)
  loss2, acc2 = model2.evaluate(x_data, y_data, verbose=0)
  loss3, acc3 = model3.evaluate(x_data, y_data, verbose=0)

  print('the all data is:')
  # Print the accuracy up to 2 decimal places in %
  print(f'Accuracy of model1: {acc1 * 100:.2f}%, '
        f'Accuracy of model2: {acc2 * 100:.2f}%, '
        f'Accuracy of model3: {acc3 * 100:.2f}%')

  # Print the loss up to 2 decimal places in %
  print(f'Loss of model1: {loss1 * 100:.2f}%, '
        f'Loss of model2: {loss2 * 100:.2f}%, '
        f'Loss of model3: {loss3 * 100:.2f}%\n')
  # endregion
  # region Predict some test data
  # Predict some test data
  y_pred = model1.predict(x_test)
  for i in range(len(x_test)):
    print(f'X={x_test[i]}, Predicted={y_pred[i]}, Actual={y_test[i]}')

if __name__ == '__main__': main()
