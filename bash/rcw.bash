#!/usr/bin/env bash

# 显示帮助信息
show_help() {
	cat <<EOF
用法: rcw.bash [选项] [目录]

清理 ROS Catkin 工作空间的构建产物（build、devel、logs 目录等）

选项:
    -n          干运行模式，仅显示将要删除的文件，不实际删除
    --help      显示此帮助信息

参数:
    目录         要清理的工作空间目录，默认为当前目录

示例:
    rcw.bash                    # 清理当前目录
    rcw.bash /path/to/ws        # 清理指定目录
    rcw.bash -n                 # 预览当前目录将要删除的文件
    rcw.bash -n /path/to/ws     # 预览指定目录将要删除的文件
EOF
}

# 解析参数
root_dir="."
dry_run=false

while [[ $# -gt 0 ]]; do
	case "$1" in
	--help)
		show_help
		exit 0
		;;
	-n)
		dry_run=true
		shift
		;;
	-*)
		echo "错误: 未知选项 '$1'"
		echo "使用 --help 查看帮助信息"
		exit 1
		;;
	*)
		root_dir="$1"
		shift
		;;
	esac
done

# 统计变量
dir_count=0
file_count=0
link_count=0

# 临时文件用于存储删除列表
tmp_list=$(mktemp)
trap "rm -f $tmp_list" EXIT

echo "开始清理: $root_dir"
if $dry_run; then
	echo "[干运行模式] 不会实际删除任何文件。"
fi

# 安全搜索，排除 .git 目录
safe_find() {
	find "$root_dir" \( -type d -name ".git" \) -prune -o "$@" -print
}

# 收集要删除的项目
echo "搜索 build、devel 和 logs 目录..."
while IFS= read -r dir; do
	echo "DIR:$dir" >>"$tmp_list"
	((dir_count++))
done < <(safe_find -type d \( -name "build" -o -name "devel" -o -name "logs" \))

echo "搜索 .catkin_workspace 文件..."
while IFS= read -r file; do
	echo "FILE:$file" >>"$tmp_list"
	((file_count++))
done < <(safe_find -type f -name ".catkin_workspace")

echo "搜索符号链接 CMakeLists.txt..."
while IFS= read -r link; do
	echo "LINK:$link" >>"$tmp_list"
	((link_count++))
done < <(safe_find -type l -name "CMakeLists.txt")

# 显示统计信息
total=$((dir_count + file_count + link_count))
echo ""
echo "找到待清理项目: $total 项"
echo "  - 目录: $dir_count 个"
echo "  - 文件: $file_count 个"
echo "  - 符号链接: $link_count 个"

if [[ $total -eq 0 ]]; then
	echo "无需清理的项目。"
	exit 0
fi

# 非干运行模式下，请求确认
if ! $dry_run; then
	echo ""
	read -p "确认要删除以上项目吗? [y/N] " -n 1 -r
	echo ""
	if [[ ! $REPLY =~ ^[Yy]$ ]]; then
		echo "取消操作。"
		exit 0
	fi
fi

# 执行删除操作
echo ""
deleted_dirs=0
deleted_files=0
deleted_links=0

while IFS=: read -r type path; do
	case "$type" in
	DIR)
		echo "删除目录: $path"
		if ! $dry_run; then
			rm -rf "$path"
			((deleted_dirs++))
		fi
		;;
	FILE)
		echo "删除文件: $path"
		if ! $dry_run; then
			rm -f "$path"
			((deleted_files++))
		fi
		;;
	LINK)
		echo "删除符号链接: $path"
		if ! $dry_run; then
			rm -f "$path"
			((deleted_links++))
		fi
		;;
	esac
done <"$tmp_list"

# 显示完成信息
echo ""
echo "清理完成!"
if ! $dry_run; then
	echo "已删除: $((deleted_dirs + deleted_files + deleted_links)) 项"
	echo "  - 目录: $deleted_dirs 个"
	echo "  - 文件: $deleted_files 个"
	echo "  - 符号链接: $deleted_links 个"
fi
