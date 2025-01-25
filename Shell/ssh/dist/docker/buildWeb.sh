#!/bin/bash

###
# @moduleName: Dcoker 构建 web 应用
# @Author: M.yunlong
# @Date: 2023-03-23 xxx
###

# 服务器 - 执行脚本目录
serverShell='/home/shell'

# 项目根目录
projectPath=${1}
# 容器名称
dockerName=${2}
# 是否要额外执行 -> npm install
npmCmd=${3}
# 打包的输出目录
distName=${4}

# 项目 子目录
monoRepo=${5}

# 更新代码
docker cp ${projectPath}/. ${dockerName}-container:/build/

# 拷贝构建 脚本
docker cp ${serverShell}/ci/. ${dockerName}-container:/build/${monoRepo}ci/

# 执行构建
docker exec -i ${dockerName}-container bash -c "sh /build/${monoRepo}ci/ready.sh && sh /build/${monoRepo}ci/build.sh ${npmCmd} ${monoRepo}"

# 执行拷贝
echo ""
docker cp ${dockerName}-container:/build/${monoRepo}${distName}/. ${projectPath}/${monoRepo}${distName}/
echo "拷贝文件到宿主机： 拷贝完毕 !!!"

# 停止 docker container 防止资源占用
echo ""
docker stop ${dockerName}-container
echo "stop container 释放资源: 已停止 !!!"

