/**
 * @description: 入口
 * @author: M.yunlong
 * @date: 2023-04-24 19:54:53
*/
if (process.env.LOCAL_DEBUG) {
  // 如果是调试模式，加载src中的源码
  require('./src/index')
} else {
  // dist会发到npm
  require('./dist/index')
}
