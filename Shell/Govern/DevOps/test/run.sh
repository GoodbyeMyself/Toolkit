#!/bin/bash

###
# @moduleName: Jenkins shell
# @Author: M.yunlong
# @Date: 2023-04-11 xxx
###

# 构建时间
buildDate=$(date "+%Y-%m-%d")

# 服务器 - 执行脚本目录
serverShell='/usr/jenkins/shell'

# 服务器 - 代码缓存 根目录
serverProject='/usr/jenkins/workspace'

# 服务器 - 缓存包目录
serverPackages='/usr/jenkins/temp'

# 默认构建 输出目录
defaultDistName="dist"

# git 地址 : 举例 http://10.0.5.16/govern_dept/web/webmanager.git
gitUrl=${1}
# 工程名称 Govern
projectName=${2}
# git 分支 dev
branch=${3}
# 是否要额外执行 -> npm install
npmCmd=${4}
# 输出包的 文件夹名称：ui || protal || xxx
distName=${5}
# 部署服务器 - 地址: sdc@10.0.30.113:/home/sdc/web/ui
deployServer=${6}
# 兼容 monoRepo [ 单个代码库里包含了多项目的代码] production/Govern/
monoRepo=${7}

# 创建存放代码目录: Govern-dev
gitDirectory="${projectName}-${branch}"

# 项目根目录： /usr/jenkins/workspace/Govern-dev
projectPath="${serverProject}/${gitDirectory}"

# 构建 dist 目录路径: production/Govern/dist
distPath="${monoRepo}${defaultDistName}"

echo ""
echo '---------- 构建参数 ----------'

echo "Git地址: $gitUrl"
echo "项目名称: $projectName"
echo "分支: $branch"
echo "npm 执行命令: $npmCmd"
echo "打包文件夹名称: $defaultDistName"
echo "目标服务器 部署目录: $deployServer"
echo "monoRepo 子级名称: $monoRepo"


echo ""
# 代码 -> Govern-dev
echo "代码 -> 目录: $gitDirectory"
# /usr/jenkins/workspace/Govern-dev
echo "代码 -> 根目录: $projectPath"
# dist
echo "打包 -> 输出目录: $distPath"

echo ""
echo '---------- 流程开始 ----------'

# 缓存根目录
cd "${serverProject}"
echo "进入根目录 => $serverProject"

echo ""
echo '---------- 1、Project 检测 ----------'

# 判断代码分支 是否存在 [ 从根目录开始 ]
if [ -d $projectPath ]; then
    # 清空上一次 构建记录
    sh ${serverShell}/linux/clearDir.sh "${projectPath}/${distPath}"
else
    # 主动创建目录
    echo "未知路径 -> 执行 [克隆] ${gitDirectory}"
    # 执行克隆
    git clone -b $branch $gitUrl $gitDirectory
fi

echo ""
echo '---------- 2、拉取代码 ----------'

# 拉取代码
echo "进入目标路径 -> ${gitDirectory}" && cd $gitDirectory
# 执行 [更新]
git pull

echo ""
echo "---------- 3、Docker 构建 ----------"

# Docker 构建 ：docker 容器名称 [ 注意转小写 ]
dockerName="${gitDirectory,,}"

# 进入 container 查询 容器
hasContainer=`docker inspect --format '{{.Id}}' ${dockerName}-container`

# 判断容器 是否存在
if [ $hasContainer ]; then
    echo "todo"
else
    # 容器不存在：启动 Docker 配置文件创建
    sh ${serverShell}/test/createContainer.sh $dockerName $monoRepo
    #执行 docker 内部构建
    sh ${serverShell}/test/buildWeb.sh $projectPath $dockerName $npmCmd $defaultDistName $monoRepo
fi


# 格式化 占位符
echo ""
echo '---------- 流程结束 ----------'

# 格式化 占位符
echo ""