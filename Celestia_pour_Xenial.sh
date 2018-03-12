#!/bin/bash

# Le but de ce script est d'installer le logiciel "Celestia" (par défaut Celestia-Gnome) sur une base Ubuntu 16.04 en 64 bits (et variantes).

##################################################################
# Vérification que le script est bien lancé avec les droits admin
##################################################################
if [ "$UID" -ne "0" ]
then
  echo "Vous n'avez pas les bons droits, merci de lancer le script avec sudo !"
  exit 
fi 

UBUNTU_MIRROR=https://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/universe/c/celestia

# common
apt install -y liblua5.1-0
wget "${UBUNTU_MIRROR}"/celestia-common_1.6.1+dfsg-3.1_all.deb
dpkg -i celestia-common_1.6.1+dfsg-3.1_all.deb
apt install -y celestia-common-nonfree

# Pour celestia-glut  ## désactivé par défaut
#wget "${UBUNTU_MIRROR}"/celestia-glut_1.6.1+dfsg-3.1_amd64.deb
#apt install -y freeglut3
#dpkg -i celestia-glut_1.6.1+dfsg-3.1_amd64.deb

# Pour celestia-gnome ## activé par défaut
wget "${UBUNTU_MIRROR}"/celestia-gnome_1.6.1+dfsg-3.1_amd64.deb
apt install -y libgtkglext1 libgnome2-0 libgnomeui-0
dpkg -i celestia-gnome_1.6.1+dfsg-3.1_amd64.deb
apt install -fy
