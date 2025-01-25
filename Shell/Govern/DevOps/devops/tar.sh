#! /bin/bash

###
# @moduleName: 制作转测 tar 包
# @Author: M.yunlong
# @Date: 2023-04-11 xxx
###

# 工程
project="${1}"
# 目标服务器 - 地址
targetServer="${2}"
# 目标服务器 - 目录
targetPackage="${3}"

# 组装目标
target="${targetServer}:${targetPackage}"

# 分割工程
projectNameList=(${project//,/ })

# 兼容多工程
for ((i = 0; i < ${#projectNameList[*]}; i++)); do
    {
    	# 工程名称
        projectName=${projectNameList[i]}

        echo " "
        echo "制作 tar 包...： $projectName"

        # tar 包名称
        tarName="${projectName}.tar.gz"

        # 制作 tar 包
        tar -zcf $tarName $projectName

        echo " "
        echo "拷贝到目标服务器..."

        # 跨服务器 拷贝
		scp -r $tarName ${target}

		# 清空掉 临时文件
		rm -r $tarName
        
    }
done


echo ""
echo '转测完毕...!!!'


echo ""
echo '---------- 2、清空临时文件 ----------'
rm -r tar.sh

echo '清空完毕...!!!'

# 格式化 占位符
echo ""
