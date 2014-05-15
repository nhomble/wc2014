To run the expected simulation, run "WCSimulator.rb"

To simulate WC's by sampling from Poisson, instead of getting expected winners, run "WCSimulator2.rb"

To make new fits, simply run "ELOSimulator.rb" and change the parameters at the top.
The date determines when to stop, and k value determines how quickly the model accepts new games.

Any new countries can be added to ELO by putting them in the format from the files in ELO.
Running "ELOReaderPre.rb", followed by "ELOReader.rb" automatically formats them for use by "ELOSimulator.rb".
If the new country name is eccentric, such as more than two words, it must be accounted for in ELOReader.rb.

Feel free to contact me, Daniel Farias, if you have any questions.