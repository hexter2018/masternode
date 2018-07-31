#/bin/bash

################################################################################
# Author:   Phongthep K
# Date:     July, 27th 2018
# 
# Program:
#
#   Install TELOS  Coin masternode on clean VPS with Ubuntu 16.04 
#	Need 3 IP on VPS
################################################################################

echo && echo 
echo "****************************************************************************"
echo "*                                                                          *"
echo "*  This script will install and configure your TELOS  Coin masternode.     *"
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
TELOS_RPC_PORT1=22122
TELOS_RPC_PORT2=22132
TELOS_RPC_PORT3=22142

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
read TELOS_USER_PASS

sudo userdel telosmn1
sudo useradd -U -m telosmn1 -s /bin/bash
echo "telosmn1:${TELOS_USER_PASS}" | sudo chpasswd

sudo userdel telosmn2
sudo useradd -U -m telosmn2 -s /bin/bash
echo "telosmn2:${TELOS_USER_PASS}" | sudo chpasswd

sudo userdel telosmn3
sudo useradd -U -m telosmn3 -s /bin/bash
echo "telosmn3:${TELOS_USER_PASS}" | sudo chpasswd

sudo wget $TELOS_LINUX_URL --directory-prefix /root/
sudo unzip /root/Linux.zip
sudo rm /root/Linux.zip

echo "Copy TELOS files to MN1!"
sudo cp /root/Linux/bin/transcendence* /home/telosmn1
sudo chown -R telosmn1:telosmn1 /home/telosmn1/transcendence*
sudo chmod 755 /home/telosmn1/transcendence*

echo "Copy TELOS files to MN2!"
sudo cp /root/Linux/bin/transcendence* /home/telosmn2
sudo chown -R telosmn2:telosmn2 /home/telosmn2/transcendence*
sudo chmod 755 /home/telosmn2/transcendence*

echo "Copy TELOS files to MN3!"
sudo cp /root/Linux/bin/transcendence* /home/telosmn3
sudo chown -R telosmn3:telosmn3 /home/telosmn3/transcendence*
sudo chmod 755 /home/telosmn3/transcendence*

sudo rm -rf /root/Linux/

sudo rm -rf /home/telosmn1/.transcendence/
CONF_DIR=/home/telosmn1/.transcendence/
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
echo "bind=${IP1}:22123" >> $CONF_DIR/$CONF_FILE
echo "logtimestamps=1" >> $CONF_DIR/$CONF_FILE
echo "maxconnections=256" >> $CONF_DIR/$CONF_FILE
sudo chown -R telosmn1:telosmn1 /home/telosmn1/.transcendence/
sudo chown 500 /home/telosmn1/.transcendence/transcendence.conf

sudo rm -rf /home/telosmn2/.transcendence/
CONF_DIR=/home/telosmn2/.transcendence/
CONF_FILE=transcendence.conf
mkdir -p $CONF_DIR
echo "rpcuser=transcendencerpc" >> $CONF_DIR/$CONF_FILE
echo "rpcpassword=${TELOS_RPC_PASS}" >> $CONF_DIR/$CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
echo "rpcport=${TELOS_RPC_PORT2}" >> $CONF_DIR/$CONF_FILE
echo "port=22123" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "bind=${IP2}:22123" >> $CONF_DIR/$CONF_FILE
echo "logtimestamps=1" >> $CONF_DIR/$CONF_FILE
echo "maxconnections=256" >> $CONF_DIR/$CONF_FILE
sudo chown -R telosmn2:telosmn2 /home/telosmn2/.transcendence/
sudo chown 500 /home/telosmn2/.transcendence/transcendence.conf

sudo rm -rf /home/telosmn3/.transcendence/
CONF_DIR=/home/telosmn3/.transcendence/
CONF_FILE=transcendence.conf
mkdir -p $CONF_DIR
echo "rpcuser=transcendencerpc" >> $CONF_DIR/$CONF_FILE
echo "rpcpassword=${TELOS_RPC_PASS}" >> $CONF_DIR/$CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
echo "rpcport=${TELOS_RPC_PORT3}" >> $CONF_DIR/$CONF_FILE
echo "port=22123" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "bind=${IP3}:22123" >> $CONF_DIR/$CONF_FILE
echo "logtimestamps=1" >> $CONF_DIR/$CONF_FILE
echo "maxconnections=256" >> $CONF_DIR/$CONF_FILE
sudo chown -R telosmn3:telosmn3 /home/telosmn3/.transcendence/
sudo chown 500 /home/telosmn3/.transcendence/transcendence.conf

sudo tee /etc/systemd/system/telosmn1.service <<EOF
[Unit]
Description=TELOS Coin, distributed currency daemon
After=syslog.target network.target

[Service]
Type=forking
User=telosmn1
Group=telosmn1
WorkingDirectory=/home/telosmn1/
ExecStart=/home/telosmn1/./transcendenced
ExecStop=/home/telosmn1/./transcendence-cli stop
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

sudo tee /etc/systemd/system/telosmn2.service <<EOF
[Unit]
Description=TELOS Coin, distributed currency daemon
After=syslog.target network.target

[Service]
Type=forking
User=telosmn2
Group=telosmn2
WorkingDirectory=/home/telosmn2/
ExecStart=/home/telosmn2/./transcendenced
ExecStop=/home/telosmn2/./transcendence-cli stop
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

sudo tee /etc/systemd/system/telosmn3.service <<EOF
[Unit]
Description=TELOS Coin, distributed currency daemon
After=syslog.target network.target

[Service]
Type=forking
User=telosmn3
Group=telosmn3
WorkingDirectory=/home/telosmn3/
ExecStart=/home/telosmn3/./transcendenced
ExecStop=/home/telosmn3/./transcendence-cli stop
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

sudo -H -u telosmn1 /home/telosmn1/./transcendenced
echo "Booting TELOS MN1 and creating keypool"
sleep 10
MNGENKEY1=`sudo -H -u telosmn1 /home/telosmn1/./transcendence-cli masternode genkey`
echo -e "masternode=1\nmasternodeaddr=${IP1}:22123\nmasternodeprivkey=${MNGENKEY1}" | sudo tee -a /home/telosmn1/.transcendence/transcendence.conf
sudo -H -u telosmn1 /home/telosmn1/./transcendence-cli stop
sudo systemctl enable telosmn1
sudo systemctl start telosmn1

sudo -H -u telosmn2 /home/telosmn2/./transcendenced
echo "Booting TELOS MN2 and creating keypool"
sleep 10
MNGENKEY2=`sudo -H -u telosmn2 /home/telosmn2/./transcendence-cli masternode genkey`
echo -e "masternode=1\nmasternodeaddr=${IP2}:22123\nmasternodeprivkey=${MNGENKEY2}" | sudo tee -a /home/telosmn2/.transcendence/transcendence.conf
sudo -H -u telosmn2 /home/telosmn2/./transcendence-cli stop
sudo systemctl enable telosmn2
sudo systemctl start telosmn2

sudo -H -u telosmn3 /home/telosmn3/./transcendenced
echo "Booting TELOS MN3 and creating keypool"
sleep 10
MNGENKEY3=`sudo -H -u telosmn3 /home/telosmn3/./transcendence-cli masternode genkey`
echo -e "masternode=1\nmasternodeaddr=${IP3}:22123\nmasternodeprivkey=${MNGENKEY3}" | sudo tee -a /home/telosmn3/.transcendence/transcendence.conf
sudo -H -u telosmn3 /home/telosmn3/./transcendence-cli stop
sudo systemctl enable telosmn3
sudo systemctl start telosmn3

echo " "
echo " "
echo "==============================="
echo "TELOS Coin Masternode installed!"
echo "==============================="
echo "Copy and keep that information in secret:"
echo "masternodeaddr #1 key: ${MNGENKEY1}"
echo "masternodeaddr #2 key: ${MNGENKEY2}"
echo "masternodeaddr #3 key: ${MNGENKEY2}"
echo "SSH password for user \"telosmn1@${IP1},telosmn2@${IP2},telosmn3@${IP3}\": ${TELOS_USER_PASS}"
echo "Prepared masternode.conf string:"
echo "MN1 ${IP1}:22123 ${MNGENKEY1} INPUTTX INPUTINDEX"
echo "MN2 ${IP2}:22123 ${MNGENKEY2} INPUTTX INPUTINDEX"
echo "MN3 ${IP3}:22123 ${MNGENKEY3} INPUTTX INPUTINDEX"

exit 0



