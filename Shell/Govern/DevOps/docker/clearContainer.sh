#!/bin/bash

###
# @moduleName: Dcoker 清除 容器
# @Author: M.yunlong
# @Date: 2023-08-14 xxx
###

#  容器名称
container=${1}

# 分割工程
containerList=(${container//,/ })

# 循环处理
for ((i = 0; i < ${#containerList[*]}; i++)); do
    {
    	# 容器名称
        containerName=${containerList[i]}

        echo ""
        echo "---------- stop container ----------"
        docker container stop ${containerName}


        echo ""
        echo "---------- rm container ----------"
        docker container rm ${containerName}

        # 查询容器
        echo ""
        echo "---------- 查询容器 是否存在 ? ----------"
        hasContainer=`docker inspect --format '{{.Id}}' ${containerName}`

        # 判断容器 是否存在
        if [ $hasContainer ]; then
            echo ""
            echo "---------- ${containerName} - 删除失败 !!! ----------"
        else
            echo ""
            echo "---------- ${containerName} - 删除成功 !!! ----------"
        fi

    }
done

# 查询容器列表
echo ""
echo "---------- 流程结束：显示当前容器列表 ----------"
echo ""

docker ps -a

echo ""
echo ""

