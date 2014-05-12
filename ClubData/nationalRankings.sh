#!/usr/bin/env bash

URL='http://www.futhead.com/fifa/nations'
teams=('brazil' 'spain' 'italy' 'france' 'germany' 'argentina' 'england' 'holland' 'portugal' 'belgium' 'russia' 'columbia' 'uruguay' 'serbia' 'chile' 'switzerland' 'ivorycoast' 'cameroon' 'poland' 'mexico' 'croatia' 'morocco' 'nigeria' 'irelandrepublic' 'sweden' 'austria' 'turley' 'czechrepublic' 'unitedstates' 'senegal' 'denmark' 'greece' 'bosniaherzegovina' 'ghana' 'wales' 'slovakia' 'norway' 'peru' 'burkinafaso' 'scotland' 'ecuador' 'japan' 'algeria' 'korearepublic' 'montenegro' 'southafrica' 'paraguay' 'bulgaria' 'mali')
DEBUG=false
for team in ${teams[@]}; do
	DATA="data/$teamDATA.dat"
	if [ ! -e $DATA ]; then
		curl $URL'/'$team'/' -s | grep "Attackers\|Midfielders\|Defenders\|Goal Keepers\|playercard-rating\|playercard-name" > $DATA 
	fi
		
	POSITION=""
	RATING="0"
	PLAYER=""

	NEW_VAL=false

	OFFENSE=0
	DEFENSE=0
	OFFENSE_NUM=0
	DEFENSE_NUM=0
	while read -r DATA_LINE; do
		# first determine position
		lineAtt=$(echo $DATA_LINE | grep "Attackers" | sed 's/.*<h2>\(.*\)<\/h2>/\1/')
		lineMid=$(echo $DATA_LINE | grep "Midfielders" | sed 's/.*<h2>\(.*\)<\/h2>/\1/')
		lineDef=$(echo $DATA_LINE | grep "Defenders" | sed 's/.*<h2>\(.*\)<\/h2>/\1/')
		lineGK=$(echo $DATA_LINE | grep "Goal Keepers" | sed 's/.*<h2>\(.*\)<\/h2>/\1/')
		if [ ! -z "$lineAtt" ]; then
			POSITION="ATTACKERS"
		elif [ ! -z "$lineMid" ]; then
			POSITION="MIDFIELDERS"
		elif [ ! -z "$lineDef" ]; then
			POSITION="DEFENSE"
		elif [ ! -z "$lineGK" ]; then
			POSITION="DEFENSE"
		fi

		# rating is posted before name
		lineRating=$(echo $DATA_LINE | grep "playercard-rating")
		if [ ! -z "$lineRating" ]; then
			RATING=$(echo $lineRating | sed 's/.*>\([0-9]*\)<.*/\1/')
			NEW_VAL=true
		fi

		# get player name
		linePlayer=$(echo $DATA_LINE | grep "playercard-name")
		if [ ! -z "$linePlayer" ]; then
			TEMP_PLAYER=$(echo $linePlayer |  sed 's/.*>\(.*\)<\/div>/\1/')

			# check for duplicate
			if [ "$PLAYER" = "$TEMP_PLAYER" ]; then
				NEW_VAL=false
			else
				PLAYER="$TEMP_PLAYER"
				NEW_VAL=true
			fi
		fi
		# only update when I have a new rating with a new player
		if [ $NEW_VAL = true ]; then
			if [ "$POSITION" = "ATTACKERS" ] || [ "$POSITION" = "MIDFIELDERS" ]; then
				OFFENSE=`expr $OFFENSE + $RATING`
				let OFFENSE_NUM+=1
				if [ $DEBUG = true ]; then
					echo "offense $OFFENSE/$OFFENSE_NUM"
				fi
			fi
			if [ "$POSITION" = "DEFENSE" ]; then
				DEFENSE=`expr $DEFENSE + $RATING`
				let DEFENSE_NUM+=1
				if [ $DEBUG = true ]; then
					echo "defense $DEFENSE/$DEFENSE_NUM"
				fi
			fi
			NEW_VAL=false
		fi
	done < $DATA
	if [ $OFFENSE_NUM -eq "0" ] || [ $DEFENSE_NUM -eq "0" ]; then
		continue
	fi
	retOffense=$(echo "$OFFENSE/$OFFENSE_NUM" | bc -l)
	retDefense=$(echo "$DEFENSE/$DEFENSE_NUM" | bc -l)
	echo "$team $retOffense $retDefense"

done
