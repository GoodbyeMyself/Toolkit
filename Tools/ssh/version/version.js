
// 获取 node 子进程
const { exec } = require('child_process');

// node 操作文件
let fs = require('fs');

// 构建时间
let buildDate = new Date().toLocaleString();

// 分支名称
var gitBranch = '';

// 分支名称
exec('git symbolic-ref --short -q HEAD', (err, stdout, stderr) => {
    // 设值
    gitBranch = stdout;
});

// 最后一次 提交信息
var lastCommitId = '';

// 最后一次 提交 commit id
exec('git rev-parse --short HEAD', (err, stdout, stderr) => {
    lastCommitId = stdout;
});

// 监听参数获取 完毕
process.on("exit", function(code) {

    // 生成版本文件
    fs.writeFileSync('./dist/version.txt', `
        构建 时间 : ${ buildDate }

        构建 branch: ${ gitBranch }
        commit id: ${ lastCommitId }
    `);

    // 打印
    console.log(`
        构建 时间 : ${ buildDate }
        
        构建 branch: ${ gitBranch }
        commit id: ${ lastCommitId }
    `);

});


