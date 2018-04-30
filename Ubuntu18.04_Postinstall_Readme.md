# Script de post-installation pour Ubuntu 18.04

### 1/ Aperçu

Si vous voulez un aperçu de ce que donne le script avant de le lancer vous même, voici une démo en capture vidéo via asciinema : https://asciinema.org/a/5G8rzzZ4WM6Lx8JCjmwYtNiAs (dans cet exemple, j'ai choisi le mode "extra").

Astuce : si vous voulez faire le choix par défaut (qui correspond à 1), vous pouvez gagner du temps en faisant directement "entrée" sur votre clavier sans taper le numéro, ça reviendra au même.

### 2/ Précision

- Le script de post-installation est conçu uniquement pour la nouvelle LTS (18.04 Bionic Beaver) qui sortira en stable en Avril 2018 (mais déjà testable en récupérant l'iso ici : http://cdimage.ubuntu.com/ubuntu/daily-live/current/)

- Le script peut être utilisé avec des variantes, par exemple Xubuntu 18.04, Ubuntu Mate 18.04... à condition toutefois d'être en 64 bits (pas de support 32 bits même si la plupart des logiciels fonctionnent aussi en 32 bits).

### 3/ Pour lancer le script

- C'est très simple, il suffit de télécharger le script shell (appuyer sur raw avant sur github) ou directement en faisant :
```bash 
  wget https://raw.githubusercontent.com/simbd/Scripts_Ubuntu/master/Ubuntu18.04_Bionic_Postinstall.sh
```
- Il suffit ensuite de mettre les droits d'éxécution : 
```bash 
  chmod +x Ubuntu18.04_Bionic_Postinstall.sh
```
- Enfin pour le lancer : 
```bash 
  sudo ./Ubuntu18.04_Bionic_Postinstall.sh
``` 

### 4/ Utilisation

- Le script possède différents modes adaptés suivant l'utilisateur :
  #### Novice
  le script se lancera automatiquement et ne posera aucune question supplémentaire, il installera automatiquement        notamment chromium (firefox est déjà présent de base), pidgin, vlc, gnome mpv, pitivi, gimp, pinta, brasero, flash, gnome todo, police d'écriture Microsoft, unrar, codecs...
  
  #### Standard
  Avec ce mode ainsi que les 2 suivants, le script n'est plus entièrement automatisé, de nombreuses questions vous seront posés pour faire un choix pour vos logiciels. A noté que ce mode ne propose pas les choix liés aux extensions Gnome, à la customisation (thèmes, icones...), les logiciels de programmation, les fonctions serveurs et les optimisations.
  
  #### Avancé
  C'est le choix recommandé pour les utilisateurs avancés avec, comme indiqué précédemment, la possibilité cette fois-ci de choisir parmi des extensions, des thèmes graphiques etc...
  
  #### Extra
  Le mode extra ajoute 3 questions supplémentaires à la fin pour ceux qui aiment bien utiliser les Snaps, les paquets Flatpak ou des Appimages (large choix supplémentaire).
  
### 5/ Légende dans le script

- Bien que ça soit indiqué rapidement dans le script, un petit rappel plus complet ici concernant les éléments en couleur :

[Snap] => signifie que le logiciel ne sera pas installé avec la méthode traditionnelle (apt install...) mais avec Snap. Snappy gère notamment le multi-branche pour vos logiciels, c'est à dire que vous pouvez choisir par exemple entre plusieurs versions pour un même logiciel, par exemple VLC est dispo en snap branche stable en 3.0 mais aussi en 4.0 dans la branche edge. Vous pouvez voir la liste de vos paquets Snappy installés via la commande suivante :
```bash 
  snap list
```  
Pour avoir des infos sur un paquet snappy, par exemple VLC :
```bash 
  snap info vlc
```  

Pour mettre à jour l'ensemble de vos paquets snaps :
```bash 
  sudo snap refresh
```  

[Flatpak] => cette fois-ci le logiciel sera installé avec Flatpak (une alternative aux snaps), c'est une méthode d'installation encore peu connue des Ubunteros pour 2 raisons : flatpak n'est pas installé par défaut et il n'est présent dans les dépots officiels que depuis les versions récentes (sous la 16.04 il fallait ajouter un PPA par exemple). Les paquets Flatpak fonctionnent particulièrement bien avec l'environnement "Gnome Shell", ça tombe bien, c'est l'environnement par défaut de la 18.04.

Pour voir les paquets flatpak installés :
```bash 
  flatpak list
```  
Pour mettre à jour l'ensemble de vos paquets flatpak :
```bash 
  sudo flatpak update -y
```  
(A noté que dans la partie optimisation, vous avez la possibilité d'avoir une commande "maj" qui met tout à jour d'un coup) c'est en faite un alias qui fait la même chose que :
```bash 
  sudo apt update && sudo apt full-upgrade -y ; sudo apt autoremove --purge -y ; sudo snap refresh ; sudo flatpak update -y
```  

[AppImage] => Le format de paquets Appimage permet de distribuer des logiciels de manière portable sur n'importe quelle distribution Linux, y compris Ubuntu. Le but est de pouvoir déployer des applications simplement, avec une grande compatibilité, sans impacter le système. Cependant, sachez que contrairement aux paquets Snappy et Flatpak, les AppImages ne se mettent pas à jour. Si une nouvelle version sort du logiciel sort, ça sera à vous d'aller récupérer manuellement la nouvelle AppImage du logiciel en question.
  
[Interv!] => Signifie que l'installation ne peux pas être entièrement automatisé, autrement dit en sélectionant un logiciel avec cet avertissement, le script va s'arréter en plein milieu et vous demander d'intervenir et ne reprendra qu'une fois avoir compléter l'installation (par exemple pour accepter un contrat de licence). C'est quelque chose d'assez rare (très peu de logiciels sont concernés).

[Xorg only!] => Cet avertissement ne concerne que ceux qui utilisent la version de base (donc avec Gnome Shell), si vous utilisez une variante vous n'avez pas à vous poser de question car vous êtes forcément sous Xorg (donc logiciel compatible). Sous le nouveau Ubuntu avec Gnome Shell, il y a 2 sessions, la session Xorg (choix par défaut) et la session Wayland (choix alternatif). Certains logiciels ne sont pas compatibles avec Wayland mais fonctionneront sous Xorg. C'est le cas par exemple de "Synaptic" ou "Gparted". Cela dit, ce n'est pas très génant dans la mesure ou Xorg est la session par défaut sous la 18.04 (contrairement à la 17.10).
Cela vient du fait que Wayland est plus sécurisé et interdit de lancer une application graphique avec les droits root. 
A noté qu'il y a une méthode de contournement sous Wayland (cf mode avancé/extra partie optimisation, choix "commande fraude wayland").
Vous pouvez alors lancer par exemple gparted en session Wayland via la commande : fraude gparted

[à lancer manuellement] => Signifie que le logiciel devra être lancé manuellement depuis le dossier présent dans votre dossier perso (pas de raccourci dans le menu des applications). C'est le cas par exemple de Teamspeak ou Algoid. 

### 6/ Contribution

N'hésitez pas à contribuer, par exemple pour :
- corriger des fautes
- proposer des logiciels manquants, vous pouvez faire des propositions ici : https://framaforms.org/demande-dajout-de-logiciel-pour-le-script-de-pi-1804-1523260125

### 7/ Options supplémentaires

Si besoin (cas particulier), le script peut être lancé avec 2 options (paramètre) :

- paramètre 1 "vbox" : installe les additions invités, peut être utile si vous utilisez le script dans un Ubuntu virtualisé dans Virtualbox. Dans ce cas le script se lance comme ceci : sudo ./script.sh vbox

- paramètre 2 "NRI!" (NeRienInstaller!) : n'installe aucun logiciel de base (déconseillé), attention n'utilisez cette option que si vous savez ce que vous faites, par exemple flatpak ne sera pas installé mais le script propose un choix de logiciel flatpak, si vous choisissez un paquet flatpak dans la liste dans ce cas ça ne fonctionnera pas et il faudra alors installer vous même flatpak manuellement avant de lancer le script. Cette option n'a d'intérêt que pour certains utilisateurs qui veulent vraiment un système très minimale sans même des logiciels utiles comme "transmission" ou "thunderbird". Dans ce cas le script se lance comme ceci : sudo ./script.sh - NRI! (ou pour cummuler les 2 : sudo ./script.sh vbox NRI!). 
