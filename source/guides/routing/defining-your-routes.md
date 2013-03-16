英文原文 [http://emberjs.com/guides/routing/defining-your-routes/]

## 定义你的路由（Defining Your Route）

When your application starts, the router is responsible for displaying
templates, loading data, and otherwise setting up application state.
It does so by matching the current URL to the _routes_ that you've
defined.

当启动你的应用，路由器就负责了展示模板，载入数据，以及设置应用状态等任务。
这些都是通过将当前的URL与你定义的路由进行匹配来实现的。

```js
App.Router.map(function() {
  this.route("about", { path: "/about" });
  this.route("favorites", { path: "/favs" });
});
```

When the user visits `/`, Ember.js will render the `index` template.
Visiting `/about` renders the `about` template, and `/favs` renders the
`favorites` template.

当用户访问'/'时，Ember.js就会渲染`index`的模板。访问'/about'渲染`about`的模板，
访问'/favs'渲染`favorites`的模板。

Note that you can leave off the path if it is the same as the route
name. In this case, the following is equivalent to the above example:

提示：如果路径（path）的名字跟路由（route）的名字是一样的话，你可以不用写上路径。
所以下面的示例跟上面的是相同的。

```js
App.Router.map(function() {
  this.route("about");
  this.route("favorites", { path: "/favs" });
});
```

Inside your templates, you can use `{{linkTo}}` to navigate between
routes, using the name that you provided to the `route` method (or, in
the case of `/`, the name `index`).

在模板里面，你可以用{{linkTo}}来导向路由，这需要用到你在route方法中定义的名字
（在例子'/'中，名字就是index）。

```handlebars
{{#linkTo "index"}}<img class="logo">{{/linkTo}}

<nav>
  {{#linkTo "about"}}About{{/linkTo}}
  {{#linkTo "favorites"}}Favorites{{/linkTo}}
</nav>
```

The `{{linkTo}}` helper will also add an `active` class to the link that
points to the currently active route.

{{linkTo}}助手会在链接上面加上active的类名（class）来指出当前活跃的路由。

You can customize the behavior of a route by creating an `Ember.Route`
subclass. For example, to customize what happens when your user visits
`/`, create an `App.IndexRoute`:

你也可以通过创建一个Ember.Route的子类来对路由的行为进行自定义。例如，创建
App.IndexRoute类来定义当用户访问'/'时会发生什么。

```javascript
App.IndexRoute = Ember.Route.extend({
  setupController: function(controller) {
    // Set the IndexController's `title`
    controller.set('title', "My App");
  }
});
```

The `IndexController` is the starting context for the `index` template.
Now that you've set `title`, you can use it in the template:

`IndexController`是`index`模板初始的上下文环境。如果你已经设置了`title`，
那么你可以在模板里面使用它。

```handlebars
<!-- get the title from the IndexController -->
<h1>{{title}}</h1>
```

(If you don't explicitly define an `App.IndexController`, Ember.js will
automatically generate one for you.)

（如果你没有特别的声明`IndexController`，`Ember.js`会自动生成一个。）

Ember.js automatically figures out the names of routes and controllers based on
the name you pass to `this.route`.

`ember.js`会自动地根据你在`this.route`设置的名字来找出对应的路由跟控制器。

<table>
  <thead>
  <tr>
    <th>URL</th>
    <th>Route Name</th>
    <th>Controller</th>
    <th>Route</th>
    <th>Template</th>
  </tr>
  </thead>
  <tr>
    <td><code>/</code></td>
    <td><code>index</code></td>
    <td><code>IndexController</code></td>
    <td><code>IndexRoute</code></td>
    <td><code>index</code></td>
  </tr>
  <tr>
    <td><code>/about</code></td>
    <td><code>about</code></td>
    <td><code>AboutController</code></td>
    <td><code>AboutRoute</code></td>
    <td><code>about</code></td>
  </tr>
  <tr>
    <td><code>/favs</code></td>
    <td><code>favorites</code></td>
    <td><code>FavoritesController</code></td>
    <td><code>FavoritesRoute</code></td>
    <td><code>favorites</code></td>
  </tr>
</table>

### 资源（Resources）

You can define groups of routes that work with a resource:

你可以为一个资源定义一系列的路由：

```javascript
App.Router.map(function() {
  this.resource('posts', { path: '/posts' }, function() {
    this.route('new');
  });
});
```

As with `this.route`, you can leave off the path if it's the same as the
name of the route, so the following router is equivalent:

跟`this.route`一样，如果路径跟路由相同，你可以忽略路径，所以下面的路由器跟上面是等效的：

```javascript
App.Router.map(function() {
  this.resource('posts', function() {
    this.route('new');
  });
});
```

This router creates three routes:
这个路由器创建了三个路由：

<table>
  <thead>
  <tr>
    <th>URL</th>
    <th>Route Name</th>
    <th>Controller</th>
    <th>Route</th>
    <th>Template</th>
  </tr>
  </thead>
  <tr>
    <td><code>/</code></td>
    <td><code>index</code></td>
    <td><code>IndexController</code></td>
    <td><code>IndexRoute</code></td>
    <td><code>index</code></td>
  </tr>
  <tr>
    <td>N/A</td>
    <td><code>posts</code><sup>1</sup></td>
    <td><code>PostsController</code></td>
    <td><code>PostsRoute</code></td>
    <td><code>posts</code></td>
  </tr>
  <tr>
    <td><code>/posts</code></td>
    <td><code>posts.index</code></code></td>
    <td><code>PostsController</code><br>↳<code>PostsIndexController</code></td>
    <td><code>PostsRoute</code><br>↳<code>PostsIndexRoute</code></td>
    <td><code>posts</code><br>↳<code>posts/index</code></td>
  </tr>
  <tr>
    <td><code>/posts/new</code></td>
    <td><code>posts.new</code></td>
    <td><code>PostsController</code><br>↳<code>PostsNewController</code></td>
    <td><code>PostsRoute</code><br>↳<code>PostsNewRoute</code></td>
    <td><code>posts</code><br>↳<code>posts/new</code></td>
  </tr>
</table>

<small><sup>1</sup> Transitioning to `posts` or creating a link to
`posts` is equivalent to transitioning to `posts.index` or linking to
`posts.index`</small>

<small><sup>1</sup> 跳转到`post`或者链接到`post`，等效于跳转
到`post.index`或链接到`post.index`。</small>

NOTE: If you define a resource using `this.resource` and **do not** supply
a function, then the implicit `resource.index` route is **not** created. In
that case, `/resource` will only use the `ResourceRoute`, `ResourceController`,
and `resource` template.


注意：如果你通过`this.resource`定义了一个资源，但是*没有*提供一个函数作为参数，
那么隐式的`resource.index`是*不会*被创建的。在这种情况下，`/reosurce`只会用到
`ResourceRoute`，`RescourceController`和`resource`模板。

Routes nested under a resource take the name of the resource plus their
name as their route name. If you want to transition to a route (either
via `transitionTo` or `{{#linkTo}}`, make sure to use the full route
name (`posts.new`, not `new`).

一个资源下的嵌套路由的名字会是资源名加上路由名。如果你想跳转到一个路由（用`transitionTo`或
`{{#linkTo}}`），请确保使用了是完整的路由名（如：`post.new`，而不是`new`）。

Visiting `/` renders the `index` template, as you would expect.

正如你期望的一样，访问`/`会渲染`index`模板。

Visiting `/posts` is slightly different. It will first render the
`posts` template. Then, it will render the `posts/index` template into the
`posts` template's outlet.

访问`/posts`会有点不同。它会先渲染`posts`模板，然后再渲染`posts/index`模板到
`post`模板的出口（`outlet`）上。

Finally, visiting `/posts/new` will first render the `posts` template,
then render the `posts/new` template into its outlet.

最后，访问`/posts/new`会先渲染`posts`模板，然后渲染`posts/new`模板到它的出口上。

NOTE: You should use `this.resource` for URLs that represent a **noun**,
and `this.route` for URLs that represent **adjectives** or **verbs**
modifying those nouns.

注意：你应该使用`this.resource`来映射**名词**，使用`this.routes`来映射**形容词**或**动词**。

### 动态段（Dynamic Segments）

One of the responsibilities of a resource's route handler is to convert a URL
into a model.

在路由处理器的众多职责里，其中有一个就是转换URL并将其传入模型（`model`）中。

For example, if we have the resource `this.resource('/blog_posts');`, our
route handler might look like this:

例如，如果我们有一个资源`this.resource('/blog_posts');`，那么我们的路由处理器看起来
可能像这样：

```js
App.BlogPostsRoute = Ember.Route.extend({
  model: function() {
    return App.BlogPost.all();
  }
});
```

The `blog_posts` template will then receive a list of all available posts as
its context.

`blog_posts`模板将会接收到一张所有可用的posts清单并将它们当做是上下文环境。

Because `/blog_posts` represents a fixed model, we don't need any
additional information to know what to use.  However, if we want a route
to represent a single post, we would not want to have to hardcode every
possible post into the router.

由于`/blog_posts`映射到一个特定的模型上，所以我们不需要其他额外的资料就可以
运行。然而，如果我们想要路由映射到一个单数的post上，我们可不想通过在路由器中
写死每一个可能的post来实现。

Enter _dynamic segments_.

探究_动态段_

A dynamic segment is a portion of a URL that starts with a `:` and is
followed by an identifier.

一个动态段是URL的一部分，是由一个`:`，加上一个标示符组成的。

```js
App.Router.map(function() {
  this.resource('posts');
  this.resource('post', { path: '/post/:post_id' });
});

App.PostRoute = Ember.Route.extend({
  model: function(params) {
    return App.Post.find(params.post_id);
  }
});
```

Because this pattern is so common, the above `model` hook is the
default behavior.

由于这种模式很常用，所以上面的模型（`model`）钩子函数就是默认的行为。

For example, if the dynamic segment is `:post_id`, Ember.js is smart
enough to know that it should use the model `App.Post` (with the ID
provided in the URL). Specifically, unless you override `model`, the route will
return `App.Post.find(params.post_id)` automatically.

例如，如果动态段是`:post_id`，`ember.js`会智能地使用`App.post`（加上`URL`提供的`ID`)。
特别地，路由会自动地返回`App.Post.find(params.post_id)`除非你重写了模型（`model`）。

Not coincidentally, this is exactly what Ember Data expects. So if you
use the Ember router with Ember Data, your dynamic segments will work
as expected out of the box.

这不是巧合，而是`ember`资料（data）所想要的。所以如果你使用`ember`路由和`ember`资料，你的动态段将会像
开箱即用那种一样工作。


### （嵌套资源）Nested Resources

You cannot nest routes, but you can nest resources:

你不能嵌套路由，但是你可以嵌套资源：

```javascript
App.Router.map(function() {
  this.resource('post', { path: '/post/:post_id' }, function() {
    this.route('edit');
    this.resource('comments', function() {
      this.route('new');
    });
  });
});
```

This router creates five routes:

这个路由器创建了五个路由：

<div style="overflow: auto">
  <table>
    <thead>
    <tr>
      <th>URL</th>
      <th>Route Name</th>
      <th>Controller</th>
      <th>Route</th>
      <th>Template</th>
    </tr>
    </thead>
    <tr>
      <td><code>/</code></td>
      <td><code>index</code></td>
      <td><code>App.IndexController</code></td>
      <td><code>App.IndexRoute</code></td>
      <td><code>index</code></td>
    </tr>
    <tr>
      <td>N/A</td>
      <td><code>post</code></td>
      <td><code>App.PostController</code></td>
      <td><code>App.PostRoute</code></td>
      <td><code>post</code></td>
    </tr>
    <tr>
      <td><code>/post/:post_id<sup>2</sup></code></td>
      <td><code>post.index</code></td>
      <td><code>App.PostIndexController</code></td>
      <td><code>App.PostIndexRoute</code></td>
      <td><code>post/index</code></td>
    </tr>
    <tr>
      <td><code>/post/:post_id/edit</code></td>
      <td><code>post.edit</code></td>
      <td><code>App.PostEditController</code></td>
      <td><code>App.PostEditRoute</code></td>
      <td><code>post/edit</code></td>
    </tr>
    <tr>
      <td>N/A</td>
      <td><code>comments</code></td>
      <td><code>App.CommentsController</code></td>
      <td><code>App.CommentsRoute</code></td>
      <td><code>comments</code></td>
    </tr>
    <tr>
      <td><code>/post/:post_id/comments</code></td>
      <td><code>comments.index</code></td>
      <td><code>App.CommentsIndexController</code></td>
      <td><code>App.CommentsIndexRoute</code></td>
      <td><code>comments/index</code></td>
    </tr>
    <tr>
      <td><code>/post/:post_id/comments/new</code></td>
      <td><code>comments.new</code></td>
      <td><code>App.CommentsNewController</code></td>
      <td><code>App.CommentsNewRoute</code></td>
      <td><code>comments/new</code></td>
    </tr>
  </table>
</div>


<small><sup>2</sup> :post_id is the post's id.  For a post with id = 1, the route will be:
`/post/1`</small>

<small><sup>2</sup> `:post_id`就是post的id。例如一个post的id是1，那么路由就是`/post/1`</small>

The `comments` template will be rendered in the `post` outlet.
All templates under `comments` (`comments/index` and `comments/new`) will be rendered in the `comments` outlet.

`comments`模板会被渲染进`post`的出口。
所有在`comments`下的模板（`comments/index` and `comments/new`）都会被渲染进`comments`出口。
