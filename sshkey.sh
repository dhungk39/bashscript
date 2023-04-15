#!/bin/bash
set -euxo pipefail

# Go to directory /.ssh
cd /$HOME/.ssh/
# create ssh key
ssh-keygen -t rsa
# backup file config ssh
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
# Modify line 42 and line 124 in file ssh_config
sudo sed "42 c AuthorizedKeysFile     .ssh/id_rsa.pub" /etc/ssh/sshd_config > ${HOME}/temp_sshd.txt
sudo sed "124 c PasswordAuthentication no" ${HOME}/temp_sshd.txt
sudo cp ${HOME}/temp_sshd.txt /etc/ssh/sshd_config
sudo rm ${HOME}/temp_sshd.txt
# restart service sshd
sudo systemctl restart sshd.service
#Show key ssh
cat /$HOME/.ssh/id_rsa
