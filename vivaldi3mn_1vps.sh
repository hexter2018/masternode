#/bin/bash

################################################################################
# Author:   Phongthep K
# Date:     July, 29th 2018
# 
# Program:
#
#   Install VIVALDI Coin masternode on clean VPS with Ubuntu 16.04 
#	Need 3 IP on VPS
################################################################################

echo && echo 
echo "****************************************************************************"
echo "*                                                                          *"
echo "*  This script will install and configure your VIVALDI Coin masternode.     *"
echo "*                                                                          *"
echo "****************************************************************************"
echo && echo

#set -o errexit

cd ~
sudo locale-gen en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

sudo apt-get install unzip -y

COINDOWNLOADLINK1=https://github.com/VivaldiCoin/Vivaldi/releases/download/v1.1.1.1/vivaldid
COINDOWNLOADLINK2=https://github.com/VivaldiCoin/Vivaldi/releases/download/v1.1.1.1/vivaldi-cli

VIVALDI_RPC_PASS=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 24 ; echo ""`
VIVALDI_RPC_PORT1=27329
VIVALDI_RPC_PORT2=27339
VIVALDI_RPC_PORT3=27349

echo "Type the IP #1 of this server, followed by [ENTER]:"
read IP1
echo ""
echo "Type the IP #2 of this server, followed by [ENTER]:"
read IP2
echo ""
echo "Type the IP #3 of this server, followed by [ENTER]:"
read IP3
echo ""
echo "Enter Masternode Account Login Password"
read VIVALDI_USER_PASS

sudo userdel vivaldimn1
sudo useradd -U -m vivaldimn1 -s /bin/bash
echo "vivaldimn1:${VYIGRAT_USER_PASS}" | sudo chpasswd

sudo userdel vivaldimn2
sudo useradd -U -m vivaldimn2 -s /bin/bash
echo "vivaldimn2:${VYIGRAT_USER_PASS}" | sudo chpasswd

sudo userdel vivaldimn3
sudo useradd -U -m vivaldimn3 -s /bin/bash
echo "vivaldimn3:${VYIGRAT_USER_PASS}" | sudo chpasswd

sudo wget $COINDOWNLOADLINK1 --directory-prefix /root/
sudo wget $COINDOWNLOADLINK2 --directory-prefix /root/


echo "Copy VYIGRAT files to MN1!"
sudo cp /root/vivaldi* /home/vivaldimn1
sudo chown -R vivaldimn1:vivaldimn1 /home/vivaldimn1/vivaldi*
sudo chmod 755 /home/vivaldimn1/vivaldi*

echo "Copy VYIGRAT files to MN2!"
sudo cp /root/vivaldi* /home/vivaldimn2
sudo chown -R vivaldimn2:vivaldimn2 /home/vivaldimn2/vivaldi*
sudo chmod 755 /home/vivaldimn2/vivaldi*

echo "Copy VYIGRAT files to MN3!"
sudo cp /root/vivaldi* /home/vivaldimn3
sudo chown -R vivaldimn3:vivaldimn3 /home/vivaldimn3/vivaldi*
sudo chmod 755 /home/vivaldimn3/vivaldi*

sudo rm -rf /root/vivaldi*

sudo rm -rf /home/vivaldimn1/.vivaldi/
CONF_DIR=/home/vivaldimn1/.vivaldi/
CONF_FILE=vivaldi.conf
mkdir -p $CONF_DIR
echo "rpcuser=vivaldicoinrpc" >> $CONF_DIR/$CONF_FILE
echo "rpcpassword=${VYIGRAT_RPC_PASS}" >> $CONF_DIR/$CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
echo "rpcport=${VYIGRAT_RPC_PORT1}" >> $CONF_DIR/$CONF_FILE
echo "port=22733" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "maxconnections=256" >> $CONF_DIR/$CONF_FILE
echo "bind=${IP1}:22733" >> $CONF_DIR/$CONF_FILE
sudo chown -R vivaldimn1:vivaldimn1 /home/vivaldimn1/.vivaldi/
sudo chown 500 /home/vivaldimn1/.vivaldi/vivaldi.conf

sudo rm -rf /home/vivaldimn2/.vivaldi/
CONF_DIR=/home/vivaldimn2/.vivaldi/
CONF_FILE=vivaldi.conf
mkdir -p $CONF_DIR
echo "rpcuser=vivaldicoinrpc" >> $CONF_DIR/$CONF_FILE
echo "rpcpassword=${VYIGRAT_RPC_PASS}" >> $CONF_DIR/$CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
echo "rpcport=${VYIGRAT_RPC_PORT2}" >> $CONF_DIR/$CONF_FILE
echo "port=22733" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "maxconnections=256" >> $CONF_DIR/$CONF_FILE
echo "bind=${IP2}:22733" >> $CONF_DIR/$CONF_FILE
sudo chown -R vivaldimn2:vivaldimn2 /home/vivaldimn2/.vivaldi/
sudo chown 500 /home/vivaldimn2/.vivaldi/vivaldi.conf

sudo rm -rf /home/vivaldimn3/.vivaldi/
CONF_DIR=/home/vivaldimn3/.vivaldi/
CONF_FILE=vivaldi.conf
mkdir -p $CONF_DIR
echo "rpcuser=vivaldicoinrpc" >> $CONF_DIR/$CONF_FILE
echo "rpcpassword=${VYIGRAT_RPC_PASS}" >> $CONF_DIR/$CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
echo "rpcport=${VYIGRAT_RPC_PORT3}" >> $CONF_DIR/$CONF_FILE
echo "port=22733" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "maxconnections=256" >> $CONF_DIR/$CONF_FILE
echo "bind=${IP3}:22733" >> $CONF_DIR/$CONF_FILE
sudo chown -R vivaldimn3:vivaldimn3 /home/vivaldimn3/.vivaldi/
sudo chown 500 /home/vivaldimn3/.vivaldi/vivaldi.conf

sudo tee /etc/systemd/system/vivaldimn1.service <<EOF
[Unit]
Description=VYIGRAT Coin, distributed currency daemon
After=syslog.target network.target
[Service]
Type=forking
User=vivaldimn1
Group=vivaldimn1
WorkingDirectory=/home/vivaldimn1/
ExecStart=/home/vivaldimn1/vivaldid
ExecStop=/home/vivaldimn1/vivaldi-cli stop
Restart=on-failure
RestartSec=120
PrivateTmp=true
TimeoutStopSec=120
TimeoutStartSec=120
StartLimitInterval=120
StartLimitBurst=3
[Install]
WantedBy=multi-user.target
EOF

sudo tee /etc/systemd/system/vivaldimn2.service <<EOF
[Unit]
Description=VYIGRAT Coin, distributed currency daemon
After=syslog.target network.target
[Service]
Type=forking
User=vivaldimn2
Group=vivaldimn2
WorkingDirectory=/home/vivaldimn2/
ExecStart=/home/vivaldimn2/vivaldid
ExecStop=/home/vivaldimn2/vivaldi-cli stop
Restart=on-failure
RestartSec=120
PrivateTmp=true
TimeoutStopSec=120
TimeoutStartSec=120
StartLimitInterval=120
StartLimitBurst=3
[Install]
WantedBy=multi-user.target
EOF

sudo tee /etc/systemd/system/vivaldimn3.service <<EOF
[Unit]
Description=VYIGRAT Coin, distributed currency daemon
After=syslog.target network.target
[Service]
Type=forking
User=vivaldimn3
Group=vivaldimn3
WorkingDirectory=/home/vivaldimn3/
ExecStart=/home/vivaldimn3/vivaldid
ExecStop=/home/vivaldimn3/vivaldi-cli stop
Restart=on-failure
RestartSec=120
PrivateTmp=true
TimeoutStopSec=120
TimeoutStartSec=120
StartLimitInterval=120
StartLimitBurst=3
[Install]
WantedBy=multi-user.target
EOF

sudo -H -u vivaldimn1 /home/vivaldimn1/vivaldid
echo "Booting VYIGRAT MN1 and creating keypool"
sleep 10
MNGENKEY1=`sudo -H -u vivaldimn1 /home/vivaldimn1/vivaldi-cli masternode genkey`
echo -e "masternode=1\nmasternodeaddr=${IP1}:22733\nmasternodeprivkey=${MNGENKEY1}" | sudo tee -a /home/vivaldimn1/.vivaldi/vivaldi.conf
sudo -H -u vivaldimn1 /home/vivaldimn1/vivaldi-cli stop
sudo systemctl enable vivaldimn1
sudo systemctl start vivaldimn1

sudo -H -u vivaldimn2 /home/vivaldimn2/vivaldid
echo "Booting VYIGRAT MN2 and creating keypool"
sleep 10
MNGENKEY2=`sudo -H -u vivaldimn2 /home/vivaldimn2/vivaldi-cli masternode genkey`
echo -e "masternode=1\nmasternodeaddr=${IP2}:22733\nmasternodeprivkey=${MNGENKEY2}" | sudo tee -a /home/vivaldimn2/.vivaldi/vivaldi.conf
sudo -H -u vivaldimn2 /home/vivaldimn2/vivaldi-cli stop
sudo systemctl enable vivaldimn2
sudo systemctl start vivaldimn2

sudo -H -u vivaldimn3 /home/vivaldimn3/vivaldid
echo "Booting VYIGRAT MN3 and creating keypool"
sleep 10
MNGENKEY3=`sudo -H -u vivaldimn3 /home/vivaldimn3/vivaldi-cli masternode genkey`
echo -e "masternode=1\nmasternodeaddr=${IP3}:22733\nmasternodeprivkey=${MNGENKEY3}" | sudo tee -a /home/vivaldimn3/.vivaldi/vivaldi.conf
sudo -H -u vivaldimn3 /home/vivaldimn3/vivaldi-cli stop
sudo systemctl enable vivaldimn3
sudo systemctl start vivaldimn3

echo " "
echo " "
echo "==============================="
echo "VYIGRAT Coin Masternode installed!"
echo "==============================="
echo "Copy and keep that information in secret:"
echo "masternodeaddr #1 key: ${MNGENKEY1}"
echo "masternodeaddr #2 key: ${MNGENKEY2}"
echo "masternodeaddr #3 key: ${MNGENKEY3}"
echo "SSH password for user \"vivaldimn1@${IP1},vivaldimn2@${IP2},vivaldimn3@${IP3}\": ${VYIGRAT_USER_PASS}"
echo "Prepared masternode.conf string:"
echo "MN1 ${IP1}:22733 ${MNGENKEY1} INPUTTX INPUTINDEX"
echo "MN2 ${IP2}:22733 ${MNGENKEY2} INPUTTX INPUTINDEX"
echo "MN3 ${IP3}:22733 ${MNGENKEY3} INPUTTX INPUTINDEX"

sudo apt-get install -y ufw
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw allow 27329/tcp
sudo ufw allow 27339/tcp
sudo ufw allow 27349/tcp
sudo ufw allow 22733/tcp
sudo ufw logging on
sudo ufw --force enable
sudo ufw status

exit 0
