---
title: 第二期周报
tags: Weekly
author: Tower He
---

_本期对周报的内容进行了一点小的调整，就是主要内容的标题如果是英文的对被翻译为中文。_

本周Ember.js热点：

### 读物

#### [运用Yeoman和Mocha的Ember.js应用开发工作流](http://tech.pro/tutorial/1249/modern-emberjs-application-workflow-with-yeoman-and-mocha)

文章介绍了如何使用`Yeoman`来构建一个Ember.js应用。其中包括如何使用`Yeoman`来创建一个应用结构，如何编译，如何运行和如何测试等。

### 视频

#### [从零开始使用Ember.js构建RSS阅读器](http://www.youtube.com/watch?v=obaWh8xL2C0)

Gordon通过一个40分钟的视频，讲述了如何使用Ember.js从零开始来构建一个RSS阅读器。该阅读器实现的模型部分采用[ember-data](https://github.com/emberjs/data)来实现。本视频可以帮助我们更深入的理解如何使用Ember.js去构建优秀的应用。[示例代码下载](https://github.com/emberjs-seattle/ember-reader)

#### [简单且快速的测试Ember.js应用](http://www.youtube.com/watch?v=nO1hxT9GBTs)

Erik在视频中为我们介绍了如何使用[ember-testing][ember-testing]对Ember.js应用进行验收测试。[ember-testing][ember-testing]是Ember.js大家庭中新近加入的成员，旨在为我们提供一些列辅助测试的基础方法，方便我们为Ember.js应用编写测试。[查看演示代码](https://github.com/ebryn/bloggr-client-rails/blob/master/test/javascripts/integration/bloggr_test.js)

[ember-testing]: https://github.com/emberjs/ember.js/tree/master/packages/ember-testing

### 库、代码和工具

#### [ember-inflector](https://github.com/stefanpenner/ember-inflector)

提供一个与rails兼容的inflector，参见[ActiveSupport::Inflector](http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html)。

#### [ember-table](https://github.com/Addepar/ember-table)

表格是每个应用的核心控件之一，ember-table是一个非常优秀的采用Ember.js实现的表格控件。它几乎涵盖了大部分的应用场景，包括按列排序、树状表、Ajax加载、可编辑的单元格等等。[在线演示](http://addepar.github.io/ember-table/)

#### [ember-auth](https://github.com/heartsentwined/ember-auth)

[ember-auth](https://github.com/heartsentwined/ember-auth)是一个基于token进行身份验证的库，它假定服务器端实现了基于token的身份验证。它将在登录成功后从服务器获取token，并在之后所有的针对模型的查询和持久化的操作上附加该token。在用户注销时销毁该token。
