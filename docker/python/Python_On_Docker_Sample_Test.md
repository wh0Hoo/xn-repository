우선 개발 환경을 Docker 에 만드는 것이 좋다
이유는 의존성 설치를 위해서이다
local PC 에서 하게되면 local PC 에 설치된 모든 모듈을 넣게된다
따라서 깨끗한 환경을 만들고 거기에서 의존성 리스트를 얻는 것이 낫다
다른 방법으로는 수동으로 개발자가 의존성 리스트를 작성하는 것인데 이 방법은 실수의 가능성이 생긴다


처음 Dockerfile 작성할 때 베이스가 되는 python 버전을 넣게된다

```
FROM python:3.8-slim-buster
```


우선 깨끗한 환경을 위해서 위 python Docker 를 실행한다
Flask 프레임 워크를 사용하여 간단한 Python 애플리케이션을 만들어본다

```sh
[wh0hoo@Node1 ~]$ docker run --rm -dit --name python_dev python:3.8-slim-buster
014bee7e2576657882b2355eb220a1848b679474480af5eca7f4c72ebed74c11
1. [wh0hoo@Node1 ~]$ docker exec -it $(docker ps -f name=python_dev -q) /bin/bash
2. [wh0hoo@Node1 ~]$ docker exec -it python_dev /bin/bash
root@014bee7e2576:/# mkdir python-docker
root@014bee7e2576:/# cd python-docker
root@014bee7e2576:/python-docker# pip3 install Flask
Collecting Flask
  Downloading Flask-1.1.2-py2.py3-none-any.whl (94 kB)
     |████████████████████████████████| 94 kB 424 kB/s 
Collecting itsdangerous>=0.24
  Downloading itsdangerous-1.1.0-py2.py3-none-any.whl (16 kB)
Collecting Jinja2>=2.10.1
  Downloading Jinja2-2.11.3-py2.py3-none-any.whl (125 kB)
     |████████████████████████████████| 125 kB 515 kB/s 
Collecting Werkzeug>=0.15
  Downloading Werkzeug-1.0.1-py2.py3-none-any.whl (298 kB)
     |████████████████████████████████| 298 kB 544 kB/s 
Collecting click>=5.1
  Downloading click-7.1.2-py2.py3-none-any.whl (82 kB)
     |████████████████████████████████| 82 kB 393 kB/s 
Collecting MarkupSafe>=0.23
  Downloading MarkupSafe-1.1.1-cp38-cp38-manylinux2010_x86_64.whl (32 kB)
Installing collected packages: MarkupSafe, Werkzeug, Jinja2, itsdangerous, click, Flask
Successfully installed Flask-1.1.2 Jinja2-2.11.3 MarkupSafe-1.1.1 Werkzeug-1.0.1 click-7.1.2 itsdangerous-1.1.0
root@014bee7e2576:/python-docker# pip3 freeze > requirements.txt
root@014bee7e2576:/python-docker# touch app.py
```

아래의 간단한 웹 요청을 처리하는 코드를 app.py 에 작성한다

```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, Docker!'
```

아래와 같이 Dockerfile 을 작성한다

```
# Base image we would like to use for our application
FROM python:3.8-slim-buster

# Create a working directory and Change directory
WORKDIR /app

# All dependencies are installed.
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

# add our source code into the image.
COPY . .

# we have to do is to tell Docker what command we want to run when our image is executed inside a container.
CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]
```

작성이 완료되면 해당 폴더를 압축하여 local PC 로 옮긴다

```sh
root@014bee7e2576:/python-docker# cd ..
root@014bee7e2576:/# tar cvf python-docker.tar python-docker
python-docker/
python-docker/Dockerfile
python-docker/requirements.txt
python-docker/app.py
root@014bee7e2576:/# exit
[wh0hoo@Node1 ~]$ docker cp python_dev:python-docker.tar .
```

압축을 풀고 Docker Image 를 만든다

```sh
[wh0hoo@Node1 ~]$ tar --no-same-owner -xf ./python-docker.tar
[wh0hoo@Node1 ~]$ cd python-docker
[wh0hoo@Node1 ~/python-docker]$ ls
Dockerfile  app.py  requirements.txt
[wh0hoo@Node1 ~/python-docker]$ docker build --tag testpy:1.0 .
Sending build context to Docker daemon  4.096kB
Step 1/6 : FROM python:3.8-slim-buster
 ---> 20b06bd8f030
Step 2/6 : WORKDIR /app
 ---> Running in efe078efcb7f
Removing intermediate container efe078efcb7f
 ---> d0a6b0dce2f2
Step 3/6 : COPY requirements.txt requirements.txt
 ---> fd30e20c5aed
Step 4/6 : RUN pip3 install -r requirements.txt
 ---> Running in ed09722134e8
Collecting click==7.1.2
  Downloading click-7.1.2-py2.py3-none-any.whl (82 kB)
Collecting Flask==1.1.2
  Downloading Flask-1.1.2-py2.py3-none-any.whl (94 kB)
Collecting itsdangerous==1.1.0
  Downloading itsdangerous-1.1.0-py2.py3-none-any.whl (16 kB)
Collecting Jinja2==2.11.3
  Downloading Jinja2-2.11.3-py2.py3-none-any.whl (125 kB)
Collecting MarkupSafe==1.1.1
  Downloading MarkupSafe-1.1.1-cp38-cp38-manylinux2010_x86_64.whl (32 kB)
Collecting Werkzeug==1.0.1
  Downloading Werkzeug-1.0.1-py2.py3-none-any.whl (298 kB)
Installing collected packages: MarkupSafe, Werkzeug, Jinja2, itsdangerous, click, Flask
Successfully installed Flask-1.1.2 Jinja2-2.11.3 MarkupSafe-1.1.1 Werkzeug-1.0.1 click-7.1.2 itsdangerous-1.1.0
Removing intermediate container ed09722134e8
 ---> f144c41f4a77
Step 5/6 : COPY . .
 ---> 530f6c2dad49
Step 6/6 : CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]
 ---> Running in e03c6b9a8f81
Removing intermediate container e03c6b9a8f81
 ---> 30b2e3ffda66
Successfully built 30b2e3ffda66
Successfully tagged testpy:1.0
[wh0hoo@Node1 ~/python-docker]$ docker images
REPOSITORY                TAG                 IMAGE ID            CREATED             SIZE
testpy                    1.0                 30b2e3ffda66        33 seconds ago      124MB
python                    3.8-slim-buster     20b06bd8f030        8 weeks ago         114MB
[wh0hoo@Node1 ~/python-docker]$ 
```

이제 실행을 해보자

```sh
[wh0hoo@Node1 ~/python-docker]$ docker run -d -p 5000:5000 testpy:1.0
d0985e6c2c9244f664e1c5f2a256441469774930ba8679412322ff3890ad3a15
[wh0hoo@Node1 ~/python-docker]$ docker ps
CONTAINER ID        IMAGE                    COMMAND                  CREATED             STATUS              PORTS                    NAMES
d0985e6c2c92        testpy:1.0               "python3 -m flask ru…"   2 seconds ago       Up 2 seconds        0.0.0.0:5000->5000/tcp   mystifying_shirley
014bee7e2576        python:3.8-slim-buster   "python3"                3 hours ago         Up 3 hours                                   python_dev
[wh0hoo@Node1 ~/python-docker]$ curl localhost:5000
Hello, Docker![wh0hoo@Node1 ~/python-docker]$ 
```


### docker cp

위에서는 압축파일을 만들어서 그 파일을 다운로드했지만, 실제로 docker cp 명령으로는 폴더를 다운로드할 수 있다

굳이 압축하지 말고 폴더를 그냥 다운받도록 하자

```sh
[wh0hoo@Node1 ~]$ docker cp python_dev:python-docker .
[wh0hoo@Node1 ~]$ ls
 Desktop   Documents   Downloads   Music   Pictures   Public   Templates   Videos   python-docker
```


### 의존 리스트의 차이

처음에 얘기했던 의존 리스트의 차이점은 아래와 같다

#### Local PC
```
apturl==0.5.2
bcrypt==3.1.7
blinker==1.4
bottle==0.12.19
Brlapi==0.7.0
certifi==2019.11.28
chardet==3.0.4
Click==7.0
colorama==0.4.3
command-not-found==0.3
configobj==5.0.6
cryptography==2.8
cupshelpers==1.0
dbus-python==1.2.16
decorator==4.4.2
defer==1.0.6
distro==1.4.0
distro-info===0.23ubuntu1
duplicity==0.8.12.0
entrypoints==0.3
fasteners==0.14.1
flake8==3.8.4
Flask==1.1.2
future==0.18.2
httplib2==0.14.0
idna==2.8
itsdangerous==1.1.0
Jinja2==2.11.3
keyring==18.0.1
language-selector==0.1
launchpadlib==1.10.13
lazr.restfulclient==0.14.2
lazr.uri==1.0.3
libvirt-python==6.1.0
lockfile==0.12.2
louis==3.12.0
macaroonbakery==1.3.1
Mako==1.1.0
MarkupSafe==1.1.0
mccabe==0.6.1
monotonic==1.5
netifaces==0.10.4
networkx==2.4
numpy==1.19.4
oauthlib==3.1.0
olefile==0.46
paramiko==2.6.0
pexpect==4.6.0
Pillow==7.0.0
protobuf==3.6.1
psutil==5.5.1
pycairo==1.16.2
pycodestyle==2.6.0
pycups==1.9.73
pyflakes==2.2.0
PyGObject==3.36.0
PyJWT==1.7.1
pymacaroons==0.13.0
PyNaCl==1.3.0
pyRFC3339==1.1
python-apt==2.0.0+ubuntu0.20.4.4
python-dateutil==2.7.3
python-debian===0.1.36ubuntu1
pytz==2019.3
pyxdg==0.26
PyYAML==5.3.1
reportlab==3.5.34
requests==2.22.0
requests-unixsocket==0.2.0
SecretStorage==2.3.1
setools==4.2.2
simplejson==3.16.0
six==1.14.0
ssh-import-id==5.10
systemd-python==234
terminator==2.0.1
tk==0.1.0
ubuntu-advantage-tools==20.3
ubuntu-drivers-common==0.0.0
ufw==0.36
unattended-upgrades==0.1
urllib3==1.25.8
usb-creator==0.3.7
vboxapi==1.0
wadllib==1.3.3
Werkzeug==1.0.1
xkit==0.0.0
```

#### Docker python:3.8-slim-buster
```
click==7.1.2
Flask==1.1.2
itsdangerous==1.1.0
Jinja2==2.11.3
MarkupSafe==1.1.1
Werkzeug==1.0.1
```

### 참고
  * [Build your Python image](https://docs.docker.com/language/python/build-images/)
  * [Run your image as a container](https://docs.docker.com/language/python/run-containers/)
