/*
 * @Description: 入口文件
 * @Author: M.yunlong
 * @Date: 2023.03.01 11:53
 */
import Vue from 'vue'
import App from './App.vue'
import VueRouter from 'vue-router';
import Element from 'element-ui'

// 高亮函数
import hljs from 'highlight.js';

// 注册 组件
import demoBlock from './components/demo-block';

// element 样式
import 'element-ui/lib/theme-chalk/index.css';

// demo 组件样式
import './assets/scss/index.scss';

Vue.config.productionTip = false

Vue.use(Element);

Vue.use(VueRouter);

Vue.component('demo-block', demoBlock);

const router = new VueRouter({
	mode: 'hash',
	base: __dirname,
	routes:[{
		path:'',
		redirect:"/button"
	}, {
		path:"/button",
		component:() => import("@/components/docs/button.md")
	}]
});

router.afterEach(() => {
	// https://github.com/highlightjs/highlight.js/issues/909#issuecomment-131686186
	Vue.nextTick(() => {
		const blocks = document.querySelectorAll('pre code:not(.hljs)');
		Array.prototype.forEach.call(blocks, hljs.highlightBlock);
	});
});


new Vue({
	router,
	render: h => h(App)
}).$mount('#app')
