#!/bin/bash

function changeKey {
	local i
	
	echo -e "\n"
	for i in $* ; do
		
		case $i in 
		
		"LEFT")
			LEFT_=$L
			
			echo -n "LEFT :"
			read -n 1 L
			
			echo -e "\n$LEFT_ -> $L"
			;;
		
		"RIGHT")
			RIGHT_=$R
			
			echo -n "RIGHT :"
			read -n 1 R
			
			echo -e "\n$RIGHT_ -> $R"
			;;
			
		"FIRE")
			FIRE_=$F
			
			echo -n "FIRE :"
			read -n 1 F
			
			echo -e "\n$FIRE_ -> $F"
			;;
			
		"QUIT")
			QUIT_=$Q
			
			echo -n "QUIT :"
			read -n 1 Q
			
			echo -e "\n$QUIT_ -> $Q"
			;;
			
		*);;
		esac
	done
}