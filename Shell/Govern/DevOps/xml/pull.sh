#!/bin/bash

###
# @moduleName: 将 xml 菜单 拉到 69 上
# @Author: M.yunlong
# @Date: 2023-07-14 xxx
###

# 中转服务器
transfer="root@10.0.30.138:/home/xmlTransfer"

# git 地址
gitUrl="http://10.0.5.16/govern_dept/govern/v303r001c06/script.git"
# git 分支
branch="master"

# 根目录
rootPath="/usr/jenkins/"

# 临时脚本目录
shellDirectory="gitXml"


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


# 格式化 占位符
echo ""
echo '---------- 流程结束 ----------'

# 格式化 占位符
echo ""