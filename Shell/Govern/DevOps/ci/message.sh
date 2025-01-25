#!/bin/bash

###
# @moduleName: 消息通知
# @Author: M.yunlong
# @Date: 2023-04-11 xxx
###


# 工程名称
projectName=${1}
# git 分支
branch=${2}
# 目标服务器 - 地址
deployServer=${3}
# 消息
message="${4}"
# 开始 or 结束
status="${5}"


# 参数截取
arr=(${deployServer//:/ })
# 映射地址
linkServerPath=${arr[0]}


# 存在 消息服务器再发送
if [ "${message}" != '无' ]; then

    # 区分构建开始 还是结束
    if [ ${status} == 'start' ]; then
        notice="'开始构建:"${linkServerPath}-${projectName}-${branch}"！'"
    else
        notice="'构建完毕:"${linkServerPath}-${projectName}-${branch}"！'"
    fi

    # 企业微信通知
    result=$(curl "https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=${message}" \
        -H 'Content-Type: application/json' \
        -d '
    {
            "msgtype": "text",
            "text": {
                "content": ${notice}
            }
    }')

fi


# 格式化 占位符
echo ""