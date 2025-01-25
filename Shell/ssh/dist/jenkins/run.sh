#!/bin/bash

###
# @moduleName: Jenkins shell
# @Author: M.yunlong
# @Date: 2023-03-23 xxx
###

# 服务器 - 执行脚本目录
serverShell='/home/shell'

# 服务器 - 代码缓存 根目录
serverProject='/usr/share/project'

# git 地址
gitUrl=${1}
# 工程名称
projectName=${2}
# git 分支
branch=${3}
# 是否要额外执行 -> npm install
npmCmd=${4}
# 输出包的 文件夹名称
distName=${5}
# 目标服务器 - 地址
remoteDirectory=${6}
# 是否 是单机部署 还是 集群部署
deployment=${7}
# 兼容 monoRepo [ 单个代码库里包含了多项目的代码]
monoRepo=${8}

# 创建 存放代码 Git
gitDirectory="${projectName}-${branch}"

# 项目根目录
projectPath="${serverProject}/${gitDirectory}"

# 构建 dist 目录路径
distPath="${monoRepo}${distName}"

echo ""
echo '---------- 构建参数 ----------'

echo "Git地址: $gitUrl"
echo "项目名称: $projectName"
echo "分支: $branch"
echo "npm 执行命令: $npmCmd"
echo "打包文件夹名称: $distName"
echo "目标服务器 部署目录: $remoteDirectory"
echo "部署类型 [ true: 单机、false: 集群 ]: $deployment"
echo "monoRepo 子级名称: $monoRepo"


echo ""
echo "代码 -> 目录: $gitDirectory"
echo "代码 -> 根目录: $projectPath"
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
    # 主动创建目录 [ -p 是为了后续扩展 创建多级目录使用 ] 此处注意服务器 目录权限: chmod -R 777 /usr/share/project
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
    # 启动 容器
    docker start ${dockerName}-container

    # 执行 docker 内部构建
    sh ${serverShell}/docker/buildWeb.sh $projectPath $dockerName $npmCmd $distName $monoRepo
else
    # 容器不存在：启动 Docker 配置文件创建
    sh ${serverShell}/docker/createContainer.sh $dockerName $monoRepo

    # 执行 docker 内部构建
    sh ${serverShell}/docker/buildWeb.sh $projectPath $dockerName $npmCmd $distName $monoRepo
fi

# 生成版本信息
echo ""
echo "---------- 4、创建版本信息 ----------"
sh ${serverShell}/ci/version.sh $projectName $branch $distName $monoRepo

# 构建 tar 包
echo ""

cd $distPath && tar -zcvf dist.tar.gz *

# 执行发布
echo ""
echo "---------- 5、执行部署 ----------"
sh ${serverShell}/ci/deploy.sh $deployment $remoteDirectory $projectPath $distPath

# 格式化 占位符
echo ""
echo '---------- 流程结束 ----------'

# 格式化 占位符
echo ""