英文原文：[http://emberjs.com/guides/models/finding-records/](http://emberjs.com/guides/models/finding-records/)

`store.find()`用于查询所有的记录，包括单一记录，或基于条件查询的记录。方法的第一个参数是需要查询的记录的类型，例如：`post`，第二个参数是可选参数，可以是一个用作查询条件的对象，也可以只是一个记录的ID。下面给出一些具体的例子：

### 查询一个类型的所有记录

```js
var posts = this.store.find('post');
```

这里将返回一个`DS.RecordArray`对象。跟记录一样，记录数组对象一开始也是正在加载的状态，其`length`为`0`。当服务器返回结果时，所有引用了记录数组对象的地方都会自动更新。

**注意**：`DS.RecordArray`不是一个Javascript的数组，它是一个实现了`Ember.Enumerable`的对象。如果希望通过索引来获取记录，那么需要使用`objectAt(index)`方法来实现。由于记录数组对象不是一个Javascript数组，因此不能是`[]`来获取。更多的信息请参看[Ember.Enumerable][1]和[Ember.Array][2]。

获取已经加载到仓库中的记录，而不触发一个新的网络请求，可以使用`store.all('post')`方法。

[1]: http://emberjs.com/api/classes/Ember.Enumerable.html
[2]: http://emberjs.com/api/classes/Ember.Array.html

### 查询一个记录

调用`find()`方法时，指定记录模型的名称和记录唯一的ID就可以获取对应的这个记录。ID可以是字符串或者数字。`find()`方法会返回一个会使用被请求的对象来履行的承诺：

```js
this.store.find('post', 1).then(function(post) {
  post.set('title', "My Dark Twisted Fantasy");
});
```

#### 与路由的模型钩子集成

如同在[指定路由的模型](/guides/routing/specifying-a-routes-model)一节中讨论的一样，路由是负责告诉模板将渲染哪个模型。

`Ember.Route`的`model`钩子支持立即可用的异步值。如果`model`钩子返回一个承诺，路由将等待承诺履行条件满足时才渲染模板。

这使得使用Ember
Data的异步数据来编写应用变得容易。只需要通过`model`钩子返回请求的记录，交个Ember来处理是否需要一个网络请求：

```js
App.Router.map(function() {
  this.resource('post', { path: ':post_id' });
});

App.PostRoute = Ember.Route.extend({
  model: function(params) {
    return this.store.find('post', params.post_id);
  }
});
```

由于上述的场景非常常用，上面的`model`钩子是具有动态端的路由的一个缺省实现。如果使用Ember Data，且希望使用一个不是与提供的ID对应的模型时，可以重现`model`钩子来实现。

### 查询记录

通过传递一个哈希值作为`find()`方法的第二个参数，就能实现发起一个到服务器端的查询请求。该方法返回一个将使用返回的查询结果数组来履行的承诺。

例如，可以查询名为`Peter`的`person`模型的所有记录：

```js
this.store.find('person', { name: "Peter" }).then(function(people) {
  console.log("Found " + people.get('length') + " people named Peter.");
});
```

传递给`find()`方法的查询参数对于Ember
Data是不透明的。默认情况下，这些参数将作为HTTP的`GET`请求的`body`来发送到服务器端。

**使用查询特性需要服务器端能够正确解析查询参数。**
