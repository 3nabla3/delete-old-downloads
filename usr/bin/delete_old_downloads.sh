#!/bin/bash

grep "^[^#]" etc/delete-old-downloads/users.list |
while read line; do
	user=$(echo $line | awk -F: '{print $1}')
	days=$(echo $line | awk -F: '{print $2}')

	if [[ -z $days ]]; then
		# default to 30 days
		days=30
	fi

	echo "User: $user ($days days)"

	DIR=$(sudo -u "$user" xdg-user-dir DOWNLOAD)
	if [[ $? -eq 1 ]]; then
		echo "Could not get download directory for user $user"
		continue;
	fi

	# if the download directory is not than 3 levels deep, it is suspicious
	if ! [[ "$DIR" =~ ^(\/[A-Za-z0-9\ -]+){3,}$ ]]; then
		echo "Suspicious download directory"
		continue;
	fi

	if [ -z "$DIR" ]; then
		echo "could not find download directory"
		continue;
	fi

	if [ ! -d "$DIR" ]; then
		echo "directory does not exist"
		continue;
	fi

	date
	# we cant use -delete because it wont delete non empty dirs
	results=$(find $DIR -maxdepth 1 -mtime +$days -print -exec rm -rf {} \;)
	if [[ -z results ]]; then
		echo "Nothing to delete"
	else
		echo "$results"
	fi
done 

exit 0
