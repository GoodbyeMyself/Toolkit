#!/bin/bash

###
# @moduleName: Dcoker 清除 容器
# @Author: M.yunlong
# @Date: 2023-03-23 xxx
###

#  服务器 - 执行脚本目录
projectName=${1}
# 项目根目录
branch=${2}

# docker 容器名称 [ 注意转小写 ]
dockerName="${projectName,,}-${branch,,}"

echo ""
echo "---------- stop container ----------"
docker container stop ${dockerName}-container

echo ""
echo "---------- rm container ----------"
docker container rm ${dockerName}-container

echo ""
echo "---------- rm image ----------"
docker image rm ${dockerName}-image

# 查询容器
echo ""
echo "---------- 查询容器 是否存在 ? ----------"
hasContainer=`docker inspect --format '{{.Id}}' ${dockerName}-container`

# 判断容器 是否存在
if [ $hasContainer ]; then
    echo ""
    echo "---------- 删除失败 !!! ----------"
else
    echo ""
    echo "---------- 删除成功 !!! ----------"
fi

