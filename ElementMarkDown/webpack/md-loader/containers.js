/*
 * @Description: 文件使用 markdown-it-container 来转换自定义容器, 将自定义容器 :::demo 转换成 demo-block 组件
 * @Author: M.yunlong
 * @Date: 2023.03.01 15：43
 */

// 识别 markdown的 ::: 转换成div
const mdContainer = require('markdown-it-container');

module.exports = md => {
	/*
	 * 约定的文档格式, 用在 markdown-it 里面 进行规则识别
	 * ::: demo 中 写演示的例子, :::demo 中 ```(fence)中编写代码
	 * ::: 属于 MarkDown 中的 拓展语法，通过他来自定义容器
	*/
	md.use(mdContainer, 'demo', {

		// 验证 代码块为 :::demo::: 才可以渲染
		validate(params) {
			// *是匹配0次以上
			return params.trim().match(/^demo\s*(.*)$/);
		},
		/**
		 * 自定义 容器 demo, 转成 demo-block 组件
		 * tokens 符合上面规则的所有内容
		 * idx 某一条的id
		 */
		render(tokens, idx) {

			const m = tokens[idx].info.trim().match(/^demo\s*(.*)$/);

			if (tokens[idx].nesting === 1) {
				
				// 获取 第一行的内容， 使用 markdown 渲染 html 作为组件的描述
				const description = m && m.length > 1 ? m[1] : '';

				// html的匹配内容
				const content = tokens[idx + 1].type === 'fence' ? tokens[idx + 1].content : '';

				// 返回把内容放到已经写好的组件demo-block里；把html的内容放到!--element-demo里，偏于后面处理抽取
				// demo-block 组件已经是在entry.js 里作为全局组件注册过了可以直接使用
				return `<demo-block>
							${description ? `<div>${md.render(description)}</div>` : ''}
							<!--element-demo: ${content}:element-demo-->
						`;
				}
				return '</demo-block>';
			}
		}
	);
	// 解析 :::tip:::
	md.use(mdContainer, 'tip');
	// 解析 :::warning :::
	md.use(mdContainer, 'warning');
};
