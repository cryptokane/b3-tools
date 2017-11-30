#!/bin/bash

# B3-Coin
# cryptokane
# Script to automate sudo user creation, disabling SSH password login,
# create swap file, clone B3 Repo, install dependencies and compile code

# add sudo user to system
if [ $(id -u) -eq 0 ]; then
	read -p "Enter username : " username
	read -s -p "Enter password : " password
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists"
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		useradd -m -p $pass $username
		[ $? -eq 0 ] && echo $username " has been added to system!" || echo "Failed to add user!"
		usermod -a -G sudo $username
		echo $username " added to sudo group!"
	fi
else
	echo "Only root may add a user to the system!"
	exit 2
fi

# disable ssh password based login
grep -q "ChallengeResponseAuthentication" /etc/ssh/sshd_config && sed -i "/^[^#]*ChallengeResponseAuthentication[[:space:]]yes.*/c\ChallengeResponseAuthentication no" /etc/ssh/sshd_config || echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config
grep -q "^[^#]*PasswordAuthentication" /etc/ssh/sshd_config && sed -i "/^[^#]*PasswordAuthentication[[:space:]]yes/c\PasswordAuthentication no" /etc/ssh/sshd_config || echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

# create swap file
grep -q "swapfile" /etc/fstab

if [ $? -ne 0 ]; then
	fallocate -l 4G /swapfile
	chmod 600 /swapfile
	mkswap /swapfile
	swapon /swapfile
	echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
	sysctl vm.swappiness=10
	echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
	free -h
	sleep 5
fi

# install git, clone wallet repo
apt-get -y install git
git clone https://github.com/B3-Coin/B3-CoinV2.git /root/B3-CoinV2

# install dependencies
apt-get -y update && sudo apt-get -y install build-essential libssl-dev libdb++-dev libboost-all-dev libqrencode-dev

# enter src dir, make, compile
cd /root/B3-CoinV2/src/leveldb
chmod +x build_detect_platform
make clean
make libmemenv.a libleveldb.a
cd ..
make -f makefile.unix
cp b3coind /home/$username
su - $username