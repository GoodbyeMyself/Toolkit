/*
 * @Description: 使用 markdown-it-chain 配置markdown-it选项、插件和容器信息，初始化 markdown-it 实例
 * @Author: M.yunlong
 * @Date: 2023.03.01 14:50
 */

// 支持链式调用 markdown-it
const Config = require('markdown-it-chain');

// 配置标题目录跳转的插件
const anchorPlugin = require('markdown-it-anchor');

// 把中文翻译成拼音的插件
const slugify = require('transliteration').slugify;

const containers = require('./containers');
const overWriteFenceRule = require('./fence');

// 实例化 对象
const config = new Config();

/*
 * 使用 链式API 调用配置
*/
config
	// markdown-it 选项配置
	.options
	// 在源码中 使用 HTML 标签
	.html(true).end()
	// 插件配置
	.plugin('anchor')
	/*
	 * 标题 锚点生成插件
	 * 第一个参数： 插件使用的模块
	 * 第二个参数： 插件使用配置参数
	*/
	.use(anchorPlugin, [
		{
			// 最少包含的渲染层级
			level: 2,
			// 生成 有效 url 的自定义参数
			slugify: slugify,
			// 是否在 标题旁 加入永久链接
			permalink: true,
			// 将永久链接 放在永久标题的前面
			permalinkBefore: true
		}
	]).end()
	// 创建 块级容器的 自定义 解析插件
	.plugin('containers')
	.use(containers).end();

// 使用上述配置 创建一个 markdown-it 的实例
const md = config.toMd();

// 针对 代码块 （ fence ） 覆盖默认渲染规则， 当代码块在 demo 容器内 要做一下 特殊处理
overWriteFenceRule(md);

module.exports = md;
