#! /bin/bash

###
# @moduleName: 清空 目录
# @Author: M.yunlong
# @Date: 2023-03-23 xxx
# 注意目录权限  chmod -R 777 /xxx
###

# 目录名称
directoryName=${1}

# 判断文件夹 是否存在
if [ -d $directoryName ]; then
    # 进入目录
    cd $directoryName
    # 执行 目标路径 清空
    rm -r *
    # log
    echo "目录: ${directoryName} , 清空完毕 !!!"
fi
