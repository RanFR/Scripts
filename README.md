# Scripts

## bash

### [clean_workspace.bash](docs/bash/clean_workspace.md)

Clean workspace files, including **build**, **devel**, **logs** and **CMakeLists.txt** for symbolic link.

### [tar_with_progress.bash](docs/bash/tar_with_progress.md)

Compress and decompress to show progress by using the tar tool.

### [purge_dpkg_rc.bash](docs/bash/purge_dpkg_rc.md)

`apt purge` package which has been removed but with config files left.

## Python

### [merge_compile_commdans.py](docs/python/merge_compile_commands.md)

Merge every compile_commands.json in each package into a single compile_commands.json file.

### [extract_clash_domains.py](docs/python/extract_clash_domains.md)

将指定文件夹下所有 log 文件中提取的网址，整理为 Clash 规则（DOMAIN-SUFFIX 优先，IP/特殊域名用 DOMAIN），去重、排序，并输出为 YAML 文件。

## ShareLaTeX

基于`sharelatex/sharelatex:latest`，构建包含完整 TeXLive 镜像的本地部署。
