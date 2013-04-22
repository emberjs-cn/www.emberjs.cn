英文原文：[http://emberjs.com/guides/application/](http://emberjs.com/guides/application/)

## 创建一个应用

要创建一个 Ember.js 应用，首先需要创建一个`Ember.Application`的实例：

```javascript
window.App = Ember.Application.create();
```

在这里，我们把这个应用命名为`App`，你可以为它取一个有实际项目意义的名字。

一开始就创建一个应用对象有很多重要原因：

1. 它是你应用的命名空间，应用里面所有的类都会作为它的属性去定义（例如：`App.PostsView`和`App.PostsController`）。这样避免你污染了公共的域。

2. 它会帮你监听网页的事件，同时负责发送事件到你的视图。

5. 它会自动帮你渲染[_应用模板_](/guides/application/the-application-template)模板，应用模板是根模板，你其他的模板都会被渲染到该模板中去。

4. 它会基于当前的路径自动帮你创建一个路由，并开始进行路由。
