# URL: https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-repository

key_finger_print="0EBFCD88"

# update the apt package index:
sudo apt-get update

# Install packages to allow apt to use a repository over HTTPS
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -


# Checking fingerprint
