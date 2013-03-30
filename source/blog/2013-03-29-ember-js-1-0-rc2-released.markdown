---
title: Ember.js 1.0.0-rc2发布
tags: 最近文章
author: Tower He
---

今天`Ember.js`
1.0.0-rc2发布了，改版本主要完成了Bug的修订和文档的增强，另外也改进了一些内部的处理逻辑，使`Ember.js`更加趋于稳定。

变更记录：

* 改进了应用初始化过程，废弃了`Ember.Application#initialize`，使用`deferReadiness`和`advanceReadiness`取代。
* 添加`Ember.Application#then`，其如同`isReady`钩子一样触发。
* 添加更多`Ember.computed`宏。
* 为计算属性添加`readOnly`标记。
* `Enumerable#compact`将删除`undefined`值。
* 修正在虚拟视图上注销操作的问题。
* 公开`Ember.LinkView`。
* 支持jQuery 2.0。
* 支持火狐10或更低版本不支持`domElement.outerHTML`的浏览器。
* 更容易增大应用容器的解析器。
* 在`{{view}}`助手中添加`tagName`的别名`tag`。
* 将`name`加入`Ember.TextField`和`Ember.Select`的`attributeBinding`。
* `Ember.merge`返回被合并的对象。
* 废除在`Metamorphs`上设置`tagNames`。
* 避免了父级隐藏的`index`路由影响子级显示的`index`。
* `App#reset`行为更接近`App#create`。
* `Evented#on、#off、#one`支持链式调用。
* 为`{{action}}`助手添加一个基本的`allowedKeys`的实现。
* 改进了`Ember.Array#slice`的实现。
* 修正了`ArrayProxy`的`arrangedObject`处理，修正了#2121，#2138。
* 支持自定义默认生成的控制器和路由。
* 改进了`HistoryLocation`的`popstate`处理，修正了#2234。
* 修正了IE7的问题。
* 标准化了`Ember.run.later`和`Ember.run.next`的行为。
* 修正了`classNameBindings`尝试更新已经删除的元素的问题。
* `Ember.Array`方法总是返回`Ember.Arrays`。
* `RSVP`可以通过`Ember.RSVP`来调用。
* `ObjectProxy`不再尝试在创建的时候代理不可知的属性。
* 可以通过将`ENV.LOG_VERSION`设置为`false`来关闭日志中输出版本信息。
* `Ember.ArrayController#lastObject`不再抛出异常，即便是空的。
* Fixes to {{render}} helper when used with model
* 修正了`{{render}}`助手与模型一起使用的时候的问题。
* 增强了`{{linkTo}}`控制器处理。
* 修正了目标属性在`{{#each prop in array}}`时的`{{bindAttr}}` - #1523。
* `String#camelize`将首字母小写。
* 另外还修正了许多其他的问题，并改进了文档。
