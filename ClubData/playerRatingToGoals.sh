#!/usr/bin/env bash

DEBUG=false
leagues=('epl' 'laliga' 'ligue' 'series1' 'bundesliga')
URL='http://www.futhead.com/fifa/clubs'
i=0
for league in ${leagues[@]}; do
	FILE="$league".txt

	files[$i]=$FILE
	let i+=1
done

for file in ${files[@]}; do
	if [ $DEBUG = true ]; then
		echo $file
	fi
	while read -r LINE; do
		parse=(`echo $LINE | sed 's/\([a-zA-Z]\)\s\([a-zA-Z]\)/\1\2/g' | awk '{print $2, $7, $8, $3}' | tr " " "\n"`)
		DATA="data/${parse[0]}DATA.txt"
		if [ ! -e $DATA ]; then
			curl $URL'/'${parse[0]}'/' -s | grep "playercard-position\|playercard-rating\|playercard-name" > $DATA 
		fi

		if [ $DEBUG = true ]; then
			echo ${parse[0]} ${parse[1]} ${parse[2]}
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
			# only update when I have a new rating with a new player
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
				NEW_VAL=false
			fi
		done < $DATA
		if [ $OFFENSE_NUM -eq "0" ] || [ $DEFENSE_NUM -eq "0" ]; then
			if [ $DEBUG = true ]; then
				echo "${parse[0]} failed"
			fi
			continue
		fi
		retOffense=$(echo "$OFFENSE/$OFFENSE_NUM" | bc -l)
		retDefense=$(echo "$DEFENSE/$DEFENSE_NUM" | bc -l)
		retGoals=$(echo "${parse[1]}/${parse[3]}" | bc -l)
		retConceded=$(echo "${parse[2]}/${parse[3]}" | bc -l)
		if [ $DEBUG = true ]; then
			echo "club: ${parse[0]} goals: ${parse[1]} conceded: ${parse[2]} OFFENSE: $retOffense DEFENSE: $retDefense"
		else
			echo "${parse[0]} $retGoals $retConceded $retOffense $retDefense"
		fi
	done < $file
done
