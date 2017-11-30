#!/bin/bash

# B3 Coin Linux Wallet Upgrade Script

rm -rf /root/B3-CoinV2/ && git clone https://github.com/B3-Coin/B3-CoinV2.git /root/B3-CoinV2

# install dependencies
apt-get -y update && sudo apt-get -y install build-essential libssl-dev libdb++-dev libboost-all-dev libqrencode-dev

# enter src dir, make, compile
cd /root/B3-CoinV2/src/leveldb
chmod +x build_detect_platform
make clean
make libmemenv.a libleveldb.a
cd ..
make -f makefile.unix
