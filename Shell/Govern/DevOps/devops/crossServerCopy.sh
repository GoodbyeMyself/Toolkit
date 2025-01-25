#! /bin/bash

###
# @moduleName: 跨服务器 拷贝 例： 30.112 - 30.104
# @Author: M.yunlong
# @Date: 2023-03-23 xxx
###


# 工程
project="${1}"
# 目标服务器
target="${2}"

# 分割工程
projectNameList=(${project//,/ })


# 参数截取
arr=(${target//:/ })
# 映射地址
linkServerPath=${arr[0]}
# 项目目录
projectPath=${arr[1]}


# 多工程 循环拷贝
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
		scp -r $tarName $target

		# 清空掉 临时文件
		rm -r $tarName

		# 目标服务器 执行清空
		ssh ${linkServerPath} "cd ${projectPath} && sh ./clearDir.sh $projectName"

		echo " "
        echo "安装包部署..."

		# 执行 安装包解压
		ssh ${linkServerPath} "cd ${projectPath} && tar -zxf $tarName && rm -r $tarName"
    }
done


# 临时脚本 清除
rm -r crossServerCopy.sh

# 目标服务器 临时脚本 清除
ssh ${linkServerPath} "cd ${projectPath} && rm -r clearDir.sh"

# 格式化 占位符
echo " "
