#!/bin/bash
# version 0.1.9

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

# Contrôle de la configuration système (script correctement lancé + version 18.04 + gnome-shell présent)
. /etc/lsb-release
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
            echo -e "${bleu}0/Vous utilisez actuellement une variante, merci de préciser laquelle (support 64 bits uniquement!) :${neutre}"
            echo "*******************************************************"
            echo -e "${jaune}[1] Xubuntu 18.04 x64 (Xfce)${neutre}"
            echo -e "${violet}[2] Ubuntu Mate 18.04 x64 (Mate)${neutre}"
            echo -e "${cyan}[3] Lubuntu ou Lubuntu Next 18.04 x64 (Lxde ou LxQt)${neutre}"
            echo -e "${gris}[4] Kubuntu 18.04 x64 (Kde/Plasma)${neutre}"            
            echo -e "${vert}[5] Autres variantes basées sur la 18.04 x64 (ex: Kubuntu 18.04, Ubuntu Budgie 18.04...)${neutre}" 
            read -p "Répondre par le chiffre correspondant (exemple : 1) : " distrib
fi
clear
########################
echo "Ok, vous avez correctement lancé le script, passons aux questions..."
echo -e "#########################################################"
echo -e "Voici la légende pour vous informer de certaines choses :"
echo -e "${jaune}[Snap]${neutre} => Le paquet s'installera avec Snap (snap install...)"
echo -e "${bleu}[Flatpak]${neutre} => S'installera avec Flatpak, une alternative aux snaps (flatpak install --from...)"
echo -e "${vert}[Appimage]${neutre} => Application portable (pas d'installation), à lancer comme ceci : ./nomdulogiciel.AppImage"
echo -e "${rouge}[Interv!]${neutre} => Installation pas totalement automatisé : vous devrez intervenir (ex : valider contrat de licence...)"
echo -e "${violet}[Xorg only!]${neutre} => Le logiciel fonctionnera correctement uniquement en session Xorg mais pas sous Wayland (NB : sur les variantes vous êtes en Xorg)"
echo -e "${cyan}[à lancer manuellement]${neutre} => Il n'y aura pas de raccourci, il faudra aller manuellement dans le dossier et le lancer via celui-ci"
echo -e "Si rien de précisé en encadré => Installation classique depuis les dépots officiels si c'est possible (sinon PPA ou dépot externe)"
echo -e "#########################################################\n"    

### Section interactive avec les questions

## Mode normal
# Question 1 : sélection du mode de lancement du script
echo -e "${vert}Astuce 1: Mettez votre terminal en plein écran pour un affichage plus agréable (conseillé)${neutre}"
echo "*******************************************************"
echo -e "${bleu}1/ Mode de lancement du script :${neutre}"
echo "*******************************************************"
echo -e "[0] Mode ${gris}novice${neutre} (lancement automatique sans question, le script installera des logiciels intéressants pour les novices)"
echo -e "[1] Mode ${bleu}standard${neutre} (choix par défaut, pose diverses questions simples, recommandé pour la plupart des utilisateurs)"
echo -e "[2] Mode ${jaune}avancé${neutre} (comme standard mais avec des questions supplémentaires : programmation, optimisation, extension...)"
echo -e "[3] Mode ${vert}extra${neutre} (comme avancé mais avec un supplément snap/flatpak/appimages proposé à la fin)"
echo "*******************************************************"
read -p "Répondre par le chiffre correspondant (exemple : 1) : " choixMode
clear

while [ "$choixMode" != "0" ] && [ "$choixMode" != "1" ] && [ "$choixMode" != "2" ] && [ "$choixMode" != "3" ]
do
    read -p "Désolé, je ne comprend pas votre réponse, les seuls choix possibles sont 0 (novice), 1 (standard), 2 (avancé), 3 (extra) : " choixMode
    clear
done

if [ "$choixMode" != "0" ] #lancement pour tous sauf mode novice
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
        echo "*******************************************************"
        read -p "Répondre par le ou les chiffres correspondants séparés d'un espace (exemple : 1) : " choixSession
        clear
    fi

    # Question 3 : Navigateur web 
    echo -e "${vert}Astuce 3: à partir de cette question, vous pouvez faire plusieurs choix, il suffit d'indiquer chaque chiffre séparé d'un espace, par exemple : 2 4 12 19${neutre}"
    echo "*******************************************************"
    echo -e "${bleu}3/ Quel(s) navigateur(s) vous intéresse(nt) ? (plusieurs choix possibles)${neutre}"
    echo "*******************************************************"
    echo "[1] Pas de navigateur supplémentaire : rester sur la version classique de Firefox (stable)"
    echo "[2] Firefox Béta (n+1 : 1 version d'avance, remplace la version classique)"
    echo "[3] Firefox ESR (version plutôt orientée entreprise/organisation)"
    echo -e "[4] Firefox Developer Edition ${bleu}[Flatpak]${neutre} (version alternative incluant des outils de développement, généralement n+1/n+2)"
    echo -e "[5] Firefox Nightly ${bleu}[Flatpak]${neutre} (toute dernière build construite, n+2/n+3, ${rouge}potentiellement instable !${neutre})"
    echo "[6] Chromium (la version libre/opensource de Chrome)"
    echo "[7] Google Chrome (le célèbre navigateur de Google mais il est propriétaire !)"
    echo "[8] Vivaldi (un navigateur propriétaire avec une interface sobre assez particulière)"
    echo "[9] Opera (un navigateur propriétaire relativement connu)"
    echo "[10] PaleMoon (un navigateur plutôt récent, libre & performant)"
    echo "[11] WaterFox (un fork de Firefox compatible avec les anciennes extensions)"
    echo "[12] Tor Browser (pour naviguer dans l'anonymat avec le réseau tor : basé sur Firefox ESR)"
    echo "[13] Gnome Web/Epiphany (navigateur de la fondation Gnome s'intégrant bien avec cet environnement)"
    echo "[14] Midori (libre & léger mais un peu obsolète maintenant...)"
    echo "[15] QupZilla/Falkon (une alternative libre et légère utilisant Webkit)"   
    echo "[16] Min (un navigateur minimaliste et donc très léger)"   
    echo "[17] NetSurf (basique mais très léger et performant)"
    echo "[18] Dillo (navigateur capable de tourner sur des ordinosaures)"
    echo "[19] Lynx (navigateur 100% en ligne de commande, pratique depuis une console SSH)"
    echo -e "[20] Rekonq (navigateur web conçu surtout pour KDE)"
    echo -e "[21] Eolie ${bleu}[Flatpak]${neutre} (une autre alternative pour Gnome)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants séparés d'un espace (exemple : 6 10 16) : " choixNavigateur
    clear

    # Question 4 : Messagerie instantanée
    echo "*******************************************************"
    echo -e "${bleu}4/ Quel(s) logiciel(s) de messagerie instantanée/tchat/VoIP/visio souhaitez-vous ?${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun"
    echo "[2] Empathy (messagerie instantanée adaptée à Gnome, multi-protocole)"
    echo "[3] Pidgin (une alternative à Empathy avec l'avantage d'être multiplateforme)"
    echo "[4] Jitsi (anciennement 'SIP Communicator' surtout orienté VoIP)"
    echo "[5] Psi (multiplateforme, libre et surtout conçu pour le protocole XMPP cad Jabber)"
    echo "[6] Gajim (un autre client Jabber utilisant GTK+)"
    echo "[7] Skype (logiciel propriétaire de téléphonie, vidéophonie et clavardage très connue)"
    echo "[8] Ekiga (anciennement 'Gnome Meeting', logiciel de visioconférence/VoIP)"
    echo "[9] Linphone (visioconférence utilisant le protocole SIP)"
    echo "[10] Ring (anciennement 'SFLphone', logiciel très performant pour la téléphonie IP)"
    echo "[11] Mumble (logiciel libre connue chez les gameurs pour les conversations audios à plusieurs)"
    echo "[12] Wire (un autre client de messagerie instantanée chiffrée créé par Wire Swiss)"
    echo "[13] Hexchat (client IRC, fork de xchat)"
    echo "[14] Polari (client IRC pour Gnome)"
    echo -e "[15] Discord ${jaune}[Snap]${neutre} (logiciel propriétaire multiplateforme pour communiquer à plusieurs, pour les gameurs)"
    echo -e "[16] Telegram (appli de messagerie basée sur le cloud avec du chiffrage)"
    echo -e "[17] Viber ${bleu}[Flatpak]${neutre} (logiciel de communication, surtout connu en application mobile)"
    echo -e "[18] Slack ${bleu}[Flatpak]${neutre} (plate-forme de communication collaborative propriétaire avec gestion de projets)"
    echo -e "[19] Signal ${bleu}[Flatpak]${neutre} (messagerie instantanée cryptée recommandée par Edward Snowden)"
    echo -e "[20] Récupérer TeamSpeak ${cyan}[script à lancer manuellement]${neutre} (équivalent à Mumble mais propriétaire)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 3 7 13 18) : " choixMessagerie
    clear

    # Question 5 : Download/Upload
    echo "*******************************************************"
    echo -e "${bleu}5/ Quel(s) logiciel(s) de téléchargement/copie voulez-vous ?${neutre}"
    echo "*******************************************************"
    echo "[1] Pas de supplément (Transmission installé par défaut sur la version de base)"
    echo "[2] FileZilla (logiciel très répandu utilisé pour les transferts FTP ou SFTP)"
    echo "[3] Deluge (client BitTorrent basé sur Python et GTK+)"
    echo "[4] Rtorrent (client BitTorrent en ligne de commande donc très léger)"
    echo "[5] qBittorrent (client BitTorrent léger développé en C++ avec Qt)"
    echo "[6] Bittorrent (client non-libre qui s'utilise depuis le terminal via btdownloadgui)"
    echo "[7] aMule (pour le réseau eDonkey2000, clone de Emule)"
    echo "[8] FrostWire (client multiplate-forme pour le réseau Gnutella)"
    echo "[9] Gtk-Gnutella (un autre client stable et léger avec pas mal d'options)"
    echo "[10] EiskaltDC++ (stable et en français, pour le réseau DirectConnect)"
    echo "[11] Grsync (une interface graphique pour l'outil rsync)"
    echo "[12] SubDownloader (téléchargement de sous-titre)"
    echo "[13] Nicotine+ (client P2P pour le réseau mono-source Soulseek)"
    echo -e "[14] Vuze ${jaune}[Snap]${neutre} (plate-forme commerciale d'Azureus avec BitTorrent)"
    echo -e "[15] Gydl ${bleu}[Flatpak]${neutre} (permet de télécharger des vidéos Youtube ou juste la piste audio)"
    echo -e "[16] WebTorrent (permet le streamming de flux vidéo décentralisé via le protocole bittorrent)"
    echo -e "[17] WormHole (un outil en CLI permettant le transfert sécurisé à travers n'importe quel réseau)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 2 3 4 15) : " choixTelechargement
    clear

    # Question 6 : Lecture multimédia
    echo -e "${vert}Astuce 4: Il est recommandé de choisir au moins VLC ou MPV car le lecteur de base (Totem) est assez limité !${neutre}"
    echo "*******************************************************"
    echo -e "${bleu}6/ Quel(s) logiciel(s) de lecture audio/vidéo (ou de stream) voulez-vous ?${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun, rester avec les choix par défaut (Totem pour la vidéo, Rhythmbox pour la musique)"
    echo "[2] VLC VideoLan (le couteau suisse de la vidéo, très complet !)"
    echo "[3] MPV/Gnome MPV (léger et puissant, capable de lire de nombreux formats)" #(semble instable dans une VM)
    echo "[4] SmPlayer (lecteur basé sur mplayer avec une interface utilisant Qt)"
    echo -e "[5] DragonPlayer (lecteur vidéo pour l'environnement Kde)" 
    echo "[6] Banshee (lecteur audio assez complet équivalent à Rhythmbox)"
    echo "[7] Clementine (lecteur audio avec gestion des pochettes, genres musicaux...)"
    echo "[8] QuodLibet (un lecteur audio très puissant avec liste de lecture basée sur les expressions rationnelles)"
    echo "[9] Audacious (lecteur complet pour les audiophiles avec beaucoup de plugins)"
    echo "[10] Guayadeque (lecteur audio et radio avec une interface agréable)"
    echo "[11] Gnome Music (utilitaire de la fondation Gnome pour la gestion audio, assez basique)"
    echo "[12] Gmusicbrowser (lecteur avec une interface très configurable)"
    echo "[13] Musique (un lecteur épuré)"
    echo "[14] Qmmp (dans le même style de Winamp pour les fans)"
    echo "[15] Xmms2+Gxmms2 (un autre lecteur audio dans le style de Winamp)"
    echo "[16] Gnome Twitch (pour visionner les flux vidéo du site Twitch depuis votre bureau sans utiliser de navigateur)"
    echo -e "[17] Lollypop ${bleu}[Flatpak]${neutre} (lecteur de musique adapté à Gnome avec des fonctions très avancées)"
    echo -e "[18] Spotify ${jaune}[Snap]${neutre} (permet d'accéder gratuitement et légalement à de la musique en ligne)"
    echo -e "[19] MuseScore (l'éditeur de partitions de musique le plus utilisé au monde !)"
    echo -e "[20] GRadio ${bleu}[Flatpak]${neutre} (application Gnome pour écouter la radio, plus de 1 000 références rien qu'en France !)"
    echo -e "[21] Molotov.TV ${vert}[Appimage]${neutre} (service français de distribution de chaînes de TV)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 2 3) : " choixMultimedia
    clear

    # Question 7 : Traitement/montage video
    echo "*******************************************************"
    echo -e "${bleu}7/ Souhaitez-vous un logiciel de montage/encodage vidéo ?${neutre}"
    echo "*******************************************************"
    echo "[1] Non merci (aucun n'est installé par défaut)"
    echo "[2] Handbrake (transcodage de n'importe quel fichier vidéo)"
    echo "[3] WinFF (encodage vidéo rapide dans différents formats)"
    echo "[4] Libav-tools (fork de FFmpeg, outil en CLI pour la conversion via : avconv)"
    echo "[5] KDEnLive (éditeur vidéo non-linéaire pour monter sons et images avec effets spéciaux)"
    echo "[6] OpenShot Video Editor (une autre alternative comme éditeur vidéo, libre et écrit en Python)"
    echo "[7] Pitivi (logiciel de montage basique avec une interface simple et intuitive)" 
    echo "[8] Lives (dispose des fonctionnalités d'éditions vidéo/son classique, des filtres et multipiste"
    echo -e "[9] Flowblade ${violet}[Xorg only!]${neutre} (logiciel de montage vidéo multi-piste performant)"
    echo "[10] Cinelerra (montage non-linéaire sophistiqué, équivalent à Adobe première, Final Cut et Sony Vegas"
    echo "[11] Natron (programme de post-prod destiné au compositing et aux effets spéciaux)"
    echo "[12] Mencoder (s'utilise en ligne de commande : encodage de fichiers vidéos)"
    echo "[13] MMG : MkvMergeGui (interface graphique pour l'outil mkmerge : création/manipulation fichier mkv)"
    echo "[14] DeVeDe (création de DVD/CD vidéos lisibles par des lecteurs de salon)"
    echo -e "[15] Peek ${bleu}[Flatpak]${neutre} (outil de création de Gif animé à partir d'une capture vidéo)"
    echo -e "[16] Avidemux ${vert}[Appimage]${neutre}${rouge}[Ne semble pas fonctionner !]${neutre} (équivalent de 'VirtualDub' : coupe, filtre et ré-encodage)"
    echo "[17] Shotcut (éditeur de vidéos libre, open source, gratuit et multiplateforme)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 1) : " choixVideo
    clear

    # Question 8 : Traitement/montage photo & modélisation 3D
    echo "*******************************************************"
    echo -e "${bleu}8/ Quel(s) logiciel(s) de montage photo ou modélisation 3D voulez-vous ?${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun (pas de logiciel par défaut)"
    echo "[2] Gimp (montage photo avancé, équivalent à 'Adobe Photoshop')"
    echo "[3] Krita (outil d'édition et retouche d'images, orienté plutôt vers le dessin bitmap)"
    echo "[4] Pinta (graphisme simple équivalent à Paint.NET)"
    echo "[5] Pixeluvo (une autre alternative à Photoshop mais il reste propriétaire)"
    echo "[6] Phatch (pour traiter des images par lot via des scripts prédéfinis)"
    echo "[7] MyPaint (logiciel de peinture numérique développé en Python)"
    echo "[8] Ufraw (logiciel de dérawtisation capable de lire/interpréter la plupart des formats RAW)"
    echo "[9] Inkscape (logiciel spécialisé dans le dessin vectoriel, équivalent de 'Adobe Illustrator')"
    echo "[10] Darktable (gestionnaire de photos libre sous forme de table lumineuse et chambre noir)"
    echo "[11] Blender (suite libre de modélisation 3D, matériaux et textures, d'éclairage, d'animation...)"
    echo "[12] K-3D (animation et modélisation polygonale et modélisation par courbes)"
    echo "[13] SweetHome 3D (aménagement d'intérieur pour dessiner les plans d'une maison, placement des meubles...)"
    echo "[14] LibreCAD (anciennement CADubuntu, DAO 2D pour modéliser des dessins techniques)"
    echo -e "[15] Shutter ${violet}[Xorg only!]${neutre} (pour effectuer des captures d'écran + appliquer des modifications diverses)"
    echo "[16] Frogr (utile pour ceux qui utilisent le service web 'Flickr')"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 2 4) : " choixGraphisme
    clear

    # Question 9 : Traitement/encodage audio
    echo "*******************************************************"
    echo -e "${bleu}9/ Quel(s) logiciel(s) pour l'encodage/réglage ou traitement audio voulez-vous ?${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun"
    echo "[2] Xcfa : X Convert File Audio (extraction cd audio, piste dvd, normalisation, création pochette)"
    echo "[3] Sound-Juicer (pour extraire les pistes audios d'un cd)"
    echo "[4] Gnome Sound Recorder (pour enregistrer et lire du son, realisé par défaut avec OggVorbis)"
    echo "[5] Audacity (enregistrement et édition de son numérique)"
    echo "[6] MhWaveEdit (application libre d'enregistrement et d'édition audio complète distribuée sous GPL)"
    echo "[7] RipperX (une autre alternative pour extraire les cd de musique)"
    echo "[8] LMMS : Let's Make Music (station audio opensource crée par des musiciens pour les musiciens)"
    echo "[9] Mixxx (logiciel pour Dj pour le mixage de musique)"
    echo "[10] Rosegarden (création musicale avec édition des partitions et peut s'interfacer avec des instruments)"
    echo "[11] Pavucontrol (outil graphique de contrôle des volumes audio entrée/sortie pour Pulseaudio)"
    echo "[12] Lame (outil d'encodage en CLI pour le format MP3, par exemple pour convertir un Wav en Mp3)"
    echo "[13] Hydrogen (synthétiseur de boite à rythme basé sur les patterns avec connexion possible d'un séquenceur externe)"
    echo -e "[14] Ardour (station de travail audio numérique avec enregistrement multipiste et mixage)"
    echo -e "[15] Flacon ${jaune}[Snap]${neutre} (pour extraire les pistes d'un gros fichier audio)"
    echo -e "[16] PulseEffects ${bleu}[Flatpak]${neutre} (interface puissante GTK pour faire plein de réglages/effets sur le son)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 2 4) : " choixAudio
    clear

    # Question 10 : Bureautique et Mail
    echo "*******************************************************"
    echo -e "${bleu}10/ Quel(s) logiciel(s) de bureautique/courrier souhaitez-vous ?${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun supplément (par défaut : Evince pour pdf, LibreOffice en bureautique, Thunderbird pour les mails)"
    echo "[2] LibreOffice avec Supplément : ajout du module 'Base' + extensions utiles (templates, modèles de documents, clipboard...)"
    echo "[3] PdfMod (logiciel permettant diverses modifications sur vos PDF)"
    echo "[4] Suite Scenari (scenarichaine 4.2 + opale : famille d'applications d'édition avancées de chaînes éditoriales)"
    echo "[5] Freeplane (création de cartes heuristiques (Mind Map) avec des diagrammes représentant les connexions sémantiques)"
    echo -e "[6] FeedReader ${bleu}[Flatpak]${neutre} (agrégateur RSS moderne pour consulter vos fils d'informations RSS)"
    echo "[7] Geary (logiciel de messagerie, alternative à Thunderbird et bien intégré à Gnome)"
    echo "[8] Gnome Office (pack contenant Abiword, Gnumeric, Dia, Planner, Glabels, Glom, Tomboy et Gnucash)"
    echo "[9] Wordgrinder (traitement de texte léger en CLI, Formats OpenDocument, HTML import and export)"
    echo "[10] LaTex + Texworks (langage de description de document avec un éditeur spécialisé LaTex)"
    echo "[11] Gnome Evolution (logiciel de type groupware et courrielleur, facile à utiliser)"
    echo -e "[12] MailSpring ${jaune}[Snap]${neutre} (client de messagerie moderne et multi-plateforme)"
    echo -e "[13] Notes Up ${bleu}[Flatpak]${neutre} (éditeur et manager de notes avec markdown, simple mais efficace)"
    echo "[14] Zim (wiki en local avec une collection de pages et de marqueurs)"
    echo "[15] WPSOffice (suite bureautique propriétaire avec une interface proche de Microsoft Office)"
    echo "[16] SoftMaker Office béta (suite bureautique alternative propriétaire & payante mais compatible linux)"
    echo -e "[17] OnlyOffice ${jaune}[Snap]${neutre} (suite bureautique multifonctionnelle intégrée au CRM, avec jeu d'outils de collaboration)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 1) : " choixBureautique
    clear

    # Question 11 : Science et éducation (voir pour Scratch2 + Celestia ?)
    echo "*******************************************************"
    echo -e "${bleu}11/ Des logiciels de science ou pour l'éducation ?${neutre}"
    echo "*******************************************************"
    echo "[1] Pas d'ajout"
    echo "[2] [GEO] Google Earth Pro (globe terrestre de Google pour explorer la planète)"
    echo "[3] [GEO] Extension OooHg pour LibreOffice (ajoute 1600 cartes de géographie)"
    echo "[4] [SCIENCE] SciLab (logiciel scientifique pour le calcul numérique pour des applications scientifiques"
    echo "[5] [MATH] GeoGebra (géométrie dynamique pour manipuler des objets avec un ensemble de fonctions algébriques)"
    echo "[6] [MATH] Algobox (logiciel libre d'aide à l'élaboration/exécution d'algorithmes en mathématique)"
    echo "[7] [MATH] CaRMetal (logiciel libre de géométrie dynamique, conçu à partir du moteur de C.a.R)"
    echo "[8] [ASTRO] Stellarium (planétarium avec l'affichage du ciel réaliste en 3D avec simulation d'un téléscope)"
    echo "[9] [ASTRO] SkyChart (cartographie céleste très complète avec un catalogue riche)"
    echo "[10] [ASTRO] Celestia (simulation spatiale en temps réel qui permet d’explorer l'univers en trois dimensions)"
    echo "[11] [CHIMIE] Avogadro (éditeur/visualiseur avancé de molécules pour le calcul scientifique en chimie)"
    echo "[12] [TECHNO] Scratch 1.4 (langage de programmation visuel libre, créé par le MIT, à vocation éducative et ludique)"
    echo -e "[13] [TECHNO] Scratch 2 ${rouge}[Interv!]${neutre} (dernière version stable de Scratch)"
    echo -e "[14] [TECHNO] mBlock ${rouge}[Semble poser problème!]${neutre}(environnement de programmation basé sur Scratch 2 pour Arduino"
    echo -e "[15] [TECHNO] Algoid ${cyan}[Fichier Jar à lancer manuellement]${neutre} (langage de programmation éducatif)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 1) : " choixScience
    clear

    # Question 12 : Utilitaires 
    echo "*******************************************************"
    echo -e "${bleu}12/ Quel(s) utilitaire(s) supplémentaire(s) voulez-vous ?${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun"
    echo -e "[2] Kazam ${violet}[Xorg Only!]${neutre} (capture vidéo de votre bureau)"
    echo "[3] SimpleScreenRecorder (autre alternative pour la capture vidéo)"
    echo "[4] OBS : OpenBroadcasterSoftware (pour faire du live en streaming, adapté pour les gamers)"
    echo "[5] Glances (afficher l'état des ressources systèmes en temps réel, comme htop mais plus complet)"
    echo "[6] Brasero (logiciel de gravure de cd/dvd)" 
    echo "[7] Wine (une sorte d'émulateur pour faire tourner des applis/jeux conçus à la base pour Windows)"
    echo "[8] Oracle Java 8 (plate-forme propriétaire pour le développement/éxécution de logiciels écrit en Java)"
    echo "[9] Oracle Java 9 (nouvelle version de Java)"
    echo "[10] OpenJDK v9 (JRE) (implémentation libre de Java, à noter que la V8 est installée par défaut)"
    echo "[11] OpenJDK v10 (JRE) (implémentation libre de la prochaine version de Java)"
    echo "[12] Installer FlashPlayer (via le dépot partenaire)"
    echo "[13] VirtualBox (virtualisation de système Windows/Mac/Linux/Bsd)"
    echo "[14] KeePassX2 (centralise la gestion de vos mots de passe personnels, protégé par un master password)"
    echo -e "[15] TeamViewer ${violet}[Coté serveur en Xorg only]${neutre} (logiciel propriétaire de télémaintenance avec contrôle de bureau à distance)"
    echo "[16] Cheese (outil pour prendre des photos/vidéos à partir d'une webcam)"
    echo "[17] Gnome Recipes (pour les gourmets : appli Gnome spécialisée dans les recettes de cuisine)"
    echo -e "[18] Gufw ${violet}[Xorg only!]${neutre} (interface graphique pour le pare-feu installé par défaut dans Ubuntu 'Ufw')"
    echo "[19] Pack d'appli en cyber-sécurité (aircrack-ng + John The Ripper[snap] + Nmap)"
    echo "[20] Gnome Enfs Manager (coffre-fort pour vos fichiers/dossiers)"
    echo -e "[21] Bleachbit ${rougesouligne}[potentiellement dangereux !]${neutre} (efface les fichiers inutiles/temporaires du système)"
    echo -e "[22] VMWare Workstation Player ${rouge}[Interv!]${neutre}${violet}[Install depuis Xorg!]${neutre} (version gratuite mais propriétaire de VmWare)"
    echo -e "[23] CoreBird (un client de bureau pour le réseau social Twitter)"
    echo "[24] Wireshark (analyseur de paquets utilisé dans le dépannage et l'analyse de réseaux )"
    echo "[25] Pack d'outils utiles : vrms + screenfetch + asciinema + ncdu + screen + kclean + rclone"
    echo -e "[26] Synaptic ${violet}[Xorg only!]${neutre} (gestionnaire graphique pour les paquets deb)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 1) : " choixUtilitaire
    clear

    # Question 13 : Gaming
    echo "*******************************************************"
    echo -e "${bleu}13/ Quel(s) jeux-vidéo(s) (ou applis liées aux jeux) voulez-vous installer ?${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun, je ne suis pas un gamer"
    echo "[2] Steam (plateforme de distribution de jeux. Permet notamment d'installer Dota2, TF2, CS, TR...)"
    echo "[3] PlayOnLinux (permet de faire tourner des jeux Windows via Wine avec des réglages pré-établis)"
    echo "[4] Minecraft (un des plus célèbres jeux sandbox, jeu propriétaire et payant)"
    echo "[5] Minetest (un clone de Minecraft mais libre/opensource et totalement gratuit)"
    echo "[6] OpenArena (un clone libre du célèbre jeu 'Quake')"
    echo "[7] 0ad: Empires Ascendant (jeu de stratégie en temps réel (RTS))"
    echo "[8] FlightGear (simulateur de vol)"
    echo "[9] SuperTux (clone de Super Mario mais avec un pingouin)"
    echo "[10] SuperTuxKart (clone de Super Mario Kart)"
    echo "[11] Assault Cube (clone de Counter Strike)"
    echo "[12] Gnome Games (pack d'une dizaine de mini-jeux pour Gnome)"
    echo "[13] Megaglest (RTS 3d dans un monde fantastique avec 2 factions qui s'affrontent : la magie et la technologie)"
    echo "[14] Pingus (clone de Lemmings, vous devrez aider des manchots un peu idiots à traverser des obstacles)"
    echo -e "[15] Battle for Wesnoth (stratégie, le joueur doit se battre pour retrouver sa place dans le royaume)"
    echo -e "[16] Albion Online ${bleu}[Flatpak]${neutre} (MMORPG avec système de quête et donjons)"
    echo -e "[17] RuneScape ${bleu}[Flatpak]${neutre} (reconnu MMORPG gratuit le plus populaire au monde avec plus de 15 millions de comptes F2P)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 2 3) : " choixGaming
    clear
fi

## Mode avancé (seulement pour mode avancé et extra)
if [ "$choixMode" = "2" ] || [ "$choixMode" = "3" ]
then
    if [ "$(which gnome-shell)" = "/usr/bin/gnome-shell" ]
    then
        # Question 14 : Extension 
        echo -e "${vert}Astuce 5: Si vous aimez faire de la customisation graphique, il est recommandé d'installer 'user themes' (choix2)${neutre}"
        echo "*******************************************************"
        echo -e "${jaune}14/ Des extensions pour gnome-shell à installer ? [mode avancé]${neutre}"
        echo "*******************************************************"
        echo "[1] Non, ne pas ajouter de nouvelles extensions"
        echo "[2] User themes (pour charger des thèmes pour Gnome Shell à partir de votre répertoire perso)"
        echo "[3] AlternateTab (alternative au Alt+Tab issu du mode classique)"
        echo "[4] Caffeine (permet en 1 clic de désactiver temporairement les mises en veilles)"
        echo "[5] DashToDock (permet plus d'options pour les réglages du dock, celui d'Ubuntu étant basé dessus)"
        echo "[6] DashToPanel (un dock alternatif conçu pour remplacer le panel de Gnome, se place en bas ou en haut)"
        echo "[7] Clipboard Indicator (permet de conserver du contenu copié/collé facilement accessible depuis le panel)"
        echo "[8] Impatience (permet d'augmenter la vitesse d'affichage des animations de Gnome Shell)"
        echo "[9] Log Out Button (ajouter un bouton de déconnexion pour gagner 1 clic en moins pour cette action)"
        echo "[10] Media Player Indicator (ajouter un indicateur pour le contrôle du lecteur multimédia)"
        echo "[11] Multi monitors add on (ajoute au panel un icone pour gérer rapidement les écrans)"
        echo "[12] Openweather (pour avoir la météo directement sur votre bureau)"
        echo "[13] Places status indicator (permet d'ajouter un raccourci vers les dossiers utiles dans le panel)"
        echo "[14] Removable drive menu (raccourci pour démonter rapidement les clés usb/support externe)"
        echo "[15] Shortcuts (permet d'afficher un popup avec la liste des raccourcis possibles)"
        echo "[16] Suspend button (ajout d'un bouton pour activer l'hibernation)"
        echo "[17] Taskbar (permet d'ajouter des raccourcis d'applis directement sur le panel en haut)"
        echo "[18] Trash (ajoute un raccourci vers la corbeille dans le panel en haut)"
        echo "[19] Window list (affiche la liste des fenêtres en bas du bureau, comme à l'époque sous Gnome 2)"
        echo "[20] Workspace indicator (affiche dans le panel en haut dans quel espace de travail vous êtes)"
        echo "[21] System-monitor (moniteur de ressources visible directement depuis le bureau)"
        echo "[22] Top Icons Plus (permet d'afficher un icone de notification pour les applis en haut à droite)"
        echo "[23] Unite (retire la décoration des fenêtres pour gagner de l'espace, pour un style proche du shell Unity)"
        echo "[24] AppFolders Management (permet de classer les applis dans des dossiers)"
        echo "*******************************************************"
        read -p "Répondre par le ou les chiffres correspondants (exemple : 2) : " choixExtension
        clear
    fi

    # Question 15 : Customization
    echo -e "${vert}Astuce 6: Si vous voulez transformer l'apparence du bureau, il faudra modifier vous-même l'agencement du bureau en plus d'appliquer les thèmes/icones${neutre}"
    echo "*******************************************************"
    echo -e "${jaune}15/ Sélectionnez ce qui vous intéresse en terme de customisation [mode avancé]${neutre}"
    echo "*******************************************************"
    echo "[1] Pas d'ajout"
    echo "[2] Thème GTK : Arc + Numix"
    echo "[3] Pack2 avec encore d'autres thèmes : Adapta + Greybird/Blackbird/Bluebird"
    echo "[4] Pack3 de thèmes : albatross, Yuyo, human, gilouche"
    echo "[5] Pack d'icones 1 : Numix et Numix Circle, Breathe, Breeze, Elementary, Brave + supplément extra icone Gnome"
    echo "[6] Pack d'icones 2 : Dust, Humility, Garton, Gperfection2, Nuovo"
    echo "[7] Pack d'icones 3 : Human, Moblin, Oxygen, Suede, Yasis"
    echo "[8] Pack de curseurs : Breeze + Moblin + Oxygen/Oxygen-extra"
    echo "[9] Mac OS X High Sierra - vLight+Dark (thème + icone + wallpaper)"
    echo "[10] Windows 10 Thème (thème + icone)"
    echo "[11] Unity8 Thème"
    echo "[12] Icones Papirus utilisées notamment dans Solus (différentes variantes : Adapta, Nokto, Dark, Light...)"    
    echo -e "[13] Spécifique Gnome-Shell : Remettre GDM avec thème gris ${rouge}=> Attention : ajoute la session Vanilla en dépendance !${neutre}"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 2 5) : " choixCustom
    clear

    # Question 16 : Prog
    echo "*******************************************************"
    echo -e "${jaune}16/ Quel(s) éditeur(s) de texte et logiciel(s) de développement voulez-vous ? [mode avancé]${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun (en dehors de Vim et Gedit)"
    echo "[2] Gvim (interface graphique pour Vim)"
    echo "[3] Emacs (le couteau suisse des éditeurs de texte, il fait tout mais il est complexe)"
    echo "[4] Geany (IDE rapide et simple utilisant GTK2 supportant de nombreux langages)"
    echo "[5] Sublime Text (logiciel développé en C++ et Python prenant en charge 44 langages de programmation)"
    echo "[6] Code:Blocks (IDE spécialisé pour les langages C/C++)"
    echo "[7] JEdit (éditeur libre, multiplateforme et très personnalisable)"
    echo "[8] Anjuta (IDE simple pour C/C++, Java, JavaScript, Python et Vala)"
    echo "[9] Android Studio (IDE de Google spécialisé pour le développement d'application Android)"
    echo "[10] Netbeans (IDE supportant plusieurs langages, surtout Java, avec de nombreux plugins)"
    echo "[11] BlueFish (éditeur orienté développement web : HTML/PHP/CSS/...)"
    echo "[12] BlueGriffon (éditeur HTML/CSS avec aperçu du rendu en temps réel)"
    echo "[13] SciTE : Scintilla Text Editor (éditeur web avec une bonne coloration syntaxique)"
    echo -e "[14] Eclipse ${rouge}[Interv!]${neutre}${violet}[Install sous Xorg uniquement!]${neutre}(Projet décliné en sous-projets de dev)"
    echo -e "[15] PyCharm ${jaune}[Snap]${neutre} (IDE pour le langage Python, à lancer depuis le terminal la 1ère fois)"
    echo -e "[16] Visual Studio Code ${jaune}[Snap]${neutre} (développé par Microsoft, sous licence libre MIT)"
    echo -e "[17] Atom ${jaune}[Snap]${neutre} (éditeur sous licence libre qui supporte les plug-ins Node.js et implémente GitControl)"
    echo -e "[18] Brackets ${jaune}[Snap]${neutre} (éditeur opensource d'Adobe pour le web design et dev web HTML, CSS, JavaScript...)"
    echo -e "[19] IntelliJ Idea ${jaune}[Snap]${neutre} (IDE Java commercial de JetBrains, plutôt conçu pour Java)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 4 5) : " choixDev
    clear

    # Question 17 : Serveur 
    echo "*******************************************************"
    echo -e "${jaune}17/ Des fonctions serveurs à activer ? [mode avancé]${neutre}"
    echo "*******************************************************"
    echo "[1] Pas de service à activer"
    echo "[2] Serveur SSH (pour contrôler votre PC à distance via SSH)"
    echo "[3] Serveur LAMP (pour faire un serveur web avec votre PC : Apache + MariaDB + PHP)"
    echo "[4] Serveur FTP avec ProFTPd (stockage de fichier sur votre machine via FTP)"
    echo "[5] Serveur BDD PostgreSQL (pour installer une base de donnée PostgreSQL)"
    echo "[6] PHP5.6 (rétroportage de l'ancienne version)"
    echo "[7] PHP7.2 (dernière version stable de PHP)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 1) : " choixServeur
    clear

    # Question 18 : Optimisation
    echo "*******************************************************"
    echo -e "${jaune}18/ Des optimisations supplémentaires à activer ? [mode avancé]${neutre}"
    echo "*******************************************************"
    echo "[1] Non"
    echo "[2] Optimisation Swap : swapiness à 5% (swap utilisé uniquement si plus de 95% de ram utilisée)"
    echo "[3] Désactiver complètement le swap (utile si vous avez un SSD et 8 Go de ram ou plus)"
    echo "[4] Activer TLP avec Powertop (économie d'énergie pour pc portable)"
    echo "[5] Installer le microcode propriétaire Intel (pour cpu intel uniquement !)"
    echo "[6] Gnome Shell : Ajouter une commande 'fraude' pour la session Wayland (ex : fraude synaptic)"
    echo "[7] Gnome Shell : Désactiver l'userlist de GDM (utile en entreprise intégrée à un domaine)"
    echo "[8] Ajouter le support pour le système de fichier exFat de Microsoft"
    echo "[9] Ajouter le support pour le système de fichier HFS d'Apple"
    echo "[10] Ajout d'une nouvelle commande 'maj' qui met tout à jour d'un coup (maj apt + purge + maj snap + maj flatpak)"
    echo "[11] Optimisation Grub : réduire le temps d'attente (si multiboot) de 10 à 2 secondes + retirer le test de RAM dans grub"
    echo -e "[12] Lecture DVD commerciaux protégés par CSS (Content Scrambling System) ${rouge}[Interv!]${neutre}"
    echo "[13] Support imprimantes HP (hplip + sane + hplip-gui)"
    echo -e "[14] Gnome Shell/DtD : Activer la minimisation de fenêtre ${cyan}(DashToDock doit être installé !)${neutre}"
    echo "[15] Augmenter la sécurité de votre compte : empêcher l'accès à votre dossier perso aux autres utilisateurs"
    echo "[16] Installation de switcheroo-control : permet d'utiliser la carte dédié avec le pilote opensource" 
    echo "[17] Retirer les paquets snappy pré-installés et réinstaller les paquets concernés par apt"
    #echo "[99][Ne fonctionne pas] Installer + Configurer Bumblebee (pilote Nvidia proprio) pour technologie Optimus nvidia/intel"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 2 3 7) : " choixOptimisation
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
    echo -e "[2] VLC ${jaune}[Snap]${neutre}"
    echo -e "[3] LibreOffice ${jaune}[Snap]${neutre}"
    echo -e "[4] Dino ${jaune}[Snap]${neutre}"
    echo -e "[5] Gimp ${jaune}[Snap]${neutre}"
    echo -e "[6] Instagraph ${jaune}[Snap]${neutre}"
    echo -e "[7] KeepassXC ${jaune}[Snap]${neutre}"
    echo -e "[8] Ktube media downloader ${jaune}[Snap]${neutre}${rouge}[ne semble pas fonctionner !]${neutre}"
    echo -e "[9] Warzone 2100 ${jaune}[Snap]${neutre}"
    echo -e "[10] Asciinema ${orange}[isolation --classic]${neutre} ${jaune}[Snap]${neutre}"
    echo -e "[11] Bitcoin ${jaune}[Snap]${neutre}"
    echo -e "[12] Blender ${orange}[isolation --classic]${neutre} ${jaune}[Snap]${neutre}"
    echo -e "[13] Electrum ${jaune}[Snap]${neutre}"
    echo -e "[14] NextCloud client ${jaune}[Snap]${neutre}"
    echo -e "[15] PyCharm édition Professionnelle ${violet}[Xorg only!]${neutre}${orange}[isolation --classic]${neutre} ${jaune}[Snap]${neutre}"
    echo -e "[16] Quassel client ${jaune}[Snap]${neutre}"
    echo -e "[17] Rube cube ${jaune}[Snap]${neutre}"
    echo -e "[18] TermiusApp ${jaune}[Snap]${neutre}"
    echo -e "[19] TicTacToe ${jaune}[Snap]${neutre}"
    echo "*******************************************************"
    read -p "Choix snappy : " choixSnap
    clear
             
    # Question 20 : Flatpak
    echo "*******************************************************"
    echo -e "${vert}20/ Mode Extra : supplément paquet Flatpak :${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun"
    echo -e "[2] 0ad ${bleu}[Flatpak]${neutre}"
    echo -e "[3] Audacity ${bleu}[Flatpak]${neutre}"
    echo -e "[4] Battle Tanks ${bleu}[Flatpak]${neutre}"
    echo -e "[5] Blender ${bleu}[Flatpak]${neutre}"
    echo -e "[6] Dolphin Emulator ${bleu}[Flatpak]${neutre}"
    echo -e "[7] Extreme Tuxracer ${bleu}[Flatpak]${neutre}"
    echo -e "[8] Frozen Bubble ${bleu}[Flatpak]${neutre}"
    echo -e "[9] Gnome MPV ${bleu}[Flatpak]${neutre}"
    echo -e "[10] Gimp ${bleu}[Flatpak]${neutre}"
    echo -e "[11] Google Play Music Desktop Player ${bleu}[Flatpak]${neutre}"
    echo -e "[12] Homebank ${bleu}[Flatpak]${neutre}"
    echo -e "[13] LibreOffice ${bleu}[Flatpak]${neutre}"
    echo -e "[14] Minetest ${bleu}[Flatpak]${neutre}"
    echo -e "[15] Nextcloud cli ${bleu}[Flatpak]${neutre}"
    echo -e "[16] Othman Quran Browser ${bleu}[Flatpak]${neutre}"
    echo -e "[17] Password Calculator ${bleu}[Flatpak]${neutre}"
    echo -e "[18] PPSSPP ${bleu}[Flatpak]${neutre}"
    echo -e "[19] Riot ${bleu}[Flatpak]${neutre}"
    echo -e "[20] Teeworlds ${bleu}[Flatpak]${neutre}"
    echo -e "[21] VLC ${bleu}[Flatpak]${neutre}"
    echo "*******************************************************"
    read -p "Choix flatpak : " choixFlatpak
    clear
            
    # Question 21 : Appimages
    echo -e "${vert}Astuce 8: Vos AppImages seront disponibles dans un dossier 'appimage' dans votre dossier perso, pour lancer une application : ./nomdulogiciel.AppImage (les droits d'éxécutions seront déjà attribués)${neutre}"
    echo "*******************************************************"
    echo -e "${vert}21/ Mode Extra : récupération Appimages:${neutre}"
    echo "*******************************************************"
    echo "[1] Aucune"
    echo -e "[2] Digikam ${vert}[Appimage]${neutre}"
    echo -e "[3] Freecad ${vert}[Appimage]${neutre}"
    echo -e "[4] Aidos Wallet ${vert}[Appimage]${neutre}"
    echo -e "[5] Cerebro ${vert}[Appimage]${neutre}"
    echo -e "[6] Chronos ${vert}[Appimage]${neutre}"
    echo -e "[7] Crypter ${vert}[Appimage]${neutre}"
    echo -e "[8] Jaxx ${vert}[Appimage]${neutre}"
    echo -e "[9] Imagine ${vert}[Appimage]${neutre}"
    echo -e "[10] Infinite Electron ${vert}[Appimage]${neutre}"
    echo -e "[11] Kdenlive ${vert}[Appimage]${neutre}"
    echo -e "[12] KDevelop ${vert}[Appimage]${neutre}"
    echo -e "[13] MellowPlayer ${vert}[Appimage]${neutre}"
    echo -e "[14] Nextcloud Cli ${vert}[Appimage]${neutre}"
    echo -e "[15] Openshot ${vert}[Appimage]${neutre}"
    echo -e "[16] Owncloud Cli ${vert}[Appimage]${neutre}"
    echo -e "[17] Popcorntime ${vert}[Appimage]${neutre}"
    echo -e "[18] Skype for Business ${vert}[Appimage]${neutre}"
    echo -e "[19] Spotify web client ${vert}[Appimage]${neutre}"
    echo -e "[20] Tulip ${vert}[Appimage]${neutre}"
    echo -e "[21] Wire ${vert}[Appimage]${neutre}"
    echo "*******************************************************"
    read -p "Choix appimage : " choixAppimage
    clear
fi
                  
### Section installation automatisé

###################################################
# Communs à tous quelque soit la variante

# Pour automatiser l'instalaliton de certains logiciels qui pose des questions :
export DEBIAN_FRONTEND="noninteractive"

# Activation du dépot partenaire 
sed -i "/^# deb .*partner/ s/^# //" /etc/apt/sources.list

#Maj du système + nettoyage
apt update ; apt full-upgrade -y ; apt autoremove --purge -y ; apt clean

#Paquet Snappy & Flatpak (snapd est déjà installé sur Ubuntu mais pas forcément sur les dérivés)
apt install snapd flatpak gnome-software-plugin-flatpak -y

#Police d'écriture Microsoft
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | /usr/bin/debconf-set-selections | apt install ttf-mscorefonts-installer -y

# Autres outils utiles
apt install inxi curl net-tools git gdebi vim htop gparted openjdk-8-jre hardinfo ppa-purge numlockx unace unrar debconf-utils -y

# Codecs utiles
apt install  x264 x265 -y

#optimisation
apt install ffmpegthumbnailer -y #permet de charger les minatures vidéos plus rapidement dans nautilus

# Désactivation de l'affichage des messages d'erreurs à l'écran
sed -i 's/^enabled=1$/enabled=0/' /etc/default/apport

###################################################
# Pour version de base sous Gnome Shell
if [ "$(which gnome-shell)" = "/usr/bin/gnome-shell" ]
then
    # logiciels utiles pour Gnome
    apt install dconf-editor gnome-tweak-tool folder-color gedit-plugins nautilus-image-converter gnome-themes-standard gnome-weather gnome-packagekit -y
    # Suppression de l'icone Amazon (présent uniquement sur la version de base)
    apt remove ubuntu-web-launchers -y
    # Autres logiciels utiles
    apt install ubuntu-restricted-addons ubuntu-restricted-extras -y
    # Création répertoire extension pour l'ajout d'extension supplémentaire pour l'utilisateur principal
    su $SUDO_USER -c "mkdir ~/.local/share/gnome-shell/extensions ; mkdir ~/.themes ; mkdir ~/.icons"
    # Augmenter le temps maximum pour la capture vidéo à 20 minutes (1200s) (par défaut c'était 30s)
    gsettings set org.gnome.settings-daemon.plugins.media-keys max-screencast-length 1200
fi
###################################################
# Spécifique Xubuntu/Xfce 18.04
if [ "$distrib" = "1" ]
then
    apt install xfce4 gtk3-engines-xfce xfce4-goodies xfwm4-themes xubuntu-restricted-addons xubuntu-restricted-extras -y 
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
    apt install lubuntu-restricted-addons lubuntu-restricted-extras -y
fi
###################################################
# Spécifique Kubuntu/Kde 18.04
if [ "$distrib" = "4" ]
then
    apt insstall kubuntu-restricted-addons kubuntu-restricted-extras -y
fi
###################################################
# Logiciels automatiques pour mode novice :
if [ "$choixMode" = "0" ]
then
    #internet
    apt install chromium-browser pidgin -y
    #multimédia
    apt install vlc gnome-mpv pitivi gimp pinta -y
    #divers
    apt install brasero adobe-flashplugin gnome-todo -y
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
done

# Q3/ Installation des navigateurs demandées
for navigateur in $choixNavigateur
do
    case $navigateur in
        "2") #firefox béta 
            add-apt-repository ppa:mozillateam/firefox-next -y 
            apt update ; apt upgrade -y
            ;;
        "3") #firefox esr
            add-apt-repository ppa:mozillateam/ppa -y 
            apt update ; apt install firefox-esr firefox-esr-locale-fr -y
            ;;
        "4") #firefox developper edition 
            flatpak install --from https://firefox-flatpak.mojefedora.cz/org.mozilla.FirefoxDevEdition.flatpakref -y
            ;;
        "5") #firefox nightly
            flatpak install --from https://firefox-flatpak.mojefedora.cz/org.mozilla.FirefoxNightly.flatpakref -y
            ;;
        "6") #chromium
            apt install chromium-browser -y    
            ;;
        "7") #chrome
            wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
            sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
            apt update ; apt install google-chrome-stable -y
            ;;
        "8") #vivaldi x64
            apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 2CC26F777B8B44A1
            echo "deb http://repo.vivaldi.com/stable/deb/ stable main" >> /etc/apt/sources.list.d/vivaldi.list
            apt update ; apt install vivaldi-stable -y
            ;;
        "9") #opera 
            wget -q http://deb.opera.com/archive.key -O- | apt-key add -
            apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 517590D9A8492E35
            echo "deb https://deb.opera.com/opera/ stable non-free" | tee -a /etc/apt/sources.list.d/opera-stable.list
            echo "opera-stable opera-stable/add-deb-source boolean true\n" | debconf-set-selections
            apt update ; apt install opera-stable -y
            ;;
        "10") #Palemoon
            wget http://nux87.free.fr/script-postinstall-ubuntu/deb/palemoon27.6.2-amd64.deb
            dpkg -i palemoon27.6.2-amd64.deb ; apt install -fy ; rm palemoon27.6.2-amd64.deb
            ;; 
        "11") #Waterfox
            echo "deb https://dl.bintray.com/hawkeye116477/waterfox-deb release main" >> /etc/apt/sources.list.d/waterfox.list
            curl https://bintray.com/user/downloadSubjectPublicKey?username=hawkeye116477 | apt-key add - 
            apt update
            apt install waterfox waterfox-locale-fr -y
            ;;                       
        "12") #Tor browser
            apt install torbrowser-launcher -y
            ;;
        "13") #epiphany
            apt install epiphany-browser -y
            ;;
        "14") #midori
            wget http://midori-browser.org/downloads/midori_0.5.11-0_amd64_.deb
            dpkg -i midori_0.5.11-0_amd64_.deb
            apt install -fy
            ;;
        "15") #Falkon/Qupzilla
            apt install qupzilla -y
            ;;
        "16") #Min
            wget https://github.com/minbrowser/min/releases/download/v1.6.3/Min_1.6.3_amd64.deb
            dpkg -i Min_1.6.3_amd64.deb
            apt install -fy
            ;;
        "17") #Netsurf
            apt install netsurf-gtk -y
            ;;
        "18") #Dillo
            apt install dillo -y
            ;;
        "19") #Lynx
            apt install lynx -y
            ;;
        "20") #Rekonq
            apt install rekonq -y
            ;;
        "21") #Eolie via Flatpak
            flatpak install --from https://flathub.org/repo/appstream/org.gnome.Eolie.flatpakref -y
            ;;
    esac
done

# Q4/ Tchat/Messagerie instantannée/Télephonie
for messagerie in $choixMessagerie
do
    case $messagerie in
        "2") #empathy
            apt install empathy -y
            ;;
        "3") #pidgin
            apt install pidgin pidgin-plugin-pack -y
            ;;
        "4") #jitsi
            wget -qO - https://download.jitsi.org/jitsi-key.gpg.key | apt-key add -   
            sh -c "echo 'deb https://download.jitsi.org stable/' > /etc/apt/sources.list.d/jitsi-stable.list"   
            apt update ; apt install jitsi -y   
            ;;
        "5") #psi
            apt install psi -y
            ;;         
        "6") #gajim
            apt install gajim -y
            ;;
        "7") #skype
            wget https://repo.skype.com/latest/skypeforlinux-64.deb
            dpkg -i skypeforlinux-64.deb
            apt install -fy
            ;;            
        "8") #ekiga
            apt install ekiga -y
            ;;           
        "9") #linphone
            apt install linphone -y
            ;;           
        "10") #ring
            apt install ring -y
            ;;        
        "11") #mumble
            apt install mumble -y
            ;;    
        "12") #wire
            apt-key adv --fetch-keys http://wire-app.wire.com/linux/releases.key
            echo "deb https://wire-app.wire.com/linux/debian stable main" | tee /etc/apt/sources.list.d/wire-desktop.list
            apt update ; apt install apt-transport-https wire-desktop -y
            ;;               
        "13") #hexchat
            apt install hexchat hexchat-plugins -y
            ;;       
        "14") #Polari
            apt install polari -y
            ;;                       
        "15") #discord (via snap)
            snap install discord
            ;;
        "16") #telegram 
            apt install telegram-desktop -y
            ;;                 
        "17") #viber
            flatpak install --from https://flathub.org/repo/appstream/com.viber.Viber.flatpakref -y
            ;;               
        "18") #Slack (flatpak)
            flatpak install --from https://flathub.org/repo/appstream/com.slack.Slack.flatpakref -y
            ;;          

        "19") #signal (flatpak)
            flatpak install --from https://vrutkovs.github.io/flatpak-signal/signal.flatpakref -y
            ;;           
        "20") #Récupération du script d'installation de teamspeak (à lancer manuellement par l'utilisateur)
            wget http://dl.4players.de/ts/releases/3.1.6/TeamSpeak3-Client-linux_amd64-3.1.6.run ; chmod +x TeamSpeak* ; chown $SUDO_USER TeamSpeak*
            mv TeamSpeak* /home/$SUDO_USER/
            ;; 
    esac
done

# Q5/ Download/Copie
for download in $choixTelechargement
do
    case $download in
        "2") #filezilla
            apt install filezilla -y
            ;;
        "3") #Deluge
            apt install deluge -y
            ;;
        "4") #Rtorrent
            apt install rtorrent screen -y
            ;;
        "5") #qBittorrent
            apt install qbittorrent -y
            ;;         
        "6") #Bittorrent
            apt install bittorrent bittorrent-gui -y
            ;;                 
        "7") #aMule
            apt install amule -y
            ;;           
        "8") #FrostWire
            wget https://netcologne.dl.sourceforge.net/project/frostwire/FrostWire%206.x/6.5.9-build-246/frostwire-6.5.9.all.deb
            dpkg -i frostwire-6.5.9.all.deb
            apt install -fy
            ;;        
        "9") #Gtk-Gnutella
            apt install gtk-gnutella -y
            ;;    
        "10") #EiskaltDC++
            apt install eiskaltdcpp eiskaltdcpp-gtk3 -y
            ;;                                          
        "11") #Grsync
            apt install grsync -y
            ;;               
        "12") #SubDownloader
            apt install subdownloader -y
            ;;              
        "13") #Nicotine+ 
            apt install nicotine -y
            ;;  
        "14") #Vuze
            snap install vuze-vs --classic
            ;;  
        "15") #Gydl
            flatpak install --from https://flathub.org/repo/appstream/com.github.JannikHv.Gydl.flatpakref -y
            ;;  
        "16") #Webtorrent
            wget https://github.com/webtorrent/webtorrent-desktop/releases/download/v0.18.0/webtorrent-desktop_0.18.0-1_amd64.deb
            dpkg -i webtorrent-desktop_0.18.0-1_amd64.deb ; apt install -fy ; rm webtorrent-desktop_0.18.0-1_amd64.deb
            ;;
        "17") #WormHole
            apt install wormhole -y
            ;;            
    esac
done

# Q6/ Lecture multimédia
for multimedia in $choixMultimedia
do
    case $multimedia in
        "2") #VLC
            apt install vlc vlc-plugin-vlsub vlc-plugin-visualization -y
            ;;
        "3") #Gnome MPV
            apt install gnome-mpv -y
            ;;
        "4") #SmPlayer
            apt install smplayer smplayer-l10n smplayer-themes -y
            ;;       
        "5") #dragonplayer
            apt install dragonplayer -y
            ;;
        "6") #Banshee
            apt install banshee -y
            ;;            
        "7") #Clementine
            apt install clementine -y
            ;;           
        "8") #QuodLibet
            apt install quodlibet -y
            ;;           
        "9") #audacious
            apt install audacious audacious-plugins -y
            ;;        
        "10") #Guayadeque #(dépot pour Artful utilisé car Bionic pas encore activé mais fonctionnement validé)
            echo "deb http://ppa.launchpad.net/anonbeat/guayadeque/ubuntu artful main" >> /etc/apt/sources.list.d/anonbeat-ubuntu-guayadeque-bionic.list
            apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 95FABEFB4499973B
            apt update
            apt install guayadeque -y
            ;;    
        "11") #gnome music
            apt install gnome-music -y
            ;;       
        "12") #gmusicbrowser
            apt install gmusicbrowser -y
            ;;                         
        "13") #musique
            apt install musique -y
            ;;               
        "14") #qmmp
            apt install qmmp -y
            ;;               
        "15") #xmms2 + plugins
            apt install xmms2 xmms2-plugin-all gxmms2 -y
            ;;              
        "16") #Gnome Twitch
            apt install gnome-twitch -y
            ;;         
        "17") #Lollypop 
            flatpak install --from https://flathub.org/repo/appstream/org.gnome.Lollypop.flatpakref -y
            ;;             
        "18") #Spotify (snap)
            snap install spotify
            ;;     
        "19") #MuseScore 
            apt install musescore -y
            ;;    
        "20") #Gradio (flatpak) // Paquet snappy existant mais semble poser problème
            flatpak install --from https://flathub.org/repo/appstream/de.haeckerfelix.gradio.flatpakref -y
            ;;  
        "21") #Molotov.tv (appimage)
            wget https://desktop-auto-upgrade.s3.amazonaws.com/linux/1.8.0/molotov
            mv molotov molotov.AppImage && chmod +x molotov.AppImage
            ;; 
        "22") #gxine
            apt install gxine  -y
            ;;  
    esac
done

# Q7/ Montage vidéo
for video in $choixVideo
do
    case $video in
        "2") #Handbrake
            apt install handbrake -y
            ;;
        "3") #WinFF
            apt install winff winff-doc winff-qt -y
            ;;
        "4") #Libav-tools
            apt install libav-tools -y
            ;;
        "5") #KDEnLive
            apt install kdenlive breeze-icon-theme -y
            ;;
        "6") #OpenShot Video Editor 
            apt install openshot-qt -y
            ;;
        "7") #Pitivi
            apt install pitivi -y
            ;;
        "8") #Lives
            apt install lives -y
            ;;            
        "9") #Flowblade
            apt install flowblade -y
            ;;           
        "10") #Cinelerra
            add-apt-repository ppa:cinelerra-ppa/ppa -y
            apt update ; apt install cinelerra-cv -y
            ;;        
        "11") #Natron
            wget http://nux87.free.fr/script-postinstall-ubuntu/deb/natron_2.3.3_amd64.deb
            dpkg -i natron_2.3.3_amd64.deb
            apt install -fy
            ;;                                   
        "12") #Mencoder
            apt install mencoder -y
            ;;               
        "13") #MMG MkvMergeGui
            apt install mkvtoolnix mkvtoolnix-gui -y
            ;;              
        "14") #DeVeDe 
            apt install devede -y
            ;;     
        "15") #Peek (via Flatpak) // paquet snappy existant mais semble poser problème
            flatpak install --from https://flathub.org/repo/appstream/com.uploadedlobster.peek.flatpakref -y
            ;;  
        "16") #Avidemux (AppImage)
            wget http://nux87.free.fr/script-postinstall-ubuntu/appimage/avidemux2.7.0.AppImage
            chmod +x avidemux2.7.0.AppImage
            ;;    
        "17") #Shotcut (PPA pour Bionic pas encore actif) // existe en snappy mais ne semble pas fonctionner
            add-apt-repository "deb http://ppa.launchpad.net/haraldhv/shotcut/ubuntu zesty main" -y
            apt-key adv --recv-keys --keyserver keyserver.ubuntu.com D03D19F673FED66EBD64099959A9D327745898E3
            apt update ; apt install shotcut -y
            ;;              
    esac
done

# Q8/ Montage photo/graphisme/3d
for graphisme in $choixGraphisme
do
    case $graphisme in
        "2") #Gimp
            apt install gimp gimp-help-fr gimp-plugin-registry gimp-ufraw gimp-data-extras -y
            ;;
        "3") #Krita
            apt install krita krita-l10n -y
            ;;
        "4") #Pinta
            apt install pinta -y
            ;;
        "5") #Pixeluvo
            wget http://www.pixeluvo.com/downloads/pixeluvo_1.6.0-2_amd64.deb
            dpkg -i pixeluvo_1.6.0-2_amd64.deb
            apt install -fy
            ;;
        "6") #Phatch
            apt install phatch phatch-cli -y
            ;;
        "7") #MyPaint
            apt install mypaint mypaint-data-extras -y
            ;;         
        "8") #Ufraw
            apt install ufraw ufraw-batch -y
            ;;            
        "9") #Inkscape
            apt install inkscape -y
            ;;                    
        "10") #Darktable
            apt install darktable -y
            ;;          
        "11") #Blender
            apt install blender -y
            ;;       
        "12") #K-3D
            apt install k3d -y
            ;;                         
        "13") #SweetHome 3D
            apt install sweethome3d -y
            ;;               
        "14") #LibreCAD
            apt install librecad -y
            ;;        
        "15") #Shutter
            apt install shutter -y
            ;;    
        "16") #Frogr
            apt install frogr -y
            ;;    
    esac
done

# Q9/ Traitement audio
for audio in $choixAudio
do
    case $audio in
        "2") #Xcfa
            apt install xcfa -y
            ;;
        "3") #SoundJuicer
            apt install sound-juicer -y
            ;;
        "4") #Gnome Sound Recorder
            apt install gnome-sound-recorder -y
            ;;
        "5") #Audacity
            apt install audacity -y
            ;;
        "6") #MhWaveEdit
            apt install mhwaveedit -y
            ;;         
        "7") #RipperX
            apt install ripperx -y
            ;;                     
        "8") #LMMS
            apt install lmms -y
            ;;           
        "9") #MiXX
            apt install mixxx -y
            ;;        
        "10") #Rosegarden
            apt install rosegarden -y
            ;;           
        "11") #Pavucontrol
            apt install pavucontrol -y
            ;;   
        "12") #lame
            apt install lame -y
            ;;
        "13") #Hydrogen
            apt install hydrogen -y
            ;;            
        "14") #Ardour
            debconf-set-selections <<< "jackd/tweak_rt_limits false"
            apt install ardour -y
            ;;                
        "15") #Flacon
            snap install flacon-tabetai
            ;;            
        "16") #PulseEffects
            flatpak install --from https://flathub.org/repo/appstream/com.github.wwmm.pulseeffects.flatpakref -y
            ;;   
    esac
done

# Q10/ Bureautique
for bureautique in $choixBureautique
do
    case $bureautique in
        "2") #Complément LibreOffice
            apt install libreoffice libreoffice-style-breeze libreoffice-style-oxygen libreoffice-style-human libreoffice-style-sifrm libreoffice-wiki-publisher -y
            apt install libreoffice-templates openclipart-libreoffice -y
            ;;
        "3") #PDFMod
            apt install pdfmod -y 
            ;;
        "4") #Scenari (dépot pas encore actif pour 18.04)
            echo "deb https://download.scenari.org/deb xenial main" > /etc/apt/sources.list.d/scenari.list
            wget -O- https://download.scenari.org/deb/scenari.asc | apt-key add -
            apt update
            apt install scenarichain4.2.fr-fr opale3.6.fr-fr -y
            ;;
        "5") #Freeplane
            apt install freeplane -y
            ;;
        "6") #Feedreader
            flatpak install --from https://flathub.org/repo/appstream/org.gnome.FeedReader.flatpakref -y
            ;;
        "7") #Geary
            apt install geary -y
            ;;        
        "8") #Gnome Office
            apt install abiword gnumeric dia planner glabels glom tomboy gnucash -y
            ;; 
        "9") #Wordgrinder
            apt install wordgrinder wordgrinder-x11 -y
            ;;            
        "10") #Latex
            apt install texlive texlive-lang-french texworks -y
            ;; 
        "11") #Gnome Evolution
            apt install evolution -y
            ;;  
        "12") #MailSpring (Snap)
            snap install mailspring
            ;; 
        "13") #Notes Up (Flatpak)
            flatpak install --from https://flathub.org/repo/appstream/com.github.philip_scott.notes-up.flatpakref -y
            ;;          
        "14") #Zim
            apt install zim -y
            ;;                         
        "15") #WPS Office
            wget http://ftp.fr.debian.org/debian/pool/main/libp/libpng/libpng12-0_1.2.50-2+deb8u3_amd64.deb
            wget http://kdl1.cache.wps.com/ksodl/download/linux/a21//wps-office_10.1.0.5707~a21_amd64.deb
            dpkg -i libpng12-0_1.2.50-2+deb8u3_amd64.deb ; dpkg -i wps-office_10.1.0.5707~a21_amd64.deb ; apt install -fy
            ;;     
        "16") #Soft Maker Office (béta)
            wget http://www.softmaker.net/down/softmaker-office-2018_924-01_amd64.deb
            dpkg -i softmaker-office-2018_924-01_amd64.deb
            rm -f softmaker-office-2018_924-01_amd64.deb
            ;;            
        "17") #OnlyOffice (Snap)
            snap install onlyoffice-desktopeditors --classic
            ;;                
    esac
done

# Q11/ Science
for science in $choixScience
do
    case $science in
        "2") #Google Earth
            wget https://dl.google.com/dl/earth/client/current/google-earth-pro-stable_current_amd64.deb
            dpkg -i google-earth-pro-stable_current_amd64.deb
            apt install -fy
            ;;
        "3") #extension LO oooHG
            apt install ooohg -y
            ;;
        "4") #Scilab
            apt install scilab -y
            ;;
        "5") #Geogebra
            apt install geogebra -y
            ;;
        "6") #Algobox
            apt install algobox -y
            ;;
        "7") #Carmetal
            apt install carmetal -y
            ;;
        "8") #Stellarium
            apt install stellarium -y
            ;;            
        "9") #Skychart
            add-apt-repository 'deb http://www.ap-i.net/apt stable main' -y
            add-apt-repository --remove 'deb-src http://www.ap-i.net/apt stable main' -y
            apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA716FC2
            apt update ; apt install --no-install-recommends skychart -y
            apt install skychart-data-stars skychart-data-dso skychart-data-pictures -y
            ;;
        "10") #Celestia
            wget https://raw.githubusercontent.com/BionicBeaver/Divers/master/CelestiaBionic.sh && chmod +x CelestiaBionic.sh
            ./CelestiaBionic.sh ; rm CelestiaBionic.sh
            ;;
        "11") #Avogadro
            apt install avogadro -y
            ;;
        "12") #Scratch 1.4
            apt install scratch -y
            ;;   
        "13") #Scratch 2 (intervention nécessaire de la part de l'utilisateur)
            wget https://scratch.mit.edu/scratchr2/static/sa/Scratch-455.air ; chmod +x Scratch* #nb: il y a la 456 mais elle semble poser problème
            wget https://raw.githubusercontent.com/dane-lyon/fichier-de-config/master/adobe-air.sh ; chmod +x adobe-air.sh
            ./adobe-air.sh ; rm adobe-air.sh
            Adobe\ AIR\ Application\ Installer #choisir manuellement le fichier "Scratch-455.air"
            ;;
        "14") #mBlock (voir plus tard pour un raccourci dans le menu des applications et non dans le dossier de l'utilisateur)
            wget https://mblockdev.blob.core.chinacloudapi.cn/mblock-src/mBlock.deb
            dpkg -i mBlock.deb ; apt install -fy ; rm mBlock.deb
            # Méthode alternative :
            #wget https://github.com/Makeblock-official/mBlock/releases/download/V4.0.0-Linux/mBlock-4.0.0-linux-4.0.0.tar.gz
            #tar zxvf mBlock-4.0.0-linux-4.0.0.tar.gz -C /opt/
            #ln -s /opt/mBlock/mblock /home/$SUDO_USER/raccourci_mblock
            ;;
        "15") #AlgoIDE 
            wget http://www.algoid.net/downloads/AlgoIDE-release.jar
            chmod +x AlgoIDE-release.jar && mv AlgoIDE-release.jar /home/$SUDO_USER/
            ;;           
    esac
done

# Q12/ Utilitaire et divers
for utilitaire in $choixUtilitaire
do
    case $utilitaire in
        "2") #Kazam
            apt install kazam -y
            ;;
        "3") #SimpleScreenRecorder
            apt install simplescreenrecorder -y
            ;;
        "4") #OpenBroadcaster Software (dépot bionic pas encore activé donc artful utilisé en attendant)
            echo "deb http://ppa.launchpad.net/obsproject/obs-studio/ubuntu artful main" >> /etc/apt/sources.list.d/openbroadcast-studio.list
            apt-key adv --recv-keys --keyserver keyserver.ubuntu.com BC7345F522079769F5BBE987EFC71127F425E228
            apt update ; apt install ffmpeg obs-studio -y
            ;;
        "5") #Glances
            apt install glances -y
            ;;
        "6") #Brasero
            apt install brasero brasero-cdrkit nautilus-extension-brasero -y
            ;;
        "7") #Wine 
            apt install wine-stable -y
            ;;
        "8") #Oracle Java 8 (dépot xenial car celui de bionic pas encore activé)
            add-apt-repository "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" -y
            apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 7B2C3B0889BF5709A105D03AC2518248EEA14886
            apt update
            echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections | apt install oracle-java8-installer -y
            ;;  
        "9") #Oracle Java 9 (dépot xenial car celui de bionic pas encore activé)
            add-apt-repository "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" -y
            apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 7B2C3B0889BF5709A105D03AC2518248EEA14886
            apt update
            echo oracle-java9-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections | apt install oracle-java9-installer -y
            ;;   
        "10") # OpenJDK 9
            apt install openjdk-9-jre -y
            ;; 
        "11") # OpenJDK 10
            apt install openjdk-10-jre -y
            ;;             
        "12") #FlashPlayer (avec dépot partenaire)
            apt install adobe-flashplugin -y
            ;;
        "13") #VirtualBox
            apt install virtualbox -y
            ;;            
        "14") #KeepassX2
            apt install keepassx -y
            ;; 
        "15") #Teamviewer
            wget https://dl.tvcdn.de/download/linux/version_13x/teamviewer_13.0.5494_amd64.deb
            dpkg -i teamviewer_13.0.5494_amd64.deb
            apt install -fy
            ;;   
        "16") #Cheese
            apt install cheese -y
            ;; 
        "17") #Gnome Recipes
            apt install gnome-recipes -y
            ;;   
        "18") #Gufw
            apt install gufw -y
            ;;  
        "19") #Pack cyber-sécurité
            apt install aircrack-ng nmap -y
            snap install john-the-ripper
            ;;  
        "20") #Gnome Encfs Manager (dépot Xenial car Bionic pas encore actif)
            add-apt-repository "deb http://ppa.launchpad.net/gencfsm/ppa/ubuntu xenial main" -y
            apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 6A0344470F68ADCA
            apt update ; apt install gnome-encfs-manager -y
            ;;             
        "21") #Bleachbit
            apt install bleachbit -y
            ;;    
        "22") #VMWare Workstation Player 
            #apt install gcc -y #<= vérifier si nécessaire sur MP
            wget https://download3.vmware.com/software/player/file/VMware-Player-14.0.0-6661328.x86_64.bundle
            chmod +x VMware-Player-14.0.0-6661328.x86_64.bundle
            ./VMware-Player-12.5.7-5813279.x86_64.bundle
            ;;              
        "23") #Corebird
            apt install corebird -y
            ;; 
        "24") #Wireshark
            debconf-set-selections <<< "wireshark-common/install-setuid true"
            apt install wireshark -y
            usermod -aG wireshark $SUDO_USER #permet à l'utilisateur principal de faire des captures
            ;;   
        "25") #pack d'outils : vrms + screenfetch + asciinema + ncdu + screen + kclean + rclone
            apt install vrms screenfetch asciinema ncdu screen rclone -y
            wget http://hoper.dnsalias.net/tdc/public/kclean.deb && dpkg -i kclean.deb ; apt install -fy ; rm kclean.deb
            ;; 
        "26") #Synaptic
            apt install synaptic -y
            ;;               
    esac
done

# Q13/ Jeux
for gaming in $choixGaming
do
    case $gaming in
        "2") #Steam
            apt install steam -y
            ;;
        "3") #PlayOnLinux
            apt install playonlinux -y
            ;;
        "4") #Minecraft 
            wget http://packages.linuxmint.com/pool/import/m/minecraft-installer/minecraft-installer_0.1+r12~ubuntu16.04.1_amd64.deb
            dpkg -i minecraft-installer_0.1+r12~ubuntu16.04.1_amd64.deb ; apt install -fy
            ;;
        "5") #Minetest 
            apt install minetest minetest-mod-nether -y
            ;;
        "6") #OpenArena
            apt install openarena -y
            ;;
        "7") #0ad: Empires Ascendant (ou via flatpak)
            apt install 0ad -y
            ;;     
        "8") #FlightGear
            apt install flightgear -y
            ;;
        "9") #SuperTux
            apt install supertux -y
            ;;            
        "10") #SuperTuxKart
            apt install supertuxkart -y
            ;;   
        "11") #Assault Cube
            apt install assaultcube -y
            ;;               
        "12") #Gnome Games 
            apt install gnome-games gnome-games-app -y
            ;;  
        "13") #Megaglest
            apt install megaglest -y
            ;;
        "14") #Pingus
            apt install pingus -y            
            ;;
        "15") #Battle for Wesnoth
            apt install wesnoth -y
            ;;
        "16") #Albion online
            flatpak install --from https://flathub.org/repo/appstream/com.albiononline.AlbionOnline.flatpakref -y
            ;;            
        "17") #Runscape
            flatpak install --from https://flathub.org/repo/appstream/com.jagex.RuneScape.flatpakref -y   
            ;;
    esac
done

# Mode avancé : ne pas oublier d'ajouter plus tard une condition => Si mode avancé alors...

# 14/ Extensions (a completer plus tard)
for extension in $choixExtension
do
    case $extension in
        "2") #User themes
            wget https://extensions.gnome.org/extension-data/user-theme%40gnome-shell-extensions.gcampax.github.com.v32.shell-extension.zip
            unzip user-theme@gnome-shell-extensions.gcampax.github.com.v32.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/user-theme@gnome-shell-extensions.gcampax.github.com
            ;;             
        "3") #AlternateTab
            wget https://extensions.gnome.org/extension-data/alternate-tab%40gnome-shell-extensions.gcampax.github.com.v36.shell-extension.zip
            unzip alternate-tab@gnome-shell-extensions.gcampax.github.com.v36.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/alternate-tab@gnome-shell-extensions.gcampax.github.com
            ;;
        "4") #Caffeine
            apt install gnome-shell-extension-caffeine -y
            ;;
        "5") #DashToDock
            wget https://extensions.gnome.org/extension-data/dash-to-dock%40micxgx.gmail.com.v61.shell-extension.zip
            unzip dash-to-dock@micxgx.gmail.com.v61.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com
            ;;
        "6") #DashToPanel
            apt install gnome-shell-extension-dash-to-panel -y
            ;;
        "7") #Clipboard Indicator
            wget https://extensions.gnome.org/extension-data/clipboard-indicator%40tudmotu.com.v29.shell-extension.zip
            unzip clipboard-indicator@tudmotu.com.v29.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com
            ;;       
        "8") #Impatience
            apt install gnome-shell-extension-impatience -y
            ;;
        "9") #Logout button
            apt install gnome-shell-extension-log-out-button -y
            ;; 
        "10") #Media Player Indicator
            apt install gnome-shell-extension-mediaplayer -y
            ;;
        "11") #Multi monitors
            apt install gnome-shell-extension-multi-monitors -y
            ;;
        "12") #Weather
            apt install gnome-shell-extension-weather -y
            ;;
        "13") #Places status indicator
            wget https://extensions.gnome.org/extension-data/places-menu%40gnome-shell-extensions.gcampax.github.com.v38.shell-extension.zip
            unzip places-menu@gnome-shell-extensions.gcampax.github.com.v38.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/places-menu@gnome-shell-extensions.gcampax.github.com
            ;;
        "14") #Removable drive menu
            wget https://extensions.gnome.org/extension-data/drive-menu%40gnome-shell-extensions.gcampax.github.com.v35.shell-extension.zip
            unzip drive-menu@gnome-shell-extensions.gcampax.github.com.v35.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/drive-menu@gnome-shell-extensions.gcampax.github.com
            ;;
        "15") #Shortcuts
            apt install gnome-shell-extension-shortcuts -y
            ;;
        "16") #Suspend button
            apt install gnome-shell-extension-suspend-button -y
            ;;         
        "17") #Taskbar
            apt install gnome-shell-extension-taskbar -y
            ;;
        "18") #Trash
            apt install gnome-shell-extension-trash -y
            ;;  
        "19") #Window list
            wget https://extensions.gnome.org/extension-data/window-list%40gnome-shell-extensions.gcampax.github.com.v22.shell-extension.zip
            unzip window-list@gnome-shell-extensions.gcampax.github.com.v22.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/window-list@gnome-shell-extensions.gcampax.github.com
            ;;
        "20") #Workspace indicator
            wget https://extensions.gnome.org/extension-data/workspace-indicator%40gnome-shell-extensions.gcampax.github.com.v34.shell-extension.zip
            unzip workspace-indicator@gnome-shell-extensions.gcampax.github.com.v34.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/workspace-indicator@gnome-shell-extensions.gcampax.github.com
            ;;
        "21") #System-monitor
            apt install gnome-shell-extension-system-monitor -y
            ;;         
        "22") #Top Icon Plus
            apt install gnome-shell-extension-top-icons-plus -y
            ;;
        "23") #Unite
            wget https://extensions.gnome.org/extension-data/unite%40hardpixel.eu.v8.shell-extension.zip
            unzip unite@hardpixel.eu.v8.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/unite@hardpixel.eu
            ;;  
        "24") #AppFolders Management
            wget https://extensions.gnome.org/extension-data/appfolders-manager%40maestroschan.fr.v11.shell-extension.zip
            unzip appfolders-manager@maestroschan.fr.v11.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/appfolders-manager@maestroschan.fr          
            ;;    
    esac
done

# Q15/ Customization
for custom in $choixCustom
do
    case $custom in
        "2") #pack theme gtk 1
            apt install arc-theme numix-blue-gtk-theme numix-gtk-theme silicon-theme -y
            #Numix Circle
            git clone https://github.com/numixproject/numix-icon-theme-circle.git ; mv -f numix-icon-theme-circle/* /usr/share/icons/ ; rm -r numix-icon-theme-circle
            ;;
        "3") #pack theme gtk 2
            apt-add-repository ppa:tista/adapta -y ; apt update ; apt install adapta-gtk-theme -y
            apt install blackbird-gtk-theme bluebird-gtk-theme greybird-gtk-theme -y
            #ajouter a la suite : minwaita vanilla + plano + Popgtk
            ;;
        "4") #pack theme gtk 3
            apt install albatross-gtk-theme yuyo-gtk-theme human-theme gnome-theme-gilouche -y
            ;;
        "5") #pack icone 1
            apt install numix-icon-theme breathe-icon-theme breeze-icon-theme elementary-icon-theme gnome-brave-icon-theme gnome-icon-theme-extras -y
            ;;        
        "6") #pack icone 2
            apt install gnome-dust-icon-theme gnome-humility-icon-theme gnome-icon-theme-gartoon gnome-icon-theme-gperfection2 gnome-icon-theme-nuovo -y
            ;;  
        "7") #pack icone 3
            apt install human-icon-theme moblin-icon-theme oxygen-icon-theme gnome-icon-theme-suede gnome-icon-theme-yasis -y
            ;;   
        "8") #pack curseur
            apt install breeze-cursor-theme moblin-cursor-theme oxygen-cursor-theme -y
            ;;  
        "9") #Mac OS X High Sierra (plusieurs versions)
            apt install gtk2-engines-pixbuf gtk2-engines-murrine -y
            git clone https://github.com/B00merang-Project/macOS-Sierra.git ; git clone https://github.com/B00merang-Project/macOS-Sierra-Dark.git
            mv -f macOS* /usr/share/themes/
            wget http://nux87.free.fr/script-postinstall-ubuntu/theme/Gnome-OSX-V-Space-Grey-1-3-1.tar.xz && wget http://nux87.free.fr/script-postinstall-ubuntu/theme/Gnome-OSX-V-Traditional-1-3-1.tar.xz   
            tar Jxvf Gnome-OSX-V-Space-Grey-1-3-1.tar.xz ; mv -f Gnome-OSX-V-Space-Grey-1-3-1 /usr/share/themes/ ; rm Gnome-OSX-V-Space-Grey-1-3-1.tar.xz
            tar Jxvf Gnome-OSX-V-Traditional-1-3-1.tar.xz ; mv -f Gnome-OSX-V-Traditional-1-3-1 /usr/share/themes/ ; rm Gnome-OSX-V-Traditional-1-3-1.tar.xz       
            #Pack d'icone la capitaine + macOS
            git clone https://github.com/keeferrourke/la-capitaine-icon-theme.git ; mv -f *capitaine* /usr/share/icons/
            wget http://nux87.free.fr/script-postinstall-ubuntu/theme/macOS.tar.xz ; tar Jxvf macOS.tar.xz ; mv macOS /usr/share/icons/ ; rm -r macOS*
            #Wallpaper officiel Mac OS X Sierra
            wget http://wallpaperswide.com/download/macos_sierra_2-wallpaper-3554x1999.jpg -P /usr/share/backgrounds/
            ;;
        "10") #Windows 10
            git clone https://github.com/B00merang-Project/Windows-10.git ; mv -f Windo* /usr/share/themes/
            wget http://nux87.free.fr/script-postinstall-ubuntu/theme/windows10-icons_1.2_all.deb && dpkg -i windows10-icons_1.2_all.deb
            wget https://framapic.org/Nd6hGtEOEJhM/LtmYwl16WjyC.jpg && mv LtmYwl16WjyC.jpg /usr/share/backgrounds/windows10.jpg
            ;;
        "11") #Unity 8
            git clone https://github.com/B00merang-Project/Unity8.git ; mv -f Unit* /usr/share/themes/
            ;;
        "12") #Icone Papirus
            wget http://nux87.free.fr/script-postinstall-ubuntu/theme/papirus-icon-theme-20171124.tar.xz ; tar Jxvf papirus-icon-theme-20171124.tar.xz
            mv *Papirus* /usr/share/icons/
            ;;  
        "13") #thème gris GDM (changement effectif seulement si la session vanilla est installé)
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
        "2") #Gvim
            apt install vim-gtk3 -y
            ;;
        "3") #Emacs
            apt install emacs -y
            ;;
        "4") #Geany (verifier les extensions)
            apt install geany geany-plugins geany-plugin-* -y
            ;;
        "5") #Sublime Text
            wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
            apt install apt-transport-https -y
            echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list
            apt update ; apt install sublime-text -y
            ;;
        "6") #Code:Blocks
            apt install codeblocks codeblocks-contrib -y
            ;;           
        "7") #JEdit
            apt install jedit -y
            ;;
        "8") #Anjuta
            apt install anjuta anjuta-extras -y
            ;;
        "9") #Android Studio (dépot Artful car Bionic pas actif)
            add-apt-repository "deb http://ppa.launchpad.net/maarten-fonville/android-studio/ubuntu artful main" -y
            apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 4DEA8909DC6A13A3
            apt update ; apt install android-studio -y
            ;;
        "10") #Netbeans
            apt install netbeans -y
            ;;         
        "11") #BlueFish
            apt install bluefish bluefish-plugins -y
            ;;
        "12") #BlueGriffon
            wget http://bluegriffon.org/freshmeat/3.0/bluegriffon-3.0.Ubuntu16.04-x86_64.deb
            dpkg -i bluegriffon-3.0.Ubuntu16.04-x86_64.deb
            apt install -fy
            ;;         
        "13") #SciTE
            apt install scite -y
            ;;  
        "14") #Eclipse // version présent aussi dans dépot officiel mais obsolète
            wget http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/oomph/epp/oxygen/R/eclipse-inst-linux64.tar.gz
            tar xvfz eclipse-inst-linux64.tar.gz
            chmod +x ./eclipse-installer/eclipse-inst
            ./eclipse-installer/eclipse-inst
            ;;           
        "15") #PyCharm
            snap install pycharm-community --classic
            ;;
        "16") #Visual Studio Code
            snap install vscode --classic
            ;;
        "17") #Atom
            snap install atom --classic
            ;;
        "18") #Brackets
            snap install brackets --classic
            ;;      
        "19") #IntelliJ Idea
            snap install intellij-idea-community --classic 
            ;;            
    esac
done

# Q17/ Serveurs
for srv in $choixServeur
do
    case $srv in
        "2") #openssh-server
            apt install openssh-server -y
            ;;
        "3") #apache+mariadb+php
            apt install apache2 php mariadb-server libapache2-mod-php php-mysql -y
            ;;
        "4") #proftpd
            apt install proftpd -y
            ;;
        "5") #Postgresql
            apt install postgresql -y
            ;;
        "6") #Retroportage PHP5 (dépot artful utilisé car bionic pas encore activé)
            echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu artful main" > /etc/apt/sources.list.d/php-backport.list
            apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 4F4EA0AAE5267A6C
            apt update ; apt install php5.6 -y
            ;;
        "7") #php7.2
            echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu artful main" > /etc/apt/sources.list.d/php-backport.list
            apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 4F4EA0AAE5267A6C
            apt update ; apt install php7.2 -y
            ;;         
    esac
done

# Q18/ Optimisation/Réglage
for optimisation in $choixOptimisation
do
    case $optimisation in
        "2") #Swapiness 95% +cache pressure 50
            echo vm.swappiness=5 | tee /etc/sysctl.d/99-swappiness.conf
            sysctl -p /etc/sysctl.d/99-swappiness.conf
            ;;
        "3") #Désactiver swap
            swapoff /swapfile #désactive l'utilisation du fichier swap
            rm /swapfile #supprime le fichier swap qui n'est plus utile
            sed -i -e '/.swapfile*/d' /etc/fstab #ligne swap retiré de fstab
            ;;
        "4") #Activer TLP + install Powertop (Attention : TLP installe postfix en dépendance)
            apt install tlp powertop -y
            systemctl enable tlp
            systemctl emable tlp-sleep
            systemctl disable postfix.service
            ;;
        "5") #Microcode Intel
            apt install intel-microcode -y
            ;;
        "6") #Mode fraude Wayland (proposé par Christophe C sur Ubuntu-fr.org)
            echo "#FONCTION POUR CONTOURNER WAYLAND
            fraude(){ 
                xhost + && sudo \$1 && xhost -
                }" >> /home/$SUDO_USER/.bashrc
            su $SUDO_USER -c "source ~/.bashrc"
            ;;
        "7") #Désactiver userlist GDM
            echo "user-db:user
            system-db:gdm
            file-db:/usr/share/gdm/greeter-dconf-defaults" > /etc/dconf/profile/gdm
            mkdir /etc/dconf/db/gdm.d
            echo "[org/gnome/login-screen]
            # Do not show the user list
            disable-user-list=true" > /etc/dconf/db/gdm.d/00-login-screen
            dconf update
            ;;
        "8") #Support ExFat
            apt install exfat-utils exfat-fuse -y    
            ;;
        "9") #Support HFS
            apt install hfsprogs hfsutils hfsplus -y
            ;;
        "10") #Nouvelle commande raccourci Maj totale
            echo "alias maj='sudo apt update && sudo apt autoremove --purge -y && sudo apt full-upgrade -y && sudo apt clean && sudo snap refresh && sudo flatpak update -y ; clear'" >> /home/$SUDO_USER/.bashrc
            su $SUDO_USER -c "source ~/.bashrc"
            ;;
        "11") #Grub réduction temps d'attente + suppression test ram dans grub
            sed -ri 's/GRUB_TIMEOUT=10/GRUB_TIMEOUT=2/g' /etc/default/grub
            mkdir /boot/old ; mv /boot/memtest86* /boot/old/
            update-grub
            ;;
        "12") #Lecture DVD Commerciaux
            apt install libdvdcss2 libdvd-pkg -y
            dpkg-reconfigure libdvd-pkg
            ;;
        "13") #Support imprimante HP
            apt install hplip hplip-doc hplip-gui sane sane-utils -y
            ;;   
        "14") #Minimisation fenêtre sur l'icone du dock (pour dashtodock uniquement)
            su $SUDO_USER -c "gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'"
            ;;
        "15") #Interdire l'accès des autres utilisateurs au dossier perso de l'utilisateur principal
            chmod -R o-rwx /home/$SUDO_USER
            ;;            
        "16") #Pour utiliser carte nvidia/pilote nouveau pour un jeu
            apt install switcheroo-control -y
            ;; 
        "17") #Retirer paquet snappy et réinstaller les logiciels de manière classique
            snap remove gnome-calculator gnome-characters gnome-logs gnome-system-monitor
            apt install -y gnome-calculator gnome-characters gnome-logs gnome-system-monitor
            ;;               
    esac
done

# Question 19 : Extra Snap
for snap in $choixSnap
do
    case $snap in
        "2") #VLC version snap
            snap install vlc
            ;;
        "3") #LibreOffice version snap
            snap install libreoffice
            ;;                       
        "4") #dino
            snap install dino
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
        "8") #ktube media downloader
            snap install ktube-media-downloader --classic
            ;; 
        "9") #warzone 2100 
            snap install warzone2100
            ;; 
        "10") #asciinema
            snap install asciinema --classic
            ;;      
        "11") #bitcoin
            snap install bitcoin
            ;;
        "12") #blender
            snap install blender --classic
            ;;  
        "13") #electrum
            snap install electrum
            ;; 
        "14") #nextcloud client
            snap install nextcloudclient
            ;;      
        "15") #pycharm pro
            snap install pycharm-professional --classic
            ;;   
        "16") #Quassel client
            snap install quasselclient-moon127
            ;;   
        "17") #Rube cube
            snap install rubecube
            ;;            
        "18") #TermiusApp
            snap install termius-app
            ;;        
        "19") #TicTacToe
            snap install tic-tac-toe
            ;;              
    esac
done        
    
# Question 20 : Extra Flatpak
for flatpak in $choixFlatpak
do
    case $flatpak in
        "2") #0ad version flatpak
            flatpak install --from https://flathub.org/repo/appstream/com.play0ad.zeroad.flatpakref -y
            ;;
        "3") #Audacity version flatpak
            flatpak install --from https://flathub.org/repo/appstream/org.audacityteam.Audacity.flatpakref -y
            ;;
        "4") #Battle Tanks
            flatpak install --from https://flathub.org/repo/appstream/net.sourceforge.btanks.flatpakref -y
            ;;            
        "5") #Blender version flatpak
            flatpak install --from https://flathub.org/repo/appstream/org.blender.Blender.flatpakref -y
            ;;             
        "6") #Dolphin Emulator
            flatpak install --from https://flathub.org/repo/appstream/org.DolphinEmu.dolphin-emu.flatpakref -y
            ;;             
        "7") #Extreme Tuxracer
            flatpak install --from https://flathub.org/repo/appstream/net.sourceforge.ExtremeTuxRacer.flatpakref -y
            ;;                
        "8") #Frozen Bubble
            flatpak install --from https://flathub.org/repo/appstream/org.frozen_bubble.frozen-bubble.flatpakref -y
            ;;                    
        "9") #Gnome MPV version flatpak
            flatpak install --from https://flathub.org/repo/appstream/io.github.GnomeMpv.flatpakref -y
            ;;               
        "10") #GIMP version flatpak
            flatpak install --from https://flathub.org/repo/appstream/org.gimp.GIMP.flatpakref -y
            ;;                    
        "11") #Google Play Music Desktop Player
            flatpak install --from https://flathub.org/repo/appstream/com.googleplaymusicdesktopplayer.GPMDP.flatpakref -y
            ;;              
        "12") #Homebank
            flatpak install --from https://flathub.org/repo/appstream/fr.free.Homebank.flatpakref -y
            ;;               
        "13") #LibreOffice version flatpak
            flatpak install --from https://flathub.org/repo/appstream/org.libreoffice.LibreOffice.flatpakref -y
            ;;         
        "14") #Minetest version flatpak
            flatpak install --from https://flathub.org/repo/appstream/net.minetest.Minetest.flatpakref -y
            ;;             
        "15") #Nextcloud
            flatpak install --from https://flathub.org/repo/appstream/org.nextcloud.Nextcloud.flatpakref -y
            ;;        
        "16") #Othman Quran Browser
            flatpak install --from https://flathub.org/repo/appstream/com.github.ojubaorg.Othman.flatpakref -y
            ;;  
        "17") #Password Calculator
            flatpak install --from https://flathub.org/repo/appstream/com.bixense.PasswordCalculator.flatpakref -y
            ;;             
        "18") #PPSSPP
            flatpak install --from https://flathub.org/repo/appstream/org.ppsspp.PPSSPP.flatpakref -y
            ;;              
        "19") #Riot
            flatpak install --from https://flathub.org/repo/appstream/im.riot.Riot.flatpakref -y
            ;;                             
        "20") #Teeworlds
            flatpak install --from https://flathub.org/repo/appstream/com.teeworlds.Teeworlds.flatpakref -y
            ;;       
        "21") #VLC version flatpak
            flatpak install --from https://flathub.org/repo/appstream/org.videolan.VLC.flatpakref -y
            ;;
    esac
done

# Question 21 : Extra Appimages
for appimage in $choixAppimage
do
    case $appimage in
        "2") #Digikam
            wget https://download.kde.org/stable/digikam/digikam-5.5.0-01-x86-64.appimage
            mv digikam-5.5.0-01-x86-64.appimage digikam-5.5.0-01-x86-64.AppImage
            ;;
        "3") #Freecad
            wget https://github.com/FreeCAD/FreeCAD/releases/download/0.16.6712/FreeCAD-0.16.6712.glibc2.17-x86_64.AppImage
            ;;
        "4") #Aidos Wallet
            wget https://github.com/AidosKuneen/aidos-wallet/releases/download/v1.2.7/Aidos-1.2.7-x86_64.AppImage
            ;; 
        "5") #Cerebro
            wget https://github.com/KELiON/cerebro/releases/download/v0.3.1/cerebro-0.3.1-x86_64.AppImage
            ;;             
        "6") #Chronos
            wget https://github.com/web-pal/Chronos/releases/download/v2.2.1/Chronos-2.2.1-x86_64.AppImage
            ;;     
        "7") #Crypter
            wget https://github.com/HR/Crypter/releases/download/v3.1.0/Crypter-3.1.0-x86_64.AppImage
            ;;
        "8") #Jaxx
            wget https://github.com/Jaxx-io/Jaxx/releases/download/v1.3.9/jaxx-1.3.9-x86_64.AppImage
            ;;            
        "9") #Imagine
            wget https://github.com/meowtec/Imagine/releases/download/v0.4.0/Imagine-0.4.0-x86_64.AppImage
            ;;     
        "10") #Infinite Electron
            wget https://github.com/InfiniteLibrary/infinite-electron/releases/download/0.1.1/infinite-electron-0.1.1-x86_64.AppImage
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
            wget http://github.com/OpenShot/openshot-qt/releases/download/v2.4.1/OpenShot-v2.4.1-x86_64.AppImage
            ;;  
        "16") #Owncloud Client
            wget http://download.opensuse.org/repositories/home:/ocfreitag/AppImage/owncloud-client-latest-x86_64.AppImage
            ;;     
        "17") #Popcorntime
            wget https://github.com/amilajack/popcorn-time-desktop/releases/download/v0.0.6/PopcornTime-0.0.6-x86_64.AppImage
            ;;     
        "18") #Skype for Business
            wget https://tel.red/linux/sky-latest-x86_64.AppImage
            ;;              
        "19") #Spotify web client
            wget https://github.com/Quacky2200/Spotify-Web-Player-for-Linux/releases/download/1.0.42/spotifywebplayer-1.0.42-x86_64.AppImage
            ;;      
        "20") #Tulip
            wget https://github.com/Tulip-Dev/tulip/releases/download/tulip_5_1_0/Tulip-5.1.0-x86_64.AppImage
            ;;        
        "21") #Wire
            wget https://wire-app.wire.com/linux/wire-3.0.2816-x86_64.AppImage
            ;;                
    esac
done
    
   
# Suppression des deb téléchargés par le script (plus nécessaire) et rangement des AppImages
mkdir ./appimages ; rm *.deb ; mv *.AppImage ./appimages/
chown -R $SUDO_USER:$SUDO_USER ./appimages
chmod -R +x ./appimages

# Finalisation & nettoyage
if [ "$(which gnome-shell)" = "/usr/bin/gnome-shell" ]
then
    chown -R $SUDO_USER /home/$SUDO_USER/.local/share/gnome-shell/extensions
    rm *-extension.zip 
fi

# Maj
apt update ; apt install -fy ; apt autoremove --purge -y ; apt clean ; apt full-upgrade -y
flatpak update -y ; snap refresh ; clear

echo "Pour prendre en compte tous les changements, il faut maintenant redémarrer !"
read -p "Voulez-vous redémarrer immédiatement ? [o/n] " rep_reboot
if [ "$rep_reboot" = "o" ] || [ "$rep_reboot" = "O" ]
then
    reboot
fi
