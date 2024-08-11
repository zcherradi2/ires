#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <REMOTE_USER> <REMOTE_PASSWORD> <REMOTE_SERVER_IP>"
    exit 1
fi

# Variables
REMOTE_USER="$1"
REMOTE_PASSWORD="$2"
REMOTE_SERVER_IP="$3"

# Remote commands to get server information
REMOTE_COMMANDS="
echo 'IPv4 Addresses:';
ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}';
echo 'IPv6 Addresses:';
ip -6 addr show | grep -oP '(?<=inet6\s)[\da-f:]+';
echo 'OS Version and Architecture:';
uname -m && cat /etc/*release | grep -w 'VERSION_ID';
echo 'Server Storage:';
df -h --total | grep 'total';
echo 'RAM:';
free -h | grep 'Mem:';
"

# Execute remote commands and capture output
sshpass -p "$REMOTE_PASSWORD" ssh -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_SERVER_IP" "$REMOTE_COMMANDS"
