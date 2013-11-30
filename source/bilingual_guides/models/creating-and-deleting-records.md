You can create records by calling the `createRecord` method on the store.

通过调用仓库的`createRecord`方法，可以创建记录：

```js
store.createRecord('post', {
  title: 'Rails is Omakase',
  body: 'Lorem ipsum'
});
```

The store object is available in controllers and routes using `this.store`.

仓库对象在控制器和路由中都可以通过`this.store`来访问。

Although `createRecord` is fairly straightforward, the only thing to watch out for
is that you cannot assign a promise as a relationship, currently.

尽管`createRecord`的使用已经非常直接，但是还需要注意一点，就是目前还不支持将一个承诺赋值给一个关联。

For example, if you want to set the `author` property of a post, this would **not** work
if the `user` with id isn't already loaded into the store:

例如，如果希望给文章设置`author`属性，如果指定ID的`user`并没有加载到仓库中的话，下面的代码将不会正常工作。

```js
var store = this.store;

store.createRecord('post', {
  title: 'Rails is Omakase',
  body: 'Lorem ipsum',
  author: store.find('user', 1)
});
```

However, you can easily set the relationship after the promise has fulfilled:

不过在承诺履行时可以非常方便的进行关联关系的设置：

```js
var store = this.store;

var post = store.createRecord('post', {
  title: 'Rails is Omakase',
  body: 'Lorem ipsum'
});

store.find('user', 1).then(function(user) {
  post.set('author', user);
});
```

### Deleting Records

### 删除记录

Deleting records is just as straightforward as creating records. Just call `deleteRecord()`
on any instace of `DS.Model`. This flags the record as `isDeleted` and thus removes
it from `all()` queries on the `store`. The deletion can then be persisted using `save()`.
Alternatively, you can use the `destroyRecord` method to delete and persist at the same time.

删除记录与创建记录一样简单。只需要调用`DS.Model`实例的`deleteRecord()`方法即可。这将会吧记录标记为`isDeleted`，并且不在`store`的`all()`查询中返回。删除操作之后会通过使用`save()`来进行持久化。此外，也可以使用`destroyRecord`来将删除和持久化一次完成。

```js
var post = store.find('post', 1);

post.deleteRecord();

post.get('isDeleted'); // => true

post.save(); // => DELETE to /posts/1

// OR

var post = store.find('post', 2);

post.destroyRecord(); // => DELETE to /posts/2
```
