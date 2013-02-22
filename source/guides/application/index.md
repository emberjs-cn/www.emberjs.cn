## 创建一个应用（Creating an Application）

The first step in creating an Ember.js application is to make an
instance of `Ember.Application`:

要创建一个 Ember.js 应用，第一步是需要创建一个`Ember.Application`的实例：

```javascript
window.App = Ember.Application.create();
```

Here we've called our application `App`, but you can call it whatever
makes the most sense for your application.

在这里，我们把这个应用命名为`App`，同时你可以把它命名为对你的项目有实际含义的名字。

Having an application object is important for several reasons:

对于一开始就先创建一个应用的对象非常重要，因为：

1. It is your application's namespace. All of the classes in your application will
   be defined as properties on this object (e.g., `App.PostsView` and
   `App.PostsController`). This helps to prevent polluting the global scope.
   它是你应用的命名空间，你应用里面所有的类都会作为它的属性去定义（例如：`App.PostsView`和`App.PostsController`）。这样避免你污染了公共的域。
2. It adds event listeners to the document and is responsible for
   sending events to your views.
   它会帮你监听网页的事件，同时负责发送事件到你的页面。
3. It automatically renders the [_application
   template_](the-application-template), the root-most
   template, into which your other templates will be rendered.
   它会自动帮你把最上层的模板[_application template_](application/the-application-template)渲染到其他需要用到的模板中。
4. It automatically creates a router and begins routing, based on the
   current URL.
   它会基于当前的路径自动帮你创建路由系统并启动路由。
