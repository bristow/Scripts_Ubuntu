#!/bin/bash

# Installation TLP
apt --no-install-recommends install tlp -y

# Pour gérer l'économie d'énergie des périphérique wifi, BT..., ajouter : sudo apt install tlp-rdw -y
# (RDW = Radio Device Wizard)

tlp start
systemctl enable tlp
systemctl enable tlp-sleep

# Pour désactiver Bluethooth au démarrage :
#(idéalement à placer juste après : # Radio devices to disable on startup: bluetooth wifi wwan)
echo 'DEVICES_TO_DISABLE_ON_STARTUP="bluetooth"' >> /etc/default/tlp 
# + éventuellement : sudo update-rc.d -f bluetooth remove


# Pour lire les info qui passe concernant TLP : sudo tlp-stat
# Pour être sûr qu'il est activé : sudo tlp-stat | grep "TLP"

# Doc TLP : http://linrunner.de/en/tlp/docs/tlp-configuration.html

# Pour le contrôle du ventilateur cpu : sudo apt install lm-sensors -y
# cf doc arch pour modifier paramètre : https://wiki.archlinux.org/index.php/Fan_speed_control#Fancontrol_.28lm-sensors.29
