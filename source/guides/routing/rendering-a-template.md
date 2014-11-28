英文原文：[http://emberjs.com/guides/routing/rendering-a-template/](http://emberjs.com/guides/routing/rendering-a-template/)

路由处理方法最主要的职责之一就是将恰当的模板渲染到屏幕上去。
默认情况下，路由处理方法将模板渲染到离它最近的带有模板的父级模板中去。

```js
App.Router.map(function() {
  this.resource('posts');
});

App.PostsRoute = Ember.Route.extend();
```

如果你不想渲染与路由处理方法相关联的那个模板，那你就要实现`renderTemplate` 钩子来覆盖默认行为。

```js
App.PostsRoute = Ember.Route.extend({
  renderTemplate: function() {
    this.render('favoritePost');
  }
});
```

如果你希望使用一个不同的控制器来取代路由处理方法默认的控制器，那就需要在传递的参数中附上`controller`的名称。

```js
App.PostsRoute = Ember.Route.extend({
  renderTemplate: function() {
    this.render({ controller: 'favoritePost' });
  }
});
```

Ember还允许你给插座取名字。比如，下面的代码为两个插座取了不同的名字。

```handlebars
<div class="toolbar">{{outlet toolbar}}</div>
<div class="sidebar">{{outlet sidebar}}</div>
```

这样，当你想将你的博文渲染进`sidebar`这个插座时，用下面的这些代码：

```js
App.PostsRoute = Ember.Route.extend({
  renderTemplate: function() {
    this.render({ outlet: 'sidebar' });
  }
});
```

上面提到的所有选项，你都可以自由组合来使用。

```js
App.PostsRoute = Ember.Route.extend({
  renderTemplate: function() {
    var controller = this.controllerFor('favoritePost');

    // Render the `favoritePost` template into
    // the outlet `posts`, and display the `favoritePost`
    // controller.
    this.render('favoritePost', {
      outlet: 'posts',
      controller: controller
    });
  }
});
```

如果在路由中，你想将两个不同的模板渲染进另外两个附属于不同模板的插座：

```js
App.PostRoute = App.Route.extend({
  renderTemplate: function() {
    this.render('favoritePost', {   // the template to render
      into: 'posts',                // the template to render into
      outlet: 'posts',              // the name of the outlet in that template
      controller: 'blogPost'        // the controller to use for the template
    });
    this.render('comments', {
      into: 'favoritePost',
      outlet: 'comment',
      controller: 'blogPost'
    });
  }
});
```
