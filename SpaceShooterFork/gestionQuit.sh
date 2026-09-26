#!/bin/bash

# 1. On définit ce qui doit se passer
gestion_quitter() {
    echo -e "\n\n[!] Fin de partie brutale via Ctrl+C !"
    
    # Vous pouvez appeler votre sauvegarde ici si le score existe déjà
    if [[ -n "$score" ]]; then
    	config_t="$L, $R, $F, $Q"
  		config_s="$SHIELD, $WINGS, $H, $B"
  		
        sauvegarder_score "$score"
    fi
    
    echo "Merci d'avoir joué !"
    echo -e "Si la musique de fond est toujours en cours:\n1. fait ps puis repérez les lignes paplay et space.sh\n2. kill d'abord le PID de space puis de paplay "
    echo "(si vous kill le PID de paplay en premier, la musique continuera à jouer en boucle 💔)"
    exit 0 # On quitte proprement le script avec le code 0
}
