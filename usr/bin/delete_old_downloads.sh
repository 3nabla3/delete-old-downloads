#!/bin/bash

for user in $(cat /etc/delete-old-downloads/users.list); do
	echo "User: $user"

	DIR=$(sudo -u "$user" xdg-user-dir DOWNLOAD)

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
	find $DIR -maxdepth 1 -mtime +30 -print
done

exit 0
