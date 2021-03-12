# -*- coding: utf-8 -*-
"""

@author: 	Iason Batzianoulis (yias)
email:		iason.batzianoulis@epfl.ch
created: 	15/06/2017

"""

import numpy as np
from scipy import signal
import scipy.io as sio
import extra_functions

#import sys
#sys.path.append('./libsvm-3.18/python')

import svmutil

import math
import mtrx
import pce

#import os
#try:
#    user_paths = os.environ['PYTHONPATH'].split(os.pathsep)
	#print user_paths
#except KeyError:
#    user_paths = []

# which model to use:
# 1 -> use data including the reaching motion
# 2 -> use data without including the reaching motion

typController=1

# classes correspondence

cclasses=np.array([16,16,18,21])

# sample rate

SR=1000.0

# time window length in seconds

twLength=0.150

# normalization of the EMG signals by the MVC

normalize=True

# rectifications of the EMG signals

rectify=True

# transfer function coefficients for the filters
B_H=0
A_H=0
B_L1=0
A_L1=0
B_L2=0
A_L2=0
B_elbowJoint=0
A_elbowJoint=0
B_elbowVel=0
A_elbowVel=0

"""
    
parameters and variable for the control scheme
    
"""

# the thesholds for the confidence of the majority vote and the minimun number of the time windows
    
MV_Conf_Threshold=0.7
Least_TW=12

# counter of the time windows\

counter=1

# a vector to contain the classification outcome of all the time windows

allTWOutputs=np.array([0],dtype=int);

# number of channels

nb_channels=12

# history of the goniometer to keep

gonioHistory=np.zeros([int(np.floor(SR*twLength)),],dtype=np.float64)

# history of the emg signals to keep

emgHistory=np.zeros([int(np.floor(SR*twLength)),nb_channels],dtype=np.float64)

# time windows to take into account

TWHistory=15

SVMmodelallmotion=None
SVMmodelonlylast=None
maxValues=None
mvc=None

# PCE Variable that holds DC configurations
CLAS_OUT = pce.get_var('CLAS_OUT').to_np_array()

mVote=pce.get_var('PR_MV_ENABLE')
mvClass=pce.get_var('MV_CLAS_OUT').to_np_array()
fddof=pce.get_var('FDOF_ACT').to_np_array()


def init():
    
    global B_H, A_H, B_L1, A_L1, B_L2, A_L2, B_elbowJoint, A_elbowJoint, B_elbowVel, A_elbowVel
    global SVMmodelallmotion, SVMmodelonlylast, maxValues, mvc

    """
    
    filter parameters for the EMG
    
    """

    # cut-off frequencies (Hz) of the band-pass filter for the EMG signals
    
    bandPassCuttOffFreq=np.array([50.0,400.0])
    
    # cut-off frequency (Hz) of the low-pass filter for the EMG signals

    lowPassCutOffFreq=20.0
    
    # order of the filter
    
    filter_order=7;
    
    # compute the transfer function coefficients for the EMG filtering
    
    Wn=(bandPassCuttOffFreq[0]*2)/SR
    
    B_H,A_H = signal.butter(filter_order,Wn,'high')
    
    Wn=(bandPassCuttOffFreq[1]*2)/SR
    
    B_L1,A_L1 = signal.butter(filter_order,Wn,'low')
    
    Wn=(lowPassCutOffFreq*2)/SR
    
    B_L2,A_L2 = signal.butter(filter_order,Wn,'low')
    
    """
    
    filter parameters for the Goniometer data
    
    """
    
    # cut-off frequency (Hz) of the low-pass filter for the elbow joint angle
    
    cutoff_LP=50.0
    
    # order of the low-pass filter for the elbow joint angle
    
    order_LP=2
    
    # cut-off frequency (Hz) of the low-pass filter for the angular velocity ofthe elbow joint 
    
    velLPCutOffFreq=5
    
    # compute the transfer coefficients for the elbow joibt angle
    
    Wn=(cutoff_LP*2)/SR
    
    B_elbowJoint,A_elbowJoint = signal.butter(order_LP, Wn, 'low')
    
    # compute the transfer coefficients for the elbow joibt angle
    
    Wn=(velLPCutOffFreq*2)/SR
    
    B_elbowVel,A_elbowVel = signal.butter(order_LP, Wn, 'low')

    """
    
    load classification models, mcv and max values
    
    """
    SVMmodelallmotion = svmutil.svm_load_model('C:\CAPS\DEV\SLAVE\SVMmodelallmotion.model')

    SVMmodelonlylast= svmutil.svm_load_model('C:\CAPS\DEV\SLAVE\SVMmodelonlylast.model')

    mat_contents = sio.loadmat('C:\CAPS\DEV\SLAVE\maxValues.mat')
    maxValues=mat_contents['maxValues'][0]
    mat_contents = sio.loadmat('C:\CAPS\DEV\SLAVE\mvc.mat')
    mvc=mat_contents['mvc'][0]



def run():
	global B_H, A_H, B_L1, A_L1, B_L2, A_L2, B_elbowJoint, A_elbowJoint, B_elbowVel, A_elbowVel
	global SVMmodelallmotion, SVMmodelonlylast, maxValues, mvc, CLAS_OUT, cclasses
	global MV_Conf_Threshold, Least_TW, counter, allTWOutputs, nb_channels, gonioHistory, emgHistory, TWHistory, mVote

	"""
    
	online control scheme

	"""

	# acquire data
	n_daq_data_tm=pce.get_var('DAQ_DATA')
	#print n_daq_data_tm
	np_daq_data=n_daq_data_tm.to_np_array()
	#print np_daq_data
	#mVote=pce.get_var('PR_MV_ENABLE')
	#print "MV"
	#print mVote
	dd=np_daq_data.transpose()/float(math.pow(2,16)-1)*10-5

	# filter emg signals

	emgSignals=extra_functions.OnlinePreprocEMG(np.concatenate((emgHistory,dd[:,0:nb_channels]),axis=0),SR,B_H,A_H,B_L1,A_L1,B_L2,A_L2,normalize,rectify,mvc,twLength)

	emgHistory=dd[:,0:nb_channels]

	# feature extraction

	twFeatures=np.array([np.sqrt(np.mean(emgSignals[:,0]**2)),extra_functions.waveformlength(emgSignals[:,0]),extra_functions.slopChanges(emgSignals[:,0],3)])

	twFeatures=np.array([],dtype=np.float64);
	for j in range(0,nb_channels):
		twFeatures=np.concatenate((twFeatures,[np.sqrt(np.mean(emgSignals[:,j]**2))]),axis=0)

	for j in range(0,nb_channels):
		twFeatures=np.concatenate((twFeatures,[extra_functions.waveformlength(emgSignals[:,j])]),axis=0)

	for j in range(0,nb_channels):
		twFeatures=np.concatenate((twFeatures,[extra_functions.slopChanges(emgSignals[:,j],3)]),axis=0)

	twFeatures=twFeatures/maxValues

	# filter goniometer data

	angVel, filtGonio = extra_functions.OnlinePreprocGonio(np.concatenate((gonioHistory,dd[:,nb_channels]),axis=0),SR,B_elbowJoint,A_elbowJoint,B_elbowVel,A_elbowVel,twLength)

	gonioHistory=dd[:,nb_channels]

	# classify emg signals

	if typController==1:
		timeWindowOutput, p_acc, p_val = svmutil.svm_predict([1], [twFeatures.tolist()], SVMmodelallmotion, '-q')
	else:
		timeWindowOutput, p_acc, p_val = svmutil.svm_predict([1], [twFeatures.tolist()], SVMmodelonlylast, '-q')

	#print timeWindowOutput
	allTWOutputs=np.concatenate((allTWOutputs,timeWindowOutput),axis=0)

	mvClass=pce.get_var('MV_CLAS_OUT')
	fddof=pce.get_var('FDOF_ACT')
	#print fddof
	#print "old MVClass"
	#print mvClass

	if counter>Least_TW:	
		#print allTWOutputs[np.size(allTWOutputs)-TWHistory:]
		winner,conf= extra_functions.majorityVote(allTWOutputs[np.size(allTWOutputs)-TWHistory:],np.size(cclasses))
		pce.set_var('MV_CONF',conf)
		pce.set_var('MV_WINNER', winner)
		print winner,conf
		if conf>=MV_Conf_Threshold:
			tmpClass=np.zeros([8,],dtype=int)
			tmpClass[0]=cclasses[winner-1]
			CLAS_OUT[0,0]=cclasses[winner-1]
			#print CLAS_OUT
			pce.set_var('CLAS_OUT',CLAS_OUT)
			mvClass[0,0]=cclasses[winner-1]
			pce.set_var('MV_CLAS_OUT',mvClass)
			#print mvClass
			#if winner==1:
			#	fddof[0,0]=-50
			#	fddof[0,1]=-50
			#	pce.set_var('FDOF_ACT',fddof)
			#if winner==2:
			#	fddof[0,0]=-50
			#	fddof[0,1]=-50
			#	pce.set_var('FDOF_ACT',fddof)
			#if winner==3:
			#	fddof[0,0]=50
			#	fddof[0,1]=50
			#	pce.set_var('FDOF_ACT',fddof)
			#if winner==4:
			#	fddof[0,0]=50
			#	fddof[0,1]=50
			#	pce.set_var('FDOF_ACT',fddof)
		else:
			mvClass[0,0]=16
			CLAS_OUT[0,0]=16
			pce.set_var('CLAS_OUT',CLAS_OUT)
			pce.set_var('MV_CLAS_OUT',mvClass)
			#fddof[0,0]=0
			#fddof[0,1]=0
			#pce.set_var('FDOF_ACT',fddof)
	counter=counter+1;



def dispose():
    pass

