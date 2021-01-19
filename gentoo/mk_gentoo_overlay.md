# Portage overlay 생성

* 참고
  * [sunny-overlay](https://github.com/dguglielmi/sunny-overlay)
  * [Custom ebuild repository](https://wiki.gentoo.org/wiki/Custom_ebuild_repository)
  * [Basic guide to write Gentoo Ebuilds](https://wiki.gentoo.org/wiki/Basic_guide_to_write_Gentoo_Ebuilds)

```sh
# emerge --ask dev-vcs/git
# mkdir -p /usr/local/portage/overlay/xnrepo
# cat << EOF > /etc/portage/repos.conf/xnrepo.conf
[xnrepo]
location = /usr/local/portage/overlay/xnrepo
sync-type = git
sync-uri = git://github.com/XNSYSTEMS/xnrepo.git
masters = gentoo
auto-sync = yes
EOF
# emaint sync -r xnrepo
```
