英文原文：[http://emberjs.com/guides/models/finding-records/](http://emberjs.com/guides/models/finding-records/)

Ember Data仓库提供了一个非常简单的查询一类记录的接口，该接口就是`store`对象的`find`方法。在内部，`store`根据传入的参数使用`find`、`findAll`和`findQuery`完成查询。`store.find()`的第一个参数是记录的类型，第二个可选参数确定查询是获取所有记录，还是一条记录，还是特定的记录。

### 查询一个类型的所有记录

```javascript
var posts = this.store.find('post');
```

如果希望获取已经加载到仓库中的记录的列表，而不希望通过一个网络请求去获取，可以使用`all`方法。

```javascript
var posts = this.store.all('post'); // => no network request
```

`find`会返回一个将使用`DS.RecordArray`来履行的`DS.PromiseArray`，而`all`直接返回`DS.RecordArray`。

需要重点注意的一点是`DS.RecordArray`不是一个Javascript数组。它是一个实现了[`Ember.Enumerable`][1]的对象。这一点非常重要，因为例如希望通过索引获取记录，那么`[]`将无法工作，需要使用`objectAt(index)`来获取。

[1]: http://emberjs.com/api/classes/Ember.Enumerable.html

### 查询一个记录

如果调用`store.find()`方法时，第二个参数是一个数字或者字符串，Ember Data将尝试获取对应ID的记录。`find()`方法将返回一个用请求的记录来履行的承诺。

```javascript
var aSinglePost = this.store.find('post', 1); // => GET /posts/1
```

### 查询记录

如果传递给`find`方法的第二个参数是一个对象，Ember Data会发送一个使用该对象来序列化出来的查询参数的`GET`请求。这是方法返回与不加第二个参数时候一样的`DS.PromiseArray`。

例如，可以查询名为`Peter`的`person`模型的所有记录：

```javascript
var peters = this.store.find('person', { name: "Peter" }); // => GET to /persons?name='Peter'
```

#### 与路由的模型钩子集成

如同在[指定路由的模型](/guides/routing/specifying-a-routes-model)一节中讨论的一样，路由是负责告诉模板将渲染哪个模型。

`Ember.Route`的`model`钩子支持立即可用的异步值。如果`model`钩子返回一个承诺，路由将等待承诺履行条件满足时才渲染模板。

这使得使用Ember Data的异步数据来编写应用变得容易。只需要通过`model`钩子返回请求的记录，交个Ember来处理是否需要一个网络请求。

```javascript
App.Router.map(function() {
  this.resource('posts');
  this.resource('post', { path: ':post_id' });
});

App.PostsRoute = Ember.Route.extend({
  model: function() {
    return this.store.find('post');
  }
});

App.PostRoute = Ember.Route.extend({
  model: function(params) {
    return this.store.find('post', params.post_id);
  }
});
```
