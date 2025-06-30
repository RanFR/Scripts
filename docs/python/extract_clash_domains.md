# extract_clash_domains.py

将指定文件夹下所有 log 文件中提取的网址，整理为 Clash 规则（DOMAIN-SUFFIX 优先，IP/特殊域名用 DOMAIN），去重、排序，并输出为 YAML 文件。

#### How to use

修改`main()`下的*log_dir*即可，运行 python 程序，会将规则输出到当前文件夹下。

```bash
python3 extract_clash_domains.py
```
