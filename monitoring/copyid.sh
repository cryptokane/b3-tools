#!/bin/bash

# Automate the copying of your ssh-keys to your nodes
# enter your username used to log into each node. this should
# be consistent if you used the provisioning script
# make sure you have performed ssh-keygen on your local machine
# add one node IP per line in fmns then execute by running ./copyid.sh
# if any copies fail, you may have to manually paste the output
# of cat ~/.ssh/id_rsa.pub into ~/.ssh/authorized_keys

USER=""

declare -a fmns=(
	""
        )

for i in "${fmns[@]}"
do
	echo -n "$i  " && ssh-copy-id $USER@$i
	echo ""
done
