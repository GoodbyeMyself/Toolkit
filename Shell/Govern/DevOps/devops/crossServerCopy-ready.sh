#! /bin/bash

###
# @moduleName: 跨服务器 拷贝 例： 30.112 - 30.104
# @Author: M.yunlong
# @Date: 2023-03-23 xxx
###

# 服务器 - 执行脚本目录
serverShell='/usr/jenkins/shell'

# 工程名称
project="${1}"
# 来源服务器
source="${2}"
# 目标服务器
target="${3}"

# 来源 参数截取
arr=(${source//:/ })
# 来源服务器
linkServerPath=${arr[0]}
# 项目目录
projectPath=${arr[1]}


echo ""
echo '---------- 构建参数 ----------'

echo "工程名称： $project"
echo "来源服务器： $source"
echo "目标服务器： $target"

echo ""
echo '---------- 流程开始 ----------'


#  拷贝 复制脚本 到来源服务器
echo ""
scp -r ${serverShell}/devops/crossServerCopy.sh $source
echo "拷贝 复制脚本 到 来源服务器完毕 !!!"

#  拷贝 删除脚本 到目标服务器
echo ""
scp -r ${serverShell}/linux/clearDir.sh $target
echo "拷贝 删除脚本 到 目标服务器完毕 !!!"


echo ""
echo '---------- 1、开始拷贝 ----------'
# 执行 脚本
ssh ${linkServerPath} "cd ${projectPath} && sh crossServerCopy.sh $project $target"


# 格式化 占位符
echo ""
echo '---------- 流程结束 ----------'

# 格式化 占位符
echo ""
