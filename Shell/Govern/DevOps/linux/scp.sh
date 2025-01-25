#! /bin/bash

###
# @moduleName: 文件拷贝
# @Author: M.yunlong
# @Date: 2023-03-23 xxx
###

# 服务器 - 执行脚本目录
serverShell='/usr/jenkins/shell'

# 目标服务器路径
remotePath=${1}

echo ""
echo "---------- 拷贝 脚本 ----------"

#  拷贝删除 脚本
scp -r ${serverShell}/ci/clearDir.sh $remotePath

