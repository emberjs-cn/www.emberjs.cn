英文原文：[http://emberjs.com/guides/concepts/naming-conventions/](http://emberjs.com/guides/concepts/naming-conventions/)


## 命名惯例(Naming Conventions)

Ember.js uses naming conventions to wire up your objects without a 
lot  of boilerplate. You will want to  use the conventional names 
for your routes, controllers and templates.

`Ember.js`使用命名惯例来连接各个对象，而不是通过大量的引用。对于路由，控制器以及模板，你都应该使用此命名惯例。

You can usually guess the names, but this guide outlines, in one place, all of the naming conventions.

有些时候，或许你可以猜到某些正确的命名，但是，这篇指南在此概述了所有的命名惯例。

## 应用程序(The Application)

When your application boots, Ember will look for these objects:

当你的应用程序启动时，`Ember`会查找下面几个对象:

* `App.ApplicationRoute`
* `App.ApplicationController`
* the `application` template
* `application`模板

Ember.js will render the `application` template as the main template.
If `App.ApplicationController` is provided, Ember.js will set an
instance of `App.ApplicationController` as the controller for the
template. This means that the template will get its properties from
the controller.

`Ember.js`会将`application`模板作为主模板来渲染。如果存在`App.ApplicationController`,
`Ember.js`将使用`App.ApplicationController`的一个实例作为此模板的控制器。这意味着此模板将从这个控制器获得属性。

If your app provides an `App.ApplicationRoute`, Ember.js will invoke
[the][1] [router's][2] [hooks][3] first, before rendering the
`application` template.

如果你的应用提供了`App.ApplicationRoute`,`Ember.js`将在渲染`application`模板前先调用[此][1][路由][2]的[钩子程序][3]。

[1]: /guides/routing/specifying-a-routes-model
[2]: /guides/routing/setting-up-a-controller
[3]: /guides/routing/rendering-a-template

Here's a simple example that uses a route, controller, and template:

下面这个例子中同时包含了路由，控制器和模板:

```javascript
App.ApplicationRoute = Ember.Route.extend({
  setupController: function(controller) {
    // `controller` is the instance of ApplicationController
    controller.set('title', "Hello world!");
  }
});

App.ApplicationController = Ember.Controller.extend({
  appName: 'My First Example'
});
```

```handlebars
<!-- application template -->
<h1>{{appName}}</h1>

<h2>{{title}}</h2>
```

In Ember.js applications, you will always specify your controllers 
as **classes**, and the framework is responsible for instantiating
them and providing them to your templates.

在`Ember.js`应用中，你可以总是将控制器看作是一个个的**类**，应用程序框架负责实例化类并且将他们提供给模板。

This makes it super-simple to test your controllers, and ensures that
your entire application shares a single instance of each controller.

这将使测试控制器的工作变得轻而易举，并且确保每个控制器在整个应用中只有唯一的一个实例。

## 简单的路由（Simple Routes)

Each of your routes will also have a route, a controller and a 
template named after the route.

Each of your routes will have a controller and a template with the 
+same name as the route.

对于应用中的每一个路由，都会有以路由名称命名的控制器和模板。

Let's start with a simple router:

以下面这个简单的路由为例：

```javascript
App.Router.map(function() {
  this.route('favorites');
});
```

If your user navigates to `/favorites`, Ember.js will look for these 
objects:

如果用户要访问`/favorites`，`Ember.js`会查找下面几个对象：

* `App.FavoritesRoute`
* `App.FavoritesController`
* the `favorites` template
* `favorites`模板 


Ember.js will render the `favorites` template into the `{{outlet}}`
in the `application` template. It will set an instance of the
`App.FavoritesController` as the controller for the template.

`Ember.js`会将`favorites`模板渲染到`application`模板中的`{{outlet}}`中去，
还将会把`App.FavoritesController`的一个实例作为此模板的控制器。

If your app provides an `App.FavoritesRoute`, the framework will 
invoke it before rendering the template. Yes, this is a bit 
repetitive.

如果你的应用程序提供了`App.FavoritesRoute`，应用程序框架会在渲染模板前先调用它。当然，这里会有点重复过程。

For a route like `App.FavoritesRoute`, you will probably implement
the `model` hook to specify what model your controller will present
to the template.

对于一个路由，例如`App.FavoritesRoute`,你可能需要实现`model`钩子去指定你的控制器要呈现给模板的模型。

Here's an example:

下面是一个例子：

```javascript
App.FavoritesRoute = Ember.Route.extend({
  model: function() {
    // the model is an Array of all of the posts
    return App.Post.find();
  }
});
```

In this example, we didn't provide a `FavoritesController`. Because
the model is an Array, Ember.js will automatically supply an instance
of `Ember.ArrayController`, which will present the backing Array as
its model.

在这个例子中，我们并没有提供`FavoritesController`。因为该模型是一个数组，`Ember.js`会自动提供一个`Ember.ArrayController`，它将会把返回的数组视为模型。

You can treat the `ArrayController` as if it was the model itself. 
This has two major benefits:

你可以将`ArrayController`本身就看做是一个模型。这主要有两个优点：

* You can replace the controller's model at any time without having
  to directly notify the view of the change.

* 你可以在任何时候变更控制器的模型而无需直接考虑视图的变化。

* The controller can provide additional computed properties or
  view-specific state that do not belong in the model layer. This
  allows a clean separation of concerns between the view, the
  controller and the model.

* 控制器可以提供额外的不属于模型层的可计算属性或特定视图的状态。这使视图，控制器和模型之间的分层结构更清晰。

The template can iterate over the elements of the controller:

模板可以迭代控制器中的元素：

```handlebars
<ul>
{{#each controller}}
  <li>{{title}}</li>
{{/each}}
</ul>
```

## 动态字段(Dynamic Segments)

If a route uses a dynamic segment, the route's model will be based
on the value of that segment provided by the user.

如果一个路由中使用了一个动态字段，它对应的模型将基于用户提供的那个字段的值。

Consider this router definition:

考虑下面这个路由的定义：

```javascript
App.Router.map(function() {
  this.resource('post', { path: '/posts/:post_id' });
});
```

In this case, the route's name is `post`, so Ember.js will look for
these objects:

在这个例子中，路由的名称是`post`, 所以`Ember.js`将查找以下几个对象:

* `App.PostRoute`
* `App.PostController`
* the `post` template
* `post`模板 

Your route handler's `model` hook converts the dynamic `:post_id`
parameter into a model. The `serialize` hook converts a model object
back into the URL parameters for this route (for example, when 
generating a link for a model object).

路由处理程序的`model`钩子将把动态参数`:post_id`转换到模型中去。而`serialize`钩子将会为这个路由把一个模型对象转化回URL参数(例如，在为一个模型对象生成链接的情况下)。

```javascript
App.PostRoute = Ember.Route.extend({
  model: function(params) {
    return App.Post.find(params.post_id);
  },

  serialize: function(post) {
    return { post_id: post.get('id') };
  }
});
```

Because this pattern is so common, it is the default for route
handlers.

由于这个模式太常见，现在它是默认的路由处理程序。

* If your dynamic segment ends in `_id`, the default `model`
  hook will convert the first part into a model class on the
  application's namespace (`post` becomes `App.Post`). It will
  then call `find` on that class with the value of the dynamic
  segment.

* 如果你的动态字段以`_id`结束，默认的`model`钩子会将第一部分转化为在应用程序命名空间中的一个模型类(`post`变成`App.Post`).
  然后，钩子将在这个模型类中调用`find`函数，函数的参数即是动态字段的值。

* The default `serialize` hook will pull the dynamic
  segment with the `id` property of the model object.

* 默认的`serialize`钩子将会使用模型对象的`id`属性代替动态字段。

## 路由，控制器和默认模板 (Route, Controller and Template Defaults)

If you don't specify a route handler for the `post` route
(`App.PostRoute`), Ember.js  will still render the `post` 
template with the app's instance of `App.PostController`.

如果你没有为`post`路由(`App.PostRoute`)指定一个路由处理程序，`Ember.js`仍然会使用`App.PostController`的一个实例来渲染`post`模板。

If you don't specify the controller (`App.PostController`),
Ember will automatically make one for you based on the return value
of the route's `model` hook. If the model is an Array, you get an
`ArrayController`. Otherwise, you get an `ObjectController`.

如果你没有指定控制器(`App.PostController`)，`Ember`将会根据路由的`model`钩子的返回值自动创建一个。如果模型是一个数组，那么就会创建`ArrayController`。
否则，将创建`ObjectController`。

If you don't specify a `post` template, Ember.js won't render 
anything!

如果你没有指定一个`post`模板，那么，`Ember.js`什么也不会渲染。

## 嵌套 (Nesting)

You can nest routes under a `resource`.

你可以在一个`resource`内嵌套路由。

```javascript
App.Router.map(function() {
  this.resource('posts', function() { // the `posts` route
    this.route('favorites');          // the `posts.favorites` route
    this.resource('post');            // the `post` route
  });
});
```

A **resource** is the beginning of a route, controller, or template 
name. Even though the `post` resource is nested, its route is named
`App.PostRoute`, its controller is named `App.PostController` and its
template is `post`.

**资源**的名称与路由，控制器或模板的起始名称一致。即使`post`资源被嵌套了，它的路由的名称
仍是`App.PostRoute`, 控制器名称是`App.PostController`,模板名称是`post`。

When you nest a **route** inside a resource, the route name is added
to the resource name, after a `.`.

如果你在一个资源内嵌套了一个**路由**,此路由的名称将变为`资源名称.路由名称`。

Here are the naming conventions for each of the routes defined in
this router:

下面定义了上面例子中各个路由的命名惯例：

<table>
  <thead>
  <tr>
    <th>Route Name</th>
    <th>Controller</th>
    <th>Route</th>
    <th>Template</th>
  </tr>
  </thead>
  <tr>
    <td><code>posts</code></td>
    <td><code>PostsController</code></td>
    <td><code>PostsRoute</code></td>
    <td><code>posts</code></td>
  </tr>
  <tr>
    <td><code>posts.favorites</code></td>
    <td><code>PostsFavoritesController</code></td>
    <td><code>PostsFavoritesRoute</code></td>
    <td><code>posts/favorites</code></td>
  </tr>
  <tr>
    <td><code>post</code></td>
    <td><code>PostController</code></td>
    <td><code>PostRoute</code></td>
    <td><code>post</code></td>
  </tr>
</table>

The rule of thumb is to use resources for nouns, and routes for
adjectives (`favorites`) or verbs (`edit`). This ensures that 
nesting does not create ridiculously long names, but avoids 
collisions with common adjectives and verbs.

命名的经验就是：资源名称为名词,路由名称应为形容词(`favorites`)或动词(`edit`).
这不仅确保了在嵌套的时候不会产生冗长的名称，而且可以避免常见形容词和动词之间的冲突。

## 索引路由 (The Index Route)

At every level of nesting (including the top level), Ember.js 
automatically provides a route for the `/` path named `index`.

在嵌套的每一个层次(包括最上层),`Ember.js`自动为`/`路径提供了一个名称为`index`的路由。

For example, if you write a simple router like this:

例如，假如你写了如下这样一个简单的路由：

```javascript
App.Router.map(function() {
  this.route('favorites');
});
```

It is the equivalent of:

```javascript
App.Router.map(function() {
  this.route('index', { path: '/' });
  this.route('favorites');
});
```

If the user visits `/`, Ember.js will look for these objects:

如果你的用户访问`/`路径，`Ember.js`会首先查找以下几个对象：

* `App.IndexRoute`
* `App.IndexController`
* the `index` template
* `index`模板 

The `index` template will be rendered into the `{{outlet}}` in the 
`application` template. If the user navigates to `/favorites`,
Ember.js will replace the `index` template with the `favorites`
template.

`index`模板将被渲染到`application`模板中的`{{outlet}}`中去。如果用户访问`/favorites`,
`Ember.js`将用`favorites`模板取代`index`模板。

A nested router like this:

例如，下面这个嵌套的路由：

```javascript
App.Router.map(function() {
  this.resource('posts', function() {
    this.route('favorites');
  });
});
```

Is the equivalent of:

等价于：

```javascript
App.Router.map(function() {
  this.route('index', { path: '/' });
  this.resource('posts', function() {
    this.route('index', { path: '/' });
    this.route('favorites');
  });
});
```

If the user navigates to `/posts`, the current route will be
`posts.index`. Ember.js will look for objects named:

如果用户访问`/posts`，当前路由就是`posts.index`。`Ember.js`将查找以下几个对象：

* `App.PostsIndexRoute`
* `App.PostsIndexController`
* The `posts/index` template
* `posts/index`模板 

First, the `posts` template will be rendered into the `{{outlet}}` 
in the `application` template. Then, the `posts/index` template
will be rendered into the `{{outlet}}` in the `posts` template.

首先，`posts`模板将被渲染到`application`模板中的`{{outlet}}`中去。然后，`posts/index`模板
将被渲染到`posts`模板的`{{outlet}}`中去。

If the user then navigates to `/posts/favorites`, Ember.js will
replace the `{{outlet}}` in the `posts` template with the
`posts/favorites` template.

如果用户又访问了`/posts/favorites`，`Ember.js`会使用`posts/favorites`模板来替换`posts`模板中的`{{outlet}}`。
