## sed


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

- [SED 单行脚本快速参考 | sourceforge][sed1line_zh-CN]
- [awk 如何取最後一個欄位 (How to use awk to get last column) | dreamtails][How_to_use_awk_to_get_last_column]



[sed1line_zh-CN]: http://sed.sourceforge.net/sed1line_zh-CN.html
[How_to_use_awk_to_get_last_column]: http://dreamtails.pixnet.net/blog/post/31257469-awk%E5%A6%82%E4%BD%95%E5%8F%96%E6%9C%80%E5%BE%8C%E4%B8%80%E5%80%8B%E6%AC%84%E4%BD%8D(how-to-use-awk-to-get-last-co

