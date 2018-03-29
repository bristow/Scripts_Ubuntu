#!/bin/bash
# Script à lancer avec sudo !
# Ce script sert à automatiser l'installation du logiciel d'astronomie "Celestia" pour Ubuntu 18.04 Bionic Beaver X64

# Testé/Validé pour Ubuntu 18.04LTS Bionic Beaver X64 avec Gnome Shell 

# Récupération dépendance manquante 
#wget http://mirrors.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb  ## pb avec le mirroir
wget http://nux87.free.fr/script-postinstall-ubuntu/deb/libpng12amd64.deb
dpkg -i libpng12*

# Autres paquets nécessaires
apt install liblua5.1-0 freeglut3 libgtkglext1 libgnome2-0 libgnomeui-0 -y

#Récup célestia
wget http://nux87.free.fr/script-postinstall-ubuntu/deb/celestia-common1.6.1all.deb
wget http://nux87.free.fr/script-postinstall-ubuntu/deb/celestia-gnome1.6.1amd64.deb
dpkg -i celestia*
apt install -fy

#nettoyage
rm libpng12-0_1.2.54-1ubuntu1_amd64.deb celestia*
clear
