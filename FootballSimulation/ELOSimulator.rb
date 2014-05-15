
# This file does the actual simulation of the Lambdas values over time

puts "Starting\n"

# The following parameters can be changed
$year = 2014 # year to stop
$day = 165
$k = 50


$average = 1.4056925 # average number of goals
$deflambda = Hash.new($average)
$offlambda = Hash.new($average)
$totgoalsaway = Hash.new(0)
$numiterations = 1  # number of times to iterate iterations
$iteration = 1      # current iteration

$totgames = Hash.new(0)
$totgoals = Hash.new(0)
$totgamesaway = Hash.new(0)
$countriescheck = {}  # debugger to make sure all coutries are reading

allfiles = Dir.entries("ELO") # inputs all countries into "countries"
$countries = []
allfiles.each { |file|
  if file =~ /^ELO(\w+\D).txt/
    if ! file.include?("output")
      $countries.unshift($1)
      $countriescheck[$1] = false
    end
  end
}

$lines = {};                  # inputs all games into "lines"
$countries.each{ |country|
    f2 = open("ELO/ELO"+country+"output.txt", 'r')
    $lines[country] = f2.readlines
}
    
def updateLambdas (country, opponent, scored, conceded, year, day, friendly) # UPDATE function
  const = 1 if friendly
  const = 2 if not friendly
    
  $countriescheck[country] = true # says that country updated
  olamb = $offlambda[country]
  dlamb = $deflambda[country]
  
  olamb2 = $offlambda[opponent]
  dlamb2 = $deflambda[opponent]
  
  if country == "Debug" # Debugger for a specific country
    puts "The current lambdas are: #{olamb} and #{dlamb}"
    puts "The game was against #{opponent} and scored #{scored} and conceded #{conceded}"
    puts "The date was year #{year} and day #{day}"
  end
  
  $offlambda[country] = ( ($k-1)*olamb + (const * scored * $average / dlamb2) ) / ($k + const - 1)
  $deflambda[country] = ( ($k-1)*dlamb + (const * conceded * $average / olamb2) ) / ($k + const - 1)
end

def main
  counter = Hash.new(0);
  
  year = 1870; # year and day to start
  day = 1;
  
  while (year < $year or day < $day)
    # go through each country and check if there is a game
    $lines.keys.each { |country|
      while true # required in the case of multiple games in same day
        
      if counter[country] < $lines[country].length
      
        game = $lines[country][counter[country]] # gets the game we are going to process next
      
        if game =~ /(\d+)\s+(\d+)\s+(\w+)\s+(\w+)\s+(\w+)\s+(\d+)\s+(\d+)\s+(\w+)/
          if $countries.include?($5.rstrip)
            friendly = ($8.rstrip == "friendly")
            opponent = $5.rstrip
            if $1.to_i == year and $2.to_i == day # if the game is today
          
              # advance a line
              counter[country] += 1
          
              # execute game 
              if $3 == "home"
                updateLambdas($4, $5, $6.to_i, $7.to_i, $1, $2, friendly)
                $totgoals[country] += ($6.to_i + $7.to_i)
                $totgames[country] += 1
              else
                updateLambdas($4, $5, $7.to_i, $6.to_i, $1, $2, friendly)
                $totgoalsaway[country] += ($6.to_i + $7.to_i)
                $totgamesaway[country] += 1
              end
              else # game is not today
                break
              end
            else # country not in database
              counter[country] += 1
              #puts "Country not in database: #{$5.rstrip}"
            break
          end
        else # incorrect format
          counter[country] += 1 #skip this line
          break
        end
      else # is done
        break
      end
      end
    }
    
    day += 1
    if day == 372
      year += 1
      day = 1
    end
  end

  puts "Iteration #{$iteration}"
  $countries.each { |country|
  puts "#{country}:   #{$offlambda[country]} #{$deflambda[country]}"
  #puts "The goals scored at home were #{$totgoals[country]} in #{$totgames[country]} games"
  #puts "The goals scored away were #{$totgoalsaway[country]} in #{$totgamesaway[country]} games"
  }
  puts "\n\n"
  $iteration += 1
end

$numiterations.times { main }

#total = 0
#$totgames.keys.each{|country| total += $totgames[country]}
#$totgamesaway.keys.each{|country| total += $totgamesaway[country]}
#totalg = 0
#$totgames.keys.each{|country| totalg += $totgoals[country]}
#$totgamesaway.keys.each{|country| totalg += $totgoalsaway[country]}
#puts "#{totalg} goals in #{total} games"

$output = open( "ELOoutput2.txt", 'w' )
$countries.each { |country|
  $output.write("#{country}:   #{$offlambda[country]} #{$deflambda[country]}\n")
}

puts "Potentially improper files:"  
$countriescheck.keys.each { |country|
  puts "This country didn't update at all: #{country}" if $countriescheck[country] == false
}

