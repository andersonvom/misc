#!/usr/bin/python

import math
import random


def h(theta, x):
	return sigmoid(z(theta,x))

def z(theta, x):
	return sum(i*j for i, j in zip(theta,x))

def sigmoid(z):
	return 1 / (1 + math.e ** (-z))


def cost(theta, x, y):
	return (1/2) * ((h(theta, x) - sum(i for i in y)) ** 2)


def updateTheta(theta, x, y, alpha):
	theta_temp = [0] * len(theta)
	for i, item in enumerate(theta):
		theta_temp[i] = theta[i] - alpha * (h(theta, x) - sum(i for i in y)) * x[i]
	return theta_temp
	# return theta


input = ''
matches = 10
for i in range(matches):
	if input == "":
		choices = ['R','P','S']
		temp_list = [0] * matches
		X = list(temp_list)
		Y = list(temp_list)
		Theta = [ list(temp_list), list(temp_list), list(temp_list) ]
		output = random.choice(choices)
		X[-1] = choices.index(output) + 1
		alpha = 0.1
	else:
		Y.pop(0)
		Y.append(choices.index(input) + 1)
		for c in [1,2,3]:
			Y_i = map(lambda i: 1 if (i==c) else 0, Y)
			Theta[c-1] = updateTheta(Theta[c-1], X, Y_i, alpha)
		#print Theta
		pred = list(X)
		pred.pop(0)
		pred.append(0)
		probabilities = [0,0,0]
		for c in [1,2,3]:
			pred[-1] = c # choices[c-1]
			probabilities[c-1] = z(Theta[c-1], pred)
		print probabilities
		best_choice = probabilities.index(max(probabilities))
		X.pop(0)
		X.append(best_choice)
		output = choices[best_choice]
	print output
	input = random.choice('RPS')
