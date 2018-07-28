#/bin/bash

################################################################################
# Author:   Phongthep K
# Date:     July, 29th 2018
# 
# Program:
#
#   Install VYIGRAT Coin masternode on clean VPS with Ubuntu 16.04 
#	Need 3 IP on VPS
################################################################################

echo && echo 
echo "****************************************************************************"
echo "*                                                                          *"
echo "*  This script will install and configure your VYIGRAT Coin masternode.     *"
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

VYIGRAT_LINUX_URL=https://github.com/vyigrat/vyigrat/releases/download/v1.3.0.0/linux-1.3.0.0.zip

VYIGRAT_RPC_PASS=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 24 ; echo ""`
VYIGRAT_RPC_PORT1=12679
VYIGRAT_RPC_PORT2=12689
VYIGRAT_RPC_PORT3=12699

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
read VYIGRAT_USER_PASS

sudo userdel vyigratmn1
sudo useradd -U -m vyigratmn1 -s /bin/bash
echo "vyigratmn1:${VYIGRAT_USER_PASS}" | sudo chpasswd

sudo userdel vyigratmn2
sudo useradd -U -m vyigratmn2 -s /bin/bash
echo "vyigratmn2:${VYIGRAT_USER_PASS}" | sudo chpasswd

sudo userdel vyigratmn3
sudo useradd -U -m vyigratmn3 -s /bin/bash
echo "vyigratmn3:${VYIGRAT_USER_PASS}" | sudo chpasswd

sudo wget $VYIGRAT_LINUX_URL --directory-prefix /root/
sudo unzip /root/linux-1.3.0.0.zip
sudo rm /root/linux-1.3.0.0.zip

echo "Copy VYIGRAT files to MN1!"
sudo cp /root/linux-1.3.0.0/vyigrat* /home/vyigratmn1
sudo chown -R vyigratmn1:vyigratmn1 /home/vyigratmn1/vyigrat*
sudo chmod 755 /home/vyigratmn1/vyigrat*

echo "Copy VYIGRAT files to MN2!"
sudo cp /root/linux-1.3.0.0/vyigrat* /home/vyigratmn2
sudo chown -R vyigratmn2:vyigratmn2 /home/vyigratmn2/vyigrat*
sudo chmod 755 /home/vyigratmn2/vyigrat*

echo "Copy VYIGRAT files to MN3!"
sudo cp /root/linux-1.3.0.0/vyigrat* /home/vyigratmn3
sudo chown -R vyigratmn3:vyigratmn3 /home/vyigratmn3/vyigrat*
sudo chmod 755 /home/vyigratmn3/vyigrat*

sudo rm -rf /root/linux-1.3.0.0

sudo rm -rf /home/vyigratmn1/.vyigrat/
CONF_DIR=/home/vyigratmn1/.vyigrat/
CONF_FILE=vyigrat.conf
mkdir -p $CONF_DIR
echo "rpcuser=vyigratcoinrpc" >> $CONF_DIR/$CONF_FILE
echo "rpcpassword=${VYIGRAT_RPC_PASS}" >> $CONF_DIR/$CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
echo "rpcport=${VYIGRAT_RPC_PORT1}" >> $CONF_DIR/$CONF_FILE
echo "port=12698" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "maxconnections=256" >> $CONF_DIR/$CONF_FILE
echo "bind=${IP1}:12698" >> $CONF_DIR/$CONF_FILE
sudo chown -R vyigratmn1:vyigratmn1 /home/vyigratmn1/.vyigrat/
sudo chown 500 /home/vyigratmn1/.vyigrat/vyigrat.conf

sudo rm -rf /home/vyigratmn2/.vyigrat/
CONF_DIR=/home/vyigratmn2/.vyigrat/
CONF_FILE=vyigrat.conf
mkdir -p $CONF_DIR
echo "rpcuser=vyigratcoinrpc" >> $CONF_DIR/$CONF_FILE
echo "rpcpassword=${VYIGRAT_RPC_PASS}" >> $CONF_DIR/$CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
echo "rpcport=${VYIGRAT_RPC_PORT2}" >> $CONF_DIR/$CONF_FILE
echo "port=12698" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "maxconnections=256" >> $CONF_DIR/$CONF_FILE
echo "bind=${IP2}:12698" >> $CONF_DIR/$CONF_FILE
sudo chown -R vyigratmn2:vyigratmn2 /home/vyigratmn2/.vyigrat/
sudo chown 500 /home/vyigratmn2/.vyigrat/vyigrat.conf

sudo rm -rf /home/vyigratmn3/.vyigrat/
CONF_DIR=/home/vyigratmn3/.vyigrat/
CONF_FILE=vyigrat.conf
mkdir -p $CONF_DIR
echo "rpcuser=vyigratcoinrpc" >> $CONF_DIR/$CONF_FILE
echo "rpcpassword=${VYIGRAT_RPC_PASS}" >> $CONF_DIR/$CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
echo "rpcport=${VYIGRAT_RPC_PORT3}" >> $CONF_DIR/$CONF_FILE
echo "port=12698" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "maxconnections=256" >> $CONF_DIR/$CONF_FILE
echo "bind=${IP3}:12698" >> $CONF_DIR/$CONF_FILE
sudo chown -R vyigratmn3:vyigratmn3 /home/vyigratmn3/.vyigrat/
sudo chown 500 /home/vyigratmn3/.vyigrat/vyigrat.conf

sudo tee /etc/systemd/system/vyigratmn1.service <<EOF
[Unit]
Description=VYIGRAT Coin, distributed currency daemon
After=syslog.target network.target
[Service]
Type=forking
User=vyigratmn1
Group=vyigratmn1
WorkingDirectory=/home/vyigratmn1/
ExecStart=/home/vyigratmn1/vyigratd
ExecStop=/home/vyigratmn1/vyigrat-cli stop
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

sudo tee /etc/systemd/system/vyigratmn2.service <<EOF
[Unit]
Description=VYIGRAT Coin, distributed currency daemon
After=syslog.target network.target
[Service]
Type=forking
User=vyigratmn2
Group=vyigratmn2
WorkingDirectory=/home/vyigratmn2/
ExecStart=/home/vyigratmn2/vyigratd
ExecStop=/home/vyigratmn2/vyigrat-cli stop
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

sudo tee /etc/systemd/system/vyigratmn3.service <<EOF
[Unit]
Description=VYIGRAT Coin, distributed currency daemon
After=syslog.target network.target
[Service]
Type=forking
User=vyigratmn3
Group=vyigratmn3
WorkingDirectory=/home/vyigratmn3/
ExecStart=/home/vyigratmn3/vyigratd
ExecStop=/home/vyigratmn3/vyigrat-cli stop
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

sudo -H -u vyigratmn1 /home/vyigratmn1/vyigratd
echo "Booting VYIGRAT MN1 and creating keypool"
sleep 10
MNGENKEY1=`sudo -H -u vyigratmn1 /home/vyigratmn1/vyigrat-cli masternode genkey`
echo -e "#masternode=1\n#masternodeaddr=${IP1}:12698\n#masternodeprivkey=${MNGENKEY1}" | sudo tee -a /home/vyigratmn1/.vyigrat/vyigrat.conf
sudo -H -u vyigratmn1 /home/vyigratmn1/vyigrat-cli stop
sudo systemctl enable vyigratmn1
sudo systemctl start vyigratmn1

sudo -H -u vyigratmn2 /home/vyigratmn2/vyigratd
echo "Booting VYIGRAT MN2 and creating keypool"
sleep 10
MNGENKEY2=`sudo -H -u vyigratmn2 /home/vyigratmn2/vyigrat-cli masternode genkey`
echo -e "#masternode=1\n#masternodeaddr=${IP2}:12698\n#masternodeprivkey=${MNGENKEY2}" | sudo tee -a /home/vyigratmn2/.vyigrat/vyigrat.conf
sudo -H -u vyigratmn2 /home/vyigratmn2/vyigrat-cli stop
sudo systemctl enable vyigratmn2
sudo systemctl start vyigratmn2

sudo -H -u vyigratmn3 /home/vyigratmn3/vyigratd
echo "Booting VYIGRAT MN3 and creating keypool"
sleep 10
MNGENKEY3=`sudo -H -u vyigratmn3 /home/vyigratmn3/vyigrat-cli masternode genkey`
echo -e "#masternode=1\n#masternodeaddr=${IP3}:12698\n#masternodeprivkey=${MNGENKEY3}" | sudo tee -a /home/vyigratmn3/.vyigrat/vyigrat.conf
sudo -H -u vyigratmn3 /home/vyigratmn3/vyigrat-cli stop
sudo systemctl enable vyigratmn3
sudo systemctl start vyigratmn3

echo " "
echo " "
echo "==============================="
echo "VYIGRAT Coin Masternode installed!"
echo "==============================="
echo "Copy and keep that information in secret:"
echo "masternodeaddr #1 key: ${MNGENKEY1}"
echo "masternodeaddr #2 key: ${MNGENKEY2}"
echo "masternodeaddr #3 key: ${MNGENKEY3}"
echo "SSH password for user \"vyigratmn1@${IP1},vyigratmn2@${IP2},vyigratmn3@${IP3}\": ${VYIGRAT_USER_PASS}"
echo "Prepared masternode.conf string:"
echo "MN1 ${IP1}:12698 ${MNGENKEY1} INPUTTX INPUTINDEX"
echo "MN2 ${IP2}:12698 ${MNGENKEY2} INPUTTX INPUTINDEX"
echo "MN3 ${IP3}:12698 ${MNGENKEY3} INPUTTX INPUTINDEX"

exit 0
