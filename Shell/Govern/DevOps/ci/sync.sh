#! /bin/bash

###
# @moduleName: 同步其他服务器 例： 30.112 - 30.104
# @Author: M.yunlong
# @Date: 2023-08-29 xxx
###

# 服务器 - 执行脚本目录
serverShell='/usr/jenkins/shell'

# 包名称
packageName="${1}"
# 目标服务器
target="${2}"
# tar 包名称
tarName="${packageName}.tar.gz"

# 参数截取
arr=(${target//:/ })
# 映射地址
linkServerPath=${arr[0]}
# 项目目录
projectPath=${arr[1]}


echo "包名称： $packageName"
echo "tar 包： $tarName"
echo "目标服务器： $target"


#  拷贝 tar 包 - 目标服务器
echo ""
scp -r $tarName $target
echo "拷贝 tar -> 目标服务器 - 完毕 !!!"


#  拷贝 删除脚本 - 目标服务器
echo ""
scp -r ${serverShell}/linux/clearDir.sh $target
echo "拷贝 删除脚本 -> 目标服务器 - 完毕 !!!"

# 目标服务器 - 部署目录 - 执行清空
echo ""
ssh ${linkServerPath} "cd ${projectPath} && sh ./clearDir.sh $packageName"

# 执行 安装包解压
echo ""
ssh ${linkServerPath} "cd ${projectPath} && tar -zxf $tarName && rm -r $tarName"

echo " "
echo "执行安装包同步完成！"

# 目标服务器 临时脚本 清除
ssh ${linkServerPath} "cd ${projectPath} && rm -r clearDir.sh"
