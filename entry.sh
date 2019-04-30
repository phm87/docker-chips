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

echo
echo "****************************************************"
echo "Running: chipsd ${args[@]}"
echo "****************************************************"

exec chipsd ${args[@]}
