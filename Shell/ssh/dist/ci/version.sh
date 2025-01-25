#! /bin/bash

###
# @moduleName: 生成 web 应用版本信息
# @Author: M.yunlong
# @Date: 2023-03-23 xxx
###

# 项目名称
projectName=${1}

# 分支名称
branch=${2}

# 打包的输出目录
distName=${3}

# 项目 子目录
monoRepo=${4}

# 进入 dist 目录
cd ${monoRepo}${distName}

# 输出版本信息
echo "

构建时间: $(date +%Y-%m-%d--%T)

project Name: ${projectName}

git Branch: ${branch}

last commit info:
$(git rev-parse --short HEAD)

">version.txt
