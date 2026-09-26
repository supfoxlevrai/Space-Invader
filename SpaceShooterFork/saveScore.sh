#!/bin/bash

function sauvegarder_score {
    local score=$1
    local date_du_jour=$(date "+%d/%m/%Y à %H:%M")
    local config_touche=$2
    local config_ship=$3
    
    # Le fichier est créé automatiquement s'il n'existe pas grâce à '>>'
    echo "$PLAYER_NAME ; $score pts ; le $date_du_jour ; ses touches $config_touche ; son vaisseau $config_ship" >> leaderboard.txt
    echo "Score enregistré avec succès dans le classement !"
}
