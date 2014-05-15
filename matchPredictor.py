#!/usr/bin/env python3

import math
import sys
from enum import Enum

global constant
global lambdas
global standings

class Result(Enum):
	Tie = 0
	Win = 1
	Loss = 2

def main():
	global constant
	global lambdas
	global standings
	constant = 1.45
	lambdas = {}
	standings = {}
	with open("ClubData/transformedWorldCupData.txt") as f:
		for line in f:
			arr = line.split()
			lambdas[arr[0]] = (float(arr[1]), float(arr[2]))

	with open("manualStandings.txt") as f:
		for line in f:
			arr = line.split()
			team = arr[0].lower()
			standing = int(arr[1])
			standings[team] = standing

	if len(sys.argv) == 3:
		team1 = sys.argv[1]
		team2 = sys.argv[2]
		headToHead(team1, team2, False)
	if len(sys.argv) == 5:
		teams = [sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]]
		groupStage(teams)

def groupStage(teams):
	points = {teams[0]:0, teams[1]:0, teams[2]:0, teams[3]:0}
	for home in teams:
		for away in teams:
			if home == away:
				continue
			result = headToHead(home, away, True)
			if result == Result.Tie:
				points[home] += 1
				points[away] += 1
			elif result == Result.Win:
				points[home] += 3
			elif result == Result.Loss:
				points[away] += 3
	# get top team
	first = ""
	firstPoints = 0
	for team in teams:
		if points[team] > firstPoints:
			first = team
			firstPoints = points[team]

	second = ""
	secondPoints = 0
	for team in teams:
		if team == first:
			continue
		if points[team] > secondPoints:
			second = team
			secondPoints = points[team]
	print(first + " " + second)
def headToHead(team1, team2, beQuiet):
	lambda1 = lambdas[team1]
	lambda2 = lambdas[team2]
	score1 = lambda1[0]*lambda2[1]/constant
	score2 = lambda2[0]*lambda1[1]/constant

	if math.isnan(score1):
		score1 = 0
	if math.isnan(score2):
		score2 = 0

	floor1 = int(math.floor(score1))
	floor2 = int(math.floor(score2))
	ceil1 = int(math.ceil(score1))
	ceil2 = int(math.ceil(score2))

	# tie?
	result = None
	if floor1 == floor2:
		if not beQuiet:
			print(team1 + " ties to " + team2, floor1, floor2)
		result = Result.Tie
	if ceil1 < ceil2:
		if not beQuiet:
			print(team1 + " loses to " + team2, ceil1, ceil2)
		result = Result.Loss
	elif ceil1 > ceil2:
		if not beQuiet:
			print(team1 +  " wins to " + team2, ceil1, ceil2)
		result = Result.Win
	else:
	# trust the higher seeded team
		if beQuiet:
			pass
		if score1 > score2:
			if not beQuiet:
				print(team1 + " barely wins to " + team2, score1, score2, standings[team1.lower()], standings[team2.lower()])
		else:
			if not beQuiet:
				print(team1 + " barely loses to " + team2, score1, score2, standings[team1.lower()], standings[team2.lower()])
			print(team1 + " barely wins to " + team2, score1, score2, standings[team1.lower()], standings[team2.lower()])
		else:
			print(team1 + " barely loses to " + team2, score1, score2, standings[team1.lower()], standings[team2.lower()])
	return result
if __name__ == "__main__":
	main()
