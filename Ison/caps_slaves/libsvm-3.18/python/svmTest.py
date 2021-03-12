# -*- coding: utf-8 -*-
"""
testing libsvm module

@author: jason

"""

#import sys
#sys.path.append('./media/jason/data/MATLAB/CBM/libsvm-3.18/python')
#sys.path.remove('/media/jason/data/MATLAB/CBM/libSVMmodule')

#print sys.path



import svmutil
import numpy as np
import scipy.io as sio

m = svmutil.svm_load_model('tmpmo.model')

mat_contents = sio.loadmat('maxValues.mat')

maxValues=mat_contents['maxValues'][0]

mat_contents = sio.loadmat('mvc.mat')

mvc=mat_contents['mvc'][0]

print maxValues[0]

print len(mvc)

tmp=np.array([mvc],dtype=np.float64)

print np.size(tmp)


aa=[1,2,3,4,5,6,7,1,2,3,4,5]/mvc

print aa

#m2=svmutil.toPyModel(m)

#x=[1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0]
x=[[1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0],[1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0]]


p_label, p_acc, p_val = svmutil.svm_predict([2,3], x, m)

print p_label