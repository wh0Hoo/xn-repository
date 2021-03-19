#!/bin/bash

distrib_id=`lsb_release -is | tr '[A-Z]' '[a-z]'`

sudo apt update
# Install dependency packages on the hosts
sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/${distrib_id}/gpg | sudo apt-key add -
# Add Docker repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/${distrib_id} $(lsb_release -cs) stable"
# Install Docker Engine
sudo apt update
# sudo apt install docker-ce docker-ce-cli
sudo apt install docker-ce

sudo usermod -aG docker `id -un`

# Install docker compose current stable release
sudo curl -sL `curl -s https://github.com/docker/compose/releases/latest | awk -v f="docker-compose-$(uname -s)-$(uname -m)" -F\" '{sub("tag", "download", $2); print $2 "/" f}'` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version

# sudo systemctl --now enable docker
