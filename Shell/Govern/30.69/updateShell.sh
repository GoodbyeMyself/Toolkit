#!/bin/bash

###
# @moduleName: 更新 69 服务器构建脚本
# @Author: M.yunlong
# @Date: 2023-04-11 xxx
###

# git 地址
gitUrl="http://10.0.5.16/govern_dept/web/dockerShell.git"
# git 分支
branch="dev"

# 根目录
rootPath="/usr/jenkins/"

# 临时脚本目录
shellDirectory="gitShell"


echo ""
echo '---------- 流程开始 ----------'
# 缓存根目录
cd "${rootPath}"
echo "进入根目录 => $rootPath"


echo ""
echo '---------- 1、Project 检测 ----------'

# 判断代码分支 是否存在 [ 从根目录开始 ]
if [ ! -d $shellDirectory ]; then
   # 主动创建目录
   echo "未知路径 -> 执行 [克隆] ${shellDirectory}"
   # 执行克隆
   git clone -b $branch $gitUrl $shellDirectory
fi

echo ""
echo '---------- 2、拉取代码 ----------'

# 拉取代码
echo "进入目标路径 -> ${shellDirectory}" && cd $shellDirectory
# 执行 [更新]
git pull


echo ""
echo '---------- 3、shell 脚本 更新 ----------'

# 更新
scp -r '/usr/jenkins/gitShell/shell' '/usr/jenkins/'
echo "更新完毕...!!!"

# 格式化 占位符
echo ""
echo '---------- 流程结束 ----------'

# 格式化 占位符
echo ""
