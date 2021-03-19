
## Add Docker Machine

[Docker Machine Overview](https://docs.docker.com/machine/)

## Managed Side

### SSH Key

우선 Key 를 만든다

```sh
${user}@hostname:~$ ssh-keygen -o -t rsa -b 4096 -C "docker_machine"
Generating public/private rsa key pair.
Enter file in which to save the key (/home/${user}/.ssh/id_rsa): /home/${user}/.ssh/dockermachine_rsa
Enter passphrase (empty for no passphrase): ↵
Enter same passphrase again: ↵
Your identification has been saved in /home/${user}/.ssh/dockermachine_rsa.
Your public key has been saved in /home/${user}/.ssh/dockermachine_rsa.pub.
The key fingerprint is:
SHA256:saIxaNSuqobFz5csOoa1cG5F9vlQxhxI0Yf2KUMk7iY docker_machine
The key's randomart image is:
+---[RSA 4096]----+
|     .+=..       |
|   . ...* .      |
|  . . .=.+ .     |
| . oo.  Boo      |
| .ooE.++So       |
|..=..*+.         |
|.B.=.. +         |
|oo* + + .        |
|=o.o o           |
+----[SHA256]-----+
```

Key 를 Machine에 넣는다
docker-machine 을 사용해서 관리할 모든 Machine 에 대해서 실행한다

```sh
${user}@hostname:~$ ssh-copy-id -i ~/.ssh/dockermachine_rsa.pub ${user}@${host_ip}
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/${user}/.ssh/swarmdebian_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
${user}@${host_ip}'s password:

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh '${user}@${host_ip}'"
and check to make sure that only the key(s) you wanted were added.

```

### Create

이번 항목에서 실행하는 것은 docker 가 설치되어 있지않은 Machine 이거나 설치된 Machine 이거나 모두 적용이 가능하다

아래 create 명령은 Machine Side 작업을 하고나서 해야 Error 가 나지않는다

```sh
${user}@hostname:~$ docker-machine create --driver generic --generic-ip-address=${host_ip} --generic-ssh-key ~/.ssh/dockermachine_rsa --generic-ssh-user ${user} ${HOSTNAME}
Running pre-create checks...
Creating machine...
(${HOSTNAME}) Importing SSH key...
Waiting for machine to be running, this may take a few minutes...
Detecting operating system of created instance...
Waiting for SSH to be available...
Detecting the provisioner...
Provisioning with ${OS(centos|debian|...)}... # ${OS(centos|debian|...)} 부분은 Machine 에 맞는 것이 출력된다
Installing Docker... # 이 분분은 Machine 에 docker 가 설치되어 있지 않으면 실행된다
Copying certs to the local machine directory...
Copying certs to the remote machine...
Setting Docker configuration on the remote daemon...
Checking connection to Docker...
Docker is up and running!
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env ${HOSTNAME}
${user}@hostname:~$ docker-machine ls
NAME          ACTIVE   DRIVER    STATE     URL                        SWARM   DOCKER     ERRORS
${HOSTNAME}   -        generic   Running   tcp://${host_ip}:2376              v20.10.5
```

## Machine Side

우선 sudo 실행시 Password 입력이 필요하지 않도록 설정한다

 * RedHat 계열

```sh
${user}@hostname:~$ sudo visudo
...전략...
## Allows people in group wheel to run all commands
%wheel  ALL=(ALL)       ALL

## Same thing without a password
# %wheel        ALL=(ALL)       NOPASSWD: ALL
...하략...
```

을 아래로 바꾼다

```sh
...전략...
## Allows people in group wheel to run all commands
#%wheel  ALL=(ALL)       ALL

## Same thing without a password
%wheel        ALL=(ALL)       NOPASSWD: ALL
...하략...
```

 * Debian 계열

```sh
${user}@hostname:~$ sudo visudo
...전략...
# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) ALL
...하략...
```

을 아래로 바꾼다

```sh
...전략...
# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) NOPASSWD: ALL
...하략...
```

sudo 실행시 Password 입력이 필요하지 않도록 설정했던 것은 Manage Side 에서 추가가 완료되면 원복한다

### Fiewalld 사용하는 Machine

RedHat 계열이 대표적이다

```sh
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
```

## Trouble Shooting

[Error: command : sudo hostname debian && echo "debian" | sudo tee /etc/hostname](https://www.techiediaries.com/ubuntu/sudo-without-password-ubuntu-20-04/)
  * sudo 명령에서 암호입력이 없어서 발생하는 문제이다

<span style="color:blue">Error: dial tcp 172.31.16.53:2376: connect: no route to host</span>
  * 2376 포트가 방화벽에서 막혀있어서 발생하는 문제이다

[Error: Maximum number of retries (10) exceeded](https://github.com/docker/machine/issues/4858)
  * Machine Side : systemctl restart docker
