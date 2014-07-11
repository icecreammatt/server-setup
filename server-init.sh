#!/bin/bash
# Ubuntu 14.04 Default Setup

# Setup Default User
username=$1
echo "Setting up new user $username"

# Timezone Setup
echo "Updating Timezone"
rm /etc/localtime
ln -s /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
echo "America/Los_Angeles" > /etc/timezone
service cron restart

addgroup admin
adduser $username
usermod -a -G admin $username

# Copy authorized keys into new account
mkdir -p /home/$username/.ssh/
cp ~/.ssh/authorized_keys /home/$username/.ssh/authorized_keys
chmod -R 750 /home/$username
chown -R $username:$username /home/$username/

# SSH Lockdown
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
echo "AllowUsers $username" >> /etc/ssh/sshd_config

sed -i 's/PermitRootLogin without-password/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config

service ssh restart

# Update and Patch
apt-get update
apt-get upgrade -y

# Install Essentials
apt-get install -y fail2ban htop zsh tree git vim nginx nodejs make npm cmake python-dev

# Softlink Node
ln -s /usr/bin/nodejs /usr/bin/node

# Node Packages
npm install -g gulp bower tldr jshint forever

# ufw (Ubuntu Firewall)
ufw default deny incoming
ufw default allow outgoing

# Open SSH
ufw allow ssh

# Open web ports
ufw allow 443/tcp
ufw allow 80/tcp

# Enable firewall and fail2ban
ufw --force enable

# Check Status
ufw status
service fail2ban status
