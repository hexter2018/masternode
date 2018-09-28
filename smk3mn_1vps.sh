#/bin/bash

################################################################################
# Author:   Phongthep K
# Date:     July, 29th 2018
# 
# Program:
#
#   Install SMK Coin masternode on clean VPS with Ubuntu 16.04 
#	Need 3 IP on VPS
################################################################################

echo && echo 
echo "****************************************************************************"
echo "*                                                                          *"
echo "*  This script will install and configure your SMK Coin masternode.     *"
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

sudo apt-get install bc git nano rpl wget python-virtualenv -qq -y > /dev/null 2>&1
sudo apt-get install build-essential libtool automake autoconf -qq -y > /dev/null 2>&1
sudo apt-get install autotools-dev autoconf pkg-config libssl-dev -qq -y > /dev/null 2>&1
sudo apt-get install libgmp3-dev libevent-dev bsdmainutils libboost-all-dev -qq -y > /dev/null 2>&1
sudo apt-get install software-properties-common python-software-properties -qq -y > /dev/null 2>&1
sudo add-apt-repository ppa:bitcoin/bitcoin -y > /dev/null 2>&1
sudo apt-get update -qq -y > /dev/null 2>&1
sudo apt-get upgrade -qq -y > /dev/null 2>&1
sudo apt-get install libdb4.8-dev libdb4.8++-dev -qq -y > /dev/null 2>&1
sudo apt-get install libminiupnpc-dev -qq -y > /dev/null 2>&1
sudo apt-get install libzmq5 -qq -y > /dev/null 2>&1
sudo apt-get install virtualenv -qq -y > /dev/null 2>&1
sudo apt-get update -qq -y > /dev/null 2>&1
sudo apt-get upgrade -qq -y > /dev/null 2>&1

sudo apt-get install -y ufw > /dev/null 2>&1
sudo ufw allow ssh/tcp > /dev/null 2>&1
sudo ufw limit ssh/tcp > /dev/null 2>&1
sudo ufw allow 23233/tcp > /dev/null 2>&1
sudo ufw allow 23243/tcp > /dev/null 2>&1
sudo ufw allow 23253/tcp > /dev/null 2>&1
sudo ufw allow 23232/tcp > /dev/null 2>&1
sudo ufw logging on > /dev/null 2>&1
sudo ufw --force enable > /dev/null 2>&1
sudo ufw status > /dev/null 2>&1

sudo apt-get install unzip -y

SMK_LINUX_URL=https://github.com/sharingmarketcoin/sharingmarketcoin/releases/download/v1.0/smk.tar.gz

SMK_RPC_PASS=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 24 ; echo ""`
SMK_RPC_PORT1=23233
SMK_RPC_PORT2=23243
SMK_RPC_PORT3=23253

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
read SMK_USER_PASS

sudo userdel smkmn1
sudo useradd -U -m smkmn1 -s /bin/bash
echo "smkmn1:${SMK_USER_PASS}" | sudo chpasswd

sudo userdel smkmn2
sudo useradd -U -m smkmn2 -s /bin/bash
echo "smkmn2:${SMK_USER_PASS}" | sudo chpasswd

sudo userdel smkmn3
sudo useradd -U -m smkmn3 -s /bin/bash
echo "smkmn3:${SMK_USER_PASS}" | sudo chpasswd

sudo wget $SMK_LINUX_URL --directory-prefix /root/
sudo tar -xvzf /root/smk.tar.gz
sudo rm /root/smk.tar.gz

echo "Copy SMK files to MN1!"
sudo cp /root/smk* /home/smkmn1
sudo chown -R smkmn1:smkmn1 /home/smkmn1/smk*
sudo chmod 755 /home/smkmn1/smk*

echo "Copy SMK files to MN2!"
sudo cp /root/smk* /home/smkmn2
sudo chown -R smkmn2:smkmn2 /home/smkmn2/smk*
sudo chmod 755 /home/smkmn2/smk*

echo "Copy SMK files to MN3!"
sudo cp /root/smk* /home/smkmn3
sudo chown -R smkmn3:smkmn3 /home/smkmn3/smk*
sudo chmod 755 /home/smkmn3/smk*

sudo rm -rf /root/smk*

sudo rm -rf /home/smkmn1/.smk/
CONF_DIR=/home/smkmn1/.smk/
CONF_FILE=smk.conf
mkdir -p $CONF_DIR
echo "rpcuser=smkcoinrpc" >> $CONF_DIR/$CONF_FILE
echo "rpcpassword=${SMK_RPC_PASS}" >> $CONF_DIR/$CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
echo "rpcport=${SMK_RPC_PORT1}" >> $CONF_DIR/$CONF_FILE
echo "port=23232" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "maxconnections=256" >> $CONF_DIR/$CONF_FILE
echo "bind=${IP1}:23232" >> $CONF_DIR/$CONF_FILE
sudo chown -R smkmn1:smkmn1 /home/smkmn1/.smk/
sudo chown 500 /home/smkmn1/.smk/smk.conf

sudo rm -rf /home/smkmn2/.smk/
CONF_DIR=/home/smkmn2/.smk/
CONF_FILE=smk.conf
mkdir -p $CONF_DIR
echo "rpcuser=smkcoinrpc" >> $CONF_DIR/$CONF_FILE
echo "rpcpassword=${SMK_RPC_PASS}" >> $CONF_DIR/$CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
echo "rpcport=${SMK_RPC_PORT2}" >> $CONF_DIR/$CONF_FILE
echo "port=23232" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "maxconnections=256" >> $CONF_DIR/$CONF_FILE
echo "bind=${IP2}:23232" >> $CONF_DIR/$CONF_FILE
sudo chown -R smkmn2:smkmn2 /home/smkmn2/.smk/
sudo chown 500 /home/smkmn2/.smk/smk.conf

sudo rm -rf /home/smkmn3/.smk/
CONF_DIR=/home/smkmn3/.smk/
CONF_FILE=smk.conf
mkdir -p $CONF_DIR
echo "rpcuser=smkcoinrpc" >> $CONF_DIR/$CONF_FILE
echo "rpcpassword=${SMK_RPC_PASS}" >> $CONF_DIR/$CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
echo "rpcport=${SMK_RPC_PORT3}" >> $CONF_DIR/$CONF_FILE
echo "port=23232" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "maxconnections=256" >> $CONF_DIR/$CONF_FILE
echo "bind=${IP3}:23232" >> $CONF_DIR/$CONF_FILE
sudo chown -R smkmn3:smkmn3 /home/smkmn3/.smk/
sudo chown 500 /home/smkmn3/.smk/smk.conf

sudo tee /etc/systemd/system/smkmn1.service <<EOF
[Unit]
Description=SMK Coin, distributed currency daemon
After=syslog.target network.target
[Service]
Type=forking
User=smkmn1
Group=smkmn1
WorkingDirectory=/home/smkmn1/
ExecStart=/home/smkmn1/./smkd
ExecStop=/home/smkmn1/./smk-cli stop
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

sudo tee /etc/systemd/system/smkmn2.service <<EOF
[Unit]
Description=SMK Coin, distributed currency daemon
After=syslog.target network.target
[Service]
Type=forking
User=smkmn2
Group=smkmn2
WorkingDirectory=/home/smkmn2/
ExecStart=/home/smkmn2/./smkd
ExecStop=/home/smkmn2/./smk-cli stop
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

sudo tee /etc/systemd/system/smkmn3.service <<EOF
[Unit]
Description=SMK Coin, distributed currency daemon
After=syslog.target network.target
[Service]
Type=forking
User=smkmn3
Group=smkmn3
WorkingDirectory=/home/smkmn3/
ExecStart=/home/smkmn3/./smkd
ExecStop=/home/smkmn3/./smk-cli stop
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

sudo -H -u smkmn1 /home/smkmn1/./smkd
echo "Booting SMK MN1 and creating keypool"
sleep 10
MNGENKEY1=`sudo -H -u smkmn1 /home/smkmn1/./smk-cli masternode genkey`
echo -e "masternode=1\nmasternodeaddr=${IP1}:23232\nmasternodeprivkey=${MNGENKEY1}" | sudo tee -a /home/smkmn1/.smk/smk.conf
sudo -H -u smkmn1 /home/smkmn1/./smk-cli stop
sudo systemctl enable smkmn1
sudo systemctl start smkmn1

sudo -H -u smkmn2 /home/smkmn2/./smkd
echo "Booting SMK MN2 and creating keypool"
sleep 10
MNGENKEY2=`sudo -H -u smkmn2 /home/smkmn2/./smk-cli masternode genkey`
echo -e "masternode=1\nmasternodeaddr=${IP2}:23232\nmasternodeprivkey=${MNGENKEY2}" | sudo tee -a /home/smkmn2/.smk/smk.conf
sudo -H -u smkmn2 /home/smkmn2/./smk-cli stop
sudo systemctl enable smkmn2
sudo systemctl start smkmn2

sudo -H -u smkmn3 /home/smkmn3/./smkd
echo "Booting SMK MN3 and creating keypool"
sleep 10
MNGENKEY3=`sudo -H -u smkmn3 /home/smkmn3/./smk-cli masternode genkey`
echo -e "masternode=1\nmasternodeaddr=${IP3}:23232\nmasternodeprivkey=${MNGENKEY3}" | sudo tee -a /home/smkmn3/.smk/smk.conf
sudo -H -u smkmn3 /home/smkmn3/./smk-cli stop
sudo systemctl enable smkmn3
sudo systemctl start smkmn3

echo " "
echo " "
echo "==============================="
echo "SMK Coin Masternode installed!"
echo "==============================="
echo "Copy and keep that information in secret:"
echo "masternodeaddr #1 key: ${MNGENKEY1}"
echo "masternodeaddr #2 key: ${MNGENKEY2}"
echo "masternodeaddr #3 key: ${MNGENKEY3}"
echo "SSH password for user \"smkmn1@${IP1},smkmn2@${IP2},smkmn3@${IP3}\": ${SMK_USER_PASS}"
echo "Prepared masternode.conf string:"
echo "MN1 ${IP1}:23232 ${MNGENKEY1} INPUTTX INPUTINDEX"
echo "MN2 ${IP2}:23232 ${MNGENKEY2} INPUTTX INPUTINDEX"
echo "MN3 ${IP3}:23232 ${MNGENKEY3} INPUTTX INPUTINDEX"

exit 0
