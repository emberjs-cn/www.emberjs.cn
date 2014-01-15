The Ember Data store provides a simple interface for finding records of
a single type through the `store` object's `find` method. Internally, the
`store` uses `find`, `findAll`, and `findQuery` based on the supplied
arguments. The first argument to `store.find()` is always the record type. The
optional second argument determines if a request is made for all records, a single
record, or a query.

Ember Data仓库提供了一个非常简单的查询一类记录的接口，该接口就是`store`对象的`find`方法。在内部，`store`根据传入的参数使用`find`、`findAll`和`findQuery`完成查询。`store.find()`的第一个参数是记录的类型，第二个可选参数确定查询是获取所有记录，还是一条记录，还是特定的记录。

### Finding All Records of a Type

### 查询一个类型的所有记录

```javascript
var posts = this.store.find('post');
```

To get a list of records already loaded into the store, without making
another network request, use `all` instead.

如果希望获取已经加载到仓库中的记录的列表，而不希望通过一个网络请求去获取，可以使用`all`方法。

```javascript
var posts = this.store.all('post'); // => no network request
```

`find` returns a `DS.PromiseArray` that fulfills to a `DS.RecordArray`
and `all` directly returns a `DS.RecordArray`.

`find`会返回一个将使用`DS.RecordArray`来履行的`DS.PromiseArray`，而`all`直接返回`DS.RecordArray`。

It's important to note that `DS.RecordArray` is not a JavaScript array.
It is an object that implements [`Ember.Enumerable`][1]. This is
important because, for example, if you want to retrieve records by index, the
`[]` notation will not work--you'll have to use `objectAt(index)` instead.

需要重点注意的一点是`DS.RecordArray`不是一个Javascript数组。它是一个实现了[`Ember.Enumerable`][1]的对象。这一点非常重要，因为例如希望通过索引获取记录，那么`[]`将无法工作，需要使用`objectAt(index)`来获取。

[1]: http://emberjs.com/api/classes/Ember.Enumerable.html

### Finding a Single Record

### 查询一个记录

If you provide a number or string as the second argument to
`store.find()`, Ember Data will attempt to retrieve a record of that with that ID.
This will return a promise that fulfills with the requested record:

如果调用`store.find()`方法时，第二个参数是一个数字或者字符串，Ember Data将尝试获取对应ID的记录。`find()`方法将返回一个用请求的记录来履行的承诺。

```javascript
var aSinglePost = this.store.find('post', 1); // => GET /posts/1
```

### Querying For Records

### 查询记录

If you provide a plain object as the second argument to `find`, Ember
Data will make a `GET` request with the object serialized as query params. This
method returns `DS.PromiseArray` in the same way as `find` with no second argument.

如果传递给`find`方法的第二个参数是一个对象，Ember Data会发送一个使用该对象来序列化出来的查询参数的`GET`请求。这是方法返回与不加第二个参数时候一样的`DS.PromiseArray`。

For example, we could search for all `person` models who have the name of
`Peter`:

例如，可以查询名为`Peter`的`person`模型的所有记录：

```javascript
var peters = this.store.find('person', { name: "Peter" }); // => GET to /persons?name='Peter'
```

#### Integrating with the Route's Model Hook

#### 与路由的模型钩子集成

As discussed in [Specifying a Route's Model](/guides/routing/specifying-a-routes-model), routes are
responsible for telling their template which model to render.

如同在[指定路由的模型](/guides/routing/specifying-a-routes-model)一节中讨论的一样，路由是负责告诉模板将渲染哪个模型。

`Ember.Route`'s `model` hook supports asynchronous values
out-of-the-box. If you return a promise from the `model` hook, the
router will wait until the promise has fulfilled to render the
template.

`Ember.Route`的`model`钩子支持立即可用的异步值。如果`model`钩子返回一个承诺，路由将等待承诺履行条件满足时才渲染模板。

This makes it easy to write apps with asynchronous data using Ember
Data. Just return the requested record from the `model` hook, and let
Ember deal with figuring out whether a network request is needed or
not.

这使得使用Ember
Data的异步数据来编写应用变得容易。只需要通过`model`钩子返回请求的记录，交给Ember来处理是否需要一个网络请求。

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
