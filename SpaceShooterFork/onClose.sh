#!/bin/bash

function GameOver {
	local code=$1

	stop_music
	sauvegarder_score "$score" "$config_t" "$config_s"
	case $code in
		0)
			echo "YOU WIN" 

			header2
			sleep 2

		    sleep $DELAY
		    tput echo
		    tput cvvis
		    echo; echo; echo
			
		    exit 0
			;;

		1)
			echo "YOU LOSE"

			header2
			sleep 2

			sleep $DELAY
		    stty echo
		    tput cvvis

		    
		    exit 1
			;;
		*)
			echo -e "\nGoodbye!"
			tput cvvis
			stty echo

			trap exit ALRM

			header2
			sleep 2
			
			sleep $DELAY
			exit 0
			;;
	esac


}