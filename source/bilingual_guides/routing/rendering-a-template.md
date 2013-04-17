##渲染模板 （Rendering a Template）

One of the most important jobs of a route handler is rendering the
appropriate template to the screen.

渲染正确的模板到屏幕上，是路由处理器众多重要工作之一。

By default, a route handler will render the template into the closest 
parent with a template.

默认情况下，路由处理器会将模板渲染进跟它最接近的父模板中。

```js
App.Router.map(function() {
  this.resource('posts');
});

App.PostsRoute = Ember.Route.extend();
```

If you want to render a template other than the one associated with the
route handler, implement the `renderTemplate` hook:

通过实现`renderTemplate`钩子方法，你可以指定要渲染的模板：

```js
App.PostsRoute = Ember.Route.extend({
  renderTemplate: function() {
    this.render('favoritePost');
  }
});
```

If you want to use a different controller than the route handler's
controller, pass the controller's name in the `controller` option:

通过将控制器的名称赋给`controller`选项，你可以指定用来处理的控制器：

```js
App.PostsRoute = Ember.Route.extend({
  renderTemplate: function() {
    this.render({ controller: 'favoritePost' });
  }
});
```

If you want to render the template into a different named outlet:

如果你想指定出口的话：

```js
App.PostsRoute = Ember.Route.extend({
  renderTemplate: function() {
    this.render({ outlet: 'posts' });
  }
});
```

All of the options described above can be used together in whatever
combination you'd like:

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

NOTE: When a template tries to render, and the parent route did not render a template, then you will see this warning:

注意：模板渲染时，如果父模板并没有模板可渲染，那么你会收到一个警告：

"The immediate parent route did not render into the main outlet ..."

This means that the the current route tried to render into the parent routes template, but the parent route didn't render a template, or if it did, the template did not render 'into' the main template (a default {{outlet}}). For the case of the following routes: Application > Posts > Post, if the posts route does not have a template, the post template will render into the application template.

这意味着当前路由尝试渲染子模板到父模板，但是父模板并不想渲染模板，或者它想，但是模板并没有渲染进主模板中（默认的出口{{`outlet`}}）。假设有路由如下：
Application > Posts > Post，如果posts路由没有模板，那么post模板会被渲染进application模板。

This default behavior could be what you expect, or it could be unexpected and the warning is there to point out the potential unexpected behavior.

默认的表现可能如你所想，也可能不尽如人意，这里出现的警告就是想指出那些潜在的意外表现。

If you want to render two different templates into outlets of two different rendered templates of a route:

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
