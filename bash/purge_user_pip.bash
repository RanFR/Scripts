#!/bin/bash

# 此脚本会卸载当前用户环境中安装的所有 Python 包。
# 工作流程如下：
# 1. 以 freeze 格式列出所有用户安装的 pip 包。
# 2. 只提取包名。
# 3. 无需确认，逐个卸载每个包。
pip list --user --format=freeze | cut -d= -f1 | xargs -n1 pip uninstall -y
