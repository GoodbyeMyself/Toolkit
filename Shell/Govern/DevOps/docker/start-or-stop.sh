#! /bin/bash

###
# @moduleName: Docker 容器的 批量启停
# @Author: M.yunlong
# @Date: 2023-08-14 xxx
###

# 容器名称
project="${1}"

# 操作类型 start or stop
operation="${2}"


# 分割工程
projectNameList=(${project//,/ })

# 循环处理
for ((i = 0; i < ${#projectNameList[*]}; i++)); do
    {
    	# 工程名称
        projectName=${projectNameList[i]}

        # 判断操作类型
        if [ $operation = "start" ]; then
            # 启动
            docker start ${projectName}
        else
            # 停止
            docker stop ${projectName}
        fi

    }
done

echo ""
echo "---------- 流程结束 ----------"
echo ""
