// scp
const scpClient = require('scp2');

// 服务器 配置信息
const serverConfig = require('./server.js');

// 终端
const ora = require('ora');

// 链接
const Client = require('ssh2').Client;

// 颜色 插件
const chalk = require('chalk');
const loading = ora('正在上传中');

// 执行发布
deployFile();

// 发布
function deployFile() {
    // 服务器 配置信息
    const server = {
        // 服务器的IP地址
        host: '120.55.81.222',
        // 服务器端口
        port: '22',
        // 用户名
        username: 'root',
        // 密码
        password: 'WOSHImyl0050',
        // 项目部署的服务器目标位置
        path: serverConfig.path,
        // 若需要删除服务器文件可使用下面代码
        // command: '',
        command: serverConfig.command
    };
    // 创建链接
    const conn = new Client();
    // 链接成功
    conn.on("ready", () => {
        // 服务器 链接成功
        console.log(chalk.green('\n服务器链接成功 准备上传: \n'));
        // 执行 清空
        conn.exec(server.command, (err, stream) => {
            if (err) {
                throw err;
            }
            stream.on('close', function (code, signal) {
                // 执行发布操作
                loading.start();
                // 拷贝
                scpClient.scp(
                    "./dist/", // 本地项目打包文件的位置
                    {
                        host: server.host,
                        port: server.port,
                        username: server.username,
                        password: server.password,
                        path: server.path,
                    },
                    (err) => {
                        loading.stop();
                        // 提示 信息
                        if (err) {
                            console.log(chalk.red('上传失败! \n'));
                            throw err;
                        } else {
                            console.log(chalk.green('文件上传成功! \n'));
                        }
                        // 关闭链接
                        conn.end();
                    }
                );
            }).on('data', function (data) {
                console.log('STDOUT: ' + data);
            }).stderr.on('data', function (data) {
                console.log('STDERR: ' + data);
            });
            
        });
    }).connect({
        host: server.host,
        port: server.port,
        username: server.username,
        password: server.password
    });
};

