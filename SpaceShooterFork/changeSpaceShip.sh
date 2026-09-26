#!/bin/bash

function changeSpaceShipModel {
	local i
	
	echo -e "\n"
	for i in $* ; do
		
		case $i in 
		
		"SHIELD")
			SHIELD_=$SHIELD
			
			echo -en "\nSHIELD  :"
			read -n 1 SHIELD
			
			echo -e "\n$SHIELD_ -> $SHIELD"
			;;
		
		"WINGS")
			WINGS_=$WINGS
			
			echo -n "WINGS :"
			read -n 2 WINGS
			
			echo -e "\n$WINGS_ -> $WINGS"
			;;

		"HEAD")
			H_=$H
			
			echo -n "HEAD :"
			read -n 1 H
			
			echo -e "\n$H_ -> $H"
			;;
			
			
		"BULLET")
			B_=$B
			
			echo -n "BULLET :"
			read -n 1 B
			
			echo -e "\n$B_ -> $B"
			;;
			
		*);;
		esac
	done

}