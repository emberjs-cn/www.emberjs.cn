英文原文：[http://emberjs.com/guides/routing/query-params/](http://emberjs.com/guides/routing/query-params/)

通常情况下，URL的动态段是模型的一种序列化表示，最常见的是模型的ID。然后，有时候还需要将应用的其他状态也序列化到URL中。这可能是对从服务器端加载模型有影响的一些参数，比如要查看的是那一页结果；也可能是一些关于客户端状态的信息，比如在客户端实现排序时的记录排序规则。

当然URL中还可以被序列化一些更为全局性的信息，例如包含一个身份令牌到URL中，或者在应用里全局的过滤模型。除此之外，还可以包含任何不适合包含在常规动态段中的一些参数。必须在一个地图视图上，可能需要保存一系列在地图上可见图层的横坐标、纵坐标和缩放比例等参数。虽然这些也可以通过动态段来实现，不过那样就显得不那么自然。对于这样的一些应用场景，就可以考虑使用查询参数来替代了。

### 控制器驱动查询参数

对查询参数的支持被内置到控制器中，这与在路由层指定和管理的URL的其他部分不同。在控制器层实现的对查询参数的一流支持，使得可以提供一个强大的API来更新和响应查询参数的变更，而不需要开发者手动的安装和管理绑定/观察器来保持URL与控制器状态的同步。

### 指定查询参数

查询参数可以通过路由驱动的控制器来设置。回想一下，给定一个`this.route('articles');`指定的路由，`ArticlesRoute`的`model`钩子获取到的值将被加载到`ArticlesController`作为`model`属性。虽然`ArticlesRoute`可以在`setupController`钩子中加载数据到其他的控制器，但`ArticlesController`被认为是“路由驱动”的控制器，因此能够设定查询参数。

<aside>
  **注意：** 给定的路由关联的控制器可以通过路由的`controllerName`属性来指定。
</aside>

这里假设需要添加一个`category`查询参数，用来过滤那些没有被分类到流行的分类的文章。为了实现这个功能，可以指定`'category'`为`ArticlesController`的`queryParams`：

```js
App.ArticlesController = Ember.ArrayController.extend({
  queryParams: ['category'],
  category: null
});
```

上述代码设定了URL查询参数`category`与`ArticlesController`的`category`属性之间的绑定。换句话说，当进入到`articles`路由时，URL中查询参数`category`的改变都会自动更新`ArticlesController`中的`category`属性，反之亦然。

接下来只需要定义一个`articles`模板渲染时需要使用的分类数组的计算属性即可：

```js
App.ArticlesController = Ember.ArrayController.extend({
  queryParams: ['category'],
  category: null,

  filteredArticles: function() {
    var category = this.get('category');
    var articles = this.get('model');

    if (category) {
      return articles.filterProperty('category', category);
    } else {
      return articles;
    }
  }.property('category', 'model')
});
```

上述代码主要完成了：

1. 如果用户导航到`/articles`，`category`值为`null`，因此文章不会被过滤。
2. 如果用户导航到`/articles?articles[category]=recent`，`category`被设置为`"recent"`，因此文章将被过滤。
3. 一旦在`articles`路由里，改变`ArticlesController`中`category`属性的值，便会导致URL中对应的查询参数被更新。默认情况下，一个查询参数的改变并不会导致一次完整的路由过渡（例如：不会调用`model`和`setupController`钩子等）；只会更新URL。

### link-to助手

`link-to`助手通过`query-params`子表达式助手可以支持指定查询参数。

```handlebars
// Explicitly set target query param
{{#link-to 'posts' (query-params direction="asc")}}Sort{{/link-to}}

// Binding is also supported
{{#link-to 'posts' (query-params
direction=otherDirection)}}Sort{{/link-to}}
```

上例中，`direction`是`PostsController`的一个假定的查询参数，它可以是`posts`路由层次结构上关联任意一个控制器的`direction`属性，该属性定义在匹配的一个叶节点控制器。

<aside>
  **注意：** 子表达式只在Handlebars 1.3或更高版本中支持。
</aside>

`link-to`助手当判断其是否是`active`状态的时候会考虑查询参数，并正确的设定样式类。`active`状态在点击一个链接的时候被计算出来，那么查询参数是否也是一样呢？其实并不需要提供所有的当前的活跃的查询参数。

### transitionTo

`Route#transitionTo`（和`Controller#transitionToRoute`）增加了一个参数，该参数一个键值为`queryParams`的对象。

```javascript
this.transitionTo('post', object, {queryParams: {showDetails: true}});
this.transitionTo('posts', {queryParams: {sort: 'title'}});

// if you just want to transition the query parameters without changing
the route
this.transitionTo({queryParams: {direction: 'asc'}});
```

当然也可以将查询参数加到URL过渡中：

```javascript
this.transitionTo("/posts/1?sort=date&showDetails=true");
```

### 选择进入一个完整过渡

需要记住一点，`transitionTo`和`link-to`提供的参数只负责改变查询参数的值，并不改变路由的层次结构，也不会当做一个完整的过渡，这也就意味着`model`和`setupController`钩子默认不会被触发，仅仅会使用新的查询参数的值，更新控制器的属性的值和URL。

但是也有时查询参数的改变需要重新从服务器端加载数据，这种情况下就需要一次完整的过渡。为了实现一个完整的过渡，那么可以提供一个`queryParamsDidChange`的处理器，来调用`Route#refresh`，例如：

```js
App.ArticlesRoute = Ember.Route.extend({
  model: function(params) {
    // This gets called upon entering 'articles' route
    // for the first time, and we opt in refiring it
    // upon query param changes via `queryParamsDidChange` action

    // params has format of { category: "someValueOrJustNull" },
    // which we can just forward to the server.
    return this.store.findQuery('articles', params);
  },
  actions: {
    queryParamsDidChange: function() {
      this.refresh();
    }
  }
});

App.ArticlesController = Ember.ArrayController.extend({
  queryParams: ['category'],
  category: null
});
```

`Route#refresh`是一个用来使之前加载到路由层次结构的数据失效的一个通用方法，并会导致调用该方法的路由（及任意子路由）的`model`钩子被重新触发。如果钩子返回的模型与之前加载的不同，`setupController`钩子也将被触发，这与导航到`/users/123`和`/users/456`时发生的情况类似。

在这种情况下的查询参数，可以使用`Route#refresh`来进入一个完整过渡来响应查询参数的改变，否则只需要更新控制器的属性即可。

<aside>
  **Note:** `Route#refresh` is general purpose, but resides behind the
  `query-params-new` feature flag along with all of the API being
  described by this guide.
</aside>

### 粘性

默认情况下，查询参数都具有“粘性的”。这意味着如果在一个如`/posts?sort=name`这样的URL时，如果执行`transitionTo({ queryParams: { direction: 'desc' }})`或者点击`{{#link-to 'posts' (query-params direction=desc)}}`，那么URL会自动变为`/posts?sort=name&directions=desc`。

如果需要去掉某一个查询参数，那么需要将其设置为假值，例如`transitionTo({ queryParams: { direction: null }})`或者`{{#link-to 'posts' (query-params direction=false)}}`。

### 布尔型查询参数

布尔型不会序列化真值，例如，`transitionTo('posts', { queryParams: { sort: true }})`，URL将会被序列化为`/posts?sort`。

这有两个原因：

1. 因为传入`false`是用来清除一个参数的
2. 而字符串的`"false"`在javascript中是一个真值。例如，`if ("false") { alert('oops'); }`将会显示一个告警。

## Examples

- [查询](http://emberjs.jsbin.com/ucanam/3008)
- [排序: 客户端，不重新触发模型钩子](http://emberjs.jsbin.com/ucanam/2937)
- [排序: 服务器端，重新触发模型钩子](http://emberjs.jsbin.com/ucanam/2942)
- [分页和排序](http://emberjs.jsbin.com/ucanam/2950)
- [布尔值。从URL中移除假值查询参数](http://emberjs.jsbin.com/ucanam/2708/edit)
- [在应用路由中的全局查询参数](http://emberjs.jsbin.com/ucanam/2719/edit)
- [通过refresh()实现完整过渡](http://emberjs.jsbin.com/ucanam/2711/edit)
- [replaceUrl通过改变控制器查询参数](http://emberjs.jsbin.com/ucanam/2710/edit)
- [易实现标签的w/ {{partial}}助手](http://emberjs.jsbin.com/ucanam/2706)
- [不带路由名只有查询参数的link-to](http://emberjs.jsbin.com/ucanam/2718#/about?about[showThing])
- [合成：序列化多行文本输入框内容到URL（子表达式）](http://emberjs.jsbin.com/ucanam/2703/edit)
- [数组](http://emberjs.jsbin.com/ucanam/2849)
