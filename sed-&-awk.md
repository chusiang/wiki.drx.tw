## sed

### 如何藉由 sed 來取代多個參數 (How to replace multiple patterns at once with sed)？

1. 在此以刪除 `"` 和 `!`為例。

    ```
    $ echo '"Hello World !"'
    "Hello World !"
    ```
    
1. 一般可以透過 2 層的 `|` 和 `sed` 處理。

    ```
    $ echo '"Hello World !"' | sed 's/\"//g'
    Hello World !
    
    $ echo '"Hello World !"' | sed 's/\"//g' | sed 's/!//'
    Hello World
    ```

1. 但其實還有更漂亮的解法。
    
    ```
    $ echo '"Hello World !"' | sed 's/\"//g; s/!//'
    Hello World
    ```


## awk

### 如何使用 awk 取得最後一個欄位 (How to use awk to get last column)？

1. Get last column.

    ```
    $ df -h | awk '{ print $NF }'
    ```

1. Get last two column.

    ```
    $ df -h | awk '{ print $(NF-1) }'
    ```

## Reference

sed:

- [SED 单行脚本快速参考 | sourceforge][sed1line_zh-CN]
- [syntax \- How to replace multiple patterns at once with sed? \| Stack Overflow][How_to_replace_multiple_patterns_at_once_with_sed]

awk:

- [awk 如何取最後一個欄位 (How to use awk to get last column) | dreamtails][How_to_use_awk_to_get_last_column]



[sed1line_zh-CN]: http://sed.sourceforge.net/sed1line_zh-CN.html
[How_to_replace_multiple_patterns_at_once_with_sed]: http://stackoverflow.com/questions/26568952/how-to-replace-multiple-patterns-at-once-with-sed

[How_to_use_awk_to_get_last_column]: http://dreamtails.pixnet.net/blog/post/31257469-awk%E5%A6%82%E4%BD%95%E5%8F%96%E6%9C%80%E5%BE%8C%E4%B8%80%E5%80%8B%E6%AC%84%E4%BD%8D(how-to-use-awk-to-get-last-co

