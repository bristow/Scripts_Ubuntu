#!/bin/bash
#v1.1

# NE FONCTIONNE PAS ! NE PAS UTILISER MERCI !

# Script pour utilisateur un minimum expérimenté !
# Si vous êtes débutant, n'utilisez pas ce script !

# Uniquement pour la 18.04, aucune garantie de fonctionnement avec une autre version ou une autre distrib !
# Pour pilote nvidia-390, inclus dans les dépots de la 18.04 (cartes nvidia récentes ou relativement récente !)

# ATTENTION : Si vous utilisez une vieille carte, adaptez vous, votre carte n'est peut être pas compatible avec le 390 !!

# Avant de lancer le script, assurez-vous d'être avec le chipset Intel ! Le pilote nvidia ne doit pas être installé, ce script s'en chargera.

# -------------------------------------

# Vérification que le script est lancé avec les bons droits
if [ "$UID" -ne "0" ]
then
  echo "Merci de lancer le script avec les droits admin ==> sudo ./script"
  exit 
fi 

# Vérification de version
. /etc/lsb-release
if [ "$DISTRIB_RELEASE" != "18.04" ] ; then
  echo "Désolé, ce script est fait uniquement pour la version 18.04LTS : Bionic Beaver"
  exit
fi

# Maj
apt update ; apt full-upgrade -y

# Installation Bumblebee
apt install bumblebee bumblebee-nvidia primus linux-headers-generic -y

# Supplément pour support jeu 32 bits :
apt install libgl1-mesa-glx:i386 primus-libs-ia32 -y

# Blacklistage dans fichier de conf
echo "# 390
blacklist nvidia-390
blacklist nvidia-390-updates
blacklist nvidia-experimental-390" >> /etc/modprobe.d/bumblebee.conf

sed -i -e "s/KernelDriver=nvidia/KernelDriver=nvidia-390/g" /etc/bumblebee/bumblebee.conf
sed -i -e "s/nvidia-current/nvidia-390/g" /etc/bumblebee/bumblebee.conf

# Benchmark
apt install mesa-utils -y

# Nettoyage
apt autoremove --purge -y 
apt clean
clear

# Pour terminer...
echo "Installation terminé, un reboot est nécessaire !"
read -p "Voulez-vous redémarrer immédiatement ? [O/n] " rep_reboot
if [ "$rep_reboot" = "O" ] || [ "$rep_reboot" = "o" ] || [ "$rep_reboot" = "" ] ; then
  reboot
fi


# ---------------------------------------------------------------------------------------------------------------
# Usage:

# Lancer une application : optirun application ou primusrun application (il est conseillé d'utiliser primusrun qui est un peu plus performant !)
# Lancer un jeu Steam avec primusrun : dans steam sur le jeu en question faire "clique droit" puis "propriété" puis dans les 
#options de lancement "Set Launch Options" et mettez : primusrun %command%

# Pour un jeu qui n'est pas dans steam, éditez son lanceur en rajoutant le mot "primusrun" devant la commande.
# Les raccourcis se trouvent par défaut dans : /usr/share/applications/  (éditer le fichier .desktop correspondant au niveau de la ligne : Exec=...)
