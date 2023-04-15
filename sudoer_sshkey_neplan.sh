#!/bin/bash
set -euo pipefail

################################## FUNCTION CONFIGURE NETWORK ###############################################
function addIP {

read -p 'Nhap ten card mang muon cau hinh: ' IN
while true; do
    read -p 'Nhap vao IP address (xx.xx.xx.xx/xx): ' IP
    if [[  $IP =~ ^([[:digit:]]{1,3}.){3}[[:digit:]]{1,3}/[[:digit:]]{1,2}$ ]]
    then
        echo "done !"
        break
    else
        echo "Ban da nhap sai IP address, xin vui long nhap lai!" >&2
    fi
done
while true; do
    read -p 'Nhap vao gateway (xxx.xxx.xxx): ' GW4
    if [[ $GW4 =~ ^([[:digit:]]{1,3}.){3}[[:digit:]]{1,3}$ ]]
    then
        echo "done!"
        break
    else
        echo "Ban da nhap sai gateway, xin vui long nhap lai!" >&2
    fi
done
while true; do
    read -p 'Nhap vao nameserver (xxx.xxx.xxx.xxx): ' AD

    if [[ $AD =~ ^([[:digit:]]{1,3}.){3}[[:digit:]]{1,3}$ ]]
    then
        echo "done!"
        break
    else
        echo "Ban da nhap sai nameserver, xin vui long nhap lai!" >&2
    fi
done
###################################################
echo "# This is the network config written by 'subiquity'
network:
  ethernets:
    ${IN}:
      addresses:
      - ${IP}
      gateway4: ${GW4}
      nameservers:
        addresses:
        - ${AD}
  version: 2" > /${HOME}/temp_ip.txt

echo "Cau hinh file IP cua ban:\n"
cat /${HOME}/temp_ip.txt

read -p "Nhan Y de apply cau hinh, nhan N de huy apply: " YN
case $YN in

  "Y")
    echo "apply"
    sudo cp /${HOME}/temp_ip.txt /etc/netplan/00-installer-config.yaml
    sudo rm /${HOME}/temp_ip.txt
    sudo netplan try
    ;;
  "N")
    echo "no apply"
    ;;
  *)
    echo "Ban da nhap sai cu phap!"
    ;;
esac

}

####################################### FUNCTION CONFIGURE PERMISSION SUDOER ############################################

function addsudoer {
	sudo cp /etc/sudoers /etc/sudoers.bak
	sudo sed "27 c ${USER}   ALL=(ALL) NOPASSWD:ALL" /etc/sudoers > ${HOME}/temp_sudoers.txt
	sudo cp ${HOME}/temp_sudoers.txt /etc/sudoers
	rm ${HOME}/temp_sudoers.txt
}

###################################### FUNCTION CONFIGURE SSH-KEY ######################################################

function addsshkey {
	cd /$HOME/.ssh/
	ssh-keygen -t rsa
	sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
	sudo sed "42 c AuthorizedKeysFile     .ssh/id_rsa.pub" /etc/ssh/sshd_config > ${HOME}/temp_sshd.txt
	sudo sed "124 c PasswordAuthentication no" ${HOME}/temp_sshd.txt
	sudo cp ${HOME}/temp_sshd.txt /etc/ssh/sshd_config
	sudo rm ${HOME}/temp_sshd.txt
	sudo systemctl restart sshd.service
	cat /$HOME/.ssh/id_rsa
}

#################################### MAIN #############################################################################
echo "Option: 1-configure network"
echo "Option: 2-configure file sudoer"
echo "Option: 3-configure ssh-key"
while true; do
    read -p "Nhap vap gia tri ban muon thiet lap: " i
        case $i in

          1)
            addIP
	    echo "add IP finish"
	    break
            ;;
          2)
            addsudoer
	    echo "add permission sudoer finish"
	    break
            ;;
          3)
            addsshkey
	    echo "add ssh-key finish"
	    break
            ;;
          *)
            echo "Ban da nhap sai cu phap!"
            ;;
        esac
done
