

# This program does the pre processing of the ELO files and fill in missing lines

def main
  allfiles = Dir.entries("ELO")
  countries = []
  allfiles.each { |file|
    if file =~ /^ELO(\w+\D).txt/
      if ! file.include?("output")
      countries.push($1)
      end
    end
  }

  countries.each{ |country|
    puts "Processing #{country}"
    output = open( "ELO/ELO"+country+"2.txt", 'w' )
    input = open("ELO/ELO"+country+".txt", 'r')
    lines = input.readlines

    count = 0
    lines.each{ |game|
      if count % 9 == 0
        if game =~ /(\w+)\s+(\d+)/ or game =~ /^(\D+)/
          output.write(game.chomp + "\n")
        else
          output.write("\n")
          output.write(game.chomp + "\n")
        count += 1
        end
      else
        output.write(game.chomp + "\n")
      end

      count += 1;
    }
  }
end

main

