#/bin/bash

################################################################################
# Author:   Phongthep K
# Date:     July, 29th 2018
# 
# Program:
#
#   Install TELOS Coin masternode on clean VPS with Ubuntu 16.04 
#	Need 3 IP on VPS
################################################################################

echo && echo 
echo "****************************************************************************"
echo "*                                                                          *"
echo "*  This script will install and configure your TELOS Coin masternode.     *"
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

TELOS_LINUX_URL=https://github.com/phoenixkonsole/transcendence/releases/download/v1.1.0.0/Linux.zip

TELOS_RPC_PASS=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 24 ; echo ""`
TELOS_RPC_PORT1=22124

echo "Type the IP #1 of this server, followed by [ENTER]:"
read IP1
echo ""
echo "Enter Masternode Account Login Password"
read TELOS_USER_PASS

sudo userdel telosmn
sudo useradd -U -m telosmn -s /bin/bash
echo "telosmn:${TELOS_USER_PASS}" | sudo chpasswd

sudo wget $TELOS_LINUX_URL --directory-prefix /root/
sudo unzip /root/Linux.zip
sudo rm /root/Linux.zip

echo "Copy TELOS files to MN!"
sudo cp /root/Linux/bin/transcendence* /home/telosmn
sudo chown -R telosmn:telosmn /home/telosmn/transcendence*
sudo chmod 755 /home/telosmn/transcendence*

sudo rm -rf /root/Linux/

sudo rm -rf /home/telosmn/.transcendence/
CONF_DIR=/home/telosmn/.transcendence/
CONF_FILE=transcendence.conf
mkdir -p $CONF_DIR
echo "rpcuser=transcendencerpc" >> $CONF_DIR/$CONF_FILE
echo "rpcpassword=${TELOS_RPC_PASS}" >> $CONF_DIR/$CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
echo "rpcport=${TELOS_RPC_PORT1}" >> $CONF_DIR/$CONF_FILE
echo "port=22123" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "maxconnections=256" >> $CONF_DIR/$CONF_FILE
echo "bind=${IP1}:22123" >> $CONF_DIR/$CONF_FILE
sudo chown -R telosmn:telosmn /home/telosmn/.transcendence/
sudo chown 500 /home/telosmn/.transcendence/transcendence.conf

sudo tee /etc/systemd/system/telosmn.service <<EOF
[Unit]
Description=TELOS Coin, distributed currency daemon
After=syslog.target network.target
[Service]
Type=forking
User=telosmn
Group=telosmn
WorkingDirectory=/home/telosmn/
ExecStart=/home/telosmn/transcendenced
ExecStop=/home/telosmn/transcendence-cli stop
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

sudo -H -u telosmn /home/telosmn/transcendenced
echo "Booting TELOS MN and creating keypool"
sleep 10
MNGENKEY1=`sudo -H -u telosmn /home/telosmn/transcendence-cli masternode genkey`
echo -e "masternode=1\nmasternodeaddr=${IP1}:12698\nmasternodeprivkey=${MNGENKEY1}" | sudo tee -a /home/telosmn/.transcendence/transcendence.conf
sudo -H -u telosmn /home/telosmn/transcendence-cli stop
sudo systemctl enable telosmn
sudo systemctl start telosmn

echo " "
echo " "
echo "==============================="
echo "TELOS Coin Masternode installed!"
echo "==============================="
echo "Copy and keep that information in secret:"
echo "masternodeaddr #1 key: ${MNGENKEY1}"
echo "SSH password for user \"telosmn@${IP1}\": ${TELOS_USER_PASS}"
echo "Prepared masternode.conf string:"
echo "MN1 ${IP1}:22123 ${MNGENKEY1} INPUTTX INPUTINDEX"

exit 0
