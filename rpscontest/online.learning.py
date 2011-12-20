#!/usr/bin/python

import math
import random
import time

MATCHES = 1000
LIST_TYPE = type([])

def h(theta, x, num):
	return sigmoid(z(theta,x,num))

def z(theta, x, num):
	total = 0
	if (type(theta) == LIST_TYPE):
		for i in range(num+1):
			total += theta[i] * x[i]
	else:
		total += theta * x
	return total

def sigmoid(z):
	return 1 / (1 + math.e ** (-z))


def cost(theta, x, y, num):
	total = 0
	for i in range(num+1):
		total += h(theta[i] * x[i] - y[i]) ** 2
	return (1/2) * total


def updateTheta(theta, x, y, alpha, num):
	theta_temp = [0] * MATCHES
	for i in range(MATCHES):
		theta_temp[i] = theta[i] - alpha * (h(theta, x, num) - sum(y)) * x[i]
	return theta_temp


if input == "":
	num = 0
	choices = ['*','R','P','S'] # star only shifts everybody to ease index manipulation, it is not an actual choice
	temp_list = [0] * MATCHES
	X = list(temp_list)
	Y = list(temp_list)
	Theta = [ list(temp_list), list(temp_list), list(temp_list) ]
	output = random.choice(choices[1:4])
	X[num] = choices.index(output)
	alpha = 1
else:
	num += 1
	Y[num] = choices.index(input)
	for c in [1,2,3]:
		idx = c-1
		Y_i = map(lambda i: 1 if (i==c) else 0, Y)
		Theta[idx] = updateTheta(Theta[idx], X, Y_i, alpha, num)
	probabilities = [0,0,0]
	ts = time.time()
	for c in [1,2,3]:
		idx = c-1
		X[num] = c
		probabilities[idx] = z(Theta[idx], X, num)
	te = time.time()
	max_probability = probabilities.index(max(probabilities))
	predicted_move = max_probability + 1
	best_choice = (predicted_move % 3) + 1
	X[num] = best_choice
	output = choices[best_choice]
	# DEBUG
	#print X
	#print Y
	#print Theta
	#print probabilities
	#print best_choice
	
	if  (num%50 == 0):
		print (te-ts)
		print "============="
