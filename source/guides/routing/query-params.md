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

但是也有时查询参数的改变需要重新从服务器端加载数据，这种情况下就需要一次完整的过渡。当控制器查询参数属性变化时，为了实现一个完整的过渡，可以使用·`Route`中与对应控制器关联的可选的`queryParams`配置哈希，并将查询参数的`refreshModel`配置属性设置为`true`：

```js
App.ArticlesRoute = Ember.Route.extend({
  queryParams: {
    category: {
      refreshModel: true
    }
  },
  model: function(params) {
    // This gets called upon entering 'articles' route
    // for the first time, and we opt in refiring it
    // upon query param changes via `queryParamsDidChange` action

    // params has format of { category: "someValueOrJustNull" },
    // which we can just forward to the server.
    return this.store.findQuery('articles', params);
  }
});

App.ArticlesController = Ember.ArrayController.extend({
  queryParams: ['category'],
  category: null
});
```

### 使用`replaceState`来更新URL

缺省情况下，Ember使用`pushState`来更新地址栏中的URL来响应控制器查询参数属性的变化，然而也可以通过使用`replaceState`来实现（这会阻止在浏览器的历史中增加附加的条目），通过设定`Route`的`queryParams`配置哈希来启用，例如（接上例）：

```js
App.ArticlesRoute = Ember.Route.extend({
  queryParams: {
    category: {
      replace: true
    }
  }
});
```

需要注意配置属性名及其默认`false`值与`link-to`助手的相似，需要通过设定`replace=true`来启用`replaceState`过渡。

### 将控制器的属性映射到不同的查询参数键值

缺省情况下，指定`foo`作为控制器的查询参数属性将会绑定一个键值为`foo`的查询参数，例如`?foo=123`。采用类似`classNameBindings`的冒号语法[示例](/guides/views/customizing-a-views-element/)可以将控制器的属性绑定到一个不同的查询参数键值。

```js
App.ArticlesController = Ember.ArrayController.extend({
  queryParams: ['category:articles_category'],
  category: null
});
```

上述代码会使得改变`ArticlesController`的`category`时更新`articles_category`查询参数，反之亦然。

### 默认值和反序列化

在下述例子中，控制器查询参数`page`默认值被设置为`1`。

```js
App.ArticlesController = Ember.ArrayController.extend({
  queryParams: 'page',
  page: 1
});
```

这对查询参数行为的影响有两种方式：

1. 在设置控制器值前，会使用默认值的类型来完成在URL中的查询参数值的类型转换。因此，在给定的上例中，如果用户点击后退按钮使得URL从`/?page=3`变为`/?page=2`，Ember会采用转换后的数值`2`来更新控制器的`page`属性，而非字符串的`"2"`，这是因为默认值`1`是数值型。这也使得布尔型参数的缺省值能在反序列化的时候被正确的转换。

2. 当控制器的查询参数被设置为默认值时，该值不会被序列化到URL中。因此在上例中，如果`page`值为`1`，URL可能就是`/articles`，但是如果`page`的值被设置为`2`，那么URL应该就是`/articles?page=2`。

## 示例

- [查询](http://emberjs.jsbin.com/ucanam/4059)
- [排序: 客户端，不重新触发模型钩子](http://emberjs.jsbin.com/ucanam/2937)
- [排序: 服务器端，重新触发模型钩子](http://emberjs.jsbin.com/ucanam/4073)
- [分页和排序](http://emberjs.jsbin.com/ucanam/4075)
- [布尔值](http://emberjs.jsbin.com/ucanam/4076/edit)
- [在应用路由中的全局查询参数](http://emberjs.jsbin.com/ucanam/4077/edit)
- [通过设置refreshModel:true实现完整过渡](http://emberjs.jsbin.com/ucanam/4079/edit)
- [通过设置replace:true实现replaceState](http://emberjs.jsbin.com/ucanam/4080/edit)
- [易实现标签的w/ {{partial}}助手](http://emberjs.jsbin.com/ucanam/4081)
- [不带路由名只有查询参数的link-to](http://emberjs.jsbin.com/ucanam/4082#/about?showThing=true)
- [合成：序列化多行文本输入框内容到URL（子表达式）](http://emberjs.jsbin.com/ucanam/4083/edit)
- [数组](http://emberjs.jsbin.com/ucanam/4084)
- [使用冒号语法映射不同的URL键值](http://emberjs.jsbin.com/ucanam/4090/edit)
