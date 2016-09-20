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

- [zabbix/zabbix-proxy-sqlite3](https://hub.docker.com/r/zabbix/zabbix-proxy-sqlite3/)
- [zabbix/zabbix-proxy-mysql](https://hub.docker.com/r/zabbix/zabbix-proxy-mysql/)

## Infrastructure as Code

### Ansible

- [Ansible Galaxy | chusiang.zabbix-agent](https://galaxy.ansible.com/chusiang/zabbix-agent/)

### Chef

- [commandp/zabbix-agent: Zabbix agent install based off laradji/zabbix](https://github.com/commandp/zabbix-agent)