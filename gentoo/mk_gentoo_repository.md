
## Make Gentoo linux Portage Repository

* 참고
  * [Handbook:AMD64/Portage/CustomTree](https://wiki.gentoo.org/wiki/Handbook:AMD64/Portage/CustomTree)
  * [Custom ebuild repository](https://wiki.gentoo.org/wiki/Custom_ebuild_repository)
  * [repoman](https://wiki.gentoo.org/wiki/Repoman)
  * [Ebuild eclass reference in the developer manual](https://devmanual.gentoo.org/eclass-reference/ebuild/index.html)

GitHub 저장소에 아래 2개의 저장소를 생성한다

 * xnrepo
   * ebuild 파일들과 metadata 들을 저장할 저장소로 Overlay 에 사용된다
   * 아래에서 생성한 /var/db/repos/xnrepo 와 연결하여 동기화 시킨다
 * xn-repository
   * 실제 소스 코드 및 바이너리들을 저장할 저장소로 ebuild 에서 SRC_URI 의 경로이다

```sh
root ~ # mkdir /var/db/repos/xnrepo
root ~ # cd /var/db/repos/xnrepo
root /var/db/repos/xnrepo # git init
root /var/db/repos/xnrepo # git user.email xn@xnsystems.com
root /var/db/repos/xnrepo # git user.name xn
root /var/db/repos/xnrepo # git add .
root /var/db/repos/xnrepo # git commit -m "first commit"
root /var/db/repos/xnrepo # git remote add origin https://github.com/XNSYSTEMS/xnrepo.git
root /var/db/repos/xnrepo # git push --all
root /var/db/repos/xnrepo # 
root /var/db/repos/xnrepo # mkdir {profiles,metadata}
root /var/db/repos/xnrepo # echo xnrepo > profiles/repo_name
root /var/db/repos/xnrepo # echo "masters = gentoo" > metadata/layout.conf
root /var/db/repos/xnrepo # git add .
root /var/db/repos/xnrepo # git commit -m "Add metadata and profiles"
root /var/db/repos/xnrepo # git push
root /var/db/repos/xnrepo # 
```

### Add Package to Repository

xn-repository 저장소에 kernel 이라는 폴더를 생성한다
kernel 폴더에 xnimage-5.4.80.tar.xz 파일을 올린다

 * xnimage-5.4.80.tar.xz
   * boot
     * xios.img
   * modules
     * 5.4.80

아래 테스트 용도의 파일에는 boot 폴더의 System.map 이라던가 config 는 그저 참고용이다
modules 폴더의 커널 모듈 폴더 이름은 커널 컴파일시에 지정해서 알맞는 이름으로 바꿔라
또한 모듈 폴더의 링크 파일(build, source)이 있는데 다 제거해도 된다


```sh
tar -tvf xnimage-5.4.80.tar.xz
drwxrwxr-x root/root     0 2021-01-18 14:26 boot/
-rw-r--r-- root/root 4327799 2021-01-18 14:15 boot/System.map-5.4.80-xn
-rw-r--r-- root/root 9016192 2021-01-18 14:15 boot/xios.img
-rw-r--r-- root/root  126485 2021-01-18 14:15 boot/config-5.4.80-xn
drwxrwxr-x root/root       0 2021-01-18 14:16 modules/
drwxr-xr-x root/root       0 2021-01-18 11:24 modules/5.4.80-gentoo-r1/
lrwxrwxrwx root/root       0 2021-01-14 10:38 modules/5.4.80-gentoo-r1/build -> /usr/src/linux-5.4.80-gentoo-r1
drwxr-xr-x root/root       0 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/
drwxr-xr-x root/root       0 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/fs/
drwxr-xr-x root/root       0 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/fs/efivarfs/
-rw-r--r-- root/root   20288 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/fs/efivarfs/efivarfs.ko
drwxr-xr-x root/root       0 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/net/
drwxr-xr-x root/root       0 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/net/ipv6/
drwxr-xr-x root/root       0 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/net/ipv6/netfilter/
-rw-r--r-- root/root   13576 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/net/ipv6/netfilter/nf_log_ipv6.ko
drwxr-xr-x root/root       0 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/net/ipv4/
drwxr-xr-x root/root       0 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/net/ipv4/netfilter/
-rw-r--r-- root/root    8568 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/net/ipv4/netfilter/nf_log_arp.ko
-rw-r--r-- root/root    7312 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/net/ipv4/netfilter/iptable_nat.ko
-rw-r--r-- root/root   13408 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/net/ipv4/netfilter/nf_log_ipv4.ko
drwxr-xr-x root/root       0 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/net/netfilter/
-rw-r--r-- root/root    6848 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/net/netfilter/xt_MASQUERADE.ko
-rw-r--r-- root/root    6280 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/net/netfilter/xt_LOG.ko
-rw-r--r-- root/root   10576 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/net/netfilter/xt_nat.ko
-rw-r--r-- root/root   10672 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/net/netfilter/nf_log_common.ko
-rw-r--r-- root/root    5680 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/net/netfilter/xt_mark.ko
-rw-r--r-- root/root   10160 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/net/netfilter/xt_addrtype.ko
drwxr-xr-x root/root       0 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/net/core/
-rw-r--r-- root/root   13192 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/net/core/failover.ko
drwxr-xr-x root/root       0 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/crypto/
-rw-r--r-- root/root   16184 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/crypto/crypto_engine.ko
drwxr-xr-x root/root       0 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/drivers/
drwxr-xr-x root/root       0 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/drivers/char/
-rw-r--r-- root/root   57024 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/drivers/char/virtio_console.ko
drwxr-xr-x root/root       0 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/drivers/char/hw_random/
-rw-r--r-- root/root    9864 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/drivers/char/hw_random/virtio-rng.ko
drwxr-xr-x root/root       0 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/drivers/thermal/
drwxr-xr-x root/root       0 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/drivers/thermal/intel/
-rw-r--r-- root/root   19928 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/drivers/thermal/intel/x86_pkg_temp_thermal.ko
drwxr-xr-x root/root       0 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/drivers/scsi/
-rw-r--r-- root/root   30176 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/drivers/scsi/virtio_scsi.ko
drwxr-xr-x root/root       0 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/drivers/net/
-rw-r--r-- root/root   86024 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/drivers/net/virtio_net.ko
-rw-r--r-- root/root   23464 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/drivers/net/net_failover.ko
drwxr-xr-x root/root       0 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/drivers/crypto/
drwxr-xr-x root/root       0 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/drivers/crypto/virtio/
-rw-r--r-- root/root   39936 2021-01-14 15:56 modules/5.4.80-gentoo-r1/kernel/drivers/crypto/virtio/virtio_crypto.ko
-rw-r--r-- root/root   13040 2021-01-14 15:56 modules/5.4.80-gentoo-r1/modules.builtin.bin
-rw-r--r-- root/root   25597 2021-01-14 15:56 modules/5.4.80-gentoo-r1/modules.builtin.alias.bin
-rw-r--r-- root/root    1945 2021-01-14 15:56 modules/5.4.80-gentoo-r1/modules.dep.bin
-rw-r--r-- root/root       0 2021-01-14 15:56 modules/5.4.80-gentoo-r1/modules.devname
-rw-r--r-- root/root      55 2021-01-14 15:56 modules/5.4.80-gentoo-r1/modules.softdep
-rw-r--r-- root/root    1539 2021-01-14 15:56 modules/5.4.80-gentoo-r1/modules.symbols.bin
-rw-r--r-- root/root    1426 2021-01-14 15:56 modules/5.4.80-gentoo-r1/modules.alias.bin
-rw-r--r-- root/root   10238 2021-01-14 15:56 modules/5.4.80-gentoo-r1/modules.builtin
lrwxrwxrwx root/root       0 2021-01-14 15:56 modules/5.4.80-gentoo-r1/source -> /usr/src/linux-5.4.80-gentoo-r1
-rw-r--r-- root/root   83390 2021-01-14 15:56 modules/5.4.80-gentoo-r1/modules.builtin.modinfo
-rw-r--r-- root/root     812 2021-01-14 15:56 modules/5.4.80-gentoo-r1/modules.alias
-rw-r--r-- root/root    1391 2021-01-14 15:56 modules/5.4.80-gentoo-r1/modules.symbols
-rw-r--r-- root/root     743 2021-01-14 15:56 modules/5.4.80-gentoo-r1/modules.order
-rw-r--r-- root/root     999 2021-01-14 15:56 modules/5.4.80-gentoo-r1/modules.dep
```
### Add Ebuild File for Package

이 작업은 아래 파일이 실제로 존재해야만 한다
 * https://github.com/XNSYSTEMS/xn-repository/raw/master/kernel/xnimage-5.4.80.tar.xz

Manifest 파일을 생성할때 SRC_URI 에 있는 실제 파일에 대한 정보가 갱신되기 때문이다

```sh
root /var/db/repos/xnrepo # cat > sys-kernel/xnkernel/xnkernel-5.4.80.ebuild << EOF
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mount-boot

DESCRIPTION="XNSYSTEMS Kernel"
HOMEPAGE="https://github.com/XNSYSTEMS/xn-repository"
SRC_URI="https://github.com/XNSYSTEMS/xn-repository/raw/master/kernel/xnimage-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

S="${WORKDIR}"

pkg_preinst() {
	# Make sure /boot is available if needed.
	mount-boot_pkg_preinst
}

pkg_postinst() {
	# Don't forget to umount /boot if it was previously mounted by us.
	mount-boot_pkg_postinst
}

src_install() {
	insinto /lib/modules
	doins -r modules/*

	insinto /boot
	doins boot/*.img
}
EOF
root /var/db/repos/xnrepo # pushd /var/db/repos/xnrepo/sys-kernel/xnkernel
root /var/db/repos/xnrepo # repoman manifest
root /var/db/repos/xnrepo # popd
root /var/db/repos/xnrepo # git add .
root /var/db/repos/xnrepo # git commit -m "Add xnkernel-5.4.80 Ebuild and Manifest"
root /var/db/repos/xnrepo # git push
root /var/db/repos/xnrepo # 
```

### Overlay

Overlay 로 저장소를 등록한다

[mk_gentoo_overlay.md](https://github.com/wh0Hoo/xn-repository/blob/master/gentoo/mk_gentoo_overlay.md) 파일을 따라한다.

이제 xnkernel 을 설치할 수 있게 되었다
