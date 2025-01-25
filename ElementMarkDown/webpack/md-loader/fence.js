/*
 * @Description: 重写了代码块（fence）默认渲染规则
 * @Author: M.yunlong
 * @Date: 2023.03.01 15：43
 */

// 覆盖默认的 fence 渲染策略
module.exports = md => {

	// 对于 token 的渲染规则，可以被更新和扩展
	const defaultRender = md.renderer.rules.fence;

	md.renderer.rules.fence = (tokens, idx, options, env, self) => {

		const token = tokens[idx];

		// 判断该 fence 是否在 :::demo 内
		const prevToken = tokens[idx - 1];

		const isInDemoContainer = prevToken && prevToken.nesting === 1 && prevToken.info.trim().match(/^demo\s*(.*)$/);

		if (token.info === 'html' && isInDemoContainer) {
			/*
			 * v-pre 是 vue 自带指令， 用来显示 原始 Mustache 标签
			 * 考虑到 代码片段 会包含 Mustache 标签 , 使用该指令 来跳过对 code 的编译
			*/
			return `<template slot="highlight"><pre v-pre><code class="html">${md.utils.escapeHtml(token.content)}</code></pre></template>`;
		}
		return defaultRender(tokens, idx, options, env, self);
	};
};
