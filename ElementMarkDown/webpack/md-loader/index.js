/*
 * @Description: loader 的入口文件，通过提取 template 与 script 的内容，把 Markdown 转化成 Vue 组件
 * @Author: M.yunlong
 * @Date: 2023.03.01 14:50
 */

const {
	stripScript,
	stripTemplate,
	genInlineComponentText
} = require('./util');

// 暴露出已经处理好markdownit插件的md
const md = require('./config');

module.exports = function(source) {
	const content = md.render(source);
	/*
	 * 注释 tag ， 开始结束时的名称和长度
	*/
	const startTag = '<!--element-demo:';
	const startTagLen = startTag.length;
	const endTag = ':element-demo-->';
	const endTagLen = endTag.length;

	let componenetsString = '';
	// demo 的 id
	let id = 0;
	// 输出的内容
	let output = [];
	// 字符串开始位置
	let start = 0;

	// 获取 注释开始 tag 内容的起始位置
	let commentStart = content.indexOf(startTag);
	// 从 注释开始 tag 之后的位置，获取注释结束 tag 位置
	let commentEnd = content.indexOf(endTag, commentStart + startTagLen);

	// 循环处理 html 的内容，必须是有 开始 和 结尾 标识的
	while (commentStart !== -1 && commentEnd !== -1) {

		// 剔除 注释 开始 tag
		output.push(content.slice(start, commentStart));

		// 获取 注释 内容
		const commentContent = content.slice(commentStart + startTagLen, commentEnd);

		// 获取 template 的 html 信息
		const html = stripTemplate(commentContent);

		// 获取 script 信息
		const script = stripScript(commentContent);

		// 把md提取的内容  转换成 一个 内联组件
		let demoComponentContent = genInlineComponentText(html, script);

		// 内联组件 名称
		const demoComponentName = `element-demo${id}`;

		// 使用 slot 插槽 运行组件
		output.push(`<template slot="source"><${demoComponentName} /></template>`);

		// 页面组件 注册： 组件名称： 组件内容
		componenetsString += `${JSON.stringify(demoComponentName)}: ${demoComponentContent},`;

		// 重新计算下一次的位置
		id++;
		start = commentEnd + endTagLen;
		commentStart = content.indexOf(startTag, start);
		commentEnd = content.indexOf(endTag, commentStart + startTagLen);
	}

	// 仅允许在 demo 不存在时，才可以在 Markdown 中写 script 标签
	// todo: 优化这段逻辑
	let pageScript = '';
	if (componenetsString) {
		pageScript = `<script>
						export default {
							name: 'component-doc',
							components: {
								${componenetsString}
							}
						}
					</script>`;
	} else if (content.indexOf('<script>') === 0) {
		// 硬编码，有待改善
		start = content.indexOf('</script>') + '</script>'.length;
		pageScript = content.slice(0, start);
	}

	output.push(content.slice(start));
	
	return `
		<template>
			<section class="content element-doc">
				${output.join('')}
			</section>
		</template>
		${pageScript}
	`;
};
