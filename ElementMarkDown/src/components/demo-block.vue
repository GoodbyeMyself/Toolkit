<template>
	<div
		class="demo-block"
		:class="[
			blockClass,
			{ 'hover': hovering }
		]"
		@mouseenter="hovering = true"
		@mouseleave="hovering = false"
	>
		<div class="source">
			<slot name="source"></slot>
		</div>
		<div class="meta" ref="meta">
			<div class="description" v-if="$slots.default">
				<slot></slot>
			</div>
			<div class="highlight">
				<slot name="highlight"></slot>
			</div>
		</div>
		<div
			class="demo-block-control"
			ref="control"
			:class="{
				'is-fixed': fixedControl
			}"
			@click="isExpanded = !isExpanded"
		>
			<transition name="arrow-slide">
				<i :class="[iconClass, { 'hovering': hovering }]"></i>
			</transition>
			<transition name="text-slide">
				<span v-show="hovering">{{ controlText }}</span>
			</transition>
		</div>
	</div>
</template>

<script type="text/babel">
export default {
	data() {
		return {
			hovering: false,
			isExpanded: false,
			fixedControl: false,
			scrollParent: null
		};
	},
	computed: {
		lang() {
			return this.$route.path.split('/')[1];
		},
		langConfig() {
			return {
				"hide-text": "隐藏代码",
				"show-text": "显示代码"
			}
		},
		blockClass() {
			return `demo-${ this.lang } demo-${ this.$router.currentRoute.path.split('/').pop() }`;
		},
		iconClass() {
			return this.isExpanded ? 'el-icon-caret-top' : 'el-icon-caret-bottom';
		},
		controlText() {
			return this.isExpanded ? this.langConfig['hide-text'] : this.langConfig['show-text'];
		},
		codeArea() {
			return this.$el.getElementsByClassName('meta')[0];
		},
		codeAreaHeight() {
			if (this.$el.getElementsByClassName('description').length > 0) {
				return this.$el.getElementsByClassName('description')[0].clientHeight + this.$el.getElementsByClassName('highlight')[0].clientHeight + 20;
			}
			return this.$el.getElementsByClassName('highlight')[0].clientHeight;
		}
	},
	watch: {
		isExpanded(val) {
			this.codeArea.style.height = val ? `${ this.codeAreaHeight + 1 }px` : '0';
			if (!val) {
				this.fixedControl = false;
				this.$refs.control.style.left = '0';
				return false;
			}
			// setTimeout(() => {
			// 	this.scrollParent = document.querySelector('.page-component__scroll > .el-scrollbar__wrap');
			// 	this.scrollParent && this.scrollParent.addEventListener('scroll', this.scrollHandler);
			// 	this.scrollHandler();
			// }, 200);
		}
	},
	mounted() {
		this.$nextTick(() => {
			let highlight = this.$el.getElementsByClassName('highlight')[0];
			if (this.$el.getElementsByClassName('description').length === 0) {
				highlight.style.width = '100%';
				highlight.borderRight = 'none';
			}
		});
	},
	methods: {
		scrollHandler() {
			const { top, bottom, left } = this.$refs.meta.getBoundingClientRect();
			this.fixedControl = bottom > document.documentElement.clientHeight && top + 44 <= document.documentElement.clientHeight;
			this.$refs.control.style.left = this.fixedControl ? `${ left }px` : '0';
		}
		// removeScrollHandler() {
		// 	this.scrollParent && this.scrollParent.removeEventListener('scroll', this.scrollHandler);
		// }
	}
	// beforeDestroy() {
	// 	this.removeScrollHandler();
	// }
};
</script>
