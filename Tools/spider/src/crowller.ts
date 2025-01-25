import fs from 'fs';
import path from 'path';

const request = require('superagent');
require('superagent-charset')(request);

import cheerio from 'cheerio';

interface Course {
	title: string;
	url: number;
};

interface CourseResult {
	time: number;
	data: Course[];
}
  
interface Content {
	[propName: number]: Course[];
}

class Crowller {

	// 当前时间
    private getNowTime = () => {
		// 时间戳
		const now = new Date();
		// 年
		const year = now.getFullYear();
		// 月
		const month = now.getMonth() >= 9 ? now.getMonth() + 1 : `0${now.getMonth() + 1}`;
		// 日
		const date = now.getDate() >= 10 ? now.getDate() : `0${now.getDate()}`;
		// 组装
		return year + '.' + month + '.' + date;
	}

	// private date = this.getNowTime();

	// debug
	private date = '2023.02.20';

	// 要抓取的 HTML 页面
	private url = `http://epaper.caacmedia.cn:81/search?channelid=12168&searchword=NPID=1*pubdate=${this.date}*page2=001`;

	getCourseInfo(html: string) {

		/*
		 * 超链接 在行内 script 标签内部
		 * 故 采用 正则匹配 字符串 强制 匹配出来
		*/ 
		var rex = /window\.location\.href=\'[^'"]*\'/g;

		var cache = html.match(rex) || [];

		var url: any[] = [];

		// 更正 超链接 前缀
		cache.forEach((item) => {
			// 去除单引号
			item = item.replace(/'/g, "");
			// 替换 前缀
			item= item.replace(/window.location.href=/g, "http://epaper.caacmedia.cn:81");
			// 插入
			url.push(item);
		});

		// 灵活的对 JQuery 核心进行实现
		const $ = cheerio.load(html);

		// 超链接 文案元素
		const courseItems = $('.STYLE9');

		// 结果集 数据类型
		const courseInfos: Course[] = [];
		
		// 组装数据
		courseItems.map((index, element) => {
			// 文章标题
			let str = $(element).children()[0].prev.data || '';
			// 去空格
			const title = str.replace(/\s+/g,"");
			/*
			 * 过滤 广告 黑名单
			*/
			if (!['广告', '编辑'].includes(title)) {
				courseInfos.push({
					title: title,
					url: url[index]
				});
			}
		});

		return {
			time: new Date().getTime(),
			data: courseInfos
		}
	}

	// 加载 HTML
	async getRawHtml() {
		/*'
		 * 网页编码： superagent 默认采用 'utf-8'
		 * 注： 此处注释的方法 可以 动态获取编码，然后重新解析，后续有扩展，可以打开注释，本报刊 目前默认 gb2312
		*/
		var charset = "gb2312";

		// 匹配 meta 标签
		// var arr = res.text.match(/<meta([^>]*?)>/g);
		// if (arr) {
		// 	arr.forEach(function (val) {
		// 		var match = val.match(/charset\s*=\s*(.+)\"/);
		// 		if (match && match[1]) {
		// 			if (match[1].substr(0, 1) == '"')match[1] = match[1].substr(1);
		// 			charset = match[1].trim();
		// 		}
		// 	})
		// }

		// 获取网站 html
		const result = await request.get(this.url).buffer(true).charset(charset);
		return result.text;
	}

	generateJsonContent(courseInfo: CourseResult) {
		// 文件夹 目录
		const filePath = path.resolve(__dirname, '../data/course.json');
		// 文件 内容
		let fileContent: Content = {};
		// 存在 目录
		if (fs.existsSync(filePath)) {
			fileContent = JSON.parse(fs.readFileSync(filePath, 'utf-8'));
		}
		// 设置 数据
		fileContent[courseInfo.time] = courseInfo.data;
		// 抛出 数据
		return fileContent;
	}

	async initSpiderProcess() {
		// 加载 HTML
		const html = await this.getRawHtml();
		// 解析 DOM、标签
		const courseInfo = this.getCourseInfo(html);
		// 生成 json
		const fileContent = this.generateJsonContent(courseInfo);
		// 文件 路径
		const filePath = path.resolve(__dirname, '../data/course.json');
		// 写入
		fs.writeFileSync(filePath, JSON.stringify(fileContent));
	}

	constructor() {
		this.initSpiderProcess();
	}
}

const crowller = new Crowller();
