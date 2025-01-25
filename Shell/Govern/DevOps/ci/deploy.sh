#! /bin/bash

###
# @moduleName: 部署 web 应用
# @Author: M.yunlong
# @Date: 2023-03-23 xxx
###

# 服务器 - 执行脚本目录
serverShell='/usr/jenkins/shell'

# 服务器 部署目录
deployServer=${1}

# 项目目录
projectPath=${2}

# 包 目录
distPath=${3}

# 进入目录
cd $projectPath && cd $distPath

# 参数截取
arr=(${deployServer//:/ })
# 映射地址
linkServerPath=${arr[0]}
# 项目目录
projectPath=${arr[1]}

#  拷贝删除 脚本
scp -r ${serverShell}/linux/clearDir.sh $deployServer

# 执行 目标路径清空
ssh ${linkServerPath} "sh ${projectPath}/clearDir.sh $projectPath"

# 跨服务器 拷贝
echo ""
echo "部署安装包, 并执行解压..."

scp -r ./dist.tar.gz $deployServer

# 执行 安装包解压
ssh ${linkServerPath} "cd ${projectPath} && tar -zxf dist.tar.gz && rm -rf dist.tar.gz"

echo ""
