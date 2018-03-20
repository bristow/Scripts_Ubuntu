# Script de post-installation pour Ubuntu 18.04

### 1/ Aperçu

Si vous voulez un aperçu de ce que donne le script avant de le lancer vous même, voici une démo en capture vidéo via asciinema : https://asciinema.org/a/gQ5bofDez8vc1jIVt3P8Es9wX (dans cet exemple, j'ai choisi le mode "avancé").

Astuce : si vous voulez faire le choix par défaut (qui correspond à 1), vous pouvez gagner du temps en faisant directement "entrée" sur votre clavier sans taper le numéro, ça reviendra au même.

### 2/ Précision

- Le script de post-installation est conçu uniquement pour la nouvelle LTS (18.04 Bionic Beaver) qui sortira en stable en Avril 2018 (mais déjà testable en récupérant l'iso ici : http://cdimage.ubuntu.com/ubuntu/daily-live/current/)

- Le script peut être utilisé avec des variantes, par exemple Xubuntu 18.04, Ubuntu Mate 18.04... à condition toutefois d'être en 64 bits (pas de support 32 bits même si la plupart des logiciels fonctionnent aussi en 32 bits).

### 3/ Pour lancer le script

- C'est très simple, il suffit de télécharger le script shell (appuyer sur raw avant sur github) ou directement en faisant :
```bash 
  wget https://raw.githubusercontent.com/BionicBeaver/GNULinux/master/Ubuntu18.04_BionicBeaver_Postinstallation.sh
```
- Il suffit ensuite de mettre les droits d'éxécution : 
```bash 
  chmod +x Ubuntu18.04_BionicBeaver_Postinstallation.sh
```
- Enfin pour le lancer (depuis une machine physique) : 
```bash 
  sudo ./Ubuntu18.04_BionicBeaver_Postinstallation.sh
```  
- Si vous lancez le script dans une machine virtuelle avec Virtualbox, il faut préciser l'argument "vbox" pour le lancer sinon cela pourrai poser un problème. Il faut donc faire comme ceci :
```bash 
  sudo ./Ubuntu18.04_BionicBeaver_Postinstallation.sh vbox
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

[Snap] => signifie que le logiciel ne sera pas installé avec la méthode traditionnelle (apt install...) mais avec Snap. Vous pouvez voir la liste de vos paquets Snappy installés via la commande suivante :
```bash 
  snap list
```  
Pour avoir des infos sur un paquet snappy, par exemple VLC :
```bash 
  snap info vlc
```  
[Flatpak] => cette fois-ci le logiciel sera installé avec Flatpak (une alternative aux snaps), c'est une méthode d'installation encore peu connue des Ubunteros pour 2 raisons : flatpak n'est pas installé par défaut et il n'est présent dans les dépots officiels que depuis les versions récentes (sous la 16.04 il fallait ajouter un PPA par exemple).

[AppImage] => Le format de paquets Appimage permet de distribuer des logiciels de manière portable sur n'importe quelle distribution Linux, y compris Ubuntu. Le but est de pouvoir déployer des applications simplement, avec une grande compatibilité, sans impacter le système.
  
[Interv!] => Signifie que l'installation ne peux pas être entièrement automatisé, autrement dit en sélectionant un logiciel avec cet avertissement, le script va s'arréter en plein milieu et vous demander d'intervenir et ne reprendra qu'une fois avoir compléter l'installation (par exemple pour accepter un contrat de licence).

[Xorg only!] => Cet avertissement ne concerne que ceux qui utilisent la version de base (donc avec Gnome Shell), si vous utilisez une variante vous n'avez pas à vous poser de question car vous êtes forcément sous Xorg (donc logiciel compatible). Sous le nouveau Ubuntu avec Gnome Shell, il y a 2 sessions, la session Wayland (choix par défaut) et la session Xorg comme alternative. Certains logiciels ne sont pas compatibles avec Wayland mais fonctionneront sous Xorg. C'est le cas par exemple de "Synaptic" ou "Gparted". 

Cela vient du fait que Wayland est plus sécurisé et interdit de lancer une application graphique avec les droits root. 
A noté qu'il y a une méthode de contournement sous Wayland (cf mode avancé/extra partie optimisation, choix 6 "mode fraude wayland").

[à lancer manuellement] => Signifie que le logiciel devra être lancé manuellement depuis le dossier présent dans votre dossier perso (pas de raccourci dans le menu des applications).

### 6/ Contribution

N'hésitez pas à contribuer, par exemple pour :
- corriger des fautes
- ajouter des logiciels utiles manquants

Pour cela il suffit de vous connecter avec votre compte github puis d'éditer le fichier du script (crayon en haut à droite), faire votre ajout/modif puis cliquer sur "Propose file change" et enfin "Pull Request". 
Une fois validé, votre modif sera visible.
