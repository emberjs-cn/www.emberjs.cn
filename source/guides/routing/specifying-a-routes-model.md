英文原文: [http://emberjs.com/guides/routing/specifying-a-routes-model/](http://emberjs.com/guides/routing/specifying-a-routes-model/)
## 指定路由的模型 （Specifying a Route's Model）

In the router, each URL is associated with one or more _route handlers_.
The route handler is responsible for converting the URL into a model
object, telling a controller to represent that model, then rendering a
template bound to that controller.

在路由器中， 每一个URL都会有一个或多个路由处理器(`route handlers`)与之相关联。路由处理器会负责将URL转换成一个模型对象，
并利用一个控制器来表示这个模型，然后渲染绑定于那个控制器的模板。

### 单一模型 （Singleton Models）

If a route does not have a dynamic segment, you can hardcode which model
should be associated with that URL by implementing the route handler's
`model` hook:

如果一个路由不包含动态段，你就可以通过执行路由处理器的模型(`model`)钩子函数来写死与这个URL关联的模型(`model`):

```js
App.Router.map(function() {
  this.resource('posts');
});

App.PostsRoute = Ember.Route.extend({
  model: function() {
    return App.Post.find();
  }
});
```

By default, the value returned from your `model` hook will be assigned
to the `model` property of the `posts` controller. You can change this
behavior by implementing the [setupControllers hook][1]. The `posts`
controller is the context for the `posts` template.

默认情况下，从模型(`model`)钩子函数返回的值将会赋值给`posts`控制器的`model`属性。
你可以通过执行[setupControllers hook][1]钩子函数来改变这种默认的方式。`posts`控制器是`posts`模板的上下文环境。

[1]: /guides/routing/setting-up-a-controller

### 动态模型（Dynamic Models）

If a route has a dynamic segment, you will want to use the parameters to
decide which model to use:

如果一个路由包含动态段，你会想用参数来决定用哪个模型(`model`):

```js
App.Router.map(function() {
  this.resource('post', { path: '/posts/:post_id' });
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
特别地，如果你没有重写了模型（`model`），路由将会自动地返回`App.Post.find(params.post_id)`。

Not coincidentally, this is exactly what Ember Data expects. So if you
use the Ember router with Ember Data, your dynamic segments will work
as expected out of the box.

这不是巧合，而是`Ember Data`所想要的。所以如果你使用`Ember`路由和`Ember Data`，
你的动态段将会以默认的方式工作。
