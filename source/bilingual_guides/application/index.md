## 创建一个应用（Creating an Application）

The first step in creating an Ember.js application is to make an
instance of `Ember.Application` and assign it to a global variable.

要创建一个 Ember.js
应用，首先需要创建一个`Ember.Application`的实例，并赋值给一个全局变量。

```javascript
window.App = Ember.Application.create();
```

Most people call their application `App`, but you can call it whatever
makes the most sense to you. Just make sure it starts with a capital
letter.

大部分人都选择将他们的应用命名为`App`，但是你可以将其命名为任何其他多余你来说更有意义的名字，只需要保证名称的首字母大写即可。

What does creating an `Ember.Application` instance get you?

创建一个`Ember.Application`意味着：

1. It is your application's namespace. All of the classes in your application will
   be defined as properties on this object (e.g., `App.PostsView` and
   `App.PostsController`). This helps to prevent polluting of the global scope.

   它是你应用的命名空间，应用里面所有的类都会作为它的属性去定义（例如：`App.PostsView`和`App.PostsController`）。这样避免你污染了公共的域。

2. It adds event listeners to the document and is responsible for delegating events to your views. (See [The View Layer](/guides/understanding-ember/the-view-layer)

   它为你添加了网页事件监听器，并且负责把事件委派到你的视图。（参看[视图层](/guides/understanding-ember/the-view-layer)）

3. It automatically renders the [_application
   template_](/guides/templates/the-application-template).

   它会自动帮你渲染[_应用模板_](/guides/templates/the-application-template)模板。

4. It automatically creates a router and begins routing, choosing which
   template and model to display based on the current URL.

   它会基于当前的路径，选择需要显示的模板和模型，自动帮你创建一个路由，并开始路由。
