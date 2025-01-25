#! /bin/bash

###
# @moduleName: 部署 web 应用
# @Author: M.yunlong
# @Date: 2023-03-23 xxx
###

# 服务器 - 执行脚本目录
serverShell='/home/shell'

# 部署类型
deployment=${1}

# 服务器 部署目录
remoteDirectory=${2}

# 项目目录
projectPath=${3}

# 包 目录
distPath=${4}

# 进入目录
cd $projectPath && cd $distPath

# 区分单机部署 还是 集群
if [ $deployment == true ]; then
    # 对部署目录 执行清空操作
    sh ${serverShell}/linux/clearDir.sh $remoteDirectory

    # 格式化 占位符
    echo ""

    # 移动
    mv -f dist.tar.gz $remoteDirectory

    # 进入部署目录
    cd $remoteDirectory

    # 执行解压
    tar -zxvf dist.tar.gz

    # 删除掉 gz
    rm -rf dist.tar.gz
else
    # 参数截取
    arr=(${remoteDirectory//:/ })
    # 映射地址
    linkServerPath=${arr[0]}
    # 项目目录
    projectPath=${arr[1]}

    #  拷贝删除 脚本
    scp -r ${serverShell}/linux/clearDir.sh $remoteDirectory

    # 执行 目标路径清空
    ssh ${linkServerPath} "sh ${projectPath}/clearDir.sh $projectPath"

    # 跨服务器 拷贝
    scp -r ./dist.tar.gz $remoteDirectory

    # 执行 安装包解压
    ssh ${linkServerPath} "cd ${projectPath} && tar -zxvf dist.tar.gz && rm -rf dist.tar.gz"
fi


