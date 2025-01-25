#! /bin/bash

###
# @moduleName: 拷贝 tar 包脚本 到 来源服务器
# @Author: M.yunlong
# @Date: 2023-04-11 xxx
###

# 服务器 - 执行脚本目录
serverShell='/usr/jenkins/shell'

# 工程名称
project="${1}"
# 来源 目录
source=${2}

# 目标 服务器
targetServer=${3}
# 目标 服务器
targetPackage=${4}

# 来源 参数截取
arr=(${source//:/ })
# 来源服务器
linkServerPath=${arr[0]}
# 项目目录
projectPath=${arr[1]}


echo ""
echo '---------- 构建参数 ----------'

echo "工程名称： $project"
echo "来源服务器: $linkServerPath"
echo "项目目录： $projectPath"

echo "目标服务器目录: ${targetServer}:${targetPackage}"

echo ""
echo '---------- 流程开始 ----------'

#  拷贝 脚本 到目标服务器
echo ""
scp -r ${serverShell}/devops/tar.sh $source
echo "拷贝脚本 到 来源服务器完毕 !!!"

echo ""
echo '---------- 1、开始打包 ----------'

# 执行 脚本
ssh ${linkServerPath} "cd ${projectPath} && sh tar.sh $project $targetServer $targetPackage"


# 格式化 占位符
echo ""
echo '---------- 流程结束 ----------'

# 格式化 占位符
echo ""
