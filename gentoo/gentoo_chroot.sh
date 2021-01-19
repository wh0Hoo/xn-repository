#!/bin/bash

# /mnt/gentoo 는 rootfs 에 마운트가 되어있어야 한다
# mount /dev/sda4 /mnt/gentoo

cd /mnt/gentoo
mount -t proc none proc
mount --rbind /sys sys
mount --make-rslave sys
mount --rbind /dev dev
mount --make-rslave dev

chroot . /bin/bash
source /etc/profile
export PS1="(chroot) ${PS1}"
