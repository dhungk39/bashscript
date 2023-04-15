#!/bin/bash
set -euxo pipefail

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
    read -p 'Nhap vao gateway (xxx.xxx.xxx.xxx): ' GW4
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
