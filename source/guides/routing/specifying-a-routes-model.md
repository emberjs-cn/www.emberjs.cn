英文原文: [http://emberjs.com/guides/routing/specifying-a-routes-model/](http://emberjs.com/guides/routing/specifying-a-routes-model/)

## 指定路由的模型

在路由器中， 每一个URL都会有一个或多个路由处理器(`route handlers`)与之相关联。路由处理器会负责将URL转换成一个模型对象，
并利用一个控制器来表示这个模型，然后渲染绑定于那个控制器的模板。

### 单一模型

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

默认情况下，从模型(`model`)钩子函数返回的值将会赋值给`posts`控制器的`model`属性。
你可以通过执行[setupControllers hook][1]钩子函数来改变这种默认的方式。`posts`控制器是`posts`模板的上下文环境。

[1]: /guides/routing/setting-up-a-controller

### 动态模型

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

由于这种模式很常用，所以上面的模型（`model`）钩子函数就是默认的行为。

例如，如果动态段是`:post_id`，`ember.js`会智能地使用`App.post`（加上`URL`提供的`ID`)。
特别地，如果你没有重写了模型（`model`），路由将会自动地返回`App.Post.find(params.post_id)`。

这不是巧合，而是`Ember Data`所想要的。所以如果你使用`Ember`路由和`Ember Data`，
你的动态段将会以默认的方式工作。

注意：一个具有动态段的路由只有在通过URL访问的时候，`model`钩子才会被调用。如果路由是从一个跳转进入的（例如：使用Handlebars的[linkTo][2]助手时），模型上下文已经准备好了，因此`model`钩子这时不会被执行。没有动态段的路由其`model`钩子每次都会被执行。

[2]: /guides/templates/links
