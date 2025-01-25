#!/bin/bash

###
# @moduleName: Dcoker 构建 web 应用
# @Author: M.yunlong
# @Date: 2023-03-23 xxx
###

# 服务器 - 执行脚本目录
serverShell='/usr/jenkins/shell'

# 项目根目录
projectPath=${1}
# 容器名称
dockerName=${2}
# 是否要额外执行 -> npm install
npmCmd=${3}
# 打包的输出目录
defaultDistName=${4}

# 项目 子目录
monoRepo=${5}

# 更新代码
docker cp ${projectPath}/. ${dockerName}-container:/build/
echo ""
