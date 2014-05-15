# This file simulates the 2014 World Cup by sampling from a distribution

$winners = Hash.new(0)
$numsimulations = 10000

$countries = ["Brazil", "Spain", "Germany", "Argentina", "Holland", "England", "Portugal", "Colombia", "Uruguay", "Chile", "Italy", "France", \
  "UnitedStates", "Ecuador", "Russia", "Switzerland", "Belgium", "Mexico", "Greece", "IvoryCoast", "Croatia", "Japan", "Bosnia", "Nigeria", \
  "Iran", "CostaRica", "Australia", "SouthKorea", "Ghana", "Honduras", "Algeria", "Cameroon"]

$teamscore = Hash.new(0)
$groups = {}
$groups[0] = ["Brazil", "Cameroon", "Mexico", "Croatia"]
$groups[1] = ["Spain", "Holland", "Chile", "Australia"]
$groups[2] = ["Colombia", "Greece", "IvoryCoast", "Japan"]
$groups[3] = ["Uruguay", "CostaRica", "England", "Italy"]
$groups[4] = ["Switzerland", "Ecuador", "France", "Honduras"]
$groups[5] = ["Argentina", "Bosnia", "Iran", "Nigeria"]
$groups[6] = ["Germany", "Portugal", "Ghana", "UnitedStates"]
$groups[7] = ["Belgium", "Algeria", "Russia", "SouthKorea"]

$deflambda = {}
$offlambda = {}

$lines = {};
f2 = open("ELOoutput2.txt", 'r')
lines = f2.readlines

lines.each { |line|
  if line =~ /([A-Za-z]+)\:   (\d\.\d+) (\d\.\d+)/
  country = $1
  $offlambda[country] = $2.to_f
  $deflambda[country] = $3.to_f
  end
}

def factorial(n)
  return 1 if n.zero?
  1.upto(n).inject(:*)
end

def getVal(lamb) # samples a labda distribution, probably not the best way?
  randnum = rand()
  cumm = 0
  k = 0;

  while (cumm < randnum)
    cumm +=  (lamb ** k) * Math.exp(-lamb) / factorial(k)
    k += 1
  end
  return k
end

def getWinnerGame(team1, team2)
  offlamb1 = getVal($offlambda[team1])
  offlamb2 = getVal($offlambda[team2])
  deflamb1 = getVal($deflambda[team1])
  deflamb2 = getVal($deflambda[team2])

  if offlamb1 * deflamb2 > offlamb2 * deflamb1
  return team1
  else
  return team2
  end
end

def getWinner(number)
  winner = $groups[number][0]
  if $teamscore[$groups[number][1]] > $teamscore[winner]
  winner = $groups[number][1]
  end
  if $teamscore[$groups[number][2]] > $teamscore[winner]
  winner = $groups[number][2]
  end
  if $teamscore[$groups[number][3]] > $teamscore[winner]
  winner = $groups[number][3]
  end
  return winner
end

def getRunnerUp(number)
  winner = getWinner(number)
  runnerup = $groups[number][0]
  if runnerup == winner
  runnerup = $groups[number][1]
  end

  if $teamscore[$groups[number][1]] > $teamscore[runnerup] and $teamscore[$groups[number][1]] != $teamscore[winner]
  runnerup = $groups[number][1]
  end
  if $teamscore[$groups[number][2]] > $teamscore[runnerup] and $teamscore[$groups[number][2]] != $teamscore[winner]
  runnerup = $groups[number][2]
  end
  if $teamscore[$groups[number][3]] > $teamscore[runnerup] and $teamscore[$groups[number][3]] != $teamscore[winner]
  runnerup = $groups[number][3]
  end
  return runnerup
end

def playGame(team1, team2)
  if team1 == getWinnerGame(team1, team2)
  $teamscore[team1] += 1
  else
  $teamscore[team2] += 1
  end
end

def main
  $groups.keys.each { |number|
    playGame($groups[number][0], $groups[number][1])
    playGame($groups[number][0], $groups[number][2])
    playGame($groups[number][0], $groups[number][3])
    playGame($groups[number][1], $groups[number][2])
    playGame($groups[number][1], $groups[number][3])
    playGame($groups[number][2], $groups[number][3])
  }

  # Groups
  groupwins = []
  groupwins[0] = getWinner(0)
  groupwins[1] = getWinner(1)
  groupwins[2] = getWinner(2)
  groupwins[3] = getWinner(3)
  groupwins[4] = getWinner(4)
  groupwins[5] = getWinner(5)
  groupwins[6] = getWinner(6)
  groupwins[7] = getWinner(7)
  groupwins[8] = getRunnerUp(0)
  groupwins[9] = getRunnerUp(1)
  groupwins[10] = getRunnerUp(2)
  groupwins[11] = getRunnerUp(3)
  groupwins[12] = getRunnerUp(4)
  groupwins[13] = getRunnerUp(5)
  groupwins[14] = getRunnerUp(6)
  groupwins[15] = getRunnerUp(7)

  # Round of 16
  eightfns = []
  eightfns[0] = getWinnerGame(groupwins[0], groupwins[9])
  eightfns[1] = getWinnerGame(groupwins[1], groupwins[8])
  eightfns[2] = getWinnerGame(groupwins[2], groupwins[11])
  eightfns[3] = getWinnerGame(groupwins[3], groupwins[10])

  eightfns[4] = getWinnerGame(groupwins[4], groupwins[13])
  eightfns[5] = getWinnerGame(groupwins[5], groupwins[12])
  eightfns[6] = getWinnerGame(groupwins[6], groupwins[15])
  eightfns[7] = getWinnerGame(groupwins[7], groupwins[14])

  # Quarters
  quarterfns = []
  quarterfns[0] = getWinnerGame(eightfns[0], eightfns[2])
  quarterfns[1] = getWinnerGame(eightfns[1], eightfns[3])
  quarterfns[2] = getWinnerGame(eightfns[4], eightfns[6])
  quarterfns[3] = getWinnerGame(eightfns[5], eightfns[7])

  # Semies
  semis = []
  semis[0] = getWinnerGame(quarterfns[0], quarterfns[2])
  semis[1] = getWinnerGame(quarterfns[1], quarterfns[3])

  # Final
  finalist = getWinnerGame(semis[0], semis[1])

  #puts finalist
  $winners[finalist] += 1
end

$numsimulations.times {main}

$winners.sort_by{|k,v|-v}.each {|country|
  puts "#{country[0]} won #{country[1]*100.0/$numsimulations} percent of the time"
}

