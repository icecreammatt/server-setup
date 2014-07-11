#!/bin/bash
# usage ./deploy.sh IP_ADDRESS USERNAME

ROOTUSER=root

IP=$1
USER=$2

echo "Run ./init.sh after logging in"
scp server-init.sh $ROOTUSER@$IP:
ssh $ROOTUSER@$IP "echo ./server-init.sh $USER > init.sh"
ssh $ROOTUSER@$IP "chmod 700 init.sh"
ssh $ROOTUSER@$IP
