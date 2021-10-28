# Install the createrepo with make on Ubuntu 20.04

身為一位 yum repo server 的維護者，凍仁想在 Ubuntu 20.04 上安裝 `createrepo`，這樣
我們就可把所有服務從 CentOS 7 搬到 Ubuntu 上！

> As a maintainer of yum repo server, I want to install the `createrepo` on Ubuntu 20.04, so than we can migrate ALL services from CentOS 7 to Ubuntu.

----

## Build

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


## Deployment

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


> Run `createrepo` on deplyed Ubuntu node.

```
[ chusiang@ubuntu-vm ~/createrepo_dir ] - 18:10
$ ./createrepo_c --version
Version: 0.17.7 (Features: LegacyWeakdeps )
```

DONE !


現在我們可以於 Ubuntu 20.04 上執行 `createrepo` 哩，或許我還可把它打包成 deb 檔，以簡化後續部署流程。

> We can run the `createrepo` on Ubuntu 20.04 now, maybe I can packaging to deb file for deploy easier.


## Reference

* <a href="https://www.stableit.ru/2021/07/createrepo-on-ubuntu-2004.html" target="_blank">Createrepo on Ubuntu 20.04 | Stable IT</a>
* <a href="http://createrepo.baseurl.org/" target="_blank">Createrepo Official</a>
* <a href="http://manpages.ubuntu.com/manpages/bionic/man8/createrepo.8.html" target="_blank">createrepo - Create repomd (xml-rpm-metadata) repository | Ubuntu Manpage</a>
