#!/usr/bin/env python2

import math
import sys
import numpy as np

def main():
	lambdas = {}
	# first get lambdas
	with open("ClubData/transformedWorldCupData.txt") as f:
		for line in f:
			arr = line.split()
			lambdas[arr[0]] = (float(arr[1]), float(arr[2]))
#	if len(sys.argv) > 1:
#		constant = float(sys.argv[1])
#	else:
#		constant = 1.4056925
	files = ["Italy", "France", "England", "UnitedStates", "Brazil", "Argentina", "Spain", "Germany", "Holland", "Portugal", "Belgium", "Russia", "Colombia", "Uruguay", "Serbia", "Chile", "Switzerland", "IvoryCoast", "Cameroon", "Poland", "Mexico", "Croatia", "Morocco", "Nigeria", "Sweden", "Austria", "Turkey", "Senegal", "Denmark", "Greece", "Ghana", "Wales", "Slovakia", "Norway", "Peru", "Scotland", "Ecuador", "Japan", "Slovenia", "Algeria", "Paraguay", "Mali", "Hungary", "Congo", "Iceland", "Ukraine"]
	scan = np.linspace(1.40, 1.50, 1000)
	years = [2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014]
	for minYear in years:
		totalGames = 0
		correctScores = 0
		correctResults = 0
		ties = 0

		bestResult = [0, 0]
		for constant in scan:
			if constant == 0:
				continue
			for f in files:
				with open("elo/ELO" + f + "output.txt") as openedFile:
					for line in openedFile:	
						arr = line.split()
						year = int(arr[0])
						day = arr[1]
						home = arr[3].lower()
						away = arr[4].lower()
						try:
							hscore = int(arr[5])
							ascore = int(arr[6])
						except:
							continue
		
						if year < minYear:
							continue
	
						try:	
							homeLambdas = lambdas[home]
							awayLambdas = lambdas[away]
							expectedHomeScore = homeLambdas[0]*awayLambdas[1]/constant
							expectedAwayScore = awayLambdas[0]*homeLambdas[1]/constant
							expectedHomeScoreRounded = int(math.floor(expectedHomeScore))
							expectedAwayScoreRounded = int(math.floor(expectedAwayScore))
						except:
							continue
						totalGames += 1
						realResult = (hscore < ascore) 
						isTieAct = (hscore == ascore)
						isTieExp = (expectedHomeScoreRounded == expectedAwayScoreRounded)
						expectedResult = (math.ceil(expectedHomeScore) < math.ceil(expectedAwayScore))
						# did I get the exact score?
						if hscore == expectedHomeScoreRounded and ascore == expectedAwayScoreRounded:
							correctScores += 1
							correctResults += 1
							#print("same", hscore, ascore, expectedHomeScore, expectedAwayScore)
						# at did I detect a tie?
						elif isTieAct and isTieExp:
							correctResults += 1
						# if not a tie, did I at least get the right inequality?
						elif realResult is expectedResult:
							correctResults += 1
			if totalGames != 0 and bestResult[0] < (float(correctResults)/float(totalGames)):
				bestResult[0] = float(correctResults)/float(totalGames)
				bestResult[1] = constant
		print(str(minYear) + " " + str(bestResult[0]) + " " + str(bestResult[1]))
if __name__ == "__main__":
	main()
