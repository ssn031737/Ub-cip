#!/bin/bash

# Switch to root user
sudo -i

# Update and install necessary packages
apt-get update
apt-get install -y sssd sssd-tools curl

# Download the Linux folder from GitHub to the Desktop
cd /home/administrator/Desktop

FILE_URL="https://github.com/ssn031737/Ub-cip/blob/main/Google_2026_05_22_46666.crt?raw=true"
TARGET_DIR="$HOME/Downloads"
wget -O "$TARGET_DIR/Google_2026_05_22_46666.crt" "$FILE_URL"
echo "Download completed: $TARGET_DIR/Google_2026_05_22_46666.crt"

FILE_URL="https://github.com/ssn031737/Ub-cip/blob/main/Google_2026_05_22_46666.key?raw=true"
TARGET_DIR="$HOME/Downloads"
wget -O "$TARGET_DIR/Google_2026_05_22_46666.key" "$FILE_URL"
echo "Download completed: $TARGET_DIR/Google_2026_05_22_46666.key"

#git clone https://github.com/ssn031737/Ub-cip.git Linux


# Navigate to the Linux folder and set permissions
cd Linux
chmod 777 /home/administrator/Desktop/Linux/

# Copy the required files and set permissions
cp -rp $HOME/Downloads/Google_2026_05_22_46666* /var/
chmod 777 /var/Google_2026_05_22_46666*

# Configure sssd.conf
#cat /home/administrator/Desktop/Linux/sssd_conf.txt > /etc/sssd/sssd.conf
# Define the sssd configuration content
SSSD_CONFIG="[sssd]
services = nss, pam
domains = delhivery.com

[domain/delhivery.com]
ignore_group_members = true
sudo_provider = none
cache_credentials = true
ldap_tls_cert = /var/Google_2026_05_22_46666.crt
ldap_tls_key = /var/Google_2026_05_22_46666.key
ldap_uri = ldaps://ldap.google.com:636
ldap_search_base = dc=delhivery,dc=com
id_provider = ldap
auth_provider = ldap
ldap_schema = rfc2307bis
ldap_user_uuid = entryUUID
ldap_groups_use_matching_rule_in_chain = true
ldap_initgroups_use_matching_rule_in_chain = true
enumerate = false
ldap_tls_cipher_suite = NORMAL:!VERS-TLS1.3"

#Variable for SSSD file path
SSSD_CONF_FILE="/etc/sssd/sssd.conf"

# Write the new configuration to sssd.conf
echo "$SSSD_CONFIG" | sudo tee "$SSSD_CONF_FILE" > /dev/null

chown root:root /etc/sssd/sssd.conf
chmod 600 /etc/sssd/sssd.conf

# Restart sssd service
service sssd restart

# Configure custom.conf
#cat /home/administrator/Desktop/Linux/custom_conf.txt > /etc/gdm3/custom.conf

GDM_CONFIG=# GDM configuration storage
#
# See /usr/share/gdm/gdm.schemas for a list of available options.

# Uncomment the line below to force the login screen to use Xorg
WaylandEnable=true

# Enabling automatic login
#  AutomaticLoginEnable = true
#  AutomaticLogin = user1

# Enabling timed login
#  TimedLoginEnable = true
#  TimedLogin = user1
#  TimedLoginDelay = 10

#[security]

#[xdmcp]

#[chooser]

#[debug]
# Uncomment the line below to turn on debugging
# More verbose logs
# Additionally lets the X server dump core if it crashes
#Enable=true

#Variable for SSSD file path
GDM_CONF_FILE="/etc/gdm3/custom.conf"

# Write the new configuration to sssd.conf
echo "$GDM_CONFIG" | sudo tee "$GDM_CONF_FILE" > /dev/null


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


