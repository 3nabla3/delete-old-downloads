# DELETE OLD DOWNLOADS

## What is it?

delete-old-downloads.deb is a package that scans your ~/Downloads folder and removes files that are older than 30 days (customizable).

## How to install?

Go to the [releases](/releases) and download the latest `delete-old-downloads.deb` package then run:

`sudo apt install ./delete-old-downloads.deb`

## How to configure?

Modify `/etc/delete-old-downloads/user.list` to include a list of user's folders to scan:

```
# a list of users and the max file age in days (default 30)
# ex:
# 
# user:30

user  # <- delete items in `user`s Downloads older than 30 days
user:14  # <- override default and delete items older than 2 weeks
```

## How it works?

The package creates a systemd timer that runs hourly.

The timer executes a script that iterates over `user.list` and removes old folders and directories.

> [!WARNING]
> The old items are not placed in the trash, they are `rm -rf`'ed
