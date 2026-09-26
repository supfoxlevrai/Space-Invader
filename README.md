# 👾 Space Invaders (Bash Edition)

Une version revisitée et enrichie du jeu classique Space Invaders, entièrement jouable dans le terminal Linux en Pure Bash.

> **Note sur la langue :** Vous remarquerez un mélange d'anglais et de français à la fois dans le code et les interfaces. Ce jongle bilingue est totalement volontaire !

## 🚀 Fonctionnalités (Fork v1.3.0)

Cette version apportée par Dos Santos Nathanaël améliore le script original en y ajoutant :

- **Mappage de touches personnalisé** : Possibilité de redéfinir les touches de déplacement, de tir et de pause/quitter au lancement.
- **Personnalisation du vaisseau** : Choix des symboles composants le vaisseau (bouclier, ailes, canon, projectiles).
- **Effets sonores & Musiques** : Gestion audio via `pulseaudio` / `paplay` (musique de menu, jeu et effets de tir/explosion).
- **Système de classement (Leaderboard)** : Sauvegarde des scores associés au pseudo du joueur.
- **Gestion propre des interruptions** : Capture du signal `SIGINT` (`Ctrl+C`) et fermeture propre des processus audio.

## 🛠️ PRÉREQUIS

Pour exécuter le jeu avec le support audio et la manipulation fluide du terminal, vous aurez besoin de :

- Bash (`bash`)
- tput / ncurses
- bc (calculateur en ligne de commande pour la logique du jeu)
- pulseaudio-utils (pour la commande `paplay` gérant les sons)

### Installation des dépendances (Ubuntu/Debian)

```bash
sudo apt update
sudo apt install bc pulseaudio-utils ncurses-bin
```
### Installation des dépendances sur macOS / Windows

#### 🍎 macOS

Le script nécessite `bash`, `bc`, `ncurses` (déjà présent nativement) ainsi que `pulseaudio-utils` pour la gestion du son. Utilisez [Homebrew](https://brew.sh) :

```bash
brew install bash bc pulseaudio
```

> ⚠️ **Note audio** : macOS utilise CoreAudio et non PulseAudio nativement. La commande `paplay` ne fonctionnera pas directement sans configuration supplémentaire (ex. installer et lancer un serveur PulseAudio en arrière-plan). Si vous rencontrez des soucis de son, vous pouvez lancer le jeu sans les effets audio.

#### 🪟 Windows

Le script étant écrit en Bash pur et s'appuyant sur des outils Linux (`tput`, `paplay`...), il **n'est pas compatible nativement** avec l'invite de commandes (CMD) ou PowerShell. Vous devez passer par **WSL (Windows Subsystem for Linux)** :

1. Installez WSL avec une distribution Ubuntu (si ce n'est pas déjà fait) :

```powershell
wsl --install
```

2. Une fois dans votre terminal Ubuntu (WSL), installez les dépendances comme sur Linux :

```bash
sudo apt update
sudo apt install bc pulseaudio-utils ncurses-bin
```

3. Pour que le son fonctionne sous WSL, vous devrez configurer un serveur audio (ex. [PulseAudio pour Windows](https://www.freedesktop.org/wiki/Software/PulseAudio/Ports/Windows/Support/) ou WSLg si vous êtes sur WSL2 avec une version récente de Windows 11, qui gère l'audio nativement).

## 📁 Structure du Projet

```
.
├── space.sh             # Script principal du jeu
├── changeKeys.sh        # Module de configuration des touches
├── changeSpaceShip.sh   # Module de personnalisation du vaisseau
├── header.sh            # Entête et affichage du titre
├── music_launcher.sh    # Gestionnaire de boucles musicales
├── saveScore.sh         # Module d'enregistrement des scores
├── gestionQuit.sh       # Gestion des interruptions et du Quit
├── onClose.sh           # Nettoyage à la fermeture du jeu
└── soundEffect/         # Fichiers audio (.wav)
```

## 🕹️ Lancement & Jouabilité

1. Rendez le script principal exécutable :

```bash
chmod +x space.sh
```

2. Lancez le jeu :

```bash
./space.sh
```

3. Commandes par défaut :

   - **Gauche** : `a`
   - **Droite** : `e`
   - **TIR** : `z`
   - **Quitter** : `q`

## 📜 Crédits & Origines

- **Fork & Améliorations v1.3.0** : Dos Santos Nathanaël
- **Script d'origine** : https://lipn.fr/~buscaldi/space.sh

> ***PS*** : à propos du son, il se peut que l'audio buggue par moments ; en tant que simple étudiant, ce n'est évidemment pas une excuse, mais il faut bien avouer que gérer de l'audio directement en Bash... c'est pas évident !
