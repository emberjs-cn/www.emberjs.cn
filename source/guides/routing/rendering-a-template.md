##渲染模板 

渲染正确的模板到屏幕上，是路由处理器众多重要工作之一。

默认情况下，路由处理器会将模板渲染进跟它最接近的父模板中。

```js
App.Router.map(function() {
  this.resource('posts');
});

App.PostsRoute = Ember.Route.extend();
```

通过实现`renderTemplate`钩子方法，你可以指定要渲染的模板：

```js
App.PostsRoute = Ember.Route.extend({
  renderTemplate: function() {
    this.render('favoritePost');
  }
});
```

通过将控制器的名称赋给`controller`选项，你可以指定用来处理的控制器：

```js
App.PostsRoute = Ember.Route.extend({
  renderTemplate: function() {
    this.render({ controller: 'favoritePost' });
  }
});
```

如果你想指定出口的话：

```js
App.PostsRoute = Ember.Route.extend({
  renderTemplate: function() {
    this.render({ outlet: 'posts' });
  }
});
```

所有以上所说的选项都可以任意组合，就像：

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

注意：模板渲染时，如果父模板并没有模板可渲染，那么你会收到一个警告：

"The immediate parent route did not render into the main outlet ..."

这意味着当前路由尝试渲染子模板到父模板，但是父模板并不想渲染模板，或者它想，但是模板并没有渲染进主模板中（默认的出口{{`outlet`}}）。假设有路由如下：
Application > Posts > Post，如果posts路由没有模板，那么post模板会被渲染进application模板。

默认的表现可能如你所想，也可能不尽如人意，这里出现的警告就是想指出那些潜在的意外表现。

如果你想在一个路由中渲染两个不同的模板到两个不同的出口，你可以：

```js
App.PostRoute = App.Route.extend({
  renderTemplate: function() {
    this.render('favoritePost', {   // the template to render
      into: 'posts',                // the template to render into
      outlet: 'posts',       // the name of the outlet in that template
      controller: 'blogPost'  // the controller to use for the template
    });
    this.render('comments', {
      into: 'favoritePost',
      outlet: 'comment',
      controller: 'blogPost'
    });
  }
});
```
