#!/bin/bash

# Switch to root user
sudo -i

# Update and install necessary packages
apt-get update
apt-get install -y sssd sssd-tools curl

# Download the Linux folder from GitHub to the Desktop
cd /home/administrator/Desktop
git clone https://github.com/yourusername/linux-ldap-setup.git Linux

# Navigate to the Linux folder and set permissions
cd Linux
chmod 777 /home/administrator/Desktop/Linux/

# Copy the required files and set permissions
cp -rp Google_2026_05_22_46666* /var/
chmod 777 /var/Google_2026_05_22_46666*

# Configure sssd.conf
cat /home/administrator/Desktop/Linux/sssd_conf.txt > /etc/sssd/sssd.conf
chown root:root /etc/sssd/sssd.conf
chmod 600 /etc/sssd/sssd.conf

# Restart sssd service
service sssd restart

# Configure custom.conf
cat /home/administrator/Desktop/Linux/custom_conf.txt > /etc/gdm3/custom.conf

# Add Google Cloud endpoint verification repository
echo "deb https://packages.cloud.google.com/apt endpoint-verification main" | sudo tee -a /etc/apt/sources.list.d/endpoint-verification.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Update and install endpoint verification package
apt-get update
apt-get install -y endpoint-verification

# Display users
getent passwd

# Enable home directory creation
sudo pam-auth-update

# Instructions for the user to follow in the pop-up
echo "In the pop-up, press the down arrow & select '[*] Create home directory on login'. Update the value from blank to '*' by pressing the space button & then hit Enter."

#check configurations
sudo service sssd status | grep Active:
cat /etc/sssd/sssd.conf
cat /etc/gdm3/custom.conf | grep Wayland


# Reboot the system
sudo reboot


