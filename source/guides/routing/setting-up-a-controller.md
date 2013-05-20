英文原文:
[http://emberjs.com/guides/routing/setting-up-a-controller/](http://emberjs.com/guides/routing/setting-up-a-controller/)

## 设置控制器

URL的改变同时也可能改变显示的模板。而模板只有当其搭载了需要呈现的信息才有用。

在`Ember.js`中，模板从控制器中过去需要呈现的信息。

内置的两个控制器`Ember.ObjectController`和`Ember.ArrayController`，使控制器可以非常方便的呈现模型的属性和其他一些附加的用于显示的属性到模板中去。

通过在路由处理器的`setupController`钩子中设置控制器的`model`属性，来设置控制器所要呈现的模型。

```js
App.Router.map(function() {
  this.resource('post', { path: '/posts/:post_id' });
});

App.PostRoute = Ember.Route.extend({
  setupController: function(controller, model) {
    controller.set('model', model);
  }
});
```

`setupController`钩子将路由处理器关联的控制器作为第一个参数。上例中`PostRoute`的`setupController`的第一个参数是应用中`App.PostController`的实例。

而第二个参数是路由处理器的模型。更多相关信息请参看[指定路由的模型][1]一节。

[1]: /guides/routing/specifying-a-routes-model

默认的`setupController`钩子将关联的控制器的`model`设置为路由处理器的模型。

如果系统设置其他的控制器来取代路由处理器关联的控制器，可以使用`controllerFor`方法。

```js
App.PostRoute = Ember.Route.extend({
  setupController: function(controller, model) {
    this.controllerFor('topPost').set('model', model);
  }
});
```
