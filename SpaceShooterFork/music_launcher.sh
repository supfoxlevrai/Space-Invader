#!/bin/bash

function stop_music {
	if [[ ! -z "$MUSIC_PID" ]]; then
		
		pkill -P $MUSIC_PID > /dev/null 2>&1
		kill $MUSIC_PID > /dev/null 2>&1
		MUSIC_PID=""
	fi
}

function start_menu_music {
	stop_music
	
	while [[ 0 ]];
	do
		paplay "$SCRIPT_DIR/soundEffect/musicMenu.wav" > /dev/null 2>&1
	done &
	
	MUSIC_PID=$!


}

function start_game_music {
	stop_music
	
	while [[ 0 ]];
	do
		paplay "$SCRIPT_DIR/soundEffect/musicGame.wav" > /dev/null 2>&1
	done &
	
	MUSIC_PID=$!


}