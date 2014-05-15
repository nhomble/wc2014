

# This file processes the ELO files into a formatted set of files that are easy to read


$lastyear = 0
$lastmonth = 0
$lastday = 0

def getMonth (month)
  return 0  if month == "January"
  return 1  if month == "February"
  return 2  if month == "March"
  return 3  if month == "April"
  return 4  if month == "May"
  return 5  if month == "June"
  return 6  if month == "July"
  return 7  if month == "August"
  return 8  if month == "September"
  return 9  if month == "October"
  return 10 if month == "November"
  return 11 if month == "December"
end

def main
  allfiles = Dir.entries("ELO")
  countries = []
  allfiles.each { |file|  # gets list of all files to read
  if file =~ /^ELO(\w+\D).txt/
    if ! file.include?("output")
    countries.push($1)
    end
  end
  }
  
  countries.each{ |country|
    puts "Processing #{country}"
    output = open( "ELO/ELO"+country+"output.txt", 'w' )
    input = open("ELO/ELO"+country+"2.txt", 'r')
    lines = input.readlines
      
    lines.each_slice(9).each{ |game|
      if game[0] =~ /(\w+)\s+(\d+)/
        day = $2.to_i
        month = $1.rstrip
      elsif game[0] =~ /(\w+)/
        month = $1.rstrip
      end
      
      if game[1] =~ /(\d+)\s+(.+)/
        name1 = $2.rstrip
        year = $1.rstrip
      end
      if game[2] =~ /(.*)\s+(\d+)/
        name2 = $1.rstrip
        score1 = $2
      end
      if game[3] =~ /(\d+)\s+(.+)/
        score2 = $1
        type = $2.rstrip
      end
      
      if month == nil # there is no month
        if $lastyear == year
          month = $lastmonth
        else
          month = "January"
        end
      end

      if day == nil # there is no day
        if ($lastyear == year) and ($lastmonth == month)
            day = $lastday + 1
        else
          day = 1
        end
      end
      date = year + " #{getMonth(month)*31 + day}"

      # Special cases for countries
      if name1 == "West Germany"
        name1 = "Germany"
      elsif name2 == "West Germany"
        name2 = "Germany"
      end
      if name1 == "Trinidad and Tobago"
        name1 = "TrinidadTobago"
      elsif name2 == "Trinidad and Tobago"
        name2 = "TrinidadTobago"
      end
      if name1 == "Netherlands"
        name1 = "Holland"
      elsif name2 == "Netherlands"
        name2 = "Holland"
      end
      if name1 == "Bosnia and Herzegovina"
        name1 = "Bosnia"
      elsif name2 == "Bosnia and Herzegovina"
        name2 = "Bosnia"
      end
      if name1 =~ /([A-Z]\w+)\s([A-Z]\w+)/
        name1 = $1 + $2
      end
      if name2 =~ /([A-Z]\w+)\s([A-Z]\w+)/
        name2 = $1 + $2
      end
      
      if name1 == country # at home
        otherteam = name2
        home = "home"
      elsif name2 == country # away
        otherteam = name1
        home = "away"
      else  # changed name
        flag = true 
      end
      
      if (not flag)
        output.write("#{date} #{home} #{country} #{otherteam} #{score1.to_i} #{score2.to_i} #{type}\n")
      
        $lastyear = year
        $lastmonth = month
        $lastday = day
      end
    }
  }
end

main

