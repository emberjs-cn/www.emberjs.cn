英文原文：[http://emberjs.com/guides/models/creating-and-deleting-records/](http://emberjs.com/guides/models/creating-and-deleting-records/)

通过调用仓库的`createRecord`方法，可以创建记录：

```js
store.createRecord('post', {
  title: 'Rails is Omakase',
  body: 'Lorem ipsum'
});
```

仓库对象在控制器和路由中都可以通过`this.store`来访问。

尽管`createRecord`的使用已经非常直接，但是还需要注意一点，就是目前还不支持将一个承诺赋值给一个关联。

例如，如果希望给文章设置`author`属性，如果指定ID的`user`并没有加载到仓库中的话，下面的代码将不会正常工作。

```js
var store = this.store;

store.createRecord('post', {
  title: 'Rails is Omakase',
  body: 'Lorem ipsum',
  author: store.find('user', 1)
});
```

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

### 删除记录

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
