#!/usr/bin/env bash

URL='http://www.futhead.com/fifa/nations/'
DEBUG=false
i=0
for j in $(seq 3); do
	MASTER=data/$j'main.txt'
	curl $URL'?page='$j -s | grep "data-club-id" > $MASTER
	while read -r LINE; do
		team=$(echo $LINE | sed 's/.*\"\(.*\)\">/\1/')
		teams[$i]=$team
		let i+=1
	done < $MASTER
done

for team in ${teams[@]}; do
	DATA=data/$teamDATA.txt
	curl $URL$team'/' -s | grep "playercard-position\|playercard-rating\|playercard-name" > $DATA
	POSITION=""
	RATING="0"
	PLAYER=""
	
	NEW_VAL=false
	
	OFFENSE=0
	DEFENSE=0
	OFFENSE_NUM=0
	DEFENSE_NUM=0
	while read -r DATA_LINE; do
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
			fi
		fi

		if [ $NEW_VAL = true ]; then
			linePos=$(echo $DATA_LINE | grep "playercard-position" | sed 's/.*position\">\([A-Z]*\).*/\1/')
			lineMid=$(echo $linePos | grep "AM\|CM\|W")
			lineDef=$(echo $linePos | grep "B\|DM")
			lineAtt=$(echo $linePos | grep "ST\|F")
			if [ ! -z "$lineAtt" ]; then
				POSITION="ATTACKERS"
			elif [ ! -z "$lineMid" ]; then
				POSITION="MIDFIELDERS"
			elif [ ! -z "$lineDef" ]; then
				POSITION="DEFENSE"
			elif [ ! -z "$lineGK" ]; then
				POSITION="DEFENSE"
			else
				continue
			fi
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
		fi
	done < $DATA
	if [ $OFFENSE_NUM -eq "0" ] || [ $DEFENSE_NUM -eq "0" ]; then
		echo "$team failed"
	else
		retOffense=$(echo "$OFFENSE/$OFFENSE_NUM" | bc -l)
		retDefense=$(echo "$DEFENSE/$DEFENSE_NUM" | bc -l)
		echo "$team $retOffense $retDefense"
	fi
done
