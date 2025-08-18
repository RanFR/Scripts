#!/bin/bash

# 定义镜像名称
IMAGE_NAME="sharelatex/sharelatex:latest-with-texlive-full"

# 打印构建信息
echo "开始构建镜像: $IMAGE_NAME"

# 执行构建命令
docker build -t "$IMAGE_NAME" .

# 检查构建是否成功
if [ $? -eq 0 ]; then
    echo "镜像构建成功: $IMAGE_NAME"
    # 可选：构建成功后显示镜像信息
    docker images | grep "$IMAGE_NAME"
else
    echo "镜像构建失败"
    exit 1
fi
