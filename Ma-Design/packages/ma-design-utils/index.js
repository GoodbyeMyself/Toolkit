/**
 * @description: 入口文件
 * @author: M.yunlong
 * @date: 2023-04-24 19:58:49
*/
if (process.env.LOCAL_DEBUG) {
  // 如果是调试模式，加载src中的源码
  module.exports = require('./src/index')
} else {
  // dist会发到 npm
  module.exports = require('./dist/index')
}
