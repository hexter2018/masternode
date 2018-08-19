#!/bin/bash

echo && echo 
echo "****************************************************************************"
echo "*                                                                          *"
echo "*  This script will updaten latest version of STAMP Coin for masternode.   *"
echo "*                                                                          *"
echo "****************************************************************************"
echo && echo

cd ~
rm -rf chainstate/ blocks/ chain.tar.gz*

sudo systemctl stop stampmn1
sudo systemctl stop stampmn2
sudo systemctl stop stampmn3
sleep 10

sudo wget https://github.com/zSAM-Project/stamp/releases/download/masternode/chain.tar.gz
sudo tar -xzvf chain.tar.gz

sudo rm -rf /home/stampmn1/.stamp/blocks 
sudo rm -rf /home/stampmn1/.stamp/chainstate 

sudo rm -rf /home/stampmn2/.stamp/blocks 
sudo rm -rf /home/stampmn2/.stamp/chainstate 

sudo rm -rf /home/stampmn3/.stamp/blocks 
sudo rm -rf /home/stampmn3/.stamp/chainstate 

sudo cp -r blocks/ /home/stampmn1/.stamp/
sudo cp -r blocks/ /home/stampmn2/.stamp/
sudo cp -r blocks/ /home/stampmn3/.stamp/

sudo cp -r chainstate/ /home/stampmn1/.stamp/
sudo cp -r chainstate/ /home/stampmn2/.stamp/
sudo cp -r chainstate/ /home/stampmn3/.stamp/

sudo rm /home/stampmn1/.stamp/peers.dat 
sudo rm /home/stampmn2/.stamp/peers.dat 
sudo rm /home/stampmn3/.stamp/peers.dat 

sudo rm /home/stampmn1/.stamp/banlist.dat 
sudo rm /home/stampmn2/.stamp/banlist.dat 
sudo rm /home/stampmn3/.stamp/banlist.dat 

sudo chown -R stampmn1:stampmn1 /home/stampmn1/.stamp/blocks
sudo chown -R stampmn1:stampmn1 /home/stampmn1/.stamp/chainstate

sudo chown -R stampmn2:stampmn2 /home/stampmn2/.stamp/blocks
sudo chown -R stampmn2:stampmn2 /home/stampmn2/.stamp/chainstate

sudo chown -R stampmn3:stampmn3 /home/stampmn3/.stamp/blocks
sudo chown -R stampmn3:stampmn3 /home/stampmn3/.stamp/chainstate

sudo systemctl start stampmn1
sudo systemctl start stampmn2
sudo systemctl start stampmn3
sleep 30
INFO1=`sudo -H -u stampmn1 /home/stampmn1/stamp-cli getinfo`
INFO2=`sudo -H -u stampmn2 /home/stampmn2/stamp-cli getinfo`
INFO3=`sudo -H -u stampmn3 /home/stampmn3/stamp-cli getinfo`

echo " "
echo " "
echo "==============================="
echo "STAMP Coin MN1 updated!        "
echo "==============================="
echo "${INFO1}"
echo " "
echo "==============================="
echo "STAMP Coin MN2 updated!        "
echo "==============================="
echo "${INFO2}"
echo " "
echo "==============================="
echo "STAMP Coin MN3 updated!        "
echo "==============================="
echo "${INFO3}"

exit 0
