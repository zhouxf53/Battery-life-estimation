import numpy as np
import pickle
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
import keras
from keras.models import Sequential
from keras.layers import Dense

f = open('store.pckl', 'rb')
Tc = pickle.load(f)
f.close()

Tc=Tc[:,250:660]
Tc=np.transpose(Tc)
y=np.asarray(list(range(410)))
y=np.reshape(y,(1,410))
y=np.transpose(y)
X_train, X_test, y_train, y_test= train_test_split(
    Tc, y, test_size=0.33, random_state=1)

X_train, X_val, y_train, y_val= train_test_split(
    X_train, y_train, test_size=0.33, random_state=1)

sc = StandardScaler()
X_train = sc.fit_transform(X_train)
X_test = sc.transform(X_test)

#Initializing Neural Network
classifier = Sequential()
# Adding the input layer and the first hidden layer
classifier.add(Dense(output_dim = 6, init = 'uniform', activation = 'relu', input_dim = 11))
# Adding the second hidden layer
classifier.add(Dense(output_dim = 6, init = 'uniform', activation = 'relu'))
# Adding the output layer
classifier.add(Dense(output_dim = 1, init = 'uniform', activation = 'sigmoid'))
# Compiling Neural Network
classifier.compile(optimizer = 'adam', loss = 'binary_crossentropy', metrics = ['accuracy'])
