#/bin/bash

################################################################################
# Author:   Phongthep K
# Date:     July, 27th 2018
# 
# Program:
#
#   Install GOSSIP Coin masternode on clean VPS with Ubuntu 16.04 
#	Need 3 IP on VPS
################################################################################

echo && echo 
echo "****************************************************************************"
echo "*                                                                          *"
echo "*  This script will install and configure your GOSSIP Coin masternode.     *"
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

GOSSIP_LINUX_URL=https://github.com/g0ssipcoin/GossipCoinCore/releases/download/v1.1.0.0/Linux-gossipcoin.zip

GOSSIP_RPC_PASS=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 24 ; echo ""`
GOSSIP_RPC_PORT1=22122
GOSSIP_RPC_PORT2=22132
GOSSIP_RPC_PORT3=22142

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
read GOSSIP_USER_PASS

sudo userdel gossipmn1
sudo useradd -U -m gossipmn1 -s /bin/bash
echo "gossipmn1:${GOSSIP_USER_PASS}" | sudo chpasswd

sudo userdel gossipmn2
sudo useradd -U -m gossipmn2 -s /bin/bash
echo "gossipmn2:${GOSSIP_USER_PASS}" | sudo chpasswd

sudo userdel gossipmn3
sudo useradd -U -m gossipmn3 -s /bin/bash
echo "gossipmn3:${GOSSIP_USER_PASS}" | sudo chpasswd

sudo wget $GOSSIP_LINUX_URL --directory-prefix /root/
sudo unzip /root/Linux-gossipcoin.zip
sudo rm /root/Linux-gossipcoin.zip

echo "Copy GOSSIP files to MN1!"
sudo cp /root/gossipcoin* /home/gossipmn1
sudo chown -R gossipmn1:gossipmn1 /home/gossipmn1/gossipcoin*
sudo chmod 755 gossipcoin*

echo "Copy GOSSIP files to MN2!"
sudo cp /root/gossipcoin* /home/gossipmn2
sudo chown -R gossipmn2:gossipmn2 /home/gossipmn2/gossipcoin*
sudo chmod 755 gossipcoin*

echo "Copy GOSSIP files to MN3!"
sudo cp /root/gossipcoin* /home/gossipmn3
sudo chown -R gossipmn3:gossipmn3 /home/gossipmn3/gossipcoin*
sudo chmod 755 gossipcoin*

sudo rm /root/gossipcoin*

sudo rm -rf /home/gossipmn1/.gossipcoin/
CONF_DIR=/home/gossipmn1/.gossipcoin/
CONF_FILE=gossipcoin.conf
mkdir -p $CONF_DIR
echo "rpcuser=gossipcoinrpc" >> $CONF_DIR/$CONF_FILE
echo "rpcpassword=${GOSSIP_RPC_PASS}" >> $CONF_DIR/$CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
echo "rpcport=${GOSSIP_RPC_PORT1}" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "maxconnections=256" >> $CONF_DIR/$CONF_FILE
echo "port=22123" >> $CONF_DIR/$CONF_FILE
echo "bind=${IP1}:22123" >> $CONF_DIR/$CONF_FILE
sudo chown -R gossipmn1:gossipmn1 /home/gossipmn1/.gossipcoin/
sudo chown 500 /home/gossipmn1/.gossipcoin/gossipcoin.conf

sudo rm -rf /home/gossipmn2/.gossipcoin/
CONF_DIR=/home/gossipmn2/.gossipcoin/
CONF_FILE=gossipcoin.conf
mkdir -p $CONF_DIR
echo "rpcuser=gossipcoinrpc" >> $CONF_DIR/$CONF_FILE
echo "rpcpassword=${GOSSIP_RPC_PASS}" >> $CONF_DIR/$CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
echo "rpcport=${GOSSIP_RPC_PORT2}" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "maxconnections=256" >> $CONF_DIR/$CONF_FILE
echo "port=22123" >> $CONF_DIR/$CONF_FILE
echo "bind=${IP2}:22123" >> $CONF_DIR/$CONF_FILE
sudo chown -R gossipmn2:gossipmn2 /home/gossipmn2/.gossipcoin/
sudo chown 500 /home/gossipmn2/.gossipcoin/gossipcoin.conf

sudo rm -rf /home/gossipmn3/.gossipcoin/
CONF_DIR=/home/gossipmn3/.gossipcoin/
CONF_FILE=gossipcoin.conf
mkdir -p $CONF_DIR
echo "rpcuser=gossipcoinrpc" >> $CONF_DIR/$CONF_FILE
echo "rpcpassword=${GOSSIP_RPC_PASS}" >> $CONF_DIR/$CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
echo "rpcport=${GOSSIP_RPC_PORT3}" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "maxconnections=256" >> $CONF_DIR/$CONF_FILE
echo "port=22123" >> $CONF_DIR/$CONF_FILE
echo "bind=${IP3}:22123" >> $CONF_DIR/$CONF_FILE
sudo chown -R gossipmn3:gossipmn3 /home/gossipmn3/.gossipcoin/
sudo chown 500 /home/gossipmn3/.gossipcoin/gossipcoin.conf

sudo tee /etc/systemd/system/gossipmn1.service <<EOF
[Unit]
Description=GOSSIP Coin, distributed currency daemon
After=syslog.target network.target

[Service]
Type=forking
User=gossipmn1
Group=gossipmn1
WorkingDirectory=/home/gossipmn1/
ExecStart=/home/gossipmn1/./gossipcoind
ExecStop=/home/gossipmn1/./gossipcoin-cli stop

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

sudo tee /etc/systemd/system/gossipmn2.service <<EOF
[Unit]
Description=GOSSIP Coin, distributed currency daemon
After=syslog.target network.target

[Service]
Type=forking
User=gossipmn2
Group=gossipmn2
WorkingDirectory=/home/gossipmn2/
ExecStart=/home/gossipmn2/./gossipcoind
ExecStop=/home/gossipmn2/./gossipcoin-cli stop

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

sudo tee /etc/systemd/system/gossipmn3.service <<EOF
[Unit]
Description=GOSSIP Coin, distributed currency daemon
After=syslog.target network.target

[Service]
Type=forking
User=gossipmn3
Group=gossipmn3
WorkingDirectory=/home/gossipmn3/
ExecStart=/home/gossipmn3/./gossipcoind
ExecStop=/home/gossipmn3/./gossipcoin-cli stop

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

sudo -H -u gossipmn1 /home/gossipmn1/./gossipcoind
echo "Booting GOSSIP MN1 and creating keypool"
sleep 10
MNGENKEY1=`sudo -H -u gossipmn1 /home/gossipmn1/./gossipcoin-cli masternode genkey`
echo -e "#masternode=1\n#masternodeaddress=${IP1}:22123\n#masternodeprivkey=${MNGENKEY1}" | sudo tee -a /home/gossipmn1/.gossipcoin/gossipcoin.conf
sudo -H -u gossipmn1 /home/gossipmn1/./gossipcoin-cli stop
sudo systemctl enable gossipmn1
sudo systemctl start gossipmn1

sudo -H -u gossipmn2 /home/gossipmn2/./gossipcoind
echo "Booting GOSSIP MN2 and creating keypool"
sleep 10
MNGENKEY1=`sudo -H -u gossipmn2 /home/gossipmn2/./gossipcoin-cli masternode genkey`
echo -e "#masternode=1\n#masternodeaddress=${IP2}:22123\n#masternodeprivkey=${MNGENKEY1}" | sudo tee -a /home/gossipmn2/.gossipcoin/gossipcoin.conf
sudo -H -u gossipmn2 /home/gossipmn2/./gossipcoin-cli stop
sudo systemctl enable gossipmn2
sudo systemctl start gossipmn2

sudo -H -u gossipmn3 /home/gossipmn3/./gossipcoind
echo "Booting GOSSIP MN3 and creating keypool"
sleep 10
MNGENKEY1=`sudo -H -u gossipmn3 /home/gossipmn3/./gossipcoin-cli masternode genkey`
echo -e "#masternode=1\n#masternodeaddress=${IP3}:22123\n#masternodeprivkey=${MNGENKEY1}" | sudo tee -a /home/gossipmn3/.gossipcoin/gossipcoin.conf
sudo -H -u gossipmn3 /home/gossipmn3/./gossipcoin-cli stop
sudo systemctl enable gossipmn3
sudo systemctl start gossipmn3

echo " "
echo " "
echo "==============================="
echo "GOSSIP Coin Masternode installed!"
echo "==============================="
echo "Copy and keep that information in secret:"
echo "Masternode #1 key: ${MNGENKEY1}"
echo "Masternode #2 key: ${MNGENKEY2}"
echo "Masternode #3 key: ${MNGENKEY3}"
echo "SSH password for user \"gossipmn1@${IP1},gossipmn2@${IP2},gossipmn3@${IP3}\": ${GOSSIP_USER_PASS}"
echo "Prepared masternode.conf string:"
echo "MN1 ${IP1}:43452 ${MNGENKEY1} INPUTTX INPUTINDEX"
echo "MN2 ${IP2}:43452 ${MNGENKEY2} INPUTTX INPUTINDEX"
echo "MN3 ${IP3}:43452 ${MNGENKEY3} INPUTTX INPUTINDEX"

exit 0



