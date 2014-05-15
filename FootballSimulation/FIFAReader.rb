#!/usr/local/bin/ruby

#require enumerate

def main
  countries = ["Brazil", "Spain", "Germany", "Argentina", "Holland", "England", "Portugal", "Colombia", "Uruguay", "Chile", "Italy", "France", \
    "UnitedStates", "Ecuador", "Russia", "Switzerland", "Belgium", "Mexico", "Greece", "IvoryCoast", "Croatia", "Japan", "Bosnia", "Nigeria", \
    "Iran", "CostaRica", "Australia", "SouthKorea", "Ghana", "Honduras", "Algeria", "Cameroon"]

  countries.each{ |country|
    output = open( "FIFA/FIFA"+country+"output.txt", 'w' )
    f2 = open("FIFA/FIFA"+country+".txt", 'r')
    lines = f2.readlines

    fcount = 0; fplayers = {};
    mcount = 0; mplayers = {};
    dcount = 0; dplayers = {};
    gcount = 0; gplayers = {};
    count = 0; doubles = 0;

    lines.each_slice(3).each{ |game|
      if game[0] =~ /(.*)/
      player = $1.rstrip[0, $1.rstrip.length/2]
      end
      if game[2] =~ /(\d+).(\w+).(\d+).(\d+).(\d+).(\d+).(\d+).(\d+)/
      rating = $1.to_i
      position = $2.rstrip

      pace = $3.to_i
      shooting = $4.to_i
      passing = $5.to_i
      dribbling = $6.to_i
      defending = $7.to_i
      heading = $8.to_i
      end
      #puts "#{player} #{rating} #{position} #{} #{} #{} "

      if position.include? "M"
        # This is a midfielder
        if !mplayers.has_key? player
        mplayers[player] = rating
        count += 1
        else
        doubles += 1
        end
      elsif position == "ST" or position == "CF" or position.include? "W"
        # This is a forward
        if !fplayers.has_key? player
        fplayers[player] = rating
        count += 1
        else
        doubles += 1
        end
      elsif position == "GK"
        # This is the goalie
        if !gplayers.has_key? player
        gplayers[player] = rating
        count += 1
        else
        doubles += 1
        end
      else
      # This is a defender
        if !dplayers.has_key? player
        dplayers[player] = rating
        count += 1
        else
        doubles += 1
        end
      end
    }

    puts
    puts country
    puts "{" + fplayers.sort_by{|k,v|-v}.map{|k,v| "#{k.inspect}=>#{v.inspect}"}.join(", ") + "}"
    puts "{" + mplayers.sort_by{|k,v|-v}.map{|k,v| "#{k.inspect}=>#{v.inspect}"}.join(", ") + "}"
    puts "{" + dplayers.sort_by{|k,v|-v}.map{|k,v| "#{k.inspect}=>#{v.inspect}"}.join(", ") + "}"
    puts "{" + gplayers.sort_by{|k,v|-v}.map{|k,v| "#{k.inspect}=>#{v.inspect}"}.join(", ") + "}"
    #puts "#{country}   :\tThere are #{count} players, and there were #{doubles} repeats"
  }
end

main
