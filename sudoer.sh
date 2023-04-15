#!/bin/bash

#backup file sudoers
sudo cp /etc/sudoers /etc/sudoers.bak
#Add permisson to curent user
sudo sed "27 c ${USER}   ALL=(ALL) NOPASSWD:ALL" /etc/sudoers > ${HOME}/temp_sudoers.txt
sudo cp ${HOME}/temp_sudoers.txt /etc/sudoers
rm ${HOME}/temp_sudoers.txt
