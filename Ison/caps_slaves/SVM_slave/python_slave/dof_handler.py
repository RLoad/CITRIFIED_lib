# -*- coding: utf-8 -*-
"""

@author: 	Iason Batzianoulis (yias)
email:		iason.batzianoulis@epfl.ch
created: 	11/07/2017

Description:
The program updates the velocity of the joint angles of the RIC Hand.

maintainer:	iason.batzianoulis@epfl

"""

import numpy as np
from scipy import signal
import scipy.io as sio
import extra_functions


import math
import mtrx
import pce

MV_Conf_Threshold=0.7

conf=0.0

def init():
    global conf

def run():
	global conf,MV_Conf_Threshold

	conf=pce.get_var('MV_CONF')
	cc=pce.get_var('MV_WINNER')
	fddof=pce.get_var('FDOF_ACT')
	
	if conf>=MV_Conf_Threshold:
		if cc==1:
			fddof[0,0]=-50
			fddof[0,1]=-50
			pce.set_var('FDOF_ACT',fddof)
		if cc==2:
			fddof[0,0]=-50
			fddof[0,1]=-50
			pce.set_var('FDOF_ACT',fddof)
		if cc==3:
			fddof[0,0]=50
			fddof[0,1]=50
			pce.set_var('FDOF_ACT',fddof)
		if cc==4:
			fddof[0,0]=50
			fddof[0,1]=50
			pce.set_var('FDOF_ACT',fddof)
	else:
		fddof[0,0]=0
		fddof[0,1]=0
		pce.set_var('FDOF_ACT',fddof)
	print cc,conf



def dispose():
    pass
