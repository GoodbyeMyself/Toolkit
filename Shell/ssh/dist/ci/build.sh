#! /bin/bash

###
# @moduleName: web 应用构建
# @Author: M.yunlong
# @Date: 2023-03-23 xxx
###

# 占位符
echo ""

# 是否要额外执行 -> npm install
npmCmd=${1}

monoRepo=${2}

echo "npm 命令 => ${npmCmd}"

# 此处做一个兼容 防止 Linux 上进入根目录
if [ "${monoRepo}" != "" ]; then
    cd $monoRepo
fi

# install 需要重新 执行 依赖更新
if [ "${npmCmd}" != "build" ]; then
    yarn install && yarn build
else
    yarn build
fi

