#!/bin/bash

# Display masternode status report
# enter the username you use to log into each node
# ideally this is consistent across your nodes
# after having used the provisioning script
# then list your IP's of each node in succession
# making sure you also put the associated
# wallet addresses in the same order in the wins array

USER=""

declare -a fmns=(
	""
	)

declare -a wins=(
        ""
        )

echo ""
echo "NODE INFO"

for i in "${fmns[@]}"
do
	echo "-------------------------------------------------------"
	echo ""
	echo -n "        NODE      " && ssh $USER@$i "hostname"
	echo -n "      STATUS  " && ssh $USER@$i "./b3coind fundamentalnodelist | grep $i"
	echo -n "        RANK  " && ssh $USER@$i "./b3coind fundamentalnodelist rank | grep $i"
	echo -n "      UPTIME  " && ssh $USER@$i "./b3coind fundamentalnodelist activeseconds | grep $i"
	echo -n "      HEIGHT      " && ssh $USER@$i "./b3coind getblockcount"
	echo ""
done

echo ""
echo "-------------------------------------------------------"
echo ""
echo "RECENT WINNERS"
echo "-------------------------------------------------------"
echo ""
for w in "${wins[@]}"
do
	ssh $USER@"${fmns[0]}" "./b3coind fundamentalnode winners | grep $w"
done
