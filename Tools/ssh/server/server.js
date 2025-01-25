/*
 * @moduleName: 环境配置文件
 * @Author: M.yunlong
 * @Date: 2023-02-08 11:15
 */

module.exports = {
    // 服务器的IP地址
    host: '120.55.81.222',
    // 服务器端口
    port: '22',
    // 项目部署的服务器目标位置
    path: '/home/temporary',
    // 若需要删除服务器文件可使用下面代码
    command: 'rm -rf /home/temporary/spider/*'
};