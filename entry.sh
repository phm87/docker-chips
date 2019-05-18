#!/bin/bash

# source : https://github.com/jl777/komodo/blob/master/zcutil/docker-entrypoint.sh

#set -ex

echo "...Checking chips.conf"

if [ ! -e "$HOME/.chips/chips.conf" ]; then
    mkdir -p $HOME/.chips

    echo "...Creating chips.conf"
    cat <<EOF > $HOME/.chips/chips.conf
rpcuser=${rpcuser:-chipsrpc}
rpcpassword=${rpcpassword:-`dd if=/dev/urandom bs=33 count=1 2>/dev/null | base64`}
txindex=1
rpcallowip=127.0.0.1
rpcallowip=${listenip:-127.0.0.1}
addnode=5.9.253.195
rpcport=12454
# port=57777
addnode=54.36.126.42
addnode=145.239.149.173
addnode=54.39.53.170
addnode=159.69.23.30
addnode=95.213.238.98
addnode=144.217.10.241
addnode=5.189.232.34
addnode=139.99.125.27

EOF

    cat $HOME/.chips/chips.conf
fi

# ToDo: Needs some rework. I was sick
if [ $# -gt 0 ]; then

    args=("$@")

elif [  -z ${assetchain+x} ]; then

    args=("-gen -genproclimit=${genproclimit:-2} -pubkey=${pubkey}")

else
# TODO : remove this part if needed or remove all args
    args=("-pubkey=${pubkey} -ac_name=${assetchain} -addnode=${seednode}")

fi

echo "****************************************************"
echo "Download bootstrap"
echo "****************************************************"
mkdir -p ~/.chips
cd ~/.chips
wget http://bootstrap3rd.dexstats.info/CHIPS-bootstrap.tar.gz
tar xvzf CHIPS-bootstrap.tar.gz
rm CHIPS-bootstrap.tar.gz
echo "****************************************************"
echo "Bootstrap downloaded"
echo "****************************************************"
echo "Running: chipsd -reindex"
echo "****************************************************"

exec ~/chips3/src/chipsd -reindex
