#!/bin/bash
# version 1.0.25
# Aperçu de ce que donne le script en capture vidéo ici : https://asciinema.org/a/5G8rzzZ4WM6Lx8JCjmwYtNiAs

#  Copyleft 2018 Simbd
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.

#code mise en forme
noir='\e[1;30m'
gris='\e[1;37m'
rouge='\e[1;31m'
rougesouligne='\e[4;31m'
vert='\e[1;32m'
jaune='\e[1;33m'
bleu='\e[1;34m'
violet='\e[1;35m'
cyan='\e[1;36m'
neutre='\e[0;m'
clear

# Contrôle de la configuration système (script correctement lancé + version 18.04 + gnome-shell présent)
. /etc/lsb-release
archi=$(uname -i)  #création d'une variable contenant l'architecture si elle est 32 ou 64 bits pour vérification

if [ "$UID" -ne "0" ]
then
    echo -e "${rouge}Ce script doit se lancer avec les droits d'administrateur : sudo ./script.sh${neutre}"
    exit
    elif  [ "$DISTRIB_RELEASE" != "18.04" ]
    then
        echo -e "${rouge}Désolé $SUDO_USER, ce script n'est conçu que pour la 18.04LTS alors que vous êtes actuellement sur la version $DISTRIB_RELEASE${blanc}"
        exit
        elif [ "$(which gnome-shell)" != "/usr/bin/gnome-shell" ]
        then
            clear
            echo -e "${vert}NB : Comme vous utilisez une variante et non la version de base d'Ubuntu, 2 questions spécifiques à Gnome seront ignorés${neutre}"
            echo "*******************************************************"
            echo -e "${bleu}0/Vous utilisez actuellement une variante, merci de préciser laquelle (il est recommandé d'être en 64 bits) :${neutre}"
            echo "*******************************************************"
            echo -e "${jaune}[1] Xubuntu 18.04 x64 (Xfce)${neutre}"
            echo -e "${violet}[2] Ubuntu Mate 18.04 x64 (Mate)${neutre}"
            echo -e "${cyan}[3] Lubuntu ou Lubuntu Next 18.04 x64 (Lxde ou LxQt)${neutre}"
            echo -e "${gris}[4] Kubuntu 18.04 x64 (Kde/Plasma)${neutre}"            
            echo -e "${vert}[5] Autres variantes basées sur la 18.04 x64 (ex: Kubuntu 18.04, Ubuntu Budgie 18.04...)${neutre}" 
            read -p "Répondre par le chiffre correspondant (exemple : 1) : " distrib
fi
clear

# Vérification de l'architecture
if [ "$archi" != "x86_64" ]
then
    echo -e "${rouge}ATTENTION : vous n'êtes pas sous une architecture 64 bits actuellement ! Ce script est testé uniquement pour la version 64 bits. Beaucoup de logiciels ne seront installés qu'en 64 bits (dans ce cas ils ne pourront pas s'installer), néammoins la plupart devraient pouvoir s'installer en 32 bits${neutre}"
    echo "===================="
    read -p "Si vous voulez quand même poursuivre si vous êtes en 32 bits, écrivez : poursuivre : " poursuite
    if [ "$poursuite" != "poursuivre" ]
    then
        exit
    fi
fi

########################
echo "Ok, vous avez correctement lancé le script, passons aux questions..."
echo -e "#########################################################"
echo -e "Voici la légende pour vous informer de certaines choses :"
echo -e "${jaune}[Snap]${neutre} => Le paquet s'installera avec Snap (snap install...)"
echo -e "${bleu}[Flatpak]${neutre} => S'installera avec Flatpak, une alternative aux snaps (flatpak install --from...)"
echo -e "${vert}[Appimage]${neutre} => Application portable (pas d'installation), à lancer comme ceci : ./nomdulogiciel.AppImage"
echo -e "${gris}[PPA]${neutre} = Utilisation d'un PPA pour l'installation du logiciel"
echo -e "${gris}[DepExt]${neutre} = Utilisation d'un dépot externe (autre que PPA) pour l'installation du logiciel"
echo -e "${rouge}[I!]${neutre} => Intervention nécessaire : installation pas totalement automatisé (par ex : valider contrat de licence)"
echo -e "${rouge}[D!]${neutre} => Dangereux : le logiciel est potentiellement instable, déconseillé aux novices !"
echo -e "${violet}[X!]${neutre} => Xorg uniquement : logiciel ok en session Xorg (par défaut) mais pas en session Wayland (choix alternatif sous Gnome)"
echo -e "${cyan}[M!]${neutre} => Manuel : pas de raccourci, il faudra aller vous même dans le dossier et le lancer manuellement, parfois en CLI"

echo -e "Si rien de précisé => Installation classique depuis les dépots officiels ou avec un .deb récupéré"
echo -e "#########################################################\n"    

### Section interactive avec les questions

## Mode normal
# Question 1 : sélection du mode de lancement du script
echo -e "${vert}Conseil: Mettez votre terminal en plein écran pour un affichage plus agréable${neutre}"
echo "*******************************************************"
echo -e "${bleu}1/ Mode de lancement du script :${neutre}"
echo "*******************************************************"
echo -e "[1] Mode ${bleu}Manuel niveau 1${neutre} (choix par défaut, recommandé pour la plupart des utilisateurs : pose diverses questions simples)"
echo -e "[2] Mode ${jaune}Manuel niveau 2${neutre} (Des choix supplémentaires notamment en terme de logiciel de dev, des extensions, optimisation système)"
echo -e "[3] Mode ${vert}Manuel niveau 3${neutre} (En plus du niveau2 propose un large choix supplémentaire de snap/flatpak/appimages)"
echo -e "[10] Profil 1 (automatique) - Novices (Quelques logiciels installés pour les débutants)"
echo -e "[11] Profil 2 (automatique) - Technicien IT (Cadre professionnel pour l'assistance technique)"
echo -e "[12] Profil 3 (automatique) - Etablissements scolaires (Collèges, lycées, universités)"
echo -e "[13] Profil 4 (automatique) - Cedric.F (Installations personnalisées spécifiques pour Bristow)"
echo "*******************************************************"
read -p "Répondre par le chiffre correspondant (par défaut: 1) : " choixMode
clear

while [ "$choixMode" != "1" ] && [ "$choixMode" != "2" ] && [ "$choixMode" != "3" ] && [ "$choixMode" != "10" ] && [ "$choixMode" != "11" ] && [ "$choixMode" != "12" ] && [ "$choixMode" != "13" ]
do
    read -p "Désolé, je ne comprend pas votre réponse, les seuls choix possibles sont 1 (Manuel niv1), 2 (Manuel niv2), 3 (Manuel niv3) ainsi que les modes automatiques (10, 11, 12) : " choixMode
    clear
done

if [ "$choixMode" = "12" ] # étab scolaire (fait appel au script externe dédié aux établissements scolaires)
then
    wget https://raw.githubusercontent.com/dane-lyon/clients-linux-scribe/master/ubuntu-et-variantes-postinstall.sh ; chmod +x ubuntu-et-variantes-postinstall.sh
    ./ubuntu-et-variantes-postinstall.sh ; rm ubuntu-et-variantes-postinstall.sh
    exit
fi

if [ "$choixMode" != "10" ] && [ "$choixMode" != "11" ] && [ "$choixMode" != "13" ] 
then
    if [ "$(which gnome-shell)" = "/usr/bin/gnome-shell" ]
    then
        echo "======================================================="
        echo -e "${vert}Astuce 2: Pour toutes les questions, le choix [1] correspond toujours au choix par défaut, si vous faites ce choix, vous pouvez aller plus vite en validant directement avec la touche 'Entrée' de votre clavier.${neutre}"
        # Question 2 : Session 
        echo "*******************************************************"
        echo -e "${bleu}2/ Quelle(s) session(s) supplémentaire(s) souhaitez-vous installer ? (plusieurs choix possibles)${neutre}"
        echo "*******************************************************"
        echo "[1] Aucune, rester avec la session Ubuntu par défaut (cad Gnome customizé + 2 extensions)"
        echo "[2] Ajouter la session 'Gnome Vanilla' (cad une session Gnome non-customizé et sans extension)"
        echo "[3] Ajouter la session 'Gnome Classique' (interface plus traditionnelle dans le style de Gnome 2 ou Mate)"
        echo "[4] Ajouter la session 'Unity' (l'ancienne interface d'Ubuntu utilisé avant la 17.10)"
        echo -e "[5] Ajouter une session avec Communitheme (via Snap) ${jaune}[Snap]${neutre}"
        echo "*******************************************************"
        read -p "Répondre par le ou les chiffres correspondants séparés d'un espace (exemple : 1) : " choixSession
        clear
    fi
    
    # Question 3 : Navigateur web 
    echo -e "${vert}Astuce 3: vous pouvez faire plusieurs choix, il suffit d'indiquer chaque chiffre séparé d'un espace, par exemple : 2 4 12 19${neutre}"
    echo "*******************************************************"
    echo -e "${bleu}3/ Quel(s) navigateur(s) vous intéresse(nt) ? (plusieurs choix possibles)${neutre}"
    echo "*******************************************************"
    echo "[1] Pas de navigateur supplémentaire (Firefox stable, version classique, par défaut)"
    echo -e "[2] Beaker ${vert}[Appimage]${neutre} (Navigateur opensource qui permet de surfer en P2P)"
    echo -e "[3] Brave ${jaune}[Snap]${neutre} (Navigateur avec protection pour la vie privée avec blocage des pisteurs)"
    echo "[4] Chromium (la version libre/opensource de 'Google Chrome')"
    echo "[5] Dillo (navigateur capable de tourner sur des ordinosaures)"
    echo -e "[6] Eolie ${bleu}[Flatpak]${neutre} (une autre alternative pour Gnome)"
    echo "[7] Falkon [QupZilla] (une alternative libre et légère utilisant Webkit)"   
    echo -e "[8] Firefox Béta ${gris}[PPA]${neutre} (n+1 : 1 version d'avance, remplace la version classique)"
    echo -e "[9] Firefox Developer Edition ${bleu}[Flatpak]${neutre} (version alternative incluant des outils de développement, généralement n+1/n+2)"
    echo -e "[10] Firefox ESR ${gris}[PPA]${neutre} (version plutôt orientée entreprise/organisation)"
    echo -e "[11] Firefox Nightly ${bleu}[Flatpak]${neutre} (toute dernière build en dev, n+2/n+3)" 
    echo "[12] Gnome Web/Epiphany (navigateur de la fondation Gnome s'intégrant bien avec cet environnement)"
    echo -e "[13] Google Chrome ${gris}[DepExt]${neutre}(Le navigateur propriétaire de Google)"
    echo "[14] Lynx (navigateur 100% en ligne de commande, pratique depuis une console SSH)"
    echo -e "[15] Midori ${gris}[DepExt]${neutre} (libre & léger mais un peu obsolète maintenant...)"
    echo -e "[16] Min ${gris}[DepExt]${neutre} (un navigateur minimaliste et donc très léger)" 
    echo -e "[17] Opera ${gris}[DepExt]${neutre} (navigateur norvégien, propriétaire, basé sur Chromium)"
    echo -e "[18] PaleMoon ${gris}[DepExt]${neutre} (un navigateur plutôt récent, libre & performant)"
    echo -e "[19] SRWare Iron (Dérivé de Chromium avec des améliorations sur la confidentialité des données)"
    echo "[20] Tor Browser (pour naviguer dans l'anonymat avec le réseau tor : basé sur Firefox ESR)"
    echo -e "[21] Vivaldi ${gris}[DepExt]${neutre} (un navigateur propriétaire avec une interface sobre assez particulière)"
    echo -e "[22] WaterFox ${gris}[DepExt]${neutre} (un fork de Firefox compatible avec les anciennes extensions)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants séparés d'un espace (exemple : 4 9 21) : " choixNavigateur
    clear

    # Question 4 : Messagerie instantanée
    echo "*******************************************************"
    echo -e "${bleu}4/ Quel(s) logiciel(s) de mail/messagerie instantanée/tchat/ToIP souhaitez-vous ?${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun supplément (Thunderbird par défaut)"
    echo -e "[2] Discord ${bleu}[Flatpak]${neutre} (logiciel propriétaire multiplateforme pour communiquer à plusieurs)"
    echo "[3] Ekiga (anciennement 'Gnome Meeting', logiciel de visioconférence/VoIP)"
    echo "[4] Empathy (messagerie instantanée adaptée à Gnome, multi-protocole)"
    echo "[5] Gajim (un autre client Jabber utilisant GTK+)"
    echo "[6] Hexchat (client IRC, fork de xchat)"
    echo -e "[7] Jitsi ${gris}[DepExt]${neutre} (anciennement 'SIP Communicator' surtout orienté VoIP)"
    echo "[8] Linphone (visioconférence utilisant le protocole SIP)"
    echo "[9] Mumble (logiciel libre connue chez les gameurs pour les conversations audios à plusieurs)"
    echo "[10] Pidgin (une alternative à Empathy avec l'avantage d'être multiplateforme)"
    echo "[11] Polari (client IRC pour Gnome)"
    echo "[12] Psi (multiplateforme, libre et surtout conçu pour le protocole XMPP cad Jabber)"
    echo "[13] Ring (anciennement 'SFLphone', logiciel très performant pour la téléphonie IP)"
    echo -e "[14] Signal ${jaune}[Snap]${neutre} (messagerie instantanée cryptée recommandée par Edward Snowden)"
    echo -e "[15] Skype ${gris}[DepExt]${neutre} (logiciel propriétaire de téléphonie, vidéophonie et clavardage très connue)"
    echo -e "[16] Slack ${jaune}[Snap]${neutre} (plate-forme de communication collaborative propriétaire avec gestion de projets)"
    echo -e "[17] TeamSpeak ${cyan}[M!]${neutre} (équivalent à Mumble mais propriétaire)"
    echo -e "[18] Telegram (appli de messagerie basée sur le cloud avec du chiffrage)"
    echo -e "[19] Viber ${bleu}[Flatpak]${neutre} (logiciel de communication, surtout connu en application mobile)"
    echo -e "[20] Weechat (client IRC léger, rapide et flexible s'utilisant en CLI)"   
    echo -e "[21] Wire ${gris}[DepExt]${neutre} (un autre client de messagerie instantanée chiffrée créé par Wire Swiss)" 
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 6 10 14) : " choixMessagerie
    clear

    # Question 5 : Download/Upload
    echo "*******************************************************"
    echo -e "${bleu}5/ Quel(s) logiciel(s) de téléchargement/torrent/copie voulez-vous ?${neutre}"
    echo "*******************************************************"
    echo "[1] Pas de supplément (Transmission par défaut)"
    echo "[2] aMule (pour le réseau eDonkey2000, clone de Emule)"
    echo "[3] Bittornado (client très simple qui permet de se connecter au réseau BitTorrent)"
    echo "[4] Deluge (client BitTorrent basé sur Python et GTK+)"
    echo "[5] EiskaltDC++ (stable et en français, pour le réseau DirectConnect)"
    echo "[6] FileZilla (logiciel très répandu utilisé pour les transferts FTP ou SFTP)"
    echo -e "[7] FrostWire ${gris}[DepExt]${neutre} (client multiplate-forme pour le réseau Gnutella)"
    echo "[8] Grsync (une interface graphique pour l'outil rsync)"
    echo "[9] Gtk-Gnutella (un autre client stable et léger avec pas mal d'options)"
    echo -e "[10] Gydl ${jaune}[Snap]${neutre} (permet de télécharger des vidéos Youtube ou juste la piste audio)"
    echo "[11] Ktorrent (client torrent pour l'environnement de bureau KDE/Plasma)"    
    echo "[12] Nicotine+ (client P2P pour le réseau mono-source Soulseek)"
    echo "[13] qBittorrent (client BitTorrent léger développé en C++ avec Qt)"    
    echo "[14] Rtorrent (client BitTorrent en ligne de commande donc très léger)"
    echo "[15] SubDownloader (téléchargement de sous-titre)"
    echo -e "[16] Vuze ${jaune}[Snap]${neutre} (plate-forme commerciale d'Azureus avec BitTorrent)"
    echo -e "[17] WebTorrent ${bleu}[Flatpak]${neutre} (permet le streamming de flux vidéo décentralisé via le protocole bittorrent)"
    echo -e "[18] WormHole (un outil en CLI permettant le transfert sécurisé à travers n'importe quel réseau)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 4 6 8 14 18) : " choixTelechargement
    clear

    # Question 6 : Lecture multimédia
    echo -e "${vert}Astuce 4: Il est recommandé de choisir au moins VLC ou MPV car Totem est assez limité (lecteur de base)${neutre}"
    echo "*******************************************************"
    echo -e "${bleu}6/ Quel(s) logiciel(s) de lecture audio/vidéo/stream voulez-vous ?${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun supplément (normalement par défaut : Totem pour la vidéo, Rhythmbox pour la musique)"
    echo "[2] Audacious (lecteur complet pour les audiophiles avec beaucoup de plugins)"
    echo "[3] Banshee (lecteur audio assez complet équivalent à Rhythmbox)"
    echo "[4] Clementine (lecteur audio avec gestion des pochettes, genres musicaux...)"
    echo -e "[5] DragonPlayer (lecteur vidéo pour l'environnement Kde)" 
    echo "[6] Gmusicbrowser (lecteur avec une interface très configurable)"
    echo "[7] Gnome MPV (Interface graphique GTK+ au lecteur mpv, léger, capable de lire de nombreux formats)" 
    echo "[8] Gnome Music (utilitaire 'Musique' de la fondation Gnome pour la gestion audio, assez basique)"
    echo "[9] Gnome Twitch (pour visionner les flux vidéo du site Twitch depuis votre bureau sans utiliser de navigateur)"
    echo -e "[10] GRadio ${bleu}[Flatpak]${neutre} (application Gnome pour écouter la radio, plus de 1 000 références rien qu'en France !)"
    echo -e "[11] Guayadeque ${gris}[PPA]${neutre} (lecteur audio et radio avec une interface agréable)"
    echo -e "[12] Lollypop ${bleu}[Flatpak]${neutre} (lecteur de musique adapté à Gnome avec des fonctions très avancées)"
    echo -e "[13] Molotov.TV ${vert}[Appimage]${neutre} (service français de distribution de chaînes de TV)"
    echo -e "[14] MuseScore (l'éditeur de partitions de musique le plus utilisé au monde !)"
    echo "[15] Musique (un lecteur épuré)"
    echo "[16] Qmmp (dans le même style de Winamp pour les fans)"
    echo "[17] QuodLibet (un lecteur audio très puissant avec liste de lecture basée sur les expressions rationnelles)"
    echo "[18] Rhythmbox (lecture audio et de gestion de bibliothèque musicale, normalement proposé par défaut sauf en mode minimal)"
    echo "[19] SmPlayer (lecteur basé sur mplayer avec une interface utilisant Qt)"
    echo -e "[20] Spotify ${jaune}[Snap]${neutre} (permet d'accéder gratuitement et légalement à de la musique en ligne)"
    echo -e "[21] VLC {branche 3.0 Stable} ${vert}[Recommandé]${neutre} (le couteau suisse de la vidéo, très complet !)"
    echo -e "[22] VLC Dev (backporté) ${jaune}[Snap]${neutre} dernière version en développement - branche Edge/instable (4.0...)"    
    echo "[23] Xmms2+Gxmms2 (un autre lecteur audio dans le style de Winamp)" 
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 4 7 13 20) : " choixMultimedia
    clear

    # Question 7 : Traitement/montage video
    echo "*******************************************************"
    echo -e "${bleu}7/ Souhaitez-vous un logiciel de montage/encodage vidéo ?${neutre}"
    echo "*******************************************************"
    echo "[1] Non, aucun ajout"
    echo -e "[2] Cinelerra ${gris}[PPA]${neutre} (montage non-linéaire sophistiqué, équivalent à Adobe première, Final Cut et Sony Vegas"
    echo "[3] DeVeDe (création de DVD/CD vidéos lisibles par des lecteurs de salon)"
    echo -e "[4] Flowblade ${violet}[X!]${neutre} (logiciel de montage vidéo multi-piste performant)"
    echo "[5] Handbrake (transcodage de n'importe quel fichier vidéo)"
    echo "[6] KDEnLive (éditeur vidéo non-linéaire pour monter sons et images avec effets spéciaux)"        
    echo "[7] Libav-tools (fork de FFmpeg, outil en CLI pour la conversion via : avconv)"
    echo "[8] Lives (dispose des fonctionnalités d'éditions vidéo/son classique, des filtres et multipiste"
    echo "[9] Mencoder (s'utilise en ligne de commande : encodage de fichiers vidéos)"    
    echo "[10] MMG : MkvMergeGui (interface graphique pour l'outil mkmerge : création/manipulation fichier mkv)"    
    echo -e "[11] Natron ${gris}[DepExt]${neutre} (programme de post-prod destiné au compositing et aux effets spéciaux)"    
    echo "[12] OpenShot Video Editor (éditeur vidéo, libre et écrit en Python. Il est conseillé d'ajouter Blender pour certaines fonctions)"    
    echo -e "[13] Peek ${bleu}[Flatpak]${neutre} (outil de création de Gif animé à partir d'une capture vidéo)"
    echo "[14] Pitivi (logiciel de montage basique avec une interface simple et intuitive)"    
    echo -e "[15] Shotcut ${gris}[PPA]${neutre} (éditeur de vidéos libre, open source, gratuit et multiplateforme)"
    echo "[16] WinFF (encodage vidéo rapide dans différents formats)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 12) : " choixVideo
    clear

    # Question 8 : Traitement/montage photo & modélisation 3D
    echo "*******************************************************"
    echo -e "${bleu}8/ Quel(s) logiciel(s) de montage photo ou modélisation 3D voulez-vous ?${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun ajout"
    echo "[2] Blender (suite libre de modélisation 3D, matériaux et textures, d'éclairage, d'animation...)"
    echo "[3] Darktable (gestionnaire de photos libre sous forme de table lumineuse et chambre noir)"
    echo "[4] Frogr (utile pour ceux qui utilisent le service web 'Flickr')"
    echo -e "[5] Gimp ${vert}[Recommandé]${neutre} (montage photo avancé, équivalent à 'Adobe Photoshop')"
    echo "[6] Inkscape (logiciel spécialisé dans le dessin vectoriel, équivalent de 'Adobe Illustrator')"
    echo "[7] K-3D (animation et modélisation polygonale et modélisation par courbes)"
    echo "[8] Krita (outil d'édition et retouche d'images, orienté plutôt vers le dessin bitmap)"
    echo "[9] LibreCAD (anciennement CADubuntu, DAO 2D pour modéliser des dessins techniques)"
    echo "[10] MyPaint (logiciel de peinture numérique développé en Python)"
    echo "[11] Pinta (graphisme simple équivalent à Paint.NET)"
    echo -e "[12] Pixeluvo ${gris}[DepExt]${neutre} (une autre alternative à Photoshop mais il reste propriétaire)"
    echo -e "[13] Shutter ${violet}[X!]${neutre} (pour effectuer des captures d'écran + appliquer des modifications diverses)"
    echo "[14] SweetHome 3D (aménagement d'intérieur pour dessiner les plans d'une maison, placement des meubles...)"
    echo "[15] Ufraw (logiciel de dérawtisation capable de lire/interpréter la plupart des formats RAW)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 5 11) : " choixGraphisme
    clear

    # Question 9 : Traitement/encodage audio
    echo "*******************************************************"
    echo -e "${bleu}9/ Quel(s) logiciel(s) pour l'encodage/réglage ou traitement audio voulez-vous ?${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun"
    echo "[2] Ardour (station de travail audio numérique avec enregistrement multipiste et mixage)"
    echo "[3] Audacity (enregistrement et édition de son numérique)"
    echo -e "[4] Flacon ${jaune}[Snap]${neutre} (pour extraire les pistes d'un gros fichier audio)"
    echo "[5] Gnome Sound Recorder ('enregistreur de son' pour Gnome)"
    echo "[6] Hydrogen (synthétiseur de boite à rythme basé sur les patterns avec connexion possible d'un séquenceur externe)"
    echo "[7] Lame (outil d'encodage en CLI pour le format MP3, par exemple pour convertir un Wav en Mp3)"
    echo "[8] LMMS : Let's Make Music (station audio opensource crée par des musiciens pour les musiciens)"
    echo "[9] MhWaveEdit (application libre d'enregistrement et d'édition audio complète distribuée sous GPL)"
    echo "[10] Mixxx (logiciel pour Dj pour le mixage de musique)"
    echo "[11] Pavucontrol (outil graphique de contrôle des volumes audio entrée/sortie pour Pulseaudio)"
    echo -e "[12] PulseEffects ${bleu}[Flatpak]${neutre} (interface puissante GTK pour faire plein de réglages/effets sur le son)"
    echo "[13] RipperX (une autre alternative pour extraire les cd de musique)"
    echo "[14] Rosegarden (création musicale avec édition des partitions et peut s'interfacer avec des instruments)"
    echo "[15] Sound-Juicer (pour extraire les pistes audios d'un cd)"
    echo "[16] Xcfa : X Convert File Audio (extraction cd audio, piste dvd, normalisation, création pochette)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 3 10) : " choixAudio
    clear

    # Question 10 : Bureautique et Mail
    echo "*******************************************************"
    echo -e "${bleu}10/ Quel(s) logiciel(s) de bureautique/courrier souhaitez-vous ?${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun supplément (Thunderbird installé par défaut et LibreOffice est normalement présent de base)"
    echo "[2] Calligra Suite (suite bureautique de KDE, il s'intègre donc bien avec l'environnement kde/plasma)"
    echo "[3] FBReader (Lecteur de livres électroniques e-books supportant notamment les formats epub, fb2, chm, rtf, plucker...)"    
    echo -e "[4] FeedReader ${bleu}[Flatpak]${neutre} (agrégateur RSS moderne pour consulter vos fils d'informations RSS)"
    echo "[5] Freeplane (création de cartes heuristiques (Mind Map) avec des diagrammes représentant les connexions sémantiques)"
    echo "[6] Geary (logiciel de messagerie, alternative à Thunderbird et bien intégré à Gnome)"
    echo "[7] Gnome Evolution (logiciel de type groupware et courrielleur, facile à utiliser)"
    echo "[8] Gnome Office (pack contenant Abiword, Gnumeric, Dia, Planner, Glabels, Glom, Tomboy et Gnucash)"
    echo "[9] LaTex + Texworks (langage de description de document avec un éditeur spécialisé LaTex)"
    echo -e "[10] LibreOffice {branche gelé en 6.0} ${vert}[Recommandé]${neutre} suite bureautique libre (normalement déjà installé de base)"
    echo -e "[11] LibreOffice Fresh (backporté) ${gris}[PPA]${neutre} {dernière version stable possible, changement de branche possible !} "    
    echo -e "[12] LibreOffice Supplément : ajoute des styles d'icones + des modèles de documents & clipart + extension Grammalecte activé)"
    echo -e "[13] MailSpring ${jaune}[Snap]${neutre} (client de messagerie moderne et multi-plateforme)"
    echo -e "[14] Master PDF Editor (éditeur PDF propriétaire capable de gérer les formulaires CERFA/XFA)" 
    echo -e "[15] Notes Up ${bleu}[Flatpak]${neutre} (éditeur et manager de notes avec markdown, simple mais efficace)"
    echo -e "[16] OnlyOffice ${jaune}[Snap]${neutre} (suite bureautique multifonctionnelle intégrée au CRM, avec jeu d'outils de collaboration)"
    echo "[17] PdfMod (logiciel permettant diverses modifications sur vos PDF)"
    echo "[18] Police d'écriture Microsoft (conseillé pour ne pas avoir de déformation de document crée avec MO)"
    echo -e "[19] Scenari ${gris}[DepExt]${neutre} (contient scenarichaine v4.2 et Opale v3.6) : édition avancée de chaîne éditoriale"
    echo -e "[20] Scribus (Logiciel de PAO, convient plutôt pour la réalisation de plaquettes, livres et magazines)"
    echo "[21] Wordgrinder (traitement de texte léger en CLI, Formats OpenDocument, HTML import and export)"
    echo -e "[22] WPSOffice ${gris}[DepExt]${neutre} (suite bureautique propriétaire avec une interface proche de Microsoft Office)"
    echo "[23] Zim (wiki en local avec une collection de pages et de marqueurs)"
    # Choix supplémentaire caché mais possible (car pose problème) :
    # [500] => Soft Maker Office Béta #peux faire planter l'installation du script avec ce logiciel (déconseillé)
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 10 12 18) : " choixBureautique
    clear

    # Question 11 : Science et éducation
    echo "*******************************************************"
    echo -e "${bleu}11/ Des logiciels de sciences ou pour l'éducation ?${neutre}"
    echo "*******************************************************"
    echo "[1] Pas d'ajout"
    echo "[2] [MATH] Algobox (logiciel libre d'aide à l'élaboration/exécution d'algorithmes en mathématique)"  
    echo -e "[3] [TECHNO] Algoid [appli portable .jar] ${cyan}[M!]${neutre} (langage de programmation éducatif)"
    echo "[4] [CHIMIE] Avogadro (éditeur/visualiseur avancé de molécules pour le calcul scientifique en chimie)"
    echo "[5] [ASTRO] Celestia (simulation spatiale en temps réel qui permet d’explorer l'univers en trois dimensions)"
    echo "[6] [DIVERS] Einstein Puzzle (Jeu intellectuel ou il faut trouver toutes les cartes d'un tableau)"
    echo "[7] [GESTION] GanttProject (planification d'un projet à travers la réalisation d'un diagramme de Gantt)"    
    echo "[8] [DIVERS] GCompris (Suite de logiciels ludo-éducatifs adapté pour les enfants de 2 à 10 ans)"
    echo "[9] [MATH] GeoGebra (géométrie dynamique pour manipuler des objets avec un ensemble de fonctions algébriques)"
    echo -e "[10] [GEO] Google Earth Pro ${gris}[DepExt]${neutre} (globe terrestre de Google pour explorer la planète)"
    echo "[11] [GEO] Marble (globe virtuel opensource développé par KDE dans le cadre du projet KdeEdu)"
    echo -e "[12] [TECHNO] mBlock ${cyan}[M!]${neutre} (environnement de programmation basé sur Scratch 2 pour Arduino"
    echo "[13] [GEO] OooHg : extension pour LibreOffice qui ajoute 1600 cartes de géographie"
    echo "[14] [MATH] OptGeo : logiciel d’optique géométrique libre et opensource"
    echo "[15] [GESTION] Planner : gestionnaire de planning/projets avec diagrammes de Gantt. Alternative à Microsoft Project"    
    echo "[16] [TECHNO] Scratch [v1.4] (langage de programmation visuel libre, créé par le MIT, à vocation éducative et ludique)"
    echo "[17] [ASTRO] Stellarium (planétarium avec l'affichage du ciel réaliste en 3D avec simulation d'un téléscope)"
    echo "[18] [MATH] Xcas (le couteau suisse des maths : calcul formel, graphe de fonction, géométrie, tableur/stats etc...)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 5 13) : " choixScience
    clear

    # Question 12 : Utilitaires 
    echo "*******************************************************"
    echo -e "${bleu}12/ Quel(s) utilitaire(s) supplémentaire(s) voulez-vous ?${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun supplément"
    echo -e "[2] AnyDesk ${gris}[DepExt]${neutre} (assistance à distance comme teamviewer, natif linux)"
    echo "[3] Brasero (logiciel de gravure de cd/dvd)"  
    echo "[4] Cheese (outil pour prendre des photos/vidéos à partir d'une webcam)"
    echo -e "[5] CoreBird (un client de bureau pour le réseau social Twitter)"
    echo -e "[6] DDRescue (Permet de dupliquer le mieux possible les parties intactes des disques usagés)"
    echo -e "[7] Diodon (Gestionnaire de presse-papiers GTK+)"
    echo "[8] Flash Player (Adobe) : permet de lire des vidéos qui utiliseraient encore Flash sans support HTML5"
    echo -e "[9] Gnome Encfs Manager ${gris}[PPA]${neutre} (coffre-fort pour vos fichiers/dossiers)"
    echo "[10] Gnome Recipes (Application Gnome spécialisée dans les recettes de cuisine)"
    echo -e "[11] Gufw ${violet}[X!]${neutre} (interface graphique pour le pare-feu installé par défaut dans Ubuntu 'Ufw')"
    echo -e "[12] Kazam ${violet}[X!]${neutre} (capture vidéo de votre bureau)"
    echo "[13] KeePassX 2 (centralise la gestion de vos mots de passe personnels, protégé par un master password)"
    echo -e "[14] MultiSystem ${gris}[DepExt]${neutre} Utilitaire permettant de créer une clé usb bootable avec plusieurs OS"
    echo -e "[15] OpenBroadcaster Software (OBS) ${gris}[PPA]${neutre} (pour faire du live en streaming, adapté pour les gamers)"
    echo -e "[16] Oracle Java 8 ${gris}[PPA]${neutre} (plate-forme propriétaire d'Oracle pour les logiciels développés en Java)"
    echo -e "[17] Oracle Java 10 ${gris}[PPA]${neutre} (version actuelle de Java distribué par Oracle)"
    echo "[18] Pack d'outils de hacking/cybersécurité (aircrack + nmap + nikto + john the ripper + hashcat + kismet)"
    echo "[19] Pack d'outils utiles : vrms + screenfetch + asciinema + ncdu + screen + kclean + rclone"
    echo "[20] RedShift (Ajuste la température de couleur de l'écran, fonction déjà incluse dans Gnome avec le mode nuit)"    
    echo "[21] SimpleScreenRecorder (autre alternative pour la capture vidéo)"
    echo "[22] Smartmontools (Fournit l'état physiques des disques durs et des SSD voir de certaines clés USB)"
    echo -e "[23] Synaptic ${violet}[X!]${neutre} (gestionnaire graphique pour les paquets deb)"
    echo -e "[24] TeamViewer ${gris}[DepExt]${neutre}${violet}[X!]${neutre} (logiciel propriétaire de télémaintenance avec contrôle de bureau à distance)"
    echo -e "[25] Testdisk (Permet de ressusciter les partitions supprimées accidentellement ou les contenus des fichiers)"
    echo -e "[26] VeraCrypt ${gris}[PPA]${neutre} (utilitaire sous licence libre utilisé pour le chiffrement)"    
    echo "[27] VirtualBox {branche 5.2} (virtualisation de système Windows/Mac/Linux/Bsd)"
    echo -e "[28] VirtualBox backporté ${gris}[DepExt]${neutre} dernière version stable possible depuis dépot d'Oracle"    
    echo "[29] Wine (une sorte d'émulateur pour faire tourner des applis/jeux conçus à la base pour Windows)"
    echo "[30] Wireshark (analyseur de paquets utilisé dans le dépannage et l'analyse de réseaux )"    
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 5 13 26 27) : " choixUtilitaire
    clear

    # Question 13 : Gaming
    echo "*******************************************************"
    echo -e "${bleu}13/ Quel(s) jeux-vidéo(s) (ou applis liées aux jeux) voulez-vous installer ?${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun, je ne suis pas un gamer"
    echo "[2] 0ad: Empires Ascendant (jeu de stratégie en temps réel RTS)" 
    echo -e "[3] Albion Online ${bleu}[Flatpak]${neutre} (MMORPG avec système de quête et donjons)"    
    echo "[4] AlienArena (jeu de tir à la première personne, gratuit, dérivé du moteur de Quake)"        
    echo "[5] Assault Cube (clone de Counter Strike)" 
    echo -e "[6] Battle for Wesnoth (stratégie, le joueur doit se battre pour retrouver sa place dans le royaume)"    
    echo "[7] FlightGear (simulateur de vol)"
    echo "[8] Gnome Games (pack d'une dizaine de mini-jeux pour Gnome)"
    echo -e "[9] Khaganat [Khanat] ${cyan}[M!]${neutre} ${rouge}[D!]${neutre} (MMORPG 100% libre avec un univers imaginaire, en phase alpha)"
    echo "[10] Lutris (Plate-forme de jeux équivalente à Steam mais libre, rassemble tous vos jeux natifs ou non)"
    echo "[11] Megaglest (RTS 3d dans un monde fantastique avec 2 factions qui s'affrontent : la magie et la technologie)"    
    echo -e "[12] Minecraft ${jaune}[Snap]${neutre} (un des plus célèbres jeux sandbox, jeu propriétaire et payant)"
    echo "[13] Minetest (un clone de Minecraft mais libre/opensource et totalement gratuit)"
    echo "[14] OpenArena (un clone libre du célèbre jeu 'Quake')"   
    echo "[15] Pingus (clone de Lemmings, vous devrez aider des manchots un peu idiots à traverser des obstacles)"    
    echo "[16] PlayOnLinux (permet de faire tourner des jeux Windows via Wine avec des réglages pré-établis)"    
    echo "[17] PokerTH (jeu de poker opensource Texas Holdem No Limit jusqu'à 10 participants, humains ou IA)"    
    echo "[18] RuneScape (reconnu MMORPG gratuit le plus populaire au monde avec plus de 15 millions de comptes F2P)"
    echo "[19] Steam (plateforme de distribution de jeux. Permet notamment d'installer Dota2, TF2, CS, TR...)"
    echo "[20] SuperTux (clone de Super Mario mais avec un pingouin)"
    echo "[21] SuperTuxKart (clone de Super Mario Kart)"
    echo "[22] Teeworlds (jeu de tir TPS multijoueur 2D, vous incarnez une petite créature, le tee)" 
    echo "[23] Xqf (Explorateur de serveurs de jeu pour visualiser tous les serveurs de vos jeux de façon unifié)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 10 13 16 19) : " choixGaming
    clear
fi

## Mode avancé (seulement pour mode avancé et extra)
if [ "$choixMode" = "2" ] || [ "$choixMode" = "3" ]
then
    if [ "$(which gnome-shell)" = "/usr/bin/gnome-shell" ]
    then
        # Question 14 : Extension 
        echo -e "${vert}Astuce 5: Si vous aimez faire de la customisation graphique, il est recommandé d'installer l'extension 'user themes'${neutre}"
        echo "*******************************************************"
        echo -e "${jaune}14/ Des extensions pour gnome-shell à installer ? [mode avancé]${neutre}"
        echo "*******************************************************"
        echo "[1] Non, ne pas ajouter de nouvelles extensions"
        echo "[2] AlternateTab (alternative au Alt+Tab issu du mode classique)"
        echo "[3] AppFolders Management (permet de classer les applis dans des dossiers)"
        echo "[4] Caffeine (permet en 1 clic de désactiver temporairement les mises en veilles)"
        echo "[5] Clipboard Indicator (permet de conserver du contenu copié/collé facilement accessible depuis le panel)"        
        echo "[6] DashToDock (permet plus d'options pour les réglages du dock, celui d'Ubuntu étant basé dessus)"
        echo "[7] DashToPanel (un dock alternatif conçu pour remplacer le panel de Gnome, se place en bas ou en haut)"
        echo "[8] Dockilus (Ajoute les signets sur le clique droit de l'icone Nautilus dans le dock comme sous Unity)"
        echo "[9] Impatience (permet d'augmenter la vitesse d'affichage des animations de Gnome Shell)"
        echo "[10] Log Out Button (ajouter un bouton de déconnexion pour gagner 1 clic en moins pour cette action)"
        echo "[11] Media Player Indicator (ajouter un indicateur pour le contrôle du lecteur multimédia)"
        echo "[12] Multi monitors add on (ajoute au panel un icone pour gérer rapidement les écrans)"
        echo "[13] Openweather (pour avoir la météo directement sur votre bureau)"
        echo "[14] Places status indicator (permet d'ajouter un raccourci vers les dossiers utiles dans le panel)"
        echo "[15] Removable drive menu (raccourci pour démonter rapidement les clés usb/support externe)"
        echo "[16] Shortcuts (permet d'afficher un popup avec la liste des raccourcis possibles)"
        echo "[17] Suspend button (ajout d'un bouton pour activer l'hibernation)"
        echo "[18] System-monitor (moniteur de ressources visible directement depuis le bureau)"        
        echo "[19] Taskbar (permet d'ajouter des raccourcis d'applis directement sur le panel en haut)"
        echo "[20] Top Icons Plus (pour l'affichage d'icone de notif : normalement n'est plus nécessaire)"
        echo "[21] Trash (ajoute un raccourci vers la corbeille dans le panel en haut)"
        echo "[22] Unite (retire la décoration des fenêtres pour gagner de l'espace, pour un style proche du shell Unity)"
        echo -e "[23] User themes ${vert}[Recommandé]${neutre} (permet de charger des thèmes stockés dans votre répertoire perso)"
        echo "[24] Window list (affiche la liste des fenêtres en bas du bureau, comme à l'époque sous Gnome 2)"
        echo "[25] Workspace indicator (affiche dans le panel en haut dans quel espace de travail vous êtes)"
        echo "*******************************************************"
        read -p "Répondre par le ou les chiffres correspondants (exemple : 6 23) : " choixExtension
        clear
    fi

    # Question 15 : Customization
    echo -e "${vert}Astuce 6: Si vous voulez transformer l'apparence du bureau, il faudra modifier vous-même l'agencement du bureau en plus d'appliquer les thèmes/icones${neutre}"
    echo "*******************************************************"
    echo -e "${jaune}15/ Sélectionnez ce qui vous intéresse en terme de customisation [mode avancé]${neutre}"
    echo "*******************************************************"
    echo "[1] Pas d'ajout"
    echo -e "[2] Communitheme ${gris}[PPA]${neutre} thème GTK + icon Suru + sound theme (inutile si session communitheme installé)"
    echo "[3] Icones Papirus (Solus) avec différentes variantes : Adapta, Nokto, Dark, Light"   
    echo "[4] Pack de curseurs : Breeze + Moblin + Oxygen/Oxygen-extra"    
    echo "[5] Pack d'icones 1 : Numix et Numix Circle, Breathe, Breeze, Elementary, Brave + supplément extra icone Gnome"
    echo "[6] Pack d'icones 2 : Dust, Humility, Garton, Gperfection2, Nuovo"
    echo "[7] Pack d'icones 3 : Human, Moblin, Oxygen, Suede, Yasis"
    echo "[8] Thème complet Mac OS X High Sierra Light+Dark (thème+icone+wallpaper)"
    echo "[9] Thème Unity 8"    
    echo "[10] Thème Windows 10 (thème+icone)"
    echo "[11] Thèmes GTK pack1 : Arc + Numix"
    echo -e "[12] Thèmes GTK pack2 ${gris}[PPA]${neutre} : Adapta + Greybird/Blackbird/Bluebird"
    echo "[13] Thèmes GTK pack3 : Albatross, Yuyo, Human, Gilouche, Materia"
    echo -e "[14] Visuel GDM avec thème gris [Pour G.S uniquement!] ${rouge}=> Attention : ajoute la session Vanilla en dépendance !${neutre}"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 5 11) : " choixCustom
    clear

    # Question 16 : Prog
    echo "*******************************************************"
    echo -e "${jaune}16/ Quel(s) éditeur(s) de texte et logiciel(s) de développement voulez-vous ? [mode avancé]${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun (en dehors de Vim et Gedit)"
    echo -e "[2] Android Studio ${bleu}[Flatpak]${neutre} (IDE de Google spécialisé pour le développement d'application Android)"    
    echo "[3] Anjuta (IDE simple pour C/C++, Java, JavaScript, Python et Vala)"  
    echo -e "[4] Atom ${jaune}[Snap]${neutre} (éditeur sous licence libre qui supporte les plug-ins Node.js et implémente GitControl)"
    echo "[5] BlueFish (éditeur orienté développement web : HTML/PHP/CSS/...)"
    echo "[6] BlueGriffon (éditeur HTML/CSS avec aperçu du rendu en temps réel)"    
    echo -e "[7] Brackets ${jaune}[Snap]${neutre} (éditeur opensource d'Adobe pour le web design et dev web HTML, CSS, JavaScript...)"    
    echo "[8] Code:Blocks (IDE spécialisé pour les langages C/C++)"    
    echo -e "[9] Eclipse ${rouge}[I!]${neutre}${violet}[X!]${neutre}(Projet décliné en sous-projets de dev)"    
    echo "[10] Emacs (le couteau suisse des éditeurs de texte, il fait tout mais il est complexe)"
    echo "[11] Geany (IDE rapide et simple utilisant GTK2 supportant de nombreux langages)"
    echo "[12] Gvim (interface graphique pour Vim)"
    echo -e "[13] IntelliJ Idea ${jaune}[Snap]${neutre} (IDE Java commercial de JetBrains, plutôt conçu pour Java)"    
    echo "[14] JEdit (éditeur libre, multiplateforme et très personnalisable)"
    echo -e "[15] PyCharm [version communautaire] ${jaune}[Snap]${neutre} (IDE pour le langage Python)"
    echo "[16] SciTE : Scintilla Text Editor (éditeur web avec une bonne coloration syntaxique)"
    echo -e "[17] Sublime Text ${gris}[DepExt]${neutre} (logiciel développé en C++ et Python prenant en charge 44 langages de programmation)"
    echo -e "[18] Visual Studio Code ${jaune}[Snap]${neutre} (développé par Microsoft, sous licence libre MIT)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 8 10 11) : " choixDev
    clear

    # Question 17 : Serveur 
    echo "*******************************************************"
    echo -e "${jaune}17/ Des fonctions serveurs à activer ? [mode avancé]${neutre}"
    echo "*******************************************************"
    echo "[1] Pas de service à activer"
    echo -e "[2] Cuberite ${jaune}[Snap]${neutre} (Serveur de jeu Minecraft performant et opensource écrit en C++)"
    echo -e "[3] Docker ${gris}[DepExt]${neutre} (Permet d'empaqueter une appli+dépendances dans un conteneur isolé, utilisable partout)"
    echo -e "[4] PHP5.6 ${gris}[PPA]${neutre} (rétroportage de l'ancienne version de PHP)"
    echo "[5] PHP7.2 (dernière version stable de PHP)"
    echo "[6] Samba + Interface d'administration gadmin-samba"
    echo "[7] Serveur BDD PostgreSQL (pour installer une base de donnée PostgreSQL)"
    echo "[8] Serveur FTP avec ProFTPd (stockage de fichier sur votre machine via FTP)"   
    echo "[9] Serveur LAMP (pour faire un serveur web avec votre PC : Apache + MariaDB + PHP)"    
    echo "[10] Serveur SSH (pour contrôler votre PC à distance via SSH)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 1) : " choixServeur
    clear

    # Question 18 : Optimisation
    echo "*******************************************************"
    echo -e "${jaune}18/ Des optimisations supplémentaires à activer ? [mode avancé]${neutre}"
    echo "*******************************************************"
    echo "[1] Non aucune"
    echo "[2] Ajout d'une commande 'maj' qui met tout à jour (maj apt + maj snap + maj flatpak)"
    echo "[3] Ajouter le support pour le système de fichier exFat de Microsoft"
    echo "[4] Ajouter le support pour le système de fichier HFS+ d'Apple"
    echo "[5] Augmenter la sécurité de votre compte : empêcher l'accès en lecture à votre dossier perso aux autres utilisateurs"
    echo "[6] Dépots supplémentaires pour Flatpak (NuvolaApps + KDEApps + GnomeApps, Flathub est déjà activé)" 
    echo "[7] Désactiver complètement le swap (utile si vous avez un SSD et 8 Go de ram ou plus)" 
    echo -e "[8] GameMode ${rouge}[I!]${neutre} ${rouge}[Experimental]${neutre} : optimisation temporaire pour les performances en jeu"
    echo -e "[9] Gnome Shell : Activer la minimisation de fenêtre sur les icones pour DashToDock ${cyan}(DtD doit être installé)${neutre}"
    echo "[10] Gnome Shell : Ajout d'une commande 'fraude' pour Wayland (permet de lancer une appli graphique en root comme sous Xorg)"
    echo "[11] Gnome Shell : Augmenter la durée maximale de capture vidéo intégré de 30s à 600s (soit 10min)"    
    echo "[12] Gnome Shell : Désactiver l'userlist de GDM (utile en entreprise intégrée à un domaine)"
    echo "[13] Installation de switcheroo-control : permet d'utiliser la carte dédié avec le pilote opensource" 
    echo "[14] Installer le microcode Intel propriétaire (pour cpu intel uniquement)"    
    echo "[15] Installer le pilote propriétaire nVidia-390 + nvidia-prime (switch intel/nvidia) + mesa-utils (glxgears test)"   
    echo "[16] Lecture DVD commerciaux protégés par CSS (Content Scrambling System)"
    echo "[17] Optimisation Grub : réduire le temps d'attente (si multiboot) de 10 à 2 secondes + retirer le test de RAM dans grub"
    echo "[18] Optimisation Swap : swapiness à 5% (swap utilisé uniquement si plus de 95% de ram utilisée)"
    echo "[19] Support imprimantes HP (hplip + sane + hplip-gui)"
    echo "[20] TLP (économie d'énergie pour pc portable)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 2 5 8 10) : " choixOptimisation
    clear
fi

# Mode Extra
if [ "$choixMode" = "3" ] 
then
    # Question 19 : Snap
    echo -e "${vert}Astuce 7: Les paquets Snappy, flatpak et Appimages sont indépendants les uns des autres, ainsi, vous pouvez avoir un même logiciel en plusieurs exemplaires dans des versions différentes${neutre}"
    echo "*******************************************************"
    echo -e "${vert}19/ Mode Extra : supplément paquet Snap :${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun"
    echo -e "[2] Blender ${orange}[--classic]${neutre} ${jaune}[Snap]${neutre}"
    echo -e "[3] Dino ${jaune}[Snap]${neutre}"
    echo -e "[4] Electrum ${jaune}[Snap]${neutre}"
    echo -e "[5] Gimp ${jaune}[Snap]${neutre}"
    echo -e "[6] Instagraph ${jaune}[Snap]${neutre}"
    echo -e "[7] KeepassXC ${jaune}[Snap]${neutre}"
    echo -e "[8] LibreOffice ${jaune}[Snap]${neutre}"
    echo -e "[9] NextCloud client ${jaune}[Snap]${neutre}"
    echo -e "[10] PyCharm édition Professionnelle ${violet}[X!]${neutre}${orange}[--classic]${neutre} ${jaune}[Snap]${neutre}"
    echo -e "[11] Quassel client ${jaune}[Snap]${neutre}"
    echo -e "[12] Rube cube ${jaune}[Snap]${neutre}"
    echo -e "[13] Shotcut ${jaune}[Snap]${neutre}"   
    echo -e "[14] Skype ${jaune}[Snap]${neutre}"
    echo -e "[15] TermiusApp ${jaune}[Snap]${neutre}"
    echo -e "[16] TicTacToe ${jaune}[Snap]${neutre}"
    echo -e "[17] ZeroNet ${jaune}[Snap]${neutre}"
    echo "*******************************************************"
    read -p "Choix paquets snappy (exemple : 4 12) : " choixSnap
    clear
             
    # Question 20 : Flatpak
    echo "*******************************************************"
    echo -e "${vert}20/ Mode Extra : supplément paquet Flatpak :${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun"
    echo -e "[2] 0ad ${bleu}[Flatpak]${neutre}"
    echo -e "[3] Audacity ${bleu}[Flatpak]${neutre}"
    echo -e "[4] Blender ${bleu}[Flatpak]${neutre}"  
    echo -e "[5] Dolphin Emulator ${bleu}[Flatpak]${neutre}"
    echo -e "[6] Extreme Tuxracer ${bleu}[Flatpak]${neutre}"
    echo -e "[7] Frozen Bubble ${bleu}[Flatpak]${neutre}"
    echo -e "[8] Gimp ${bleu}[Flatpak]${neutre}"    
    echo -e "[9] Gnome MPV ${bleu}[Flatpak]${neutre}"
    echo -e "[10] Google Play Music Desktop Player ${bleu}[Flatpak]${neutre}"
    echo -e "[11] Homebank ${bleu}[Flatpak]${neutre}"
    echo -e "[12] Kdenlive ${bleu}[Flatpak]${neutre}"
    echo -e "[13] LibreOffice ${bleu}[Flatpak]${neutre}"
    echo -e "[14] Minetest ${bleu}[Flatpak]${neutre}"
    echo -e "[15] Nextcloud cli ${bleu}[Flatpak]${neutre}"  
    echo -e "[16] Password Calculator ${bleu}[Flatpak]${neutre}"
    echo -e "[17] Riot ${bleu}[Flatpak]${neutre}"
    echo -e "[18] Skype ${bleu}[Flatpak]${neutre}"
    echo -e "[19] VLC ${bleu}[Flatpak]${neutre}"    
    echo "*******************************************************"
    read -p "Choix paquets flatpak (exemple : 5 16) : " choixFlatpak
    clear
            
    # Question 21 : Appimages
    echo -e "${vert}Astuce 8: Vos AppImages seront disponibles dans un dossier 'appimage' dans votre dossier perso, pour lancer une application : ./nomdulogiciel.AppImage (les droits d'éxécutions seront déjà attribués)${neutre}"
    echo "*******************************************************"
    echo -e "${vert}21/ Mode Extra : récupération Appimages:${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun"
    echo -e "[2] Aidos Wallet ${vert}[Appimage]${neutre}"
    echo -e "[3] AppImageUpdate ${vert}[Appimage]${neutre}"    
    echo -e "[4] Chronos ${vert}[Appimage]${neutre}"
    echo -e "[5] Crypter ${vert}[Appimage]${neutre}"
    echo -e "[6] Digikam ${vert}[Appimage]${neutre}"
    echo -e "[7] Freecad ${vert}[Appimage]${neutre}"
    echo -e "[8] Imagine ${vert}[Appimage]${neutre}"
    echo -e "[9] Infinite Electron ${vert}[Appimage]${neutre}"
    echo -e "[10] Jaxx ${vert}[Appimage]${neutre}"
    echo -e "[11] Kdenlive ${vert}[Appimage]${neutre}"
    echo -e "[12] KDevelop ${vert}[Appimage]${neutre}"
    echo -e "[13] MellowPlayer ${vert}[Appimage]${neutre}"
    echo -e "[14] Nextcloud Cli ${vert}[Appimage]${neutre}"
    echo -e "[15] Openshot ${vert}[Appimage]${neutre}"
    echo -e "[16] Owncloud Cli ${vert}[Appimage]${neutre}"
    echo -e "[17] Popcorntime ${vert}[Appimage]${neutre}"
    echo -e "[18] Spotify web client ${vert}[Appimage]${neutre}"
    echo -e "[19] Tulip ${vert}[Appimage]${neutre}"
    echo "*******************************************************"
    read -p "Choix logiciels portables au format AppImage (exemple : 9 16) : " choixAppimage
    clear
fi

### Section installation automatisé

###################################################
# Communs à tous quelque soit la variante

# Pour automatiser l'installation de certains logiciels :
export DEBIAN_FRONTEND="noninteractive"

# Activation du dépot partenaire 
sed -i "/^# deb .*partner/ s/^# //" /etc/apt/sources.list

#Maj du système + nettoyage
apt update ; apt full-upgrade -y ; apt autoremove --purge -y ; apt clean

# Désinstallation des paquets snappy inutiles (5 préinstallés par défaut) et remplacement par la version deb via apt 
snap remove gnome-3-26-1604 gnome-calculator gnome-characters gnome-logs gnome-system-monitor ; apt install gnome-calculator gnome-characters gnome-logs gnome-system-monitor -y 

# Création d'un répertoire pour le script et on se déplace dedans
mkdir /home/$SUDO_USER/script_postinstall && cd /home/$SUDO_USER/script_postinstall/

if [ "$1" = "vbox" ] ; then  # installe les additions invités pour une vm si script lancé avec paramètre "vbox" : ./script.sh vbox
    apt install virtualbox-guest-utils -y    
fi

if [ "$2" != "NRI!" ] ; then # Installé par défaut sauf dans un cas particulier si précision explicite en paramètre
    #Vérification que snapd est bien installé (surtout utile pour les variantes) + installation de flatpak
    apt install snapd flatpak -y
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    # Autres outils utiles
    apt install curl net-tools git gdebi vim htop gparted numlockx unrar debconf-utils p7zip-full -y

    # Logiciels utiles normalement déjà installés (dans le cas ou ça ne serai pas le cas, notamment sur certaines variantes)
    apt install firefox firefox-locale-fr transmission-gtk thunderbird thunderbird-locale-fr -y

    # Codecs utiles
    apt install x264 x265 -y

    #optimisation
    apt install ffmpegthumbnailer -y #permet de charger les minatures vidéos plus rapidement dans nautilus

    # Désactivation de l'affichage des messages d'erreurs à l'écran
    sed -i 's/^enabled=1$/enabled=0/' /etc/default/apport

    ###################################################
    # Pour version de base sous Gnome Shell
    if [ "$(which gnome-shell)" = "/usr/bin/gnome-shell" ]
    then
        # logiciels utiles pour Gnome
        apt install gnome-software-plugin-flatpak dconf-editor gnome-tweak-tool folder-color gnome-system-tools -y
        apt install ubuntu-restricted-addons -y
        # Suppression de l'icone Amazon (présent uniquement sur la version de base)
        apt purge ubuntu-web-launchers -y
        # Création répertoire extension pour l'ajout d'extension supplémentaire pour l'utilisateur principal
        mkdir /home/$SUDO_USER/.local/share/gnome-shell/extensions /home/$SUDO_USER/.themes /home/$SUDO_USER/.icons
    fi
    ###################################################
    # Spécifique Xubuntu/Xfce 18.04
    if [ "$distrib" = "1" ]
    then
        apt install xfce4 gtk3-engines-xfce xfce4-goodies xfwm4-themes xubuntu-restricted-addons -y 
    fi
    ###################################################
    # Spécifique Ubuntu Mate/Mate 18.04
    if [ "$distrib" = "2" ]
    then
        apt install mate-desktop-environment-extras mate-tweak mate-applet-brisk-menu -y 
    fi
    ###################################################
    # Spécifique Lubuntu/Lxde/Lxqt 18.04
    if [ "$distrib" = "3" ]
    then
        apt install lubuntu-restricted-addons -y
    fi
    ###################################################
    # Spécifique Kubuntu/Kde 18.04
    if [ "$distrib" = "4" ]
    then
        apt install kubuntu-restricted-addons kubuntu-restricted-extras -y
    fi
fi

### Modes automatiques
###################################################
# Débutant (choix 10)
if [ "$choixMode" = "10" ]
then
    #internet
    apt install chromium-browser pidgin -y
    #multimédia
    apt install vlc gnome-mpv gimp pinta -y
    #divers
    apt install brasero adobe-flashplugin gnome-todo -y
fi

###################################################
#  Technicien IT Automatique (choix 11)
if [ "$choixMode" = "11" ]
then
    # nettoyage grub
    sed -ri 's/GRUB_TIMEOUT=10/GRUB_TIMEOUT=3/g' /etc/default/grub && mkdir /boot/old && mv /boot/memtest86* /boot/old/ ; update-grub
    # alias maj
    echo "alias maj='sudo apt update ; sudo apt full-upgrade -y ; sudo snap refresh ; sudo flatpak update -y'" >> /home/$SUDO_USER/.bashrc ; su $SUDO_USER -c "source ~/.bashrc"
    # Teamviewer V8 (pour la licence)                 
    wget http://download.teamviewer.com/download/version_8x/teamviewer_linux.deb && dpkg -i teamviewer_linux.deb ; apt install -fy ; rm teamviewer_linux.deb 
    # Logiciels part1
    apt install pidgin polari filezilla pinta gimp zim keepass2 keepassxc wormhole libreoffice libreoffice-l10n-fr  -y
    # Logiciels part2    
    apt install geany codeblocks virtualbox asciinema ncdu screen nmap tcpdump chromium-browser chromium-browser-l10n -y
    # Driver imprimante Kyocera Taskalfa 3511i
    wget https://raw.githubusercontent.com/dane-lyon/fichier-de-config/master/Kyocera_taskalfa_3511i.PPD ; mv Kyocera_taskalfa_3511i.PPD /etc/cups/ppd/
    # Police d'écriture MS
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | /usr/bin/debconf-set-selections | apt install ttf-mscorefonts-installer -y
fi

###################################################
#  Cedric.F (choix 13)
if [ "$choixMode" = "13" ]
then
    ### apt
    apt install chromium-browser chromium-browser-l10n pidgin grsync vlc devede handbrake winff winff-qt gimp pinta shutter sweethome3d minetest -y
    apt install audacity sound-juicer gnote stellarium gnome-maps brasero cheese diodon adobe-flashplugin gnome-recipes keepassx gnome-games gnome-games-app -y
    apt install numix-icon-theme -y ; git clone https://github.com/numixproject/numix-icon-theme-circle.git ; mv -f numix-icon-theme-circle/* /usr/share/icons/ ; rm -r numix-icon-theme-circle
    apt install --no-install-recommends openshot-qt -y
    
    ### ppa
    add-apt-repository "deb http://ppa.launchpad.net/haraldhv/shotcut/ubuntu zesty main" -y ; apt-key adv --recv-keys --keyserver keyserver.ubuntu.com D03D19F673FED66EBD64099959A9D327745898E3 ; apt update ; apt install shotcut -y
    
    add-apt-repository -y ppa:libreoffice/ppa ; apt update ; apt upgrade -y ; apt install libreoffice libreoffice-l10n-fr libreoffice-style-breeze -y
    apt install libreoffice-style-elementary libreoffice-style-oxygen libreoffice-style-human libreoffice-style-sifr libreoffice-style-tango libreoffice-templates hunspell-fr mythes-fr hyphen-fr openclipart-libreoffice python3-uno -y
    #grammalecte (oxt)
    wget https://www.dicollecte.org/grammalecte/oxt/Grammalecte-fr-v0.6.2.oxt && chown $SUDO_USER Grammalecte* && chmod +x Grammalecte*
    unopkg add --shared Grammalecte*.oxt && rm Grammalecte*.oxt  
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | /usr/bin/debconf-set-selections | apt install ttf-mscorefonts-installer -y
    
    ### snap
    snap install communitheme
    
    ### flatpak
    flatpak install flathub de.haeckerfelix.gradio -y
    
    ### appimages
    wget http://desktop-auto-upgrade.molotov.tv/linux/2.1.2/molotov ; mv molotov molotov.AppImage ; chmod +x molotov.AppImage ; chown $SUDO_USER molotov* 

    ### dépot externe ou deb manuel
    # Google Earth
    wget https://dl.google.com/dl/earth/client/current/google-earth-pro-stable_current_amd64.deb ; dpkg -i google-earth-pro-stable_current_amd64.deb ; apt install -fy 
    sed -i -e "s/deb http/deb [arch=amd64] http/g" /etc/apt/sources.list.d/google-earth* #google earth
    # Anydesk
    wget https://download.anydesk.com/linux/anydesk_2.9.5-1_amd64.deb ; dpkg -i anydesk* ; apt install -fy ; rm anydesk* # anydesk 
    # Signal
    curl -s https://updates.signal.org/desktop/apt/keys.asc | apt-key add - ; echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | tee -a /etc/apt/sources.list.d/signal-xenial.list
    apt update && apt install signal-desktop -y
fi

## Installation suivant les choix de l'utilisateur :

# Q2/ Installation des sessions demandées
for session in $choixSession
do 
    if [ "$session" = "2" ]
    then 
        apt install gnome-session -y #session vanilla        
    fi
    
    if [ "$session" = "3" ]
    then 
        apt install gnome-shell-extensions -y #session classique  
    fi

    if [ "$session" = "4" ]
    then 
        apt install unity-session unity-tweak-tool -y #session unity      
    fi
    
    if [ "$session" = "5" ]
    then 
        snap install communitheme #session avec communitheme
    fi    
done

# Q3/ Installation des navigateurs demandées
for navigateur in $choixNavigateur
do
    case $navigateur in
        "2") #Beaker Browser (appimage)
            wget http://nux87.free.fr/script-postinstall-ubuntu/appimage/beaker-browser-0.7.11-x86_64.AppImage
            chmod +x beaker*
            ;;    
        "3") #Brave (snap)
            snap install brave
            ;;              
        "4") #chromium
            apt install chromium-browser chromium-browser-l10n -y    
            ;;   
        "5") #Dillo
            apt install dillo -y
            ;;     
        "6") #Eolie via Flatpak
            flatpak install flathub org.gnome.Eolie -y
            ;;            
        "7") #Falkon/Qupzilla
            apt install qupzilla -y
            ;;            
        "8") #firefox béta 
            add-apt-repository ppa:mozillateam/firefox-next -y 
            apt update ; apt upgrade -y
            ;;
        "9") #firefox developper edition 
            flatpak install --from https://firefox-flatpak.mojefedora.cz/org.mozilla.FirefoxDevEdition.flatpakref -y
            flatpak install flathub org.freedesktop.Platform.ffmpeg -y
            ;;               
        "10") #firefox esr
            add-apt-repository ppa:mozillateam/ppa -y 
            apt update ; apt install firefox-esr firefox-esr-locale-fr -y
            ;;
        "11") #firefox nightly
            flatpak install --from https://firefox-flatpak.mojefedora.cz/org.mozilla.FirefoxNightly.flatpakref -y
            flatpak install flathub org.freedesktop.Platform.ffmpeg -y
            ;;
        "12") #Gnome Web/epiphany
            apt install epiphany-browser -y
            ;;              
        "13") #Google Chrome
            wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
            sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
            apt update ; apt install google-chrome-stable -y
            ;;
        "14") #Lynx (cli)
            apt install lynx -y
            ;;            
        "15") #midori
            wget http://midori-browser.org/downloads/midori_0.5.11-0_amd64_.deb
            dpkg -i midori_0.5.11-0_amd64_.deb
            apt install -fy
            ;;      
        "16") #Min
            wget https://github.com/minbrowser/min/releases/download/v1.7.1/min_1.7.1_amd64.deb
            dpkg -i min*.deb ; apt install -fy ; rm -f Min*
            ;;            
        "17") #Opera (maj automatiquement via dépot opéra ajouté par le deb)
            wget http://nux87.free.fr/script-postinstall-ubuntu/deb/opera.deb
            dpkg -i opera* ; apt install -fy ; rm opera* ; apt update ; apt upgrade -y #en cas de maj d'opéra
            ;;
        "18") #Palemoon
            wget http://nux87.free.fr/script-postinstall-ubuntu/deb/palemoon.deb
            dpkg -i palemoon.deb ; apt install -fy ; rm -f palemoon*
            ;;  
        "19") #SRWare Iron
            wget http://www.srware.net/downloads/iron64.deb ; dpkg -i iron64.deb ; apt install -fy ; rm iron64.deb
            ;;             
        "20") #Tor browser
            apt install torbrowser-launcher -y
            ;;            
        "21") #Vivaldi x64 (sera toujours à jour bien qu'une version précise soit téléchargé : dépot ajouté par le deb)
            wget http://nux87.free.fr/script-postinstall-ubuntu/deb/vivaldi.deb
            dpkg -i vivaldi* ; apt install -fy ; apt upgrade vivaldi-stable -y ; rm vivaldi.deb
            ;;
        "22") #Waterfox
            echo "deb https://dl.bintray.com/hawkeye116477/waterfox-deb release main" >> /etc/apt/sources.list.d/waterfox.list
            curl https://bintray.com/user/downloadSubjectPublicKey?username=hawkeye116477 | apt-key add - 
            apt update
            apt install waterfox waterfox-locale-fr -y
            ;;                                    
    esac
done

# Q4/ Tchat/Messagerie instantannée/Télephonie
for messagerie in $choixMessagerie
do
    case $messagerie in
        "2") #Discord (flatpak)
            flatpak install flathub com.discordapp.Discord -y
            ;;  
        "3") #ekiga
            apt install ekiga -y
            ;;      
        "4") #empathy
            apt install empathy -y
            ;;
        "5") #gajim
            apt install gajim -y
            ;;   
        "6") #hexchat
            apt install hexchat hexchat-plugins -y
            ;;                
        "7") #jitsi
            wget -qO - https://download.jitsi.org/jitsi-key.gpg.key | apt-key add -   
            sh -c "echo 'deb https://download.jitsi.org stable/' > /etc/apt/sources.list.d/jitsi-stable.list"   
            apt update ; apt install jitsi -y   
            ;;   
        "8") #linphone
            apt install linphone -y
            ;;    
        "9") #mumble
            apt install mumble -y
            ;;                
        "10") #pidgin
            apt install pidgin pidgin-plugin-pack -y
            ;;
        "11") #Polari
            apt install polari -y
            ;;                  
        "12") #psi
            apt install psi -y
            ;;  
        "13") #ring
            apt install ring -y
            ;;  
        "14") #signal (snap)
            snap install signal-desktop
            ;;               
        "15") #skype
            wget https://repo.skype.com/latest/skypeforlinux-64.deb ; dpkg -i skypeforlinux-64.deb ; apt install -fy
            rm skypeforlinux*
            ;;   
        "16") #Slack (snap)
            snap install slack --classic
            ;;     
        "17") #Teamspeak (script bash à l'intérieur à lancer manuellement par l'utilisateur)
            wget http://nux87.free.fr/script-postinstall-ubuntu/archives/Teamspeak.tar.xz 
            tar -xJf Teamspeak.tar.xz ; chown -R $SUDO_USER:$SUDO_USER Teamspeak ; rm -f Teamspeak.tar.xz ; mv Teamspeak ..
            ;;             
        "18") #telegram 
            apt install telegram-desktop -y
            ;;  
        "19") #viber (flatpak)
            flatpak install flathub com.viber.Viber -y
            ;;  
        "20") #weechat
            apt install weechat -y
            ;;                 
        "21") #wire
            apt-key adv --fetch-keys http://wire-app.wire.com/linux/releases.key
            echo "deb https://wire-app.wire.com/linux/debian stable main" | tee /etc/apt/sources.list.d/wire-desktop.list
            apt update ; apt install apt-transport-https wire-desktop -y
            ;;               
    esac
done

# Q5/ Download/Copie
for download in $choixTelechargement
do
    case $download in
        "2") #aMule
            apt install amule -y
            ;;      
        "3") #Bittornado
            apt install bittornado bittornado-gui -y
            ;;      
        "4") #Deluge
            apt install deluge -y
            ;;    
        "5") #EiskaltDC++
            apt install eiskaltdcpp eiskaltdcpp-gtk3 -y
            ;;             
        "6") #filezilla
            apt install filezilla -y
            ;;
        "7") #FrostWire
            wget https://netcologne.dl.sourceforge.net/project/frostwire/FrostWire%206.x/6.5.9-build-246/frostwire-6.5.9.all.deb
            dpkg -i frostwire-6.5.9.all.deb
            apt install -fy
            ;;  
        "8") #Grsync
            apt install grsync -y
            ;;              
        "9") #Gtk-Gnutella
            apt install gtk-gnutella -y
            ;;       
        "10") #Gydl (snap)
            snap install gydl
            ;;      
        "11") #Ktorrent (kde/plasma)
            apt install ktorrent -y
            ;;               
        "12") #Nicotine+ 
            apt install nicotine -y
            ;;               
        "13") #qBittorrent
            apt install qbittorrent -y
            ;;  
        "14") #Rtorrent
            apt install rtorrent screen -y
            ;;
        "15") #SubDownloader
            apt install subdownloader -y
            ;;              
        "16") #Vuze
            snap install vuze-vs --classic
            ;;  
        "17") #Webtorrent (flatpak)
            flatpak install flathub io.webtorrent.WebTorrent -y
            ;;
        "18") #WormHole
            apt install magic-wormhole -y
            ;;            
    esac
done

# Q6/ Lecture multimédia
for multimedia in $choixMultimedia
do
    case $multimedia in
        "2") #audacious
            apt install audacious audacious-plugins -y
            ;;  
        "3") #Banshee
            apt install banshee -y
            ;;  
        "4") #Clementine
            apt install clementine -y
            ;;              
        "5") #dragonplayer
            apt install dragonplayer -y
            ;;    
        "6") #gmusicbrowser
            apt install gmusicbrowser -y
            ;;              
        "7") #Gnome MPV
            apt install gnome-mpv -y
            ;;
        "8") #gnome music
            apt install gnome-music -y
            ;;  
        "9") #Gnome Twitch
            apt install gnome-twitch -y
            ;;   
        "10") #Gradio (flatpak)
            flatpak install flathub de.haeckerfelix.gradio -y
            ;; 
        "11") #Guayadeque
            add-apt-repository -y ppa:anonbeat/guayadeque ; apt update
            apt install guayadeque -y
            ;;            
        "12") #Lollypop (flatpak)
            flatpak install flathub org.gnome.Lollypop -y
            ;;  
        "13") #Molotov.tv (appimage)
            wget http://desktop-auto-upgrade.molotov.tv/linux/2.1.2/molotov
            mv molotov molotov.AppImage && chmod +x molotov.AppImage
            ;;             
        "14") #MuseScore 
            apt install musescore -y
            ;;               
        "15") #musique
            apt install musique -y
            ;; 
        "16") #qmmp
            apt install qmmp -y
            ;;             
        "17") #QuodLibet
            apt install quodlibet -y
            ;;   
        "18") #Rhythmbox
            apt install rhythmbox rhythmbox-plugins -y
            ;;              
        "19") #SmPlayer
            apt install smplayer smplayer-l10n smplayer-themes -y
            ;;    
        "20") #Spotify (snap)
            snap install spotify
            ;;              
        "21") #VLC
            apt install vlc vlc-plugin-vlsub vlc-plugin-visualization -y
            ;;    
        "22") #VLC dev - Snap edge
            snap install vlc --edge --classic 
            ;;               
        "23") #xmms2 + plugins
            apt install xmms2 xmms2-plugin-all gxmms2 -y
            ;;             
    esac
done

# Q7/ Montage vidéo
for video in $choixVideo
do
    case $video in
        "2") #Cinelerra
            add-apt-repository ppa:cinelerra-ppa/ppa -y
            apt update ; apt install cinelerra-cv -y
            ;;    
        "3") #DeVeDe 
            apt install devede -y
            ;;              
        "4") #Flowblade
            apt install flowblade -y
            ;;      
        "5") #Handbrake
            apt install handbrake -y
            ;;
        "6") #KDEnLive
            apt install kdenlive breeze-icon-theme -y
            ;;            
        "7") #Libav-tools
            apt install libav-tools -y
            ;;
        "8") #Lives
            apt install lives -y
            ;;    
        "9") #Mencoder
            apt install mencoder -y
            ;;  
        "10") #MMG MkvMergeGui
            apt install mkvtoolnix mkvtoolnix-gui -y
            ;;             
        "11") #Natron
            wget http://nux87.free.fr/script-postinstall-ubuntu/deb/natron_2.3.3_amd64.deb
            dpkg -i natron_2.3.3_amd64.deb
            apt install -fy
            ;;               
        "12") #OpenShot Video Editor 
            apt install --no-install-recommends openshot-qt -y
            ;;
        "13") #Peek (Flatpak) 
            flatpak install flathub com.uploadedlobster.peek -y
            ;;              
        "14") #Pitivi 
            apt install pitivi -y
            ;;
        "15") #Shotcut (PPA pour Bionic pas encore actif) // existe en snappy mais ne semble pas fonctionner
            add-apt-repository "deb http://ppa.launchpad.net/haraldhv/shotcut/ubuntu zesty main" -y
            apt-key adv --recv-keys --keyserver keyserver.ubuntu.com D03D19F673FED66EBD64099959A9D327745898E3
            apt update ; apt install shotcut -y
            ;;    
        "16") #WinFF
            apt install winff winff-doc winff-qt -y
            ;;            
    esac
done

# Q8/ Montage photo/graphisme/3d
for graphisme in $choixGraphisme
do
    case $graphisme in
        "2") #Blender
            apt install blender -y
            ;;       
        "3") #Darktable
            apt install darktable -y
            ;;      
        "4") #Frogr
            apt install frogr -y
            ;;              
        "5") #Gimp
            apt install gimp gimp-help-fr gimp-plugin-registry gimp-ufraw gimp-data-extras -y
            ;;
        "6") #Inkscape
            apt install inkscape -y
            ;;     
        "7") #K-3D
            apt install k3d -y
            ;;              
        "8") #Krita
            apt install krita krita-l10n -y
            ;;
        "9") #LibreCAD
            apt install librecad -y
            ;;               
        "10") #MyPaint
            apt install mypaint mypaint-data-extras -y
            ;;              
        "11") #Pinta
            apt install pinta -y
            ;;
        "12") #Pixeluvo
            wget http://www.pixeluvo.com/downloads/pixeluvo_1.6.0-2_amd64.deb
            dpkg -i pixeluvo_1.6.0-2_amd64.deb
            apt install -fy
            ;; 
        "13") #Shutter
            apt install shutter -y
            ;;              
        "14") #SweetHome 3D
            apt install sweethome3d -y
            ;;               
        "15") #Ufraw
            apt install ufraw ufraw-batch -y
            ;;              
    esac
done

# Q9/ Traitement audio
for audio in $choixAudio
do
    case $audio in
        "2") #Ardour
            debconf-set-selections <<< "jackd/tweak_rt_limits false"
            apt install ardour -y
            ;;       
        "3") #Audacity
            apt install audacity -y
            ;;    
        "4") #Flacon
            snap install flacon-tabetai
            ;;         
        "5") #Gnome Sound Recorder
            apt install gnome-sound-recorder -y
            ;;  
        "6") #Hydrogen
            apt install hydrogen -y
            ;;                 
        "7") #Lame
            apt install lame -y
            ;;            
        "8") #LMMS
            apt install lmms -y
            ;;             
        "9") #MhWaveEdit
            apt install mhwaveedit -y
            ;;    
        "10") #Mixxx
            apt install mixxx -y
            ;;   
        "11") #Pavucontrol
            apt install pavucontrol -y
            ;; 
        "12") #PulseEffects (flatpak)
            flatpak install flathub com.github.wwmm.pulseeffects -y
            ;;               
        "13") #RipperX
            apt install ripperx -y
            ;;   
        "14") #Rosegarden
            apt install rosegarden -y
            ;;              
        "15") #SoundJuicer
            apt install sound-juicer -y
            ;;            
        "16") #Xcfa
            apt install xcfa -y
            ;;
    esac
done

# Q10/ Bureautique
for bureautique in $choixBureautique
do
    case $bureautique in
        "2") # Calligra Suite
            apt install calligra -y
            ;;   
        "3") # FBReader
            apt install fbreader -y
            ;;                
        "4") #Feedreader (flatpak)
            flatpak install flathub org.gnome.FeedReader -y
            ;;    
        "5") #Freeplane
            apt install freeplane -y
            ;;    
        "6") #Geary
            apt install geary -y
            ;;   
        "7") #Gnome Evolution
            apt install evolution -y
            ;;              
        "8") #Gnome Office
            apt install abiword gnumeric dia planner glabels glom tomboy gnucash -y
            ;; 
        "9") #Latex
            apt install texlive texlive-lang-french texworks -y
            ;;             
        "10") #LibreOffice
            apt install libreoffice libreoffice-l10n-fr libreoffice-style-breeze -y
            ;;    
        "11") #LibreOffice fresh (PPA)
            add-apt-repository -y ppa:libreoffice/ppa ; apt update ; apt upgrade -y  
            apt install libreoffice libreoffice-l10n-fr libreoffice-style-breeze -y
            ;;
        "12") #LibreOffice : Supplément
            apt install libreoffice-style-elementary libreoffice-style-oxygen libreoffice-style-human libreoffice-style-sifr libreoffice-style-tango -y
            apt install libreoffice-templates hunspell-fr mythes-fr hyphen-fr openclipart-libreoffice python3-uno -y
            # récupération extension grammalecte (oxt)
            #wget https://www.dicollecte.org/grammalecte/oxt/Grammalecte-fr-v0.6.2.oxt && chown $SUDO_USER Grammalecte* && chmod +x Grammalecte*
            #unopkg add --shared Grammalecte*.oxt && rm Grammalecte*.oxt  
            ;;            
        "13") #MailSpring (Snap)
            snap install mailspring
            ;;    
        "14") #Master PDF Editor
            wget https://code-industry.net/public/master-pdf-editor-4.3.89_qt5.amd64.deb ; dpkg -i master-pdf* ; apt install -fy ; rm master-pdf*
            ;;              
        "15") #Notes Up (Flatpak)
            flatpak install flathub com.github.philip_scott.notes-up -y
            ;;  
        "16") #OnlyOffice (Snap)
            snap install onlyoffice-desktopeditors --classic
            ;;            
        "17") #PDFMod
            apt install pdfmod -y 
            ;;    
        "18") #Police d'écriture Microsoft
            echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | /usr/bin/debconf-set-selections | apt install ttf-mscorefonts-installer -y
            ;;
        "19") #Scenari (dépot Artful utilisé car celui de bionic pas encore actif + dépendance ajouté)
            wget http://nux87.free.fr/script-postinstall-ubuntu/deb/libav-tools_3.3.4-2_all.deb ; dpkg -i libav-tools* ; rm libav-tools*
            wget -O- https://download.scenari.org/deb/scenari.asc | apt-key add - ; echo "deb https://download.scenari.org/deb artful main" > /etc/apt/sources.list.d/scenari.list
            apt update ; apt install -fy ; apt install scenarichain4.2.fr-fr opale3.6.fr-fr -y
            ;;
        "20") #Scribus
            apt install scribus scribus-template -y
            ;;    
        "21") #Wordgrinder
            apt install wordgrinder wordgrinder-x11 -y
            ;;            
        "22") #WPS Office
            #wget http://ftp.fr.debian.org/debian/pool/main/libp/libpng/libpng12-0_1.2.50-2+deb8u3_amd64.deb ; wget http://kdl1.cache.wps.com/ksodl/download/linux/a21//wps-office_10.1.0.5707~a21_amd64.deb
            # problème de bande passante donc 1 serveur altnatif :
            wget http://nux87.free.fr/script-postinstall-ubuntu/deb/wps032018.deb ; wget http://nux87.free.fr/script-postinstall-ubuntu/deb/libpng.deb
            dpkg -i libpng* ; dpkg -i wps* ; apt install -fy ; rm *.deb ;
            ;;  
        "23") #Zim
            apt install zim -y
            ;;                            
        # Entrées cachés car potentiellement risqué :
        "500") #Soft Maker Office Béta ## Peux faire planter l'installation pendant le script 
            wget http://www.softmaker.net/down/softmaker-office-2018_928-01_amd64.deb
            dpkg -i softmaker-office-*.deb ; apt install -fy ; rm -f softmaker-office-*
            ;;    
    esac
done

# Q11/ Science/Education
for science in $choixScience
do
    case $science in
        "2") #Algobox
            apt install algobox -y
            ;;   
        "3") #AlgoIDE 
            wget http://www.algoid.net/downloads/AlgoIDE-release.jar
            chmod +x AlgoIDE-release.jar && mv AlgoIDE-release.jar /home/$SUDO_USER/ ; chown -R $SUDO_USER /home/$SUDO_USER/AlgoIDE* ; chmod +x /home/$SUDO_USER/AlgoIDE*
            ;;                 
        "4") #Avogadro
            apt install avogadro -y
            ;;   
        "5") #Celestia
            wget --no-check-certificate https://raw.githubusercontent.com/simbd/Scripts_Ubuntu/master/Celestia_pour_Bionic.sh ; chmod +x Celestia*
            ./Celestia*.sh ; rm Celestia* ;
            ;;  
        "6") #Einstein Puzzle
            apt install einstein -y
            ;; 
        "7") #GanttProject
            wget https://dl.ganttproject.biz/ganttproject-2.8.7/ganttproject_2.8.7-r2262-1_all.deb
            dpkg -i ganttproject* ; apt install -fy ; rm ganttproject*
            ;;               
        "8") #GCompris
            apt install gcompris gcompris-qt gcompris-qt-data gnucap -y
            ;;              
        "9") #Geogebra
            apt install geogebra -y
            ;;            
        "10") #Google Earth
            wget https://dl.google.com/dl/earth/client/current/google-earth-pro-stable_current_amd64.deb
            dpkg -i google-earth-pro-stable_current_amd64.deb ; apt install -fy
            sed -i -e "s/deb http/deb [arch=amd64] http/g" /etc/apt/sources.list.d/google-earth* #permet d'ignorer le 32bits sinon erreur lors d'un apt update
            ;;
        "11") #Marble
            apt install --no-install-recommends marble -y
            ;;            
        "12") #mBlock 
            apt install libgconf-2-4 -y
            wget https://github.com/Makeblock-official/mBlock/releases/download/V4.0.0-Linux/mBlock-4.0.0-linux-4.0.0.tar.gz
            tar zxvf mBlock*.tar.gz -C /opt/ ; chown -R $SUDO_USER:$SUDO_USER /opt/mBlock
            ln -s /opt/mBlock/mblock /home/$SUDO_USER/raccourci_mblock ; rm mBlock*.tar.gz
            ;;            
        "13") #oooHG - extension LO 
            apt install ooohg -y
            ;;
        "14") #OptGeo
            apt install optgeo -y
            ;;    
        "15") #Planner
            apt install planner -y
            ;;                  
        "16") #Scratch 1.4
            apt install scratch -y
            ;;  
        "17") #Stellarium
            apt install stellarium -y
            ;;            
        "18") #Xcas
            apt install xcas -y
            ;;               
    esac
done

# Q12/ Utilitaire et divers
for utilitaire in $choixUtilitaire
do
    case $utilitaire in
        "2") #AnyDesk (flatpak possible en alternative)
            wget https://download.anydesk.com/linux/anydesk_2.9.5-1_amd64.deb
            dpkg -i anydesk* ; apt install -fy ; rm anydesk* ;
            ;;        
        "3") #Brasero
            apt install brasero brasero-cdrkit nautilus-extension-brasero -y
            ;;  
        "4") #Cheese
            apt install cheese -y
            ;;  
        "5") #Corebird
            apt install corebird -y
            ;;  
        "6") #ddrescue
            apt install gddrescue -y
            ;;                
        "7") #Diodon
            apt install diodon -y
            ;;              
        "8") #FlashPlayer (avec dépot partenaire)
            apt install adobe-flashplugin -y
            ;;    
        "9") #Gnome Encfs Manager
            add-apt-repository -y ppa:gencfsm/ppa ; apt update ;
            apt install gnome-encfs-manager -y
            ;;             
        "10") #Gnome Recipes
            apt install gnome-recipes -y
            ;;   
        "11") #Gufw
            apt install gufw -y
            ;;              
        "12") #Kazam
            apt install kazam -y
            ;;
        "13") #KeepassX2
            apt install keepassx -y
            ;;             
        "14") #MultiSystem
            wget -q http://liveusb.info/multisystem/depot/multisystem.asc -O- | apt-key add -
            add-apt-repository -y 'deb http://liveusb.info/multisystem/depot all main'
            apt update ; apt install multisystem -y
            ;;            
        "15") #OpenBroadcaster Software 
            add-apt-repository -y ppa:obsproject/obs-studio ; apt update
            apt install ffmpeg obs-studio -y
            ;;  
        "16") #Oracle Java 8 
            add-apt-repository -y ppa:webupd8team/java ; apt update 
            echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections | apt install oracle-java8-installer -y
            ;;  
        "17") #Oracle Java 10 
            add-apt-repository -y ppa:linuxuprising/java ; apt update
            echo oracle-java10-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections | apt install oracle-java10-installer -y
            ;;  
        "18") #Pack cyber-sécurité
            apt install aircrack-ng nmap nikto john hashcat kismet -y
            ;;       
        "19") #pack d'outils : vrms + screenfetch + asciinema + ncdu + screen + kclean + rclone
            apt install vrms screenfetch asciinema ncdu screen rclone -y
            wget http://hoper.dnsalias.net/tdc/public/kclean.deb && dpkg -i kclean.deb ; apt install -fy ; rm kclean.deb 
            ;; 
        "20") #Redshift  (à configurer par l'utilisateur lui même)
            apt install redshift-gtk -y
            ;;             
        "21") #SimpleScreenRecorder
            apt install simplescreenrecorder -y
            ;;
        "22") #Smartmontools 
            apt install --no-install-recommends smartmontools -y
            ;;            
        "23") #Synaptic
            apt install synaptic -y
            ;;              
        "24") #Teamviewer
            wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
            dpkg -i teamviewer* ; apt install -fy ; rm teamviewer*
            ;; 
        "25") #Testdisk
            apt install testdisk -y
            ;;                
        "26") #VeraCrypt
            add-apt-repository -y ppa:unit193/encryption ; apt update
            apt install -y veracrypt
            ;;               
        "27") #VirtualBox
            apt install virtualbox -y
            ;;  
        "28") #Virtualbox dernière stable possible (oracle)
            wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
            echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian bionic contrib" > /etc/apt/sources.list.d/virtualbox.list
            apt update ; apt install -y virtualbox-5.2
            ;;            
        "29") #Wine 
            apt install wine-stable -y
            ;;
        "30") #Wireshark
            debconf-set-selections <<< "wireshark-common/install-setuid true"
            apt install wireshark -y ; usermod -aG wireshark $SUDO_USER #permet à l'utilisateur principal de faire des captures
            ;;         
    esac
done

# Q13/ Jeux
for gaming in $choixGaming
do
    case $gaming in
        "2") #0ad: Empires Ascendant 
            apt install 0ad -y
            ;;    
        "3") #Albion online (flatpak)
            flatpak install flathub com.albiononline.AlbionOnline -y
            ;;       
        "4") #AlienArena
            apt install alien-arena -y
            ;;                
        "5") #Assault Cube
            apt install assaultcube -y
            ;;     
        "6") #Battle for Wesnoth
            apt install wesnoth -y
            ;;            
        "7") #FlightGear
            apt install flightgear -y
            ;;       
        "8") #Gnome Games 
            apt install gnome-games gnome-games-app -y
            ;;    
        "9") #Khaganat
            wget https://clients.lirria.khaganat.net/smokey_linux64.7z
            7z x smokey* ; rm -rf smokey*.7z ; mv Khanat* /home/$SUDO_USER/khanat_game ; chown -R $SUDO_USER /home/$SUDO_USER/khanat_game
            ;;                 
        "10") #Lutris
            wget https://download.opensuse.org/repositories/home:/strycore/xUbuntu_17.10/amd64/lutris_0.4.14_amd64.deb
            dpkg -i lutris* ; apt install -fy ; rm lutris*
            ;;                 
        "11") #Megaglest
            apt install megaglest -y
            ;;            
        "12") #Minecraft (snap car le paquet deb semble poser problème)
            snap install minecraft
            #wget http://packages.linuxmint.com/pool/import/m/minecraft-installer/minecraft-installer_0.1+r12~ubuntu16.04.1_amd64.deb ; dpkg -i minecraft-installer_0.1+r12~ubuntu16.04.1_amd64.deb ; apt install -fy
            ;;
        "13") #Minetest 
            apt install minetest minetest-mod-nether -y
            ;; 
        "14") #OpenArena
            apt install openarena -y
            ;;    
        "15") #Pingus
            apt install pingus -y            
            ;;            
        "16") #PlayOnLinux
            apt install playonlinux -y
            ;; 
        "17") #PokerTH
            apt install pokerth -y
            ;;               
        "18") #Runscape 
            apt install runescape -y
            ;;            
        "19") #Steam
            apt install steam -y
            ;;
        "20") #SuperTux
            apt install supertux -y
            ;;            
        "21") #SuperTuxKart
            apt install supertuxkart -y
            ;;   
        "22") #TeeWorlds
            apt install teeworlds -y
            ;;     
        "23") #Xqf
            apt install xqf -y
            ;;                 
    esac
done

# Mode avancé

# 14/ Extensions (extension en commentaire pas encore compatible avec GS 3.28)
for extension in $choixExtension
do
    case $extension in
           
        "2") #AlternateTab (v3.26)
            wget https://extensions.gnome.org/extension-data/alternate-tab%40gnome-shell-extensions.gcampax.github.com.v36.shell-extension.zip
            unzip alternate-tab@gnome-shell-extensions.gcampax.github.com.v36.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/alternate-tab@gnome-shell-extensions.gcampax.github.com
            ;;
        "3") #AppFolders Management (v3.26)
            wget https://extensions.gnome.org/extension-data/appfolders-manager%40maestroschan.fr.v12.shell-extension.zip
            unzip appfolders-manager@maestroschan.fr.v12.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/appfolders-manager@maestroschan.fr          
            ;;                
        "4") #Caffeine
            apt install gnome-shell-extension-caffeine -y
            ;;
        "5") #Clipboard Indicator (v3.26)
            wget https://extensions.gnome.org/extension-data/clipboard-indicator%40tudmotu.com.v30.shell-extension.zip
            unzip clipboard-indicator@tudmotu.com.v30.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com
            ;;                
        "6") #DashToDock 
            apt install gnome-shell-extension-dashtodock -y
            #wget https://extensions.gnome.org/extension-data/dash-to-dock%40micxgx.gmail.com.v62.shell-extension.zip ; unzip dash-to-dock@micxgx.gmail.com.v62.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com
            ;;
        "7") #DashToPanel
            apt install gnome-shell-extension-dash-to-panel -y
            ;; 
        "8") #Dockilus
            wget https://framagit.org/abakkk/Dockilus/repository/master/archive.zip ; unzip archive.zip ; rm archive.zip
            mv Dockilus* /home/$SUDO_USER/.local/share/gnome-shell/extensions/dockilus@framagit.org
            ;;            
        "9") #Impatience
            apt install gnome-shell-extension-impatience -y
            ;;
        "10") #Logout button
            apt install gnome-shell-extension-log-out-button -y
            ;; 
        "11") #Media Player Indicator
            apt install gnome-shell-extension-mediaplayer -y
            ;;
        "12") #Multi monitors
            apt install gnome-shell-extension-multi-monitors -y
            ;;
        "13") #openWeather
            apt install gnome-shell-extension-weather -y
            ;;
        "14") #Places status indicator (v3.26)
            wget https://extensions.gnome.org/extension-data/places-menu%40gnome-shell-extensions.gcampax.github.com.v38.shell-extension.zip
            unzip places-menu@gnome-shell-extensions.gcampax.github.com.v38.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/places-menu@gnome-shell-extensions.gcampax.github.com
            ;;
        "15") #Removable drive menu (v3.26)
            wget https://extensions.gnome.org/extension-data/drive-menu%40gnome-shell-extensions.gcampax.github.com.v35.shell-extension.zip
            unzip drive-menu@gnome-shell-extensions.gcampax.github.com.v35.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/drive-menu@gnome-shell-extensions.gcampax.github.com
            ;;
        "16") #Shortcuts
            apt install gnome-shell-extension-shortcuts -y
            ;;
        "17") #Suspend button
            apt install gnome-shell-extension-suspend-button -y
            ;;     
        "18") #System-monitor
            apt install gnome-shell-extension-system-monitor -y
            ;;              
        "19") #Taskbar
            apt install gnome-shell-extension-taskbar -y
            ;;
        "20") #Top Icon Plus
            apt install gnome-shell-extension-top-icons-plus -y
            ;;            
        "21") #Trash
            apt install gnome-shell-extension-trash -y
            ;; 
        "22") #Unite (v3.26)
            wget https://extensions.gnome.org/extension-data/unite%40hardpixel.eu.v11.shell-extension.zip
            unzip unite@hardpixel.eu.v11.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/unite@hardpixel.eu
            ;;              
        "23") #User themes (v3.26)
            wget https://extensions.gnome.org/extension-data/user-theme%40gnome-shell-extensions.gcampax.github.com.v32.shell-extension.zip
            unzip user-theme@gnome-shell-extensions.gcampax.github.com.v32.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/user-theme@gnome-shell-extensions.gcampax.github.com
            ;;              
        "24") #Window list (v3.26)
            wget https://extensions.gnome.org/extension-data/window-list%40gnome-shell-extensions.gcampax.github.com.v22.shell-extension.zip
            unzip window-list@gnome-shell-extensions.gcampax.github.com.v22.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/window-list@gnome-shell-extensions.gcampax.github.com
            ;;
        "25") #Workspace indicator (v3.26)
            wget https://extensions.gnome.org/extension-data/workspace-indicator%40gnome-shell-extensions.gcampax.github.com.v34.shell-extension.zip
            unzip workspace-indicator@gnome-shell-extensions.gcampax.github.com.v34.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/workspace-indicator@gnome-shell-extensions.gcampax.github.com
            ;; 
    esac
done

# Q15/ Customization
for custom in $choixCustom
do
    case $custom in
        "2") #Communitheme
            add-apt-repository -y ppa:communitheme/ppa ; apt update
            apt install gnome-shell-communitheme gtk-communitheme suru-icon-theme communitheme-sounds -y
            ;;   
        "3") #Icone Papirus
            wget http://nux87.free.fr/script-postinstall-ubuntu/theme/papirus-icon-theme-20171124.tar.xz ; tar Jxvf papirus-icon-theme-20171124.tar.xz
            mv *Papirus* /usr/share/icons/
            ;;             
        "4") #pack curseur
            apt install breeze-cursor-theme moblin-cursor-theme oxygen-cursor-theme -y
            ;;              
        "5") #pack icone 1
            apt install numix-icon-theme breathe-icon-theme breeze-icon-theme gnome-brave-icon-theme elementary-icon-theme -y
            ;;        
        "6") #pack icone 2
            apt install gnome-dust-icon-theme gnome-humility-icon-theme gnome-icon-theme-gartoon gnome-icon-theme-gperfection2 gnome-icon-theme-nuovo -y
            ;;  
        "7") #pack icone 3
            apt install human-icon-theme moblin-icon-theme oxygen-icon-theme gnome-icon-theme-suede gnome-icon-theme-yasis -y
            ;;    
        "8") #theme Mac OS X High Sierra (plusieurs versions)
            apt install gtk2-engines-pixbuf gtk2-engines-murrine -y
            git clone https://github.com/B00merang-Project/macOS-Sierra.git ; git clone https://github.com/B00merang-Project/macOS-Sierra-Dark.git ; mv -f macOS* /usr/share/themes/
            wget http://nux87.free.fr/script-postinstall-ubuntu/theme/Gnome-OSX-V-Space-Grey-1-3-1.tar.xz && wget http://nux87.free.fr/script-postinstall-ubuntu/theme/Gnome-OSX-V-Traditional-1-3-1.tar.xz   
            tar Jxvf Gnome-OSX-V-Space-Grey-1-3-1.tar.xz ; mv -f Gnome-OSX-V-Space-Grey-1-3-1 /usr/share/themes/ ; rm Gnome-OSX-V-Space-Grey-1-3-1.tar.xz
            tar Jxvf Gnome-OSX-V-Traditional-1-3-1.tar.xz ; mv -f Gnome-OSX-V-Traditional-1-3-1 /usr/share/themes/ ; rm Gnome-OSX-V-Traditional-1-3-1.tar.xz       
            #Pack d'icone la capitaine + macOS
            git clone https://github.com/keeferrourke/la-capitaine-icon-theme.git ; mv -f *capitaine* /usr/share/icons/
            wget http://nux87.free.fr/script-postinstall-ubuntu/theme/macOS.tar.xz ; tar Jxvf macOS.tar.xz ; mv macOS /usr/share/icons/ ; rm -r macOS*
            #Wallpaper officiel Mac OS X Sierra
            wget http://wallpaperswide.com/download/macos_sierra_2-wallpaper-3554x1999.jpg -P /home/$SUDO_USER/Images/
            ;;  
        "9") #Unity 8
            git clone https://github.com/B00merang-Project/Unity8.git ; mv -f Unit* /usr/share/themes/
            ;;         
        "10") #theme Windows 10
            git clone https://github.com/B00merang-Project/Windows-10.git ; mv -f Windo* /usr/share/themes/
            wget http://nux87.free.fr/script-postinstall-ubuntu/theme/windows10-icons_1.2_all.deb && dpkg -i windows10-icons_1.2_all.deb
            wget https://framapic.org/Nd6hGtEOEJhM/LtmYwl16WjyC.jpg && mv LtmYwl16WjyC.jpg /home/$SUDO_USER/Images/windows10.jpg
            ;;            
        "11") #pack theme gtk 1
            apt install arc-theme numix-blue-gtk-theme numix-gtk-theme silicon-theme -y
            #Numix Circle
            git clone https://github.com/numixproject/numix-icon-theme-circle.git ; mv -f numix-icon-theme-circle/* /usr/share/icons/ ; rm -r numix-icon-theme-circle
            ;;
        "12") #pack theme gtk 2
            apt-add-repository ppa:tista/adapta -y ; apt update ; 
            apt install adapta-gtk-theme blackbird-gtk-theme bluebird-gtk-theme greybird-gtk-theme -y
            ;;
        "13") #pack theme gtk 3
            apt install albatross-gtk-theme yuyo-gtk-theme human-theme gnome-theme-gilouche materia-gtk-theme -y
            ;; 
        "14") #visuel gris GDM (changement effectif seulement si la session vanilla est installé)
            apt install gnome-session -y # session vanilla nécessaire pour le changement du thème (sinon ne s'applique pas)
            mv /usr/share/gnome-shell/theme/ubuntu.css /usr/share/gnome-shell/theme/ubuntu_old.css
            mv /usr/share/gnome-shell/theme/gnome-shell.css /usr/share/gnome-shell/theme/ubuntu.css
            ;;            
    esac
done

# Q16/ Programmation/Dev
for dev in $choixDev
do
    case $dev in
        "2") #Android Studio (flatpak)
            flatpak install flathub com.google.AndroidStudio -y
            ;;       
        "3") #Anjuta
            apt install anjuta anjuta-extras -y
            ;;
        "4") #Atom
            snap install atom --classic
            ;;            
        "5") #BlueFish
            apt install bluefish bluefish-plugins -y
            ;; 
        "6") #BlueGriffon
            wget http://bluegriffon.org/freshmeat/3.0.1/bluegriffon-3.0.1.Ubuntu16.04-x86_64.deb
            dpkg -i bluegriffon*.deb ; apt install -fy ; rm bluegriffon*
            ;;      
        "7") #Brackets
            snap install brackets --classic
            ;;             
        "8") #Code:Blocks
            apt install codeblocks codeblocks-contrib -y
            ;;  
        "9") #Eclipse
            wget http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/oomph/epp/oxygen/R/eclipse-inst-linux64.tar.gz
            tar xvfz eclipse-inst-linux64.tar.gz ; chmod +x ./eclipse-installer/eclipse-inst
            ./eclipse-installer/eclipse-inst
            rm -rf eclipse-installer ; rm eclipse-inst-linux64.tar.gz
            ;;              
        "10") #Emacs
            apt install emacs -y
            ;; 
        "11") #Geany (verifier les extensions)
            apt install geany geany-plugins geany-plugin-* -y
            ;;            
        "12") #Gvim
            apt install vim-gtk3 -y
            ;;
        "13") #IntelliJ Idea
            snap install intellij-idea-community --classic 
            ;;              
        "14") #JEdit
            apt install jedit -y
            ;;    
        "15") #PyCharm
            snap install pycharm-community --classic
            ;;            
        "16") #SciTE
            apt install scite -y
            ;;              
        "17") #Sublime Text
            wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
            apt install apt-transport-https -y
            echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list
            apt update ; apt install sublime-text -y
            ;;
        "18") #Visual Studio Code
            snap install vscode --classic
            ;;     
    esac
done

# Q17/ Serveurs
for srv in $choixServeur
do
    case $srv in
        "2") #Cuberite (snap)
            snap install cuberite
            ;;    
        "3") #Docker 
            apt install apt-transport-https ca-certificates curl software-properties-common -y
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
            add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
            apt update ; apt install docker-ce -y
            ;;    
        "4") #PHP5 
            add-apt-repository -y ppa:ondrej/php ; apt update
            apt install php5.6 -y
            ;;
        "5") #php7.2
            apt install php7.2 -y
            ;;     
        "6") #Samba + gadmin-samba
            apt install samba gadmin-samba -y
            ;;                 
        "7") #Postgresql
            apt install postgresql -y
            ;;            
        "8") #proftpd
            apt install proftpd -y
            ;;  
        "9") #lamp
            apt install apache2 php mariadb-server libapache2-mod-php php-mysql -y
            ;;            
        "10") #openssh-server
            apt install openssh-server -y
            ;;            
    esac
done

# Q18/ Optimisation/Réglage
for optimisation in $choixOptimisation
do
    case $optimisation in
        "2") #Nouvelle commande raccourci Maj totale
            echo "alias maj='sudo apt update && sudo apt autoremove --purge -y && sudo apt full-upgrade -y && sudo apt clean && sudo snap refresh && sudo flatpak update -y ; clear'" >> /home/$SUDO_USER/.bashrc
            su $SUDO_USER -c "source ~/.bashrc"
            ;;    
        "3") #Support ExFat
            apt install exfat-utils exfat-fuse -y    
            ;;
        "4") #Support HFS
            apt install hfsprogs hfsutils hfsplus -y
            ;;    
        "5") #Interdire l'accès des autres utilisateurs au dossier perso de l'utilisateur principal
            chmod -R o-rwx /home/$SUDO_USER
            ;;    
        "6") #Dépots supplémentaires pour utiliser Flatpak (de base il y a déjà Flathub sans cette option)
            flatpak remote-add --if-not-exists nuvola https://dl.tiliado.eu/flatpak/nuvola.flatpakrepo
            flatpak remote-add --if-not-exists kdeapps --from https://distribute.kde.org/kdeapps.flatpakrepo
            flatpak remote-add --if-not-exists gnome https://sdk.gnome.org/gnome.flatpakrepo
            ;;           
        "7") #Désactiver swap
            swapoff /swapfile #désactive l'utilisation du fichier swap
            rm /swapfile #supprime le fichier swap qui n'est plus utile
            sed -i -e '/.swapfile*/d' /etc/fstab #ligne swap retiré de fstab
            ;;    
        "8") #GameMode
            apt install meson libsystemd-dev pkg-config ninja-build mesa-utils -y
            git clone https://github.com/FeralInteractive/gamemode.git ; cd gamemode ; ./bootstrap.sh ; cd ..
            #jeu à lancer comme ceci : LD_PRELOAD=/usr/\$LIB/libgamemodeauto.so ./game
            # Ou pour steam : LD_PRELOAD=$LD_PRELOAD:/usr/\$LIB/libgamemodeauto.so %command%
            # + de précision ici : https://github.com/FeralInteractive/gamemode
            ;;              
        "9") #Minimisation fenêtre sur l'icone du dock (pour dashtodock uniquement)
            su $SUDO_USER -c "gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'"
            ;;    
        "10") #Gnome Shell : pouvoir lancer via une commande fraude une appli avec droit root sous wayland (proposé par Christophe C sur Ubuntu-fr.org)
            echo "#FONCTION POUR CONTOURNER WAYLAND
            fraude(){ 
                xhost + && sudo \$1 && xhost -
                }" >> /home/$SUDO_USER/.bashrc
            su $SUDO_USER -c "source ~/.bashrc"
            ;;  
        "11") #Gnome Shell : augmenter durée capture vidéo de 30s à 10min
            su $SUDO_USER -c "gsettings set org.gnome.settings-daemon.plugins.media-keys max-screencast-length 600"
            ;;                 
        "12") #Gnome Shell : Désactiver l'affichage de la liste des utilisateurs dans la gestion de session GDM (donc rentrer login manuellement)
            echo "user-db:user
            system-db:gdm
            file-db:/usr/share/gdm/greeter-dconf-defaults" > /etc/dconf/profile/gdm
            mkdir /etc/dconf/db/gdm.d
            echo "[org/gnome/login-screen]
            # Do not show the user list
            disable-user-list=true" > /etc/dconf/db/gdm.d/00-login-screen
            dconf update
            ;;            
        "13") #Pour utiliser carte nvidia/pilote nouveau pour un jeu
            apt install switcheroo-control -y    
            ;;
        "14") #Microcode Intel
            apt install intel-microcode -y
            ;;   
        "15") #Pilote propriétaire nvidia + nvidia prime + glxgears
            apt install nvidia-driver-390 bbswitch-dkms nvidia-settings nvidia-prime mesa-utils -y
            ;;               
        "16") #Lecture DVD Commerciaux
            apt install libdvdcss2 libdvd-pkg -y
            dpkg-reconfigure libdvd-pkg
            ;;  
        "17") #Grub réduction temps d'attente + suppression test ram dans grub
            sed -ri 's/GRUB_TIMEOUT=10/GRUB_TIMEOUT=2/g' /etc/default/grub
            mkdir /boot/old ; mv /boot/memtest86* /boot/old/
            update-grub
            ;;                
        "18") #Swapiness 95% +cache pressure 50
            echo vm.swappiness=5 | tee /etc/sysctl.d/99-swappiness.conf
            sysctl -p /etc/sysctl.d/99-swappiness.conf
            ;; 
        "19") #Support imprimante HP
            apt install hplip hplip-doc hplip-gui sane sane-utils -y
            ;;               
        "20") #TLP 
            apt install --no-install-recommends tlp tlp-rdw -y
            systemctl enable tlp ; systemctl enable tlp-sleep
            ;;
    esac
done

# Question 19 : Extra Snap
for snap in $choixSnap
do
    case $snap in
        "2") #blender
            snap install blender --classic
            ;;              
        "3") #dino
            snap install dino
            ;;   
        "4") #electrum
            snap install electrum
            ;;             
        "5") #gimp version snap
            snap install gimp
            ;;    
        "6") #instagraph
            snap install instagraph
            ;;  
        "7") #keepassXC
            snap install keepassxc
            ;;  
        "8") #LibreOffice version snap
            snap install libreoffice
            ;;     
        "9") #nextcloud client
            snap install nextcloud-client
            ;;      
        "10") #pycharm pro
            snap install pycharm-professional --classic
            ;;   
        "11") #Quassel client
            snap install quasselclient-moon127
            ;;   
        "12") #Rube cube
            snap install rubecube
            ;;   
        "13") #Shotcut
            snap install shotcut --classic
            ;;               
        "14") #Skype version snap
            snap install skype --classic
            ;;   
        "15") #TermiusApp
            snap install termius-app
            ;;        
        "16") #TicTacToe
            snap install tic-tac-toe
            ;;        
        "17") #Zeronet
            snap install zeronet
            ;;              
    esac
done        
    
# Question 20 : Extra Flatpak
for flatpak in $choixFlatpak
do
    case $flatpak in
        "2") #0ad version flatpak
            flatpak install flathub com.play0ad.zeroad -y
            ;;
        "3") #Audacity version flatpak
            flatpak install flathub org.audacityteam.Audacity -y
            ;;          
        "4") #Blender version flatpak
            flatpak install flathub org.blender.Blender -y
            ;;              
        "5") #Dolphin Emulator
            flatpak install flathub org.DolphinEmu.dolphin-emu -y
            ;;             
        "6") #Extreme Tuxracer
            flatpak install flathub net.sourceforge.ExtremeTuxRacer -y
            ;;                
        "7") #Frozen Bubble
            flatpak install flathub org.frozen_bubble.frozen-bubble -y
            ;;     
        "8") #GIMP version flatpak
            flatpak install flathub org.gimp.GIMP -y
            ;;              
        "9") #Gnome MPV version flatpak
            flatpak install flathub io.github.GnomeMpv -y
            ;;                   
        "10") #Google Play Music Desktop Player
            flatpak install flathub com.googleplaymusicdesktopplayer.GPMDP -y
            ;;              
        "11") #Homebank
            flatpak install flathub fr.free.Homebank -y
            ;;     
        "12") #Kdenlive
            flatpak install flathub org.kde.kdenlive -y
            ;;               
        "13") #LibreOffice version flatpak
            flatpak install flathub org.libreoffice.LibreOffice -y
            ;;         
        "14") #Minetest version flatpak
            flatpak install flathub net.minetest.Minetest -y
            ;;             
        "15") #Nextcloud
            flatpak install flathub org.nextcloud.Nextcloud -y
            ;;        
        "16") #Password Calculator
            flatpak install flathub com.bixense.PasswordCalculator -y
            ;;             
        "17") #Riot
            flatpak install flathub im.riot.Riot -y
            ;;        
        "18") #Skype version flatpak
            flatpak install flathub com.skype.Client -y
            ;;                   
        "19") #VLC version flatpak
            flatpak install flathub org.videolan.VLC -y
            ;;
    esac
done

# Question 21 : Extra Appimages
for appimage in $choixAppimage
do
    case $appimage in
        "2") #Aidos Wallet
            wget https://github.com/AidosKuneen/aidos-wallet/releases/download/v1.2.7/Aidos-1.2.7-x86_64.AppImage
            ;; 
        "3") #AppImageUpdate
            wget http://nux87.free.fr/script-postinstall-ubuntu/appimage/AppImageUpdate-303-f2b8183-x86_64.AppImage
            ;;              
        "4") #Chronos
            wget https://github.com/web-pal/Chronos/releases/download/v2.2.1/Chronos-2.2.1-x86_64.AppImage
            ;;     
        "5") #Crypter
            wget https://github.com/HR/Crypter/releases/download/v3.1.0/Crypter-3.1.0-x86_64.AppImage
            ;;            
        "6") #Digikam
            wget http://nux87.free.fr/script-postinstall-ubuntu/appimage/digikam-5.9.0-01-x86-64.appimage
            mv digikam-5.9.0-01-x86-64.appimage digikam-5.9.0-01-x86-64.AppImage
            ;;
        "7") #Freecad
            wget https://github.com/FreeCAD/FreeCAD/releases/download/0.16.6712/FreeCAD-0.16.6712.glibc2.17-x86_64.AppImage
            ;;            
        "8") #Imagine
            wget https://github.com/meowtec/Imagine/releases/download/v0.4.0/Imagine-0.4.0-x86_64.AppImage
            ;;     
        "9") #Infinite Electron
            wget https://github.com/InfiniteLibrary/infinite-electron/releases/download/0.1.1/infinite-electron-0.1.1-x86_64.AppImage
            ;; 
        "10") #Jaxx
            wget https://github.com/Jaxx-io/Jaxx/releases/download/v1.3.9/jaxx-1.3.9-x86_64.AppImage
            ;;              
        "11") #Kdenlive version Appimage
            wget https://download.kde.org/unstable/kdenlive/16.12/linux/Kdenlive-16.12-rc-x86_64.AppImage
            ;;   
        "12") #KDevelop
            wget https://download.kde.org/stable/kdevelop/5.2.0/bin/linux/KDevelop-5.2.0-x86_64.AppImage
            ;;     
        "13") #MellowPlayer
            wget https://github.com/ColinDuquesnoy/MellowPlayer/releases/download/Continuous/MellowPlayer-x86_64.AppImage
            ;; 
        "14") #Nextcloud version Appimage
            wget https://download.nextcloud.com/desktop/prereleases/Linux/Nextcloud-2.3.3-beta-x86_64.AppImage
            ;;    
        "15") #Openshot version Appimage
            wget http://nux87.free.fr/script-postinstall-ubuntu/appimage/OpenShot-v2.4.1-x86_64.AppImage
            ;;  
        "16") #Owncloud Client
            wget http://download.opensuse.org/repositories/home:/ocfreitag/AppImage/owncloud-client-latest-x86_64.AppImage
            ;;     
        "17") #Popcorntime
            wget https://github.com/amilajack/popcorn-time-desktop/releases/download/v0.0.6/PopcornTime-0.0.6-x86_64.AppImage
            ;;                  
        "18") #Spotify web client
            wget https://github.com/Quacky2200/Spotify-Web-Player-for-Linux/releases/download/1.0.42/spotifywebplayer-1.0.42-x86_64.AppImage
            ;;      
        "19") #Tulip
            wget https://github.com/Tulip-Dev/tulip/releases/download/tulip_5_1_0/Tulip-5.1.0-x86_64.AppImage
            ;;                      
    esac
done

# Rangement des AppImage et vérification du bon propriétaire de certains dossiers.
cd /home/$SUDO_USER/script_postinstall/
mkdir ../appimages ; mv *.AppImage ../appimages/ ; chmod -R +x ../appimages 
chown -R $SUDO_USER:$SUDO_USER ../appimages ../.icons ../.themes ../.local

# Nettoyage fichiers/dossiers inutiles qui étaient utilisés par le script
rm *.zip ; rm *.tar.gz ; rm *.tar.xz ; rm *.deb ; cd .. && rm -rf /home/$SUDO_USER/script_postinstall
clear

# Maj/Nettoyage
apt update ; apt autoremove --purge -y ; apt clean ; cd .. ; clear 

echo "Pour prendre en compte tous les changements, il faut maintenant redémarrer !"
read -p "Voulez-vous redémarrer immédiatement ? [o/N] " rep_reboot
if [ "$rep_reboot" = "o" ] || [ "$rep_reboot" = "O" ]
then
    reboot
fi
