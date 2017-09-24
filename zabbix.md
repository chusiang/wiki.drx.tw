# Zabbix

[Zabbix](http://www.zabbix.com/) 是由 Alexei Vladishev 開發的一種網路監視、管理系統，基於 Server-Client 架構。可用於監視各種網路服務、伺服器和網路機器等狀態。 [(more)](https://zh.wikipedia.org/wiki/Zabbix)

## Zabbix Server performance tuning

1. 把 zabbix-agent 從被動 (passive) 模式改為主動 (active) 模式。
1. 架設 Zabbix Proxy Server 以降低 Zabbix Server 負載。
1. 調整 Zabbix Server 的平行處理參數。
1. 增加 Items 檢查間隔時間 (interval)。
1. 放寬 Trigger 規則。

## Active agent auto-registration

在需要動態加入監控主機的環境下，可以藉由設置 Discovery 和 Action 自動加入新主機並進行監控，在 Zabbix 的世界裡稱為 **Active agent auto-registration**。

- Discovery: 發現新的主機 (hosts, managed nodes)。
- Action: 觸發特定事件 (event) 後，用來加入新的主機的功能，可藉由設置 HostMetadata 來自動加入不同的 Host Group 或連接不同的 Templates。

## Dockerized

### Zabbix Server

- [monitoringartist/zabbix-3.0-xxl](https://hub.docker.com/r/monitoringartist/zabbix-3.0-xxl/)

### Zabbix Proxy Server

- [zabbix/zabbix-proxy-sqlite3](https://hub.docker.com/r/zabbix/zabbix-proxy-sqlite3/): 建議使用 sqlite 架設 Proxy，可省下一台 database server。
- [zabbix/zabbix-proxy-mysql](https://hub.docker.com/r/zabbix/zabbix-proxy-mysql/)

## Infrastructure as Code

### Ansible

- [Ansible Galaxy | chusiang.zabbix-agent](https://galaxy.ansible.com/chusiang/zabbix-agent/)

### Chef

- [chusiang/zabbix-agent: Zabbix agent install based off laradji/zabbix](https://github.com/chusiang/zabbix-agent.chef.cookbook)

## Extension

### Nginx

啟用 Nginx status 並藉由 Zabbix agent 進行監控，(請參考[启用 Nginx status 状态详解 | 运维生存时间](http://www.ttlsa.com/nginx/nginx-status-detail/)一文)。

- [Template App Nginx (thecamels)](https://github.com/thecamels/zabbix): 藉由 nginx-check.sh 和 User Parameters 來實作監控 Nginx sub status，並於 zabbix server 匯入 template。請參考 [Zabbix 监控 Nginx性能 (113) | 运维生存时间](http://www.ttlsa.com/zabbix/zabbix-monitor-nginx-performance/)一文。
- [Template App Nginx (blacked)](https://github.com/blacked/zbx_nginx_template): 在已安裝 zabbix-agent 的 host 裡，使用排程執行 python script 以截取 nginx status，之後於 zabbix server 匯入 nginx 的 template。

