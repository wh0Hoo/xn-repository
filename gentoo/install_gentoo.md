
## Install Gentoo linux

[Quick Installation Checklist](https://wiki.gentoo.org/wiki/Quick_Installation_Checklist)

## Partitioning

* BIOS/GPT

```sh
livecd ~ # gdisk /dev/sda

# Create GPT partition table:
Command: o ↵
This option deletes all partitions and creates a new protective MBR.
Proceed? (Y/N): y ↵

# Create Partition 1 (/boot):
Command: n ↵
Partition Number: 1 ↵
First sector: ↵
Last sector: +128M ↵
Hex Code: ↵

# Create Partition 2 (BIOS boot):
Command: n ↵
Partition Number: 2 ↵
First sector: ↵
Last sector: +2M ↵
Hex Code: EF02 ↵

# Create Partition 3 (swap):
Command: n ↵
Partition Number: 3 ↵
First sector: ↵
Last sector: +1024MB ↵
Hex Code: 8200 ↵

# Create Partition 4 (/):
Command: n ↵
Partition Number: 4 ↵
First sector: ↵
Last sector: ↵ (for rest of disk)
Hex Code: ↵

Write Partition Table To Disk:
Command: w ↵
Do you want to proceed? (Y/N): Y ↵

livecd ~ # mkfs.ext4 /dev/sda1
livecd ~ # mkfs.ext4 /dev/sda4
livecd ~ # mkswap /dev/sda3 && swapon /dev/sda3
```

### Mount

```sh
livecd ~ # mkdir -p /mnt/gentoo
livecd ~ # mount /dev/sda4 /mnt/gentoo
livecd ~ # mkdir /mnt/gentoo/boot
livecd ~ # mount /dev/sda1 /mnt/gentoo/boot
```

만약 시간이 맞지 않다면 아래 명령을 실행하여 시간을 설정한다

```sh
livecd ~ # ntpd -q -g
```

만약 NTP 로 시간 설정이 되지 않았다면 수동으로 설정한다
예를 들어 2021년 01월 15일 17시 12분을 설정하려면:
```sh
livecd ~ # date 011517122021
```

## Stage3

```sh
livecd ~ # cd /mnt/gentoo
livecd /mnt/gentoo # FILENAME=`wget -qO - http://distfiles.gentoo.org/releases/amd64/autobuilds/latest-stage3-amd64.txt | sed -e '/^#.*/d;/^ $/d;s/^ *//g;s/ .*//g'` ; wget http://distfiles.gentoo.org/releases/amd64/autobuilds/$FILENAME
livecd /mnt/gentoo # tar xvpf `echo $FILENAME | cut -f 2 -d '/'` --xattrs-include='*.*' --numeric-owner
```

## Preper Portage

```sh
livecd /mnt/gentoo # if grep -c ^COMMON_FLAGS /mnt/gentoo/etc/portage/make.conf > /dev/null ; then sed -i 's/^COMMON_FLAGS=\"/COMMON_FLAGS=\"-march=native /g' /mnt/gentoo/etc/portage/make.conf ; else sed -i 's/^CFLAGS=\"/CFLAGS=\"-march=native /g' /mnt/gentoo/etc/portage/make.conf ; fi
livecd /mnt/gentoo # 
livecd /mnt/gentoo # cat >> /mnt/gentoo/etc/portage/make.conf << EOF

GENTOO_MIRRORS="http://ftp.daum.net/gentoo/ http://ftp.kaist.ac.kr/pub/gentoo/ ftp://ftp.kaist.ac.kr/gentoo/ https://ftp.lanet.kr/pub/gentoo/"
EOF
livecd /mnt/gentoo # 
```

```sh
livecd /mnt/gentoo # mkdir -p /etc/portage/repos.conf
livecd /mnt/gentoo # cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
livecd /mnt/gentoo # cp -L /etc/resolv.conf /mnt/gentoo/etc/
```

## Chroot

```sh
livecd /mnt/gentoo # cd /mnt/gentoo
livecd /mnt/gentoo # mount -t proc none proc
livecd /mnt/gentoo # mount --rbind /sys sys
livecd /mnt/gentoo # mount --make-rslave sys
livecd /mnt/gentoo # mount --rbind /dev dev
livecd /mnt/gentoo # mount --make-rslave dev
livecd /mnt/gentoo # cp /etc/resolv.conf etc
livecd /mnt/gentoo # chroot . /bin/bash
livecd / # source /etc/profile
livecd / # export PS1="(chroot) ${PS1}"
(chroot) livecd / # 
```

## Portage

```sh
(chroot) livecd / # emerge-webrsync
```

## User accounts

* root 계정의 암호를 바꾼다

```sh
(chroot) livecd / # passwd
```

* 관리자 계정을 추가한다

```sh
(chroot) livecd / # useradd -g users -G wheel,portage,audio,video,usb,cdrom -m username
(chroot) livecd / # passwd username
```

## VIM 설치(선택사항)

```sh
(chroot) livecd / # emerge -vq vim
```

## TIMEZONE 설정(선택사항)

```sh
(chroot) livecd / # echo "Asia/Seoul" > /etc/timezone
(chroot) livecd / # emerge --config sys-libs/timezone-data
```

## Locale 설정(선택사항)

### Locale 생성

```sh
(chroot) livecd / # vi /etc/locale.gen
```
or
```sh
(chroot) livecd / # nano -w /etc/locale.gen
```

아래의 항목을 추가한다. 다른 언어를 더하여도 된다
```sh
en_US.UTF8 UTF-8
ko_KR.UTF8 UTF-8
```

```sh
(chroot) livecd / # locale-gen
(chroot) livecd / # locale -a
```

### Locale 선택

```sh
(chroot) livecd / # eselect locale list
Available targets for the LANG variable:
  [1]   C
  [2]   C.utf8
  [3]   POSIX
  [4]   en_US.utf8
  [5]   ko_KR.utf8
  [6]   C.UTF8 *
  [ ]   (free form)
(chroot) livecd / # 
(chroot) livecd / # eselect locale set 5
(chroot) livecd / # cat /etc/env.d/02locale
# Configuration file for eselect
# This file has been automatically generated.
LANG="ko_KR.utf8"
(chroot) livecd / # 
(chroot) livecd / # env-update && source /etc/profile && export PS1="(chroot) ${PS1}"
```

## Kernel

### Portage 설정

[mk_gentoo_overlay.md](https://github.com/wh0Hoo/xn-repository/blob/master/gentoo/mk_gentoo_overlay.md) 파일을 따라한다.

### XN kernel 설치

```sh
(chroot) livecd / # emerge -a xnkernel
```

### /etc/fstab 수정

아래 내용을 추가한다

```sh
/dev/sda1	/boot		ext4		noauto,noatime	1 2
/dev/sda4	/		ext4		noatime		0 1
/dev/sda3	none		swap		sw		0 0
```

### bootloader 설치

```sh
(chroot) livecd / # emerge --ask --verbose sys-boot/grub
(chroot) livecd / # grub-install /dev/sda
```

### bootloader 설정

* /boot/grub/grub.cfg 파일을 아래의 내용으로 생성한다.

```sh
set default=0
set timeout=1

menuentry "XIOS" {
linux (hd0,1)/xios.img root=/dev/sda4 rootfstype=ext4 net.ifnames=0 quiet ro
}
```

## Network tools

```sh
(chroot) livecd / # emerge --ask sys-apps/iproute2 net-misc/dhcpcd
```

## Clean up

```sh
(chroot) livecd / # exit
livecd /mnt/gentoo # cd /mnt
livecd /mnt # umount gentoo/boot
livecd /mnt # umount -R gentoo
livecd /mnt # reboot
```
