#!/bin/bash
#
# invaders game
#
# v1.3.0 [[fork by Dos Santos Nathanaël]] -> add key mapping, model space ship, sound effect && leaderboard !
# origin script -> https://lipn.fr/~buscaldi/space.sh

VERSION="v1.3.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/changeKeys.sh"
source "$SCRIPT_DIR/changeSpaceShip.sh"
source "$SCRIPT_DIR/header.sh"
source "$SCRIPT_DIR/music_launcher.sh"
source "$SCRIPT_DIR/saveScore.sh"
source "$SCRIPT_DIR/gestionQuit.sh"
source "$SCRIPT_DIR/onClose.sh"

# Make the cursor invisible (man terminfo)
tput civis

header1

sleep 5
tput cvvis
clear

#KEY
L="a"
R="e"
F="z"
Q="q"

#SPACESHIP
SHIELD="|"
WINGS="--"
H="*"
B="*"

# Initialisation du nom du joueur
PLAYER_NAME=""

while [[ -z "$PLAYER_NAME" ]]; do
    read -p "Entrez votre pseudo pour le classement : " PLAYER_NAME
    # Optionnel : remplacer les espaces par des underscores pour éviter les bugs de lecture
    PLAYER_NAME="${PLAYER_NAME// /_}"
done
clear

# On écoute le Ctrl+C (SIGINT)
trap 'gestion_quitter' SIGINT

start_menu_music
cat - << EOF
           SPACE
   LEFT:   $L
   RIGHT:  $R
   FIRE:   $F
   QUIT:   $Q
          
          Welcome $PLAYER_NAME !      Press any key. (to change keys, press $, to change spaceShip model, press !, to change these 2, press *)
EOF


read -n 1 KEY
if [[ "$KEY" == "$" ]]; then	
	continuerChangeKey="n"
	
	while [[ "$continuerChangeKey" == "n" || "$continuerChangeKey" == "N" ]];
	do
		changeKey "LEFT" "RIGHT" "FIRE" "QUIT"
		
		#echo ""
		#echo -e "LEFT -> $L\nRIGHT -> $R\nFIRE -> $F\nQUIT-> $Q"
		echo -n "Satisfait avec les changements (O=oui/n=non) :"
		read -n 1 continuerChangeKey
		
	done

elif [[ "$KEY" == "!" ]]; then	
	continuerChangeSpaceShip="n"
	
	while [[ "$continuerChangeSpaceShip" == "n" || "$continuerChangeSpaceShip" == "N" ]];
	do
		changeSpaceShipModel "SHIELD" "WINGS" "HEAD" "BULLET"
		
		#echo ""
		echo -n "Satisfait avec le changement (O=oui/n=non) :"
		read -n 1 continuerChangeSpaceShip
		
	done

elif [[ "$KEY" == "*" ]]; then
	continuerChangeKey="n"
	continuerChangeSpaceShip="n"
	
	echo -e "\n------KEYS !------"	
	while [[ "$continuerChangeKey" == "n" || "$continuerChangeKey" == "N" ]];
	do
		changeKey "LEFT" "RIGHT" "FIRE" "QUIT"
		
		#echo ""
		#echo -e "LEFT -> $L\nRIGHT -> $R\nFIRE -> $F\nQUIT-> $Q"
		echo -n "Satisfait avec les changements (O=oui/n=non) :"
		read -n 1 continuerChangeKey
		
	done
	
	echo -e "\n------SHIP MODEL !------"
	while [[ "$continuerChangeSpaceShip" == "n" || "$continuerChangeSpaceShip" == "N" ]];
	do
		changeSpaceShipModel "SHIELD" "WINGS" "HEAD" "BULLET"
		
		#echo ""
		echo -n "Satisfait avec le changement (O=oui/n=non) :"
		read -n 1 continuerChangeSpaceShip
		
	done

	
fi
#if elif ==> case !
#kill $MUSIC_MENU_PID > err.txt 2>&1 

SPACESHIPLEFT="$SHIELD$WINGS"
SPACESHIPRIGHT="$WINGS$SHIELD"
config_t="[$L, $R, $F, $Q]"
config_s="[$SHIELD, $WINGS, $H, $B]"

tput civis

start_game_music

row0=( 0 30 30 30 30 30 30 30 30 )
row1=( 0 20 20 20 20 20 20 20 20 )
row2=( 0 15 15 15 15 15 15 15 15 )
row3=( 0 10 10 10 10 10 10 10 10 )
row4=( 0 5 5 5 5 5 5 5 5 )
row5=( 0 1 1 1 1 1 1 1 1 )

aliens1=( '\033[1;32m|0|\033[0m' '\033[1;34m\-/\033[0m'
          '\033[1;35m:x:\033[0m' '\033[1;38m:#:\033[0m'
          '\033[1;33m!|!\033[0m' '\033[1;39m:-:\033[0m' )
aliens2=( '\033[1;32m:0:\033[0m' '\033[1;34m/-\\\033[0m'
          '\033[1;35m-x-\033[0m' '\033[1;38m-#-\033[0m'
          '\033[1;33m:|:\033[0m' '\033[1;39m-:-\033[0m' )

score=0

# farthest right that the *leftmost* alien can go to
MAXRIGHT=46
# furthest right that the ship can go to
FARRIGHT=73

# Ship's current position (x-axis)
ship=30
# Cannon column; remains the same even if ship moves
cannonX=$ship
# Cannon height; 0 means it's ready to fire
cannonY=0
# Positive direction to right, Negative to left
direction=1
offset=20
bottom=20
ceiling=4
MAXCEILING=6
DELAY=0.4

function drawrow
{
  # draw a row of aliens; return the index of any alien killed
  # note that only one alien can be killed at any time.
  alientype=$1
  shift
  let row="$alientype * 2 + $ceiling"
  aliensonrow=`echo $@ | tr ' ' '+' | bc`
  if [ $aliensonrow -eq 0 ]; then
    # Nothing to do here. In particular, do not detect failure.
    # Just clear the previous line (it may contain the final explosion
    # on that row) and return.
    tput cup $row 0
    printf "%80s" " "
    return 0
  fi
  if [ $row -eq $bottom ]; then
    tput cup `expr $bottom - 4` 6
    trap exit ALRM
    
    GameOver 1
  fi
  declare -a thisrow
  thisrow=( `echo $@` )

  tput cup 0 0
  printf "Score: %-80d" $score

  killed=0
  # Clear the previous line
  tput cup `expr $row - 1` 0
  printf "%80s" " "

  tput cup $row 0
  printf "%80s" " "
  tput cup $row 0
  printf "%-${offset}s"

  # Don't do this calculation in the for loop, it is slow even without expr
  if (( $offset % 2 == 0 )); then
    thisalien=${aliens1[$alientype]}
  else
    thisalien=${aliens2[$alientype]}
  fi

  # there are 8 aliens per row.
  for i in `seq 1 8`
  do
    value=${thisrow[$i]}
    avatar=$thisalien
  
    if [ $value -gt 0 ]; then
      # detect and mark a collision
      if [ $row -eq $cannonY ]; then
        let LEFT="$i * 4 + $offset - 4"
        let RIGHT="$i * 4 + $offset - 1"
        if [ $cannonX -ge $LEFT ] && [ $cannonX -le $RIGHT ]; then
          killed=$i

          
          paplay "$SCRIPT_DIR/soundEffect/AlienExplosion.wav" > /dev/null 2>&1 &
          avatar='\033[1;31m***\033[0m'

	  ((score=$score + $value))
       	  cannonY=0
        fi
      fi
    fi

    if [ $value -eq 0 ]; then
      printf "    " 
    else
        echo -en "${avatar} "
    fi
  done
  return $killed
}

function drawcannon
{
  # move the cannon up one
  if [ $cannonY -eq 0 ]; then
    # fell off the top of the screen
    return
  fi

  tput cup $cannonY $cannonX
  printf " "
  ((cannonY=cannonY-1))
  tput cup $cannonY $cannonX
  echo -en "\033[1;31m$B\033[0m" 
}

function drawship
{
  tput cup $bottom 0
  printf "%80s" " "
  tput cup $bottom $ship 
  # Show cannon state by its color in the spaceship
  if [ $cannonY -eq 0 ]; then
    col=31
  else
    col=30
  fi
  echo -en "$SPACESHIPLEFT\033[1;${col}m$H\033[0m$SPACESHIPRIGHT"
  
# spaceship v1.0 => "|--\033[1;${col}m*\033[0m--|"

}

function move
{
  # shift aliens left or right
  # move cannon, check for collision

  (sleep $DELAY && kill -ALRM $$) &
  
  # Change direction if hit the side of the screen
  if [ $offset -gt $MAXRIGHT ] && [ $direction -eq 1 ]; then
    # speed up if hit the right side of the screen
    DELAY=`echo $DELAY \* 0.90 | bc`
    direction=-1
    ((ceiling++))
  elif [ $offset -eq 0 ] && [ $direction -eq -1 ]; then
    direction=1
  fi
  
  ((offset=offset+direction))
  
  drawrow 0 ${row0[@]}
  row0[$?]=0
  drawrow 1 ${row1[@]}
  row1[$?]=0
  drawrow 2 ${row2[@]}
  row2[$?]=0
  drawrow 3 ${row3[@]}
  row3[$?]=0
  drawrow 4 ${row4[@]}
  row4[$?]=0
  drawrow 5 ${row5[@]}
  row5[$?]=0

  aliensleft=`echo ${row0[@]} ${row1[@]} ${row2[@]} ${row3[@]}\
         ${row4[@]} ${row5[@]} \
      | tr ' ' '+' | bc`
  if [ $aliensleft -eq 0 ]; then
    tput cup 5 5
    trap exit ALRM

    GameOver 0
  fi

  drawcannon
  drawship
}

trap move ALRM

clear
drawship
# Start the aliens moving...
move
while :
do
  read -s -n 1 key
  case "$key" in
    "$L") 
       [ $ship -gt 0 ] && ((ship=ship-1)) 
	drawship
	;;
	
    "$R") 
       [ $ship -lt $FARRIGHT ] && ((ship=ship+1)) 
	drawship
	;;
	
    "$F")


	if [ $cannonY -eq 0 ]; then
    paplay "$SCRIPT_DIR/soundEffect/Laser.wav" > /dev/null 2>&1 &
          let cannonX="$ship + 3"
	  cannonY=$bottom
        fi
  
        
	;;
	
    "$Q")
      GameOver
	;;
	
  esac
done
