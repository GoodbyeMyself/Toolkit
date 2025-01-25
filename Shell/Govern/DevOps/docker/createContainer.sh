#!/bin/bash

###
# @moduleName: Docker shell
# @Author: M.yunlong
# @Date: 2023-03-23 xxx
###

# 容器名称
dockerName=${1}

# 项目 子目录
monoRepo=${2}

# 项目根目录
if [ "${monoRepo}" != "" ]; then
    rootPath=${monoRepo}
else
    rootPath='/build'
fi

echo ""
echo "---------- 容器不存在: 开始创建 ----------"
docker create -it -w /build --name ${dockerName}-container node-yarn bash

echo ""
echo "---------- 创建完成: 启动 ----------"
docker start ${dockerName}-container

# 查询 容器信息
hasContainer=`docker inspect --format '{{.Id}}' ${dockerName}-container`

echo $hasContainer

# 判断容器 是否存在
if [ $hasContainer ]; then
    echo ""
    echo "---------- 容器：${dockerName}-container 已创建 !!! ----------"
    echo ""
else
    echo ""
    echo "---------- 容器：${dockerName}-container 创建失败 !!! ----------"
    echo ""
fi
