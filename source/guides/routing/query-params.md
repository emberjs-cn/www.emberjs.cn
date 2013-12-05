英文原文：[http://emberjs.com/guides/routing/query-params/](http://emberjs.com/guides/routing/query-params/)

通常情况下，URL的动态段是模型的一种序列化表示，最常见的是模型的ID。然后，有时候还需要将应用的其他状态也序列化到URL中。这可能是对从服务器端加载模型有影响的一些参数，比如要查看的是那一页结果；也可能是一些关于客户端状态的信息，比如在客户端实现排序时的记录排序规则。

当然URL中还可以被序列化一些更为全局性的信息，例如包含一个身份令牌到URL中，或者在应用里全局的过滤模型。除此之外，还可以包含任何不适合包含在常规动态段中的一些参数。必须在一个地图视图上，可能需要保存一系列在地图上可见图层的横坐标、纵坐标和缩放比例等参数。虽然这些也可以通过动态段来实现，不过那样就显得不那么自然。对于这样的一些应用场景，就可以考虑使用查询参数来替代了。

### 指定查询参数

查询参数的设定被放置在路由中，这一点非常重要，因为只有这样路由和助手才能知道哪些是正确的过渡和查询参数状态。下面是一个定义一些路由的查询参数的示例：

```javascript
App.Router.map(function() {
  this.resource('posts', {queryParams: ['sort', 'direction']}, function() {
    this.resource('post', {path: "/:id", queryParams: ['showDetails']});
  });
});
```

### 路由钩子

如果定义了查询参数，这些参数都会被传入对应路由的钩子。只有在`router.map`中定义的查询参数才会被传入。如果没有定义任何查询参数，会传入一个空的对象`{}`。

```javascript
App.PostsRoute = Ember.Route.extend({
  beforeModel:      function( queryParams, transition ) {},
  model:            function( params, queryParams, transition ) {},
  afterModel:       function( resolvedModel, queryParams, transition ) {},
  setupController:  function( controller, context, queryParams ) {},
  renderTemplate:   function( controller, context, queryParams ) {}
});
```

只有应用到一个特定的路由上，查询参数才会被传入，即使在父级路由上设定了，在子路由上也不会被传入。

```javascript
App.Router.map(function() {
  this.resource('posts', {queryParams: ['sort', 'direction']}, function() {
    this.resource('post', {path: "/:id", queryParams: ['showDetails', 'sort']});
  });
});

// If the user visits the URL:
// /posts/1?sort=name&direction=asc&showDetails=yes&otherQueryParam=something

App.PostsRoute = Ember.Route.extend({
  model: function( params, queryParams, transition ) {

    // queryParams is {sort: 'name', direction: 'asc'}
    // showDetails is not passed in because it's only registered on the child route
    // otherQueryParam is not passed in because it's not registered on any route

  }
});

App.PostRoute = Ember.Route.extend({
  model: function( params, queryParams, transition ) {
    // queryParams is {sort: 'name', showDetails: 'yes'}
    // direction is not passed in because it's only registered on the parent route
    // otherQueryParam is not passed in because it's not registered on any route
  }
});
```

<aside>
  **注意：**如果没有给路由指定任何查询参数，路由钩子的参数列表不会发生改变。
</aside>

```javascript
// IndexRoute has no query params defined

App.IndexRoute = Ember.Route.extend({
    beforeModel:      function( transition ) {},
    model:            function( params, transition ) {},
    afterModel:       function( resolvedModel, transition ) {},
    setupController:  function( controller, context ) {},
    renderTemplate:   function( controller, context ) {}
});
```

### 过渡查询参数

`transitionTo`函数在最后添加了一个参数，用来接收名为`queryParams`的对象作为查询参数。

```javascript
this.transitionTo('post', object, {queryParams: {showDetails: true}});
this.transitionTo('posts', {queryParams: {sort: 'title'}});

// if you just want to transition the query parameters without changing the route
this.transitionTo({queryParams: {direction: 'asc'}});
```

此外也可以在URL上直接添加查询参数：

```javascript
this.transitionTo("/posts/1?sort=date&showDetails=true");
```

### `{{link-to}}`助手

`{{link-to}}`助手也支持指定查询参数。

```handlebars
{{#link-to 'posts' direction=asc}}Sort{{/link-to}}

// Binding is also supported
{{#link-to 'posts' directionBinding=otherDirection}}Sort{{/link-to}}
```

`{{link-to}}`助手在确定'active'状态时，会顾及到查询参数，并且会适当的设置样式。当点击链接的时候，激活状态会通过计算得到，那么查询参数是否也是这样呢？其实并不需要提供为此提供所有的当前活动的查询参数。

### 粘性

默认情况下，查询参数都具有“粘性的”。这意味着如果在一个如`/posts?sort=name`这样的URL时，如果执行`transitionTo({ queryParams: { direction: 'desc' }})`或者点击`{{#link-to 'posts' direction=desc}}'，那么URL会自动变为`/posts?sort=name&directions=desc`。

如果需要去掉某一个查询参数，那么需要将其设置为假值（而**不是**`undefined`），例如`transitionTo({ queryParams: { direction: null }})`或者`{{#link-to 'posts' direction=false }}`。

通过将`queryParams`设置为`false`也可以一次清除所有的查询参数，例如，`transitionTo({ queryParams: false })`或者`{{#link-to 'posts' queryParams=false }}`

### 布尔型查询参数

布尔型不会序列化真值，例如，`transitionTo('posts', { queryParams: { sort: true }})`，URL将会被序列化为`/posts?sort`。

这有两个原因：

1. 因为传入`false`是用来清除一个参数的
2. 而字符串的`"false"`在javascript中是一个真值。例如，`if ("false") { alert('oops'); }`将会显示一个告警。
