# The PROBLEM STATEMENT : CREATE A SCRIPT TO PREDICT THE CHANCES OF ADMIT TO AN UNIVERSITY BASED ON
#                         THE ACADEMIC PERFORMANCE, STRENGTH OF RECOMMENDATION AND RESEARCH

import numpy as np  # linear algebra
import pandas as pd  # data processing, CSV file I/O (e.g. pd.read_csv)
import matplotlib.pyplot as plt  # For data visualisation
from sklearn.linear_model import LinearRegression
from sklearn.tree import DecisionTreeRegressor

# Input data files are available in the "../input/" directory.
# For example, running this (by clicking run or pressing Shift+Enter) will list the files in the input directory

# read the data from CSV

data = pd.read_csv(
    "https://raw.githubusercontent.com/anyoneai/notebooks/main/datasets/Admission_Predict.csv"
)

print(data.columns)

# Decide the features to work with:
feature_X = ["GRE Score", "TOEFL Score", "SOP", "LOR ", "CGPA"]
feature_Y = ["Chance of Admit "]

data_X = data[feature_X]
data_Y = data[feature_Y]

# Segregate the dataset into TRAIN DATA and TEST DATA:
## Train
train_X = data_X[0:320]
train_Y = data_Y[0:320]
## Test
test_X = data_X[321:399]
test_Y = data_Y[321:399]

# Normalize the features:
X_mean = np.mean(train_X)
X_std = np.std(train_X)
train_X_norm = (train_X - X_mean) / X_std
test_X_norm = (test_X - X_mean) / X_std

#### Visualise the data

# These data features have a clear relationship between themseleves and CHANCE OF ADMIT:
plt.scatter(train_X_norm["CGPA"], train_Y)
plt.scatter(train_X_norm["GRE Score"], train_Y)

# These data features have an ambiguous relationship between themseleves and CHANCE OF ADMIT:
plt.scatter(train_X_norm["TOEFL Score"], train_Y)  # lightly ambiguous
plt.scatter(train_X_norm["LOR "], train_Y)  # quite ambiguous

# The rest of the data features have been found to be having little or no effect on the CHANCE OF ADMIT.

#### Train the predictive mode: LINEAR REGRESSION and DECISION TREE REGRESSOR:

# Instanciate the models:
regression = LinearRegression()
decision_tree = DecisionTreeRegressor()

regression.fit(train_X_norm, train_Y)
decision_tree.fit(train_X_norm, train_Y)

# Predicting the data:
sample_prediction_linear = decision_tree.predict(test_X_norm.head())
sample_prediction_tree = regression.predict(test_X_norm.head())

print(sample_prediction_tree)
print(sample_prediction_linear)
print(test_Y.head())

# Checking accuracy of the data : LINEAR REGRESSION/DECISION TREE REGRESSOR:
prediction_linear = regression.predict(test_X_norm)
S_y_linear = np.sqrt(np.sum((test_Y - prediction_linear) ** 2) / len(test_Y))
print(S_y_linear[0] * 100)
#   The error with LINEAR REGRESSION IS AT 6.62%

prediction_tree = decision_tree.predict(test_X_norm)
S_y_decision_tree = np.sqrt(
    np.sum((test_Y.to_numpy().flatten() - prediction_tree) ** 2) / len(test_Y)
)
#   The error with DECISION TREE REGRESSOR IS AT 9.25%

# Comparing the accuracy of different prediction models:

# Train the predictive model: LINEAR REGRESSION and DECISION TREE REGRESSOR:
print("Sample prediction (Linear Regression):", sample_prediction_linear)
print("Sample prediction (Decision Tree Regressor):", sample_prediction_tree)
print("Actual values:", test_Y.head())

# Checking accuracy of the data: LINEAR REGRESSION and DECISION TREE REGRESSOR:
prediction_linear = regression.predict(test_X_norm)
error_linear = np.sqrt(np.sum((test_Y - prediction_linear) ** 2) / len(test_Y))
prediction_tree = decision_tree.predict(test_X_norm)
error_decision_tree = np.sqrt(
    np.sum((test_Y.to_numpy().flatten() - prediction_tree) ** 2) / len(test_Y)
)

# Comparing the accuracy of different prediction models:
print("Accuracy of Linear Regression: {:.2f}%".format(error_linear[0] * 100))
print("Accuracy of Decision Tree Regressor: {:.2f}%".format(error_decision_tree * 100))
