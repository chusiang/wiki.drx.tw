[Zabbix](http://www.zabbix.com/) 


## Zabbix Server performance tuning

1. 從被動 (passive) 模式改為主動 (active) 模式。
1. 調整 Zabbix Server 的平行處理參數。
1. 增加 Items 檢查間隔時間 (interval)。
1. 放寬 Trigger 規則。

## Active agent auto-registration

在需要動態加入監控主機的環境下，可以藉由設置 Discovery 和 Action 自動加入新主機並進行監控，在 Zabbix 的世界裡稱為 **Active agent auto-registration**。

- Discovery: 發現新的主機 (hosts, managed nodes)。
- Action: 觸發特定事件 (event) 後，用來加入新的主機的功能，可藉由設置 HostMetadata 來自動加入不同的 Host Group 或連接不同的 Templates。