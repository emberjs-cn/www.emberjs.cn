英文原文：[http://emberjs.com/guides/routing/generated-objects/](http://emberjs.com/guides/routing/generated-objects/)

## 生成的对象（Generated Objects）

As explained in the [routing guide][1], whenever you define a new route,
Ember.js attempts to find corresponding Route, Controller, View, and Template
classes named according to naming conventions. If an implementation of any of
these objects is not found, appropriate objects will be generated in memory for you.

正如在[定义路由][1]中所说的，无论何时，只要你定义了一个新的路由，`Ember.js`都会试着根据命名惯例寻找相对应的路由，控制器，视图还有模板类。一旦有任何一个对象找不到，那么在内存中，相对应的对象将会被生成。

[1]: /guides/routing/defining-your-routes

#### 生成的路由（Generated routes）

Given you have the following route:

假设你有下列路由：

```javascript
App.Router.map(function() {
  this.resource('posts');
});
```

When you navigate to `/posts`, Ember.js looks for `App.PostsRoute`.
If it doesn't find it, it will automatically generate an `App.PostsRoute` for you.

当你导航到`/posts`时，`Ember.js`会寻找`App.PostsRoute`。如果找不到，它会自动地为你生成`App.PostsRoute`。


##### 自定义生成的路由 （Custom Generated Routes）
You can have all your generated routes extend a custom route.  If you define `App.Route`,
all generated routes will be instances of that route.

你可以让你所有生成的路由都扩展自一个自定义的路由。如果你定义了`App.Route`，所有生成的路由都将会是这个路由的实例。


#### 生成的控制器 （Generated Controllers）

If you navigate to route `posts`, Ember.js looks for a controller called `App.PostsController`.
If you did not define it, one will be generated for you.

如果你导航到`posts`路由，`Ember.js`会寻找名为`App.PostsController`的控制器。如果你没有定义它，他会被自动生成。

Ember.js can generate three types of controllers:
`Ember.ObjectController`, `Ember.ArrayController`, and `Ember.Controller`.

`Emeber.js`可以生成三种类型的控制器：
`Ember.ObjectController`， `Ember.ArrayController`， 和 `Ember.Controller`。

The type of controller Ember.js chooses to generate for you depends on your route's
`model` hook:

`Ember.js`如何选择生成的控制器类型取决于路由中你的`model`钩子：

- If it returns an object (such as a single record), an [ObjectController][2] will be generated.
- If it returns an array, an [ArrayController][3] will be generated.
- If it does not return anything, an instance of `Ember.Controller` will be generated.

- 如果返回一个对象（例如单个记录），生成一个[ObjectController][2]。
- 如果返回一个数组，生成一个[ArrayController][3]。
- 如果不返回任何东西，那么生成一个`Ember.Controller`的实例。


[2]: /guides/controllers/representing-a-single-model-with-objectcontroller
[3]: /guides/controllers/representing-multiple-models-with-arraycontroller


#####  自定义生成的控制器 （Custom Generated Controllers）

If you want to customize generated controllers, you can define your own `App.Controller`, `App.ObjectController`
and `App.ArrayController`.  Generated controllers will extend one of these three (depending on the conditions above).

如果你想要自定义生成的控制器，你可以定义你自己的`App.Controller`，`App.ObjectController`和`App.ArrayController`。生成的控制器会
扩展自它们其中一个（取决于上面的条件）。


#### 生成的视图和模板 （Generated Views and Templates）

A route also expects a view and a template.  If you don't define a view,
a view will be generated for you.

一个路由也会跟对应视图和模板匹配。如果你没有定义对应的视图，那么系统会为你自动地生成一个视图。

A generated template is empty.
If it's a resource template, the template will simply act
as an `outlet` so that nested routes can be seamlessly inserted.  It is equivalent to:

一个生成的模板是空的。
如果它是个资源模板，基本上它像一个出口（`outlet`）一样，以便嵌套的路由可以无缝的插入。
这个等同于：

```handlebars
{{outlet}}
```



