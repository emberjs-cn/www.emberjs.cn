英文原文：[http://emberjs.com/guides/views/](http://emberjs.com/guides/views/)
## 视图介绍

因为`Ember.js`的`Handlebars`模板十分强大，所以你的应用中的大部分用户界面将采用模版来描述。如果你之前使用其他的`JavaScript`库，那么你可能会惊叹为什么`Ember.js`只需要创建这么少的视图。

`Ember.js`里视图的创建通常只有如下原因：

* 当你需要处理复杂的用户事件时

* 当你想要创建一个可重用的构件时

这两种需求经常会同时出现。

### 事件处理

视图在`Ember.js`的应用中起到将原始浏览器事件转变成你应用中有意义的事件的作用。

例如，设想你有一系列的`todo`项。在每个`todo`后面有一个按键可以删除该项：

![Todo List](/guides/views/images/todo-list.png)

视图负责将一个 _原始事件_ (点击) 转换成一个 _语义化事件_：删除此`todo`！这些语义化事件会发送到你应用的路由，路由负责根据当前应用的状态响应该事件。

![Todo List](/guides/views/images/primitive-to-semantic-event.png)
