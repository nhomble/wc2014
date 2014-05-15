


$countries = ["Brazil", "Spain", "Germany", "Argentina", "Holland", "England", "Portugal", "Colombia", "Uruguay", "Chile", "Italy", "France", \
    "UnitedStates", "Ecuador", "Russia", "Switzerland", "Belgium", "Mexico", "Greece", "IvoryCoast", "Croatia", "Japan", "Bosnia", "Nigeria", \
    "Iran", "CostaRica", "Australia", "SouthKorea", "Ghana", "Honduras", "Algeria", "Cameroon"]


$lines = {}; 
f = open("ELOoutput.txt", 'r')
f2 = open("ELOoutput3.txt", 'w')
lines = f.readlines

lines.each { |line|
  if line =~ /([A-Za-z]+) (\d\.\d+) (\d\.\d+)/
    country = [$1].map(&:capitalize)[0]
    f2.write("#{country}:   #{$2} #{$3}\n")
  end
}