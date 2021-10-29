# Install the createrepo with make on Ubuntu 20.04

身為一位 yum repo server 的維護者，凍仁想在 Ubuntu 20.04 上安裝 `createrepo`，這樣
我們就可把所有服務從 CentOS 7 搬到 Ubuntu 上！

> As a maintainer of yum repo server, I want to install the `createrepo` on Ubuntu 20.04, so than we can migrate ALL services from CentOS 7 to Ubuntu.

----

## Build createrepo_c

藉由 Docker 來編譯 createrepo。(選項)

> Build the createrepo_c with docker. (option)

```
[ chusiang@ubuntu-vm ~ ]
$ docker run --rm -it ubuntu:20.04 bash
$
```

安裝相依套件。

> Install dependency packages via apt.

```
[ chusiang@ubuntu-docker ~ ]
$ sudo apt install -y     \
    bash-completion       \
    cmake                 \
    libbz2-dev            \
    libcurl4-openssl-dev  \
    libglib2.0-dev        \
    liblzma-dev           \
    libmagic-dev          \
    librpm-dev            \
    libsqlite0-dev        \
    libsqlite3-dev        \
    libssl-dev            \
    libxml2-dev           \
    libzstd-dev           \
    pkg-config            \
    python3.9-dev         \
    zlib1g-dev
```

取得 createrepo_c 專案的原始碼。

> Clone the createrepo_c project.

```
[ chusiang@ubuntu-docker ~ ]
$ git clone https://github.com/rpm-software-management/createrepo_c && cd createrepo_c/
```

建立 `build` 目錄，並進入之。

> Create and go to the build directory.

```
[ chusiang@ubuntu-docker ~/createrepo_c ]
$ sudo mkdir build/ && cd build/
```

執行 cmake。

> Run cmake.

```
[ chusiang@ubuntu-docker ~/createrepo_c/build/ ]
$ cmake .. -DWITH_ZCHUNK=NO -DWITH_LIBMODULEMD=NO
...

-- Generating done
-- Build files have been written to: /createrepo_folder/createrepo_c/build
```

用 make 進行編譯！

> Build it with make !

```
[ chusiang@ubuntu-docker ~/createrepo_c/build/ ]
$ make -j
...

[100%] Built target createrepo_c
```


## Porting with binary

要想在其它台 Ubuntu 20.04 server 上執行剛編好的 createrepo，還需進行些簡易的組態設定才行。

用 apt 安裝 `librpm8` 套件。

> Install the librpm8 package on Ubuntu 20.04.

```
[ chusiang@ubuntu-vm ~/createrepo_dir ] - 18:10
$ sudo apt install -y librpm8 libglib2.0-0 libcurl4 libmagic1
```

複製二進位檔 (binary) 和函式檔 (library)，並建立軟連結。

> Copy some files of binary and library to other node.

```
[ chusiang@ubuntu-vm ~/createrepo_dir ] - 18:10
$ docker cp xxxxx:/xxxx/* .
```

建立 `libcreaterepo_c.so` 和 `libcreaterepo_c.so.0` 的軟連結。

> Create soft-links of `libcreaterepo_c.so` and `libcreaterepo_c.so.0`.

```
[ chusiang@ubuntu-vm ~/createrepo_dir ] - 18:10
$ ln -s libcreaterepo_c.so.0.17.7 libcreaterepo_c.so
```

```
[ chusiang@ubuntu-vm ~/createrepo_dir ] - 18:10
$ ln -s libcreaterepo_c.so.0.17.7 libcreaterepo_c.so.0
```


最終目錄結構會長的像這樣。

> Like this.

```
[ chusiang@ubuntu-vm ~/createrepo_dir ] - 18:10
$ ls -l
-rwxr-xr-x 1 chusiang chusiang  182664 Oct 27 18:01 createrepo_c
lrwxrwxrwx 1 chusiang chusiang      25 Oct 27 18:05 libcreaterepo_c.so -> libcreaterepo_c.so.0.17.7
lrwxrwxrwx 1 chusiang chusiang      25 Oct 27 18:05 libcreaterepo_c.so.0 -> libcreaterepo_c.so.0.17.7
-rwxr-xr-x 1 chusiang chusiang 1203264 Oct 27 18:01 libcreaterepo_c.so.0.17.7
```

查看 createrepo 版本。

> Check version.


```
[ chusiang@ubuntu-vm ~/createrepo_dir ] - 18:10
$ ./createrepo_c --version
Version: 0.17.7 (Features: LegacyWeakdeps )
```

建個 repo 目錄，試跑一下 createrepo 吧！

> Run `createrepo` on deplyed Ubuntu node.

```
[ chusiang@ubuntu-vm ~/createrepo_dir ] - 18:10
$ mkdir repo/ && ./createrepo_c repo/
Directory walk started
Directory walk done - 0 packages
Temporary output repo path: repo/.repodata/
Preparing sqlite DBs
Pool started (with 5 workers)
Pool finished
```

DONE !


現在我們可以於 Ubuntu 20.04 上執行 `createrepo` 哩，或許我還可把它打包成 deb 檔，以簡化後續部署流程。

> We can run the `createrepo` on Ubuntu 20.04 now, maybe I can packaging to deb file for deploy easier.

----

## Packing to deb

```
[ chusiang@ubuntu-vm ~/createrepo_dir ] - 18:10
$ tree createrepo/
createrepo/
├── DEBIAN
│   ├── control
│   ├── control.sample
│   ├── postinst
│   ├── postrm
│   ├── preinst
│   └── prerm
├── README.md
└── usr
    └── local
        ├── bin
        │   └── createrepo
        └── lib
            ├── libcreaterepo_c.so -> libcreaterepo_c.so.0.17.7
            ├── libcreaterepo_c.so.0 -> libcreaterepo_c.so.0.17.7
            └── libcreaterepo_c.so.0.17.7
```

```
[ chusiang@ubuntu-vm ~/createrepo_dir ] - 18:10
$ cat createrepo/DEBIAN/control.sample
Package: createrepo
Version: 0.17.7
Architecture: all
Maintainer: Chu-Siang Lai <chusiang.lai@gmail.com>
Installed-Size: 16
Depends: librpm8 (>=4.14.2), libglib2.0-0 (>=2.64.6), libcurl4 (>=7.68.0), libmagic1 (>=1.5.38)
Section: universe/admin
Priority: optional
Homepage: http://createrepo.baseurl.org/
Description: Make createrepo_c for Ubuntu
```

## Install createrepo by deb

```
root@7c6d843f0bdd:/srv/dest# sudo apt install ./createrepo_0.17.7.deb
Reading package lists... Done
Building dependency tree
Reading state information... Done
Note, selecting 'createrepo' instead of './createrepo_0.17.7.deb'
The following additional packages will be installed:
  ca-certificates dbus krb5-locales libapparmor1 libasn1-8-heimdal libbrotli1 libcap2 libcurl4 libdbus-1-3 libelf1
  libexpat1 libglib2.0-0 libglib2.0-data libgssapi-krb5-2 libgssapi3-heimdal libhcrypto4-heimdal libheimbase1-heimdal
  libheimntlm0-heimdal libhx509-5-heimdal libicu66 libk5crypto3 libkeyutils1 libkrb5-26-heimdal libkrb5-3 libkrb5support0
  libldap-2.4-2 libldap-common liblua5.2-0 libmagic-mgc libmagic1 libnghttp2-14 libnspr4 libnss3 libpopt0 libpsl5
  libroken18-heimdal librpm8 librpmio8 librtmp1 libsasl2-2 libsasl2-modules libsasl2-modules-db libsqlite3-0 libssh-4
  libssl1.1 libwind0-heimdal libxml2 openssl publicsuffix rpm-common shared-mime-info tzdata xdg-user-dirs
Suggested packages:
  default-dbus-session-bus | dbus-session-bus krb5-doc krb5-user file libsasl2-modules-gssapi-mit
  | libsasl2-modules-gssapi-heimdal libsasl2-modules-ldap libsasl2-modules-otp libsasl2-modules-sql
The following NEW packages will be installed:
  ca-certificates dbus krb5-locales libapparmor1 libasn1-8-heimdal libbrotli1 libcap2 libcurl4 libdbus-1-3 libelf1
  libexpat1 libglib2.0-0 libglib2.0-data libgssapi-krb5-2 libgssapi3-heimdal libhcrypto4-heimdal libheimbase1-heimdal
  libheimntlm0-heimdal libhx509-5-heimdal libicu66 libk5crypto3 libkeyutils1 libkrb5-26-heimdal libkrb5-3 libkrb5support0
  libldap-2.4-2 libldap-common liblua5.2-0 libmagic-mgc libmagic1 libnghttp2-14 libnspr4 libnss3 libpopt0 libpsl5
  libroken18-heimdal librpm8 librpmio8 librtmp1 libsasl2-2 libsasl2-modules libsasl2-modules-db libsqlite3-0 libssh-4
  libssl1.1 libwind0-heimdal libxml2 createrepo openssl publicsuffix rpm-common shared-mime-info tzdata xdg-user-dirs
0 upgraded, 54 newly installed, 0 to remove and 0 not upgraded.
Need to get 19.1 MB/19.4 MB of archives.
After this operation, 77.5 MB of additional disk space will be used.
Do you want to continue? [Y/n]
```

TBD.


## Reference

* <a href="https://www.stableit.ru/2021/07/createrepo-on-ubuntu-2004.html" target="_blank">Createrepo on Ubuntu 20.04 | Stable IT</a>
* <a href="https://blog.toright.com/posts/4434/deb-package-%e5%a5%97%e4%bb%b6%e5%b0%81%e8%a3%9d%e6%95%99%e5%ad%b8.html" target="_blank">Deb Package 套件封裝教學 | Soul & Shell Blog</a>
* <a href="http://createrepo.baseurl.org/" target="_blank">Createrepo Official</a>
* <a href="http://manpages.ubuntu.com/manpages/bionic/man8/createrepo.8.html" target="_blank">createrepo - Create repomd (xml-rpm-metadata) repository | Ubuntu Manpage</a>
