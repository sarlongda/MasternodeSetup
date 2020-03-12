#!/bin/bash
echo "****************************************************************************"
echo "*SAPPHIRE*"                                                                     
echo "*SAPP-LINUX-18.04-VERSION-1.2.2-SEPUP*"
echo "****************************************************************************"
echo && echo && echo
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "first install ? [y/n]"
read -r DOSETUP
if [ "$DOSETUP" = "y" ]
then
sudo apt-get update
sudo apt -y install software-properties-common
sudo apt -y install unzip
sudo apt-add-repository -y ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt install -y make build-essential libtool software-properties-common autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev \
libboost-program-options-dev libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git curl libdb4.8-dev \
bsdmainutils libdb4.8++-dev libminiupnpc-dev libgmp3-dev ufw fail2ban pkg-config libevent-dev libzmq5
echo && echo && echo
sudo wget https://github.com/sappcoin-com/SAPP/releases/download/v1.2.2/SAPPv122-Daemon-Ubuntu1804.zip
unzip SAPPv122-Daemon-Ubuntu1804.zip
rm -r SAPPv122-Daemon-Ubuntu1804.zip
chmod +x *
fi
## Setup conf
read -p "ServerIP:" ServerIP
echo IP ist:  "$ServerIP"
mkdir .sap
cd .sap || exit
wget https://github.com/sappcoin-com/SAPP/releases/download/v1.2.2/bootstrap.zip
unzip bootstrap.zip
rm -r  bootstrap.zip
cd || exit
echo Configure your masternodes now!
echo "Enter masternode private key for node $ALIAS"
read PRIVKEY
echo "key $COINKEY"
CONF_DIR=~/.sap
mkdir -p .sap
echo "rpcuser=user"$(shuf -i 100000-10000000 -n 1) >> sap.conf
echo "rpcpassword=pass"$(shuf -i 100000-10000000 -n 1) >> sap.conf
echo "rpcallowip=127.0.0.1" >> sap.conf
echo "rpcport=45329" >> sap.conf
echo "listen=1" >> sap.conf
echo "server=1" >> sap.conf
echo "daemon=1" >> sap.conf
echo "bind=$ServerIP" >> sap.conf
echo "externalip=$ServerIP" >> sap.conf
echo "maxconnections=56" >> sap.conf
echo "masternode=1" >> sap.conf
echo "port=45328" >> sap.conf
echo "masternodeaddr=$ServerIP:45328" >> sap.conf
echo "masternodeprivkey=$PRIVKEY" >> sap.conf
mv sap.conf $CONF_DIR/sap.conf
echo  -e  "$(crontab -l)\n */2 * * * * ./sapd -datadir=/root/.sap -config=/root/.sap/sap.conf -daemon >/dev/null 2>&1" | crontab -
./sapd
echo fertig