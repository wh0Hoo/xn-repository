#!/bin/bash

# dnf remove -y podman buildah

# First we install yum-utils, which gives a command for easily adding repositories
# sudo dnf install -y yum-utils
# command to add the docker repo
# sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# command to install docker-ce
sudo dnf install -y docker-ce
# sudo dnf install -y docker-ce docker-ce-cli containerd.io
if [ $? -ne 0 ];then # It doesn't remove podman and buildah.
	sudo dnf install -y --allowerasing docker-ce
	# sudo dnf install -y --allowerasing docker-ce docker-ce-cli containerd.io
fi

sudo usermod -aG docker `id -un`

# Set allow service port for Manager Node
# No need allow service for Worker Node
sudo firewall-cmd --permanent --new-service=swarm
sudo firewall-cmd --permanent --service=swarm --set-short=SWARM
sudo firewall-cmd --permanent --service=swarm --set-description='The Docker Swarm Management Port.'
# TCP port 2377 for cluster management communications
# TCP and UDP port 7946 for communication among nodes
# UDP port 4789 for overlay network traffic
# sudo firewall-cmd --permanent --service=swarm --add-port=2377/tcp --add-port=7946/tcp --add-port=4789/udp
# UDP port 7946 은 반드시 열지 않아도 되는 것 같다 그래도 어떤 상황이 발생할지 모르니 열자
sudo firewall-cmd --permanent --service=swarm --add-port=2377/tcp --add-port=7946/tcp --add-port=7946/udp --add-port=4789/udp
sudo firewall-cmd --permanent --add-service=swarm
# sudo firewall-cmd --info-service=swarm
# It has to be aligned to handle source NAT rules
sudo firewall-cmd --add-masquerade --permanent
sudo firewall-cmd --reload
# sudo firewall-cmd --list-all

# Install docker compose current stable release
sudo curl -sL `curl -s https://github.com/docker/compose/releases/latest | awk -v f="docker-compose-$(uname -s)-$(uname -m)" -F\" '{sub("tag", "download", $2); print $2 "/" f}'` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version

# sudo systemctl --now enable docker

# export PS1="[\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\W\[\033[00m\]]\$ "
# edit /etc/bashrc
# 아래 내용을 바꾸면 된다
# # Turn on checkwinsize
# shopt -s checkwinsize
# [ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\u@\h \W]\\$ "
# ======= 에서 마지막 줄을 바꾼다 ======
# [ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\W\[\033[00m\]]\\$ "
