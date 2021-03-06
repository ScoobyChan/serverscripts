#!/usr/bin/env bash
# AUTHOR: gotbletu <gotbletu@gmail.com>
# SOCIAL: https://www.youtube.com/user/gotbletu|https://github.com/gotbletu|https://twitter.com/gotbletu
# DESC:   easy enable openssh X11 forwarding
# DEMO:   https://youtu.be/fn8bDwfmM3c

# requires root
[ "$(whoami)" != "root" ] && exec sudo -- "$0" "$@"

Color_Off='\e[0m'
Red='\e[0;31m'
Yellow='\e[0;33m'

__desc="${Red}========== Enable OpenSSH X11 Forwarding ==========${Color_Off}
X11 forwarding is a mechanism that allows a user to start up remote graphical applications but forward the graphical application display to your local machine.
https://www.openssh.com
"
printf "%b\n" "$__desc" | fold -s

printf "%b" "${Yellow}Enable X11 Forwarding? [y/n] ${Color_Off}"
read -r REPLY
if ! [[ $REPLY =~ ^[Yy]$ ]]; then
  exit 1
fi

# enable x11 forwarding in config file
PATH_CONFIG="/etc/ssh/sshd_config"
sed -i 's:#X11Forwarding.*:X11Forwarding yes:g' "$PATH_CONFIG"

# restart service
systemctl restart sshd.service

MY_IP="$(ip addr | awk '/global/ {print $1,$2}' | cut -d'/' -f1 | cut -d' ' -f2 | head -n 1)"
printf "%b\n" "${Yellow}>>>Usage: ${Red}ssh -X username@$MY_IP:22${Color_Off}"
printf "%b\n" "${Yellow}>>>Open GUI apps over ssh: ${Red}firefox &${Color_Off}"
