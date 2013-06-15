英文原文：[http://emberjs.com/guides/views/](http://emberjs.com/guides/views/)
## 视图介绍 (Introduction to Views)

Because Handlebars templates in Ember.js are so powerful, the majority
of your application's user interface will be described using them. If
you are coming from other JavaScript libraries, you may be surprised at
how few views you have to create.

因为`Ember.js`的`Handlebars`模板十分强大，所以你的应用中的大部分用户界面将采用模版来描述。如果你之前使用其他的`JavaScript`库，那么你可能会惊叹为什么`Ember.js`只需要创建这么少的视图。

Views in Ember.js are typically only created for the following reasons:

`Ember.js`里视图的创建通常只有如下原因：

* When you need sophisticated handling of user events

* 当你需要处理复杂的用户事件时

* When you want to create a re-usable component

* 当你想要创建一个可重用的构件时

Often, both of these requirements will be present at the same time.

这两种需求经常会同时出现。


### 事件处理(Event Handling)

The role of the view in an Ember.js application is to translate
primitive browser events into events that have meaning to your
application.

视图在`Ember.js`的应用中起到将原始浏览器事件转变成你应用中有意义的事件的作用。

For example, imagine you have a list of todo items. Next to each todo is
a button to delete that item:

例如，设想你有一系列的`todo`项。在每个`todo`后面有一个按键可以删除该项：

![Todo List](/guides/views/images/todo-list.png)

The view is responsible for turning a _primitive event_ (a click) into a
_semantic event_: delete this todo! These semantic events are first
sent up to the controller, or if no method is defined there, your application's 
router, which is responsible for reacting to the event based on the 
current state of the application.

视图负责将一个 _原始事件_ (点击) 转换成一个 _语义化事件_：删除此`todo`！这些语义化事件首先会发送给控制器，如果控制器没有定义相关的处理方法，那么会发送到应用的路由，路由负责根据当前应用的状态响应该事件。

![Todo List](/guides/views/images/primitive-to-semantic-event.png)
