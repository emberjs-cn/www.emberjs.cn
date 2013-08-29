英文原文：[http://emberjs.com/guides/models/](http://emberjs.com/guides/models/)

## 模型

在大部分的 Ember.js 应用里，模型是通过 [Ember Data](https://github.com/emberjs/data) 来处理的。Ember
Data 是一个由 Ember.js 写的库，它使我们可以很方便从服务器端取回记录并动态改变浏览器中的内容，然后保存这些更改回服务器。

你可以在服务器端找到像 ActiveRecord 这样的 ORM，不过它提供了专门为浏览器端的 Javascript 环境设计的工具方法。

Ember Data 并不需要任务配置就可以通过 RESTful JSON API 的惯例来加载和保存记录和关系。

我们也知道世界上还有很多Web服务的API，其中许多会是荒唐的，矛盾的和容易失去控制。
Ember Data 被设计成可配置的，无论你想要怎么样的持久层它都可以满足。

目前， Ember Data还是作为Ember.js的一个独立的库，与此同时，我们仍然在扩展适配器的API以便支持更多功能。
在Ember Data被作为标准配置的一部分之前，你可以从其[builds.emberjs.com][builds]下载到从"master"分支编译得到的最新的拷贝。

* [Development][development-build]
* [Minified][minified-build]
 
[emberdata]: https://github.com/emberjs/data
[builds]: http://builds.emberjs.com
[development-build]: http://builds.emberjs.com/latest/ember-data.js
[minified-build]: http://builds.emberjs.com/latest/ember-data.min.js
