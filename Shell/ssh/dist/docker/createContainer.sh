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
echo "---------- 容器不存在: 写入 dockerfile、docker-compose.yml ----------"

# 写入 dockerfile
echo "FROM node:16
WORKDIR /build
COPY . ./
RUN cd ${rootPath} && yarn install --unsafe-perm=true">dockerfile

# 写入 docker-compose.yml
echo "version: "'"3.7"'"
services:
    ${dockerName}:
        container_name: ${dockerName}-container
        image: ${dockerName}-image
        network_mode: none
        tty: true
        command:
            - /bin/bash
        build:
            context: ./
        restart: always">docker-compose.yml

echo ""
echo "---------- 启动容器创建 ----------"
# 执行容器 创建
docker-compose up -d --build

# 查询 容器信息
hasContainer=`docker inspect --format '{{.Id}}' ${dockerName}-container`

echo $hasContainer

# 判断容器 是否存在
if [ $hasContainer ]; then
    echo ""
    echo "---------- 容器：${dockerName}-container 已创建 !!! ----------"
else
    echo ""
    echo "---------- 容器：${dockerName}-container 创建失败 !!! ----------"
fi
