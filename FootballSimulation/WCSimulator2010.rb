

$countries = ["Brazil", "Spain", "Germany", "Argentina", "Holland", "England", "Portugal", "Colombia", "Uruguay", "Chile", "Italy", "France", \
    "UnitedStates", "Ecuador", "Russia", "Switzerland", "Belgium", "Mexico", "Greece", "IvoryCoast", "Croatia", "Japan", "Bosnia", "Nigeria", \
    "Iran", "CostaRica", "Australia", "SouthKorea", "Ghana", "Honduras", "Algeria", "Cameroon", "NorthKorea"]

$teamscore = Hash.new(0)
$groups = {}
$groups[0] = ["Uruguay", "Mexico", "SouthAfrica", "France"]
$groups[1] = ["Argentina", "SouthKorea", "Greece", "Nigeria"]
$groups[2] = ["UnitedStates", "England", "Slovenia", "Algeria"]
$groups[3] = ["Germany", "Ghana", "Australia", "Serbia"]
$groups[4] = ["Holland", "Japan", "Denmark", "Cameroon"]
$groups[5] = ["Paraguay", "Slovakia", "NewZealand", "Italy"]
$groups[6] = ["Brazil", "Portugal", "IvoryCoast", "NorthKorea"]
$groups[7] = ["Spain", "Chile", "Switzerland", "Honduras"]

$average = 1.446078
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

def getWinnerGame(team1, team2) 
  if team2 == "NewZealand" # auto make New Zealand lose because of remoteness
    return team1
  end
  if team1 == "NewZealand"
    return team2
  end
  
  if $offlambda[team1] * $deflambda[team2] > $offlambda[team2] * $deflambda[team1]
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
puts groupwins

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
puts "-----"
puts eightfns
puts "-----"

# Quarters
quarterfns = []
quarterfns[0] = getWinnerGame(eightfns[0], eightfns[2])
quarterfns[1] = getWinnerGame(eightfns[1], eightfns[3])
quarterfns[2] = getWinnerGame(eightfns[4], eightfns[6])
quarterfns[3] = getWinnerGame(eightfns[5], eightfns[7])
puts "-----"
puts quarterfns
puts "-----"

# Semies
semis = []
semis[0] = getWinnerGame(quarterfns[0], quarterfns[2])
semis[1] = getWinnerGame(quarterfns[1], quarterfns[3])
puts "-----"
puts semis
puts "-----"

# Final
finalist = getWinnerGame(semis[0], semis[1])

puts finalist


