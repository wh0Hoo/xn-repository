#!/bin/bash

# For Docker Machine Manager
# Install docker machine current stable release
#sudo curl -sL `curl -s https://github.com/docker/machine/releases/latest | awk -v f="docker-machine-$(uname -s)-$(uname -m)" -F\" '{sub("tag", "download", $2); print $2 "/" f}'` -o /usr/local/bin/docker-machine

VERSION=`curl -s https://github.com/docker/machine/releases/latest | awk -F\" '{ n=split($2,a,"/"); print a[n] }'`

sudo curl -sL https://github.com/docker/machine/releases/download/${VERSION}/docker-machine-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-machine
sudo chmod +x /usr/local/bin/docker-machine

# Install bash completion scripts
base=https://raw.githubusercontent.com/docker/machine/${VERSION}
for i in docker-machine-prompt.bash docker-machine-wrapper.bash docker-machine.bash
do
	sudo wget "$base/contrib/completion/bash/${i}" -P /etc/bash_completion.d
done

exit
# ===============================================================================================

# For Docker Machine

sudo visudo
# For RedHat
# %wheel  ALL=(ALL)       NOPASSWD: ALL
# For Debian
# %sudo	ALL=(ALL:ALL) NOPASSWD: ALL

# For firewalld
systemctl is-active firewalld
if [ $? -eq 0 ];then
	sudo firewall-cmd --permanent --new-service=dockermachine
	sudo firewall-cmd --permanent --service=dockermachine --set-short='Docker Machine'
	sudo firewall-cmd --permanent --service=dockermachine --set-description='The Docker Machine Management Port.'
	sudo firewall-cmd --permanent --service=dockermachine --add-port=2376/tcp
	sudo firewall-cmd --permanent --add-service=dockermachine
	sudo firewall-cmd --reload
	# sudo firewall-cmd --list-all
fi
