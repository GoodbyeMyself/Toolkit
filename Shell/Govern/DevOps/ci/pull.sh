#! /bin/bash

###
# @moduleName: 推送 237 收包目录
# @Author: M.yunlong
# @Date: 2023-08-29 xxx
###


# 包名称
packageName="${1}"
# 收包目录
packageServer="${2}"

# tar 包名称
tarName="${packageName}.tar.gz"


#  拷贝 tar 包 - 目标服务器
echo ""
scp -r $tarName $packageServer

echo ""
echo "拷贝 tar -> 237 服务器收包目录 - 完毕 !!!"
