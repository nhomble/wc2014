

# This file simulates the MOST LIKELY outcome of the 2014 World Cup

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
input = open("ELOoutput2.txt", 'r') # which set of lambdas to use
lines = input.readlines

lines.each { |line| # reads all the lambdas
  if line =~ /([A-Za-z]+)\:   (\d\.\d+) (\d\.\d+)/
    $offlambda[$1] = $2.to_f
    $deflambda[$1] = $3.to_f
  end
}

def getGameWinner(team1, team2) # Given two teams, this gets the most likely winner
  if $offlambda[team1] * $deflambda[team2] > $offlambda[team2] * $deflambda[team1]
    return team1
  else
    return team2
  end
end

def getWinner(number) # Gets the GROUP winner
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

def getRunnerUp(number) # Gets the group runner-up
  winner = getWinner(number)
  runnerup = $groups[number][0]
  if runnerup == winner
    runnerup = $groups[number][1]
  end
  
  if ($teamscore[$groups[number][1]] > $teamscore[runnerup]) and ($teamscore[$groups[number][1]] != $teamscore[winner])
    runnerup = $groups[number][1]
  end
  if ($teamscore[$groups[number][2]] > $teamscore[runnerup]) and ($teamscore[$groups[number][2]] != $teamscore[winner])
    runnerup = $groups[number][2]
  end
  if ($teamscore[$groups[number][3]] > $teamscore[runnerup]) and ($teamscore[$groups[number][3]] != $teamscore[winner])
    runnerup = $groups[number][3]
  end
  return runnerup
end

def playGroupGame(team1, team2) # Simulates a group game
  if team1 == getGameWinner(team1, team2)
    $teamscore[team1] += 1
  else
    $teamscore[team2] += 1
  end
end

$groups.keys.each { |number|
  playGroupGame($groups[number][0], $groups[number][1])
  playGroupGame($groups[number][0], $groups[number][2])
  playGroupGame($groups[number][0], $groups[number][3])
  playGroupGame($groups[number][1], $groups[number][2])
  playGroupGame($groups[number][1], $groups[number][3])
  playGroupGame($groups[number][2], $groups[number][3])
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
#puts groupwins

# Round of 16
eightfns = []
eightfns[0] = getGameWinner(groupwins[0], groupwins[9])
eightfns[1] = getGameWinner(groupwins[1], groupwins[8])
eightfns[2] = getGameWinner(groupwins[2], groupwins[11])
eightfns[3] = getGameWinner(groupwins[3], groupwins[10])

eightfns[4] = getGameWinner(groupwins[4], groupwins[13])
eightfns[5] = getGameWinner(groupwins[5], groupwins[12])
eightfns[6] = getGameWinner(groupwins[6], groupwins[15])
eightfns[7] = getGameWinner(groupwins[7], groupwins[14])
puts "The winners of the round of 16 are:"
puts eightfns
puts ""

# Quarters
quarterfns = []
quarterfns[0] = getGameWinner(eightfns[0], eightfns[2])
quarterfns[1] = getGameWinner(eightfns[1], eightfns[3])
quarterfns[2] = getGameWinner(eightfns[4], eightfns[6])
quarterfns[3] = getGameWinner(eightfns[5], eightfns[7])
puts "The winners of the quarter finals are:"
puts quarterfns
puts ""

# Semies
semis = []
semis[0] = getGameWinner(quarterfns[0], quarterfns[2])
semis[1] = getGameWinner(quarterfns[1], quarterfns[3])
puts "The winners of the semi finals are:"
puts semis
puts ""

# Final
finalist = getGameWinner(semis[0], semis[1])
puts "The tournament winner is:"
puts finalist
puts ""


