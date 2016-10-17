[Vagrant](https://www.vagrantup.com/) 是一款用於構建及配置虛擬開發環境的軟體，基於 Ruby 開發，讓開發者可以使用簡易的命令操作虛擬機器。

主要使用開源的 VirtualBox 虛擬化系統，與 Ansible、Chef、Salt、Puppet 等組態管理軟體搭配使用，可實現快速開發部署工具的建置。

早期以 VirtualBox 為主，在 1.1 以後的版本中開始支援 VMware 等虛擬化軟體，包括 Amazon EC2 之類伺服器環境。[(more)](https://en.wikipedia.org/wiki/Vagrant_(software))

## Plugins

- [vagrant-remove-old-box-versions](https://github.com/swisnl/vagrant-remove-old-box-versions) - Vagrant plugin to check your downloaded boxes and remove every box that is not the lastest downloaded version.