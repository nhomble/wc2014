

$topcountries = ["Brazil", "Spain", "Germany", "Argentina"]
$countries = ["Brazil", "Spain", "Germany", "Argentina", "Holland", "England", "Portugal", "Colombia", "Uruguay", "Chile", "Italy", "France", \
    "UnitedStates", "Ecuador", "Russia", "Switzerland", "Belgium", "Mexico", "Greece", "IvoryCoast", "Croatia", "Japan", "Bosnia", "Nigeria", \
    "Iran", "CostaRica", "Australia", "SouthKorea", "Ghana", "Honduras", "Algeria", "Cameroon"]
    
$average = 1.4056925
$deflambda = {}
$offlambda = {}

$fifarankings = Hash.new(100)
$fifarankings["Spain"] = 1
$fifarankings["Germany"] = 2
$fifarankings["Argentina"] = 3
$fifarankings["Italy"] = 4
$fifarankings["Colombia"] = 5
$fifarankings["England"] = 6
$fifarankings["Portugal"] = 7
$fifarankings["Holland"] = 8
$fifarankings["Russia"] = 9
$fifarankings["Croatia"] = 10
$fifarankings["Greece"] = 11
$fifarankings["Switzerland"] = 12
$fifarankings["Ecuador"] = 13
$fifarankings["IvoryCoast"] = 14
$fifarankings["Mexico"] = 15
$fifarankings["Uruguay"] = 16
$fifarankings["France"] = 17
$fifarankings["Brazil"] = 18
$fifarankings["Algeria"] = 19
$fifarankings["Sweden"] = 20
$fifarankings["UnitedStates"] = 28

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

$lines = {};
$countries.each{ |country|
    f2 = open("ELO/ELO"+country+"output.txt", 'r')
    $lines[country] = f2.readlines
}

$totcorrect = 0
$totincorrect = 0

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

$countries.each { |country|
  $lines[country].each { |game|
    if game =~ /(\d+)\s+(\d+)\s+(\w+)\s+(\w+)\s+(\w+)\s+(\d+)\s+(\d+)/
      if ($1.to_i == 2013 or $1.to_i == 2014) and $topcountries.include?(country)
      opponent = $5.rstrip
      score1 = $6.to_i
      score2 = $7.to_i
      if $countries.include?(opponent)
        if $3 == "home" #first score is 
          if score1 == score2
           #do nothing 
          elsif (getWinnerGame(country, opponent) == country and score1 > score2) or (getWinnerGame(country, opponent) == opponent and score1 < score2)
            puts "#{$3} #{country}: We predict #{getWinnerGame(country, opponent)} and the score was #{score1} to #{score2}, correct"
            $totcorrect += 1
          else
            puts "#{$3} #{country}: We predict #{getWinnerGame(country, opponent)} and the score was #{score1} to #{score2}, incorrect"
            $totincorrect += 1
          end
        else 
          if score1 == score2
           #do nothing 
          elsif (getWinnerGame(country, opponent) == country and score1 < score2) or (getWinnerGame(country, opponent) == opponent and score1 > score2)
            $totcorrect += 1
          else
            $totincorrect += 1
          end
        end
      end
    end
    end
  }
}

puts "Our model: There were #{$totcorrect} correct predictions and #{$totincorrect} incorrect predictions"


$countries.each { |country|
  $lines[country].each { |game|
    if game =~ /(\d+)\s+(\d+)\s+(\w+)\s+(\w+)\s+(\w+)\s+(\d+)\s+(\d+)/
      if ($1.to_i == 2013 or $1.to_i == 2014) and $topcountries.include?(country)
      opponent = $5.rstrip
      score1 = $6.to_i
      score2 = $7.to_i
      if $countries.include?(opponent)
        if $3 == "home" #first score is 
          if (score1 == score2) or ($fifarankings[country] == $fifarankings[opponent])
           #do nothing 
          elsif ($fifarankings[country] < $fifarankings[opponent] and score1 > score2) or ($fifarankings[country] > $fifarankings[opponent] and score1 < score2)
            $totcorrect += 1
          else
            $totincorrect += 1
          end
        else 
          if score1 == score2
           #do nothing 
          elsif ($fifarankings[country] < $fifarankings[opponent] and score1 < score2) or ($fifarankings[country] > $fifarankings[opponent] and score1 > score2)
            $totcorrect += 1
          else
            $totincorrect += 1
          end
        end
      end
    end
    end
  }
}

puts "FIFA: There were #{$totcorrect} correct predictions and #{$totincorrect} incorrect predictions"

