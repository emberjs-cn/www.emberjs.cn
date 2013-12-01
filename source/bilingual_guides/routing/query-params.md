In general, the dynamic segments of a URL are a serialized representation of a model, commonly for example the model's ID. However, sometimes you need to serialize other application state into the URL. This could be further parameters that affect the loading of the model from the server, e.g. what page of a result set you are viewing, or it could be information about client side state, e.g. sort order when the records are sorted on the client.

通常情况下，URL的动态段是模型的一种序列化表示，最常见的是模型的ID。然后，有时候还需要将应用的其他状态也序列化到URL中。这可能是对从服务器端加载模型有影响的一些参数，比如要查看的是那一页结果；也可能是一些关于客户端状态的信息，比如在客户端实现排序时的记录排序规则。

There can also be more global information that you want to serialize into the url, for example if you want to store an auth token in the URL, or filter all models in your application globally. It's also possible that there is a lot of parameters that you want to serialize in the url that are inconvenient to store in normal dynamic segments. This might apply when you have a map view and need to store X, Y, and zoom coordinates along with a set of visible layers on the map. Although this is possible to do with dynamic segments, it can be inconvenient. For any of these use case, you can consider using query params instead.

当然URL中还可以被序列化一些更为全局性的信息，例如包含一个身份令牌到URL中，或者在应用里全局的过滤模型。除此之外，还可以包含任何不适合包含在常规动态段中的一些参数。必须在一个地图视图上，可能需要保存一系列在地图上可见图层的横坐标、纵坐标和缩放比例等参数。虽然这些也可以通过动态段来实现，不过那样就显得不那么自然。对于这样的一些应用场景，就可以考虑使用查询参数来替代了。

### Specifying Query Parameters

### 指定查询参数

Query params are baked right into your routes. This is essential so that the router and helpers can know what valid transitions and query parameter states are. Here is an example of defining which query params some routes respond to:

查询参数的设定被放置在路由中，这一点非常重要，因为只有这样路由和助手才能知道哪些是正确的过渡和查询参数状态。下面是一个定义一些路由的查询参数的示例：

```javascript
App.Router.map(function() {
  this.resource('posts', {queryParams: ['sort', 'direction']}, function() {
    this.resource('post', {path: "/:id", queryParams: ['showDetails']});
  });
});
```

### Route Hooks

### 路由钩子

Query params are passed into the hooks on your routes when you have defined them. Only query params that have been defined to apply to the route in the router.map call will be passed in. If no query params are active for this route,
an empty object `{}` is passed in.

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

Only the query parameters that you specify to apply to a route are passed in, even if the parameters apply to parent routes.

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
  **Note:** If you don't specify query params for a given route, then the parameters passed in to the route hooks remains unchanged.

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

### Transitioning Query Params

### 过渡查询参数

`transitionTo` now accepts a final argument, which is an object with the key `queryParams`.

`transitionTo`函数在最后添加了一个参数，用来接收名为`queryParams`的对象作为查询参数。

```javascript
this.transitionTo('post', object, {queryParams: {showDetails: true}});
this.transitionTo('posts', {queryParams: {sort: 'title'}});

// if you just want to transition the query parameters without changing the route
this.transitionTo({queryParams: {direction: 'asc'}});
```

You can also use add query params to URL transitions:

此外也可以在URL上直接添加查询参数：

```javascript
this.transitionTo("/posts/1?sort=date&showDetails=true");
```

### link-to Helper

### `{{link-to}}`助手


The link-to helper supports specifying query params.

`{{link-to}}`助手也支持指定查询参数。

```handlebars
{{#link-to 'posts' direction=asc}}Sort{{/link-to}}

// Binding is also supported
{{#link-to 'posts' directionBinding=otherDirection}}Sort{{/link-to}}
```

The link-to helper takes into account query parameters when determining its "active" state, and will set the class appropriately. The active state is determined by working out if you clicked on the link, would the query params end up the same? You don't have to supply all of the current, active query params for this to be true.

`{{link-to}}`助手在确定'active'状态时，会顾及到查询参数，并且会适当的设置样式。当点击链接的时候，激活状态会通过计算得到，那么查询参数是否也是这样呢？其实并不需要提供为此提供所有的当前活动的查询参数。

### "Stickiness"

### 粘性

By default, query params are "sticky". This means that if you are on a url like `/posts?sort=name`, and you executed `transitionTo({queryParams: {direction: 'desc'}})` or clicked `{{#link-to 'posts' direction=desc}}`, the resulting url will be `/posts?sort=name&direction=desc`.

默认情况下，查询参数都具有“粘性的”。这意味着如果在一个如`/posts?sort=name`这样的URL时，如果执行`transitionTo({ queryParams: { direction: 'desc' }})`或者点击`{{#link-to 'posts' direction=desc}}'，那么URL会自动变为`/posts?sort=name&directions=desc`。

To clear query params, give a falsy value (but **not** `undefined`), e.g.
`transitionTo({queryParams: {direction: null}})` or `{{#link-to 'posts' direction=false}}`

如果需要去掉某一个查询参数，那么需要将其设置为假值（而**不是**`undefined`），例如`transitionTo({ queryParams: { direction: null }})`或者`{{#link-to 'posts' direction=false }}`。

It's also possible to clear all query params by passing false, e.g. `transitionTo({queryParams: false})` or `{{#link-to 'posts' queryParams=false}}`

通过将`queryParams`设置为`false`也可以一次清除所有的查询参数，例如，`transitionTo({ queryParams: false })`或者`{{#link-to 'posts' queryParams=false }}`

### Boolean Query params

### 布尔型查询参数

Boolean query params are serialized without the truth value, e.g. `transitionTo('posts', {queryParams: {sort: true}})` would result in the url `/posts?sort`

布尔型不会序列化真值，例如，`transitionTo('posts', { queryParams: { sort: true }})`，URL将会被序列化为`/posts?sort`。

This is for two reasons:

这有两个原因：

1. passing false is the way to clear query parameters
2. The string "false" is truthy in javascript. i.e. `if ("false") { alert('oops'); }` will show an alert.

1. 因为传入`false`是用来清除一个参数的
2. 而字符串的`"false"`在javascript中是一个真值。例如，`if ("false") { alert('oops'); }`将会显示一个告警。
