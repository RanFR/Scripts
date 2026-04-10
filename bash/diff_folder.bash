#!/bin/bash

# 以 folder1 为基准，比较 folder2 中被修改或新增的文件，输出其路径。

if [[ $# -ne 2 ]]; then
    echo "用法: $0 <folder1> <folder2>" >&2
    exit 1
fi

folder1=$(realpath "$1")
folder2=$(realpath "$2")

if [[ ! -d "$folder1" ]]; then
    echo "错误: '$folder1' 不是有效目录" >&2
    exit 1
fi

if [[ ! -d "$folder2" ]]; then
    echo "错误: '$folder2' 不是有效目录" >&2
    exit 1
fi

while IFS= read -r -d '' file; do
    rel_path="${file#$folder2/}"
    base_file="$folder1/$rel_path"

    if [[ ! -f "$base_file" ]]; then
        echo "$file"
    elif [[ "$(sha256sum "$file" | awk '{print $1}')" != "$(sha256sum "$base_file" | awk '{print $1}')" ]]; then
        echo "$file"
    fi
done < <(find "$folder2" -type f -print0)
