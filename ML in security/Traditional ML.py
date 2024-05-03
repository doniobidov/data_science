import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
#import tensorflow as tf
import tensorflow.compat.v1 as tf
tf.disable_v2_behavior() 

from numpy import genfromtxt
from sklearn.metrics import (accuracy_score, confusion_matrix, f1_score,
                             precision_score, recall_score)
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder, StandardScaler

#ignore warnings
import warnings
warnings.filterwarnings('ignore')

###############################################################

learning_rate = 0.01
#n_epochs = 10000
n_epochs = 100

def convertOneHot(data):
    y_onehot=[0]*len(data)
    for i,j in enumerate(data):
        y_onehot[i]=[0]*(data.max()+1)
        y_onehot[i][j]=1
    return y_onehot

###############################################################
feature=genfromtxt('iris.csv',delimiter=',',usecols=(i for i in range(0,4)),dtype=float,skip_header=1)
target=genfromtxt('iris.csv',delimiter=',',usecols=(-1),dtype=str,skip_header=1)
feature_std = StandardScaler().fit_transform(feature)
target_label = LabelEncoder().fit_transform(target)
target_onehot = convertOneHot(target_label)
x_train, x_test, y_train_onehot, y_test_onehot = train_test_split(feature_std, target_onehot, test_size=0.30, random_state=0)
A=x_train.shape[1]
B=len(y_train_onehot[0])
print(len(y_test_onehot[0]))
print(B)
print("Begin:__________________________________")
###################################################
## print stats 
precision_scores_list = []
accuracy_scores_list = []

def print_stats_metrics(y_test, y_pred):    
    print('Accuracy: %.2f' % accuracy_score(y_test,   y_pred) )
    #Accuracy: 0.84
    accuracy_scores_list.append(accuracy_score(y_test,   y_pred) )
    confmat = confusion_matrix(y_true=y_test, y_pred=y_pred)
    #print ("confusion matrix")
    #print(confmat)
    print (pd.crosstab(y_test, y_pred, rownames=['True'], colnames=['Predicted'], margins=True))
    precision_scores_list.append(precision_score(y_true=y_test, y_pred=y_pred,average='weighted'))
    print('Precision: %.3f' % precision_score(y_true=y_test, y_pred=y_pred,average='weighted'))
    print('Recall: %.3f' % recall_score(y_true=y_test, y_pred=y_pred,average='weighted'))
    print('F1-measure: %.3f' % f1_score(y_true=y_test, y_pred=y_pred,average='weighted'))

#####################################################################

def plot_metric_per_epoch():
    x_epochs = []
    y_epochs = [] 
    for i, val in enumerate(accuracy_scores_list):
        x_epochs.append(i)
        y_epochs.append(val)
    
    plt.scatter(x_epochs, y_epochs,s=50,c='lightgreen', marker='s', label='score')
    plt.xlabel('epoch')
    plt.ylabel('score')
    plt.title('Score per epoch')
    plt.legend()
    plt.grid()
    plt.show()


###############################################################
def layer(input, weight_shape, bias_shape):
    weight_stddev = (2.0/weight_shape[0])**0.5
    w_init = tf.random_normal_initializer(stddev=weight_stddev)
    bias_init = tf.constant_initializer(value=0)
    W = tf.get_variable("W", weight_shape, initializer=w_init)
    b = tf.get_variable("b", bias_shape, initializer=bias_init)
    return tf.nn.relu(tf.matmul(input, W) + b)
###############################################################
def inference_deep_layers(x_tf, A, B):
    with tf.variable_scope("hidden_1"):
        hidden_1 = layer(x_tf, [A, 4],[4])
    with tf.variable_scope("hidden_2"):
        hidden_2 = layer(hidden_1, [4, 4],[4])
    with tf.variable_scope("output"):
        output = layer(hidden_2, [4, B], [B])
    return output
###############################################################
def loss_deep(output, y_tf):
    xentropy = tf.nn.softmax_cross_entropy_with_logits(logits=output, labels=y_tf)
    loss = tf.reduce_mean(xentropy) 
    return loss
###########################################################

def training(cost):
    optimizer = tf.train.GradientDescentOptimizer(learning_rate)
    train_op = optimizer.minimize(cost)
    return train_op

###########################################################
def evaluate(output, y_tf):
    correct_prediction = tf.equal(tf.argmax(output,1), tf.argmax(y_tf,1))
    accuracy = tf.reduce_mean(tf.cast(correct_prediction, "float"))
    return accuracy
###############################################################

x_tf = tf.placeholder("float",[None,A])
y_tf = tf.placeholder("float",[None,B])
###############################################################
output = inference_deep_layers(x_tf,A,B)
cost = loss_deep(output,y_tf)
train_op=training(cost)
eval_op=evaluate(output,y_tf)
###############################################################
init = tf.global_variables_initializer()
sess = tf.Session()
sess.run(init)
###############################################################
y_p_metrics = tf.argmax(output,1)
###############################################################
#num_samples_train_set=x_train.shape[0]
#num_batches = int(num_samples_train_set/batch_size)

###############################################################

for i in range(n_epochs):
    print ("-------------------------------------------------------------------------------")    
    print("epoch %s out of %s"%(i,n_epochs))
    sess.run(train_op,feed_dict={x_tf:x_train,y_tf:y_train_onehot})
    #print ("Accuracy score")
    #result = sess.run(eval_op,feed_dict={x_tf:x_test,y_tf:y_test_onehot})
    result, y_result_metrics = sess.run([eval_op, y_p_metrics], feed_dict={x_tf: x_test, y_tf: y_test_onehot})
    print("Run {},{}".format(i,result))
    y_true = np.argmax(y_test_onehot,1)
    print_stats_metrics(y_true, y_result_metrics)
    if i==n_epochs-1:
        plot_metric_per_epoch()
