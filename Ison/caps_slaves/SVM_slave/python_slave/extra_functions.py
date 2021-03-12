# -*- coding: utf-8 -*-
"""

@author: jason
"""

import numpy as np
from scipy import signal
import math
import operator

import matplotlib.pyplot as plt

def OnlinePreprocEMG(data,sr,B_H,A_H,B_L1,A_L1,B_L2,A_L2,normaLize,rectiFy,mvc,twLength):
    
    # detrend
    data_new=signal.detrend(data)
    
    # band-pass filtering
    
    data_h=signal.lfilter(B_H,A_H,data_new,axis=0)
    
    #zi = signal.lfilter_zi(B_L1,A_L1)
    
    data_hl=signal.lfilter(B_L1,A_L1,data_h,axis=0)
        
    # rectification
    
    if rectiFy:
        data_rett=np.absolute(data_hl)
    else:
        data_rett=data_hl

    # low-pass filtering (for creating linear envelope)

    #zi = signal.lfilter_zi(B_L2,A_L2)
    EMG_pp=signal.lfilter(B_L2,A_L2,data_rett,axis=0)
    
    # normalization
    
    if normaLize:
        for i in range(0,np.shape(EMG_pp)[1]):
            EMG_pp[:,i]=EMG_pp[:,i]/mvc[i]

    
    return EMG_pp[int(np.floor(twLength*sr)):,:]


def OnlinePreprocGonio(ssignal,SR,B_elbowJoint,A_elbowJoint,B_elbowVel,A_elbowVel,twLength):
 
    # filter singal
	
	FTraj=signal.lfilter(B_elbowJoint,A_elbowJoint,ssignal)
	
    # take the derivative of the signal
	tr=(1/SR)
	dTraj=np.diff(FTraj)/tr
	
    # filtering velocity
	
	AVel=signal.lfilter(B_elbowVel,A_elbowVel,dTraj)
	
	# extract the data that correspond to the time window
	
	FTraj=FTraj[int(np.floor(twLength*SR)):]

	mean_Vel=abs(np.mean(AVel[int(np.floor(twLength*SR)):],dtype=np.float32))
	
	return mean_Vel, FTraj




def waveformlength(sequence):
    
    sum_length=0
    
    for i in range(1,np.size(sequence)):
        Sub=np.absolute(sequence[i]-sequence[i-1])
        sum_length=sum_length+Sub
    
    return sum_length

def slopChanges(sequence,e):
    
    count_slops=0
       
    for i in xrange(0,np.shape(sequence)[0]-2*e,2*e):
        SubA=sequence[i+e]-sequence[i]
        SubB=sequence[i+e]-sequence[i+2*e]
        if (SubA>np.float64(0.0)) & (SubB>np.float64(0.0)):
            count_slops=count_slops+1
    
    return count_slops

def majorityVote(Arr,nbClases):

	arr=Arr.tolist()

	countersAp=np.zeros([nbClases],dtype=int)

	for i in range(1,nbClases+1):
		countersAp[i-1]=arr.count(i)

	ab=np.sort(countersAp)
	#conf=float((ab[-1]-ab[nbClases-2]))/float(len(arr))
	conf=float(ab[-1])/float(len(arr))
	return countersAp.argmax()+1,conf

    
    
    