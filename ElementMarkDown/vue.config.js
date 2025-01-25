/*
 * @Description: 
 * @Author: M.yunlong
 * @Date: 2021-11-29 17:08:17
 */
// const webpack = require('webpack');
const path = require("path");

module.exports = {
	lintOnSave: false,
	css: {
		loaderOptions:{
			sass:{

			},
			scss:{

			}
		}
	},
	chainWebpack(config){
		config.module
			.rule('md')
			.test(/\.md$/)
			.use('vue')
			.loader('vue-loader')
			.tap(options => {
				// 修改它的选项...
				if(options&&options.compilerOptions){
					options.compilerOptions.preserveWhitespace = false
				}
				return options
			})
			.end()
			.use('markdown')
			.loader(path.resolve(__dirname,"./webpack/md-loader/index.js"))
			.end()
	},
	devServer: {
		open:true
	}
}
