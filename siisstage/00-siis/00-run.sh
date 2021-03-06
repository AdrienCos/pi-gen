#!/bin/bash -e

on_chroot << EOF
apt autoclean
echo "i2c-dev" >> /etc/modules-load.d/modules.conf
rfkill unblock wifi
pip3 install virtualenv
mkdir -p /home/pi/src
rm -rf /home/pi/src/*
git clone https://github.com/AdrienCos/intruder.git /home/pi/src/intruder
git clone https://github.com/AdrienCos/sentinel.git /home/pi/src/sentinel
git clone https://github.com/AdrienCos/watchtower.git /home/pi/src/watchtower
git clone https://github.com/AdrienCos/iot-integrations.git /home/pi/src/integrations
git clone https://github.com/AdrienCos/pki_sentinel.git /home/pi/src/pki_sentinel
cd /home/pi/src/sentinel
KVER=4.19.118-v7l+ make install
echo "sentinel" >> /etc/modules-load.d/modules.conf
cd /home/pi/src/intruder
virtualenv venv
source ./venv/bin/activate
pip install -r requirements.txt
deactivate
cd /home/pi/src/watchtower
virtualenv venv
source ./venv/bin/activate
pip install -r requirements.txt
deactivate
cd /home/pi/src/integrations
virtualenv venv
source ./venv/bin/activate
pip install -r requirements.txt
deactivate
mkdir -p /certs
cp /home/pi/src/pki_sentinel/CA/CA.pem /certs/CA.pem
cp /home/pi/src/pki_sentinel/CA/client/node.crt /certs/node.crt
cp /home/pi/src/pki_sentinel/CA/client/node.key /certs/node.key
EOF

