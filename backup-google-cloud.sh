#!/bin/bash
# General variables
arrayDisks=$(cat Discos.txt)
days=10
date=$(date +"%d-%m-%y")
limit=$(date +"%d-%m-%y" --date="$days day ago")
# Gcloud - Parameters variables
SNAPSHOT="compute disks snapshot"
GCLOUD="/usr/local/bin/gcloud"
NAME="--snapshot-names"
ListSnap="$GCLOUD compute snapshots list"

for disks in $arrayDisks ; do
	echo yes| $GCLOUD $SNAPSHOT $disks $NAME $disks----$date
done

for snaps in `/usr/local/bin/gcloud compute snapshots list | awk '{print $1}' | grep -v NAME` ; do
	idade=$(echo $snaps |awk -F"----" '{print $2}' | awk '{print $1}'  | sed -e /^$/d)
	echo " Limite: $limit"
	echo " Idade: $idade"

	if [ $idade == $limit ] ; then

		$GCLOUD compute snapshots delete $snaps
	else
		echo "$snaps ta baum ainda"
	fi

done

