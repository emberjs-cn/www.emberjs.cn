英文原文：[http://emberjs.com/guides/application/](http://emberjs.com/guides/application/)

## 创建一个应用（Creating an Application）

The first step in creating an Ember.js application is to make an
instance of `Ember.Application`:

要创建一个 Ember.js 应用，首先需要创建一个`Ember.Application`的实例：

```javascript
window.App = Ember.Application.create();
```

Here we've called our application `App`, but you can call it whatever
makes the most sense for your application.

在这里，我们把这个应用命名为`App`，你可以为它取一个有实际项目意义的名字。

Having an application object is important for several reasons:

一开始就创建一个应用对象有很多重要原因：

1. It is your application's namespace. All of the classes in your application will
   be defined as properties on this object (e.g., `App.PostsView` and
   `App.PostsController`). This helps to prevent polluting of the global scope.

   它是你应用的命名空间，应用里面所有的类都会作为它的属性去定义（例如：`App.PostsView`和`App.PostsController`）。这样避免你污染了公共的域。

2. It adds event listeners to the document and is responsible for
   sending events to your views.

   它会帮你监听网页的事件，同时负责发送事件到你的视图。

3. It automatically renders the [_application
   template_](/guides/application/the-application-template), the root or base
   template, into which your other templates will be rendered.

   它会自动帮你渲染[_应用模板_](/guides/application/the-application-template)模板，应用模板是根模板，你其他的模板都会被渲染到该模板中去。

4. It automatically creates a router and begins routing, based on the
   current URL.

   它会基于当前的路径自动帮你创建一个路由，并开始进行路由。
