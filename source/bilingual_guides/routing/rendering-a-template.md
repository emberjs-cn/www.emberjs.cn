## Rendering a Template

## 渲染模板

One of the most important jobs of a route handler is rendering the
appropriate template to the screen.

路由处理方法最主要的指责之一就是将恰当的模板渲染到屏幕上去。

By default, a route handler will render the template into the closest 
parent with a template.

默认情况下，路由处理方法将模板渲染到离它最近的带有模板的父级模板中去。

```js
App.Router.map(function() {
  this.resource('posts');
});

App.PostsRoute = Ember.Route.extend();
```

If you want to render a template other than the one associated with the
route handler, implement the `renderTemplate` hook:

如果你不想渲染与路由处理方法相关联的那个模板，那你就要实现`renderTemplate` 钩子来覆盖默认行为。

```js
App.PostsRoute = Ember.Route.extend({
  renderTemplate: function() {
    this.render('favoritePost');
  }
});
```

If you want to use a different controller than the route handler's
controller, pass the controller's name in the `controller` option:

如果你希望使用一个不同的控制器来取代路由处理方法默认的控制器，那就需要在传递的参数中附上`controller`的名称。

```js
App.PostsRoute = Ember.Route.extend({
  renderTemplate: function() {
    this.render({ controller: 'favoritePost' });
  }
});
```

Ember allows you to name your outlets. For instance, this code allows
you to specify two outlets with distinct names:

Ember还允许你给插座取名字。比如，下面的代码为两个插座取了不同的名字。

```handlebars
<div class="toolbar">{{outlet toolbar}}</div>
<div class="sidebar">{{outlet sidebar}}</div>
```

So, if you want to render your posts into the `sidebar` outlet, use code
like this:

这样，当你想将你的博文渲染进`sidebar`这个插座时，用下面的这些代码：

```js
App.PostsRoute = Ember.Route.extend({
  renderTemplate: function() {
    this.render({ outlet: 'sidebar' });
  }
});
```

All of the options described above can be used together in whatever
combination you'd like:

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

If you want to render two different templates into outlets of two different rendered templates of a route:

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

## Rendering Warning

## 渲染警告

When a template tries to render, and the parent route did not render a
template, then you will see this warning:

"The immediate parent route did not render into the main outlet ..."

当渲染一个模板时，如果父级路由并没有渲染模版，那么你会看到一条警告：
“直接父级路由没有渲染进主插座……”

This means that the current route tried to render into the parent
route's template, but the parent route didn't render a template, or, if
it did, that the template which the parent route provided did not render
into the main template (i.e., a default `{{outlet}}`).

Ember provides this warning because it expects that you will want to
render into the main template.

什么意思呢？当前路由试图渲染进父级路由的模板，但父级路由没有渲染模板，或者假使父级路由渲染了模板，但是父级路由提供的模板却没有渲染进主插座（也就是说，一个默认的`{{outlet}}`插座）

Ember提供这条警告是希望你将模板渲染到主模板中去。
