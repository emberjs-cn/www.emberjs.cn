www.emberjs.cn
==============

[`Ember.js`](http://emberjs.com)
中文资源分享网站，旨在中文开发者社区推广`Ember.js`。

### 路线图

1. 翻译`Ember.js`官方网站的Guides和API；
2. 收集、编写、提供`Ember.js`相关的文章和资源；
3. 搭建`Ember.js`中文交流社区。

### 贡献

现在处于网站建设的初期，有太多太多的文档需要翻译，希望大家能踊跃参与进来，我们一起来打造一个高质量的中文`Ember.js`资源分享平台。

#### 搭建开发环境

```
git clone git://github.com/emberjs-cn/www.emberjs.cn.git
cd www.emberjs.cn

bundle
bundle exec rake preview
```

然后访问[http://localhost:4567/](http://localhost:4567/)

#### 如何参与

1. 创建你要进行的翻译工作的[issue](https://github.com/emberjs-cn/www.emberjs.cn/issues)；（避免与其他人重复）
2. [fork本项目](https://github.com/emberjs-cn/www.emberjs.cn/fork_select)；
3. 在你的分支完成工作；
4. 提交一个申请（Pull Request）；
5. 然后等待合并。

注：通常我们会在一至两个工作日内完成申请的处理，在此期间我们可能会根据你提交的内容，给出一定的修改意见。

#### 指南翻译说明

我们将中英文对照翻译与中文版进行分离，这不仅可以更好的保持指南与官方英文原文的同步，也让我们的工作更加清晰化。指南翻译的具体步骤：

* 在`source/bilingual_guides`目录，完成中英文对照翻译；
* 在`source/guides`中添加对应的中文版本。

#### 注意事项

* 请在每篇指南开篇添加英文原文地址；
* 将文中的专用名词用块标注符标注出来，如`Ember.js`。

#### 其他

如果你发现网站的内容有问题，又没有时间帮助修正，你可以提交你发现的问题到[这里](https://github.com/emberjs-cn/www.emberjs.cn/issues)，非常感谢！
