// scp
const scpClient = require('scp2');

// 服务器 配置信息
const serverConfig = require('../server/server.js');

// 终端
const ora = require('ora');

// 链接
const Client = require('ssh2').Client;

// 颜色 插件
const chalk = require('chalk');
const loading = ora('正在上传中');

// node模块 逐行读取模块
const readline = require('readline');

// 创建 密钥入口
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});
// 提示信息
const questions = [ 'Please input server username: ', 'Please input server password: '];
// 最大问题数
const linelimit = 2;
// 输入项
let inputArr = [];
// 下标
let index = 0;
// 存储标识
let serverKey = {};

/*
 * 依次执行命令行交互语句
*/
function runQueLoop() {
    if (index === linelimit) {
        // 设置 用户名
        serverKey["username"] = inputArr[0];
        // 设置密码
        serverKey["password"] = inputArr[1];
        // 执行发布
        deployFile();
        // 终止后续
        return;
    }
    // 完善配置信息
    rl.question(questions[index], as => {
        // 设值
        inputArr[index] = as;
        // 下标 ++
        index++;
        // 继续执行 下一个
        runQueLoop();
    })
};

// 发布
function deployFile() {
    // 服务器 配置信息
    const server = {
        // 服务器的IP地址
        host: serverConfig.host,
        // 服务器端口
        port: serverConfig.port,
        // 用户名
        username: serverKey.username,
        // 密码
        password: serverKey.password,
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

// 按顺序 执行
runQueLoop();
