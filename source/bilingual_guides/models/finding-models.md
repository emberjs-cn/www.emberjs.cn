## Finding Models

## 查找模型

You can retrieve a record by passing its unique ID to the `find()` method:

通过将记录的唯一ID传递给`find()`方法，可以获取记录：

```js
var post = App.Post.find(1);
```

If a record with that ID has already been created, it will be returned
immediately. This feature is sometimes called an _identity map_.

如果该ID的记录已经被创建，那么它将被立即返回。这个特性被称为 _标示符映射_ 。

Otherwise, a new record will be created and put into the loading
state, then returned. Feel free to use this record in templates; because
everything in Ember.js is bindings-aware, templates will automatically
update as soon as the record finishes loading.

否则，一个新的记录将被创建，其状态将被设置为加载中，并且返回。返回的记录可以在模板文件中使用；因为Ember.js中一切都是支持绑定的，因此模板在记录完成加载后会自动得到更新。

### Finding All Records

### 查找所有记录

You can find all records for a given model by calling `find()` without
arguments:

如果调用`find()`方法时不带任何参数，将返回该模型的所有记录：

```js
var posts = App.Post.find();
```

This will return an instance of `DS.RecordArray`. Like with records, the
record array will start in a loading state with a `length` of `0`, but
you can immediately use it in your templates. When the server responds
with results, the templates will watch for changes in the length of the
array and update themselves automatically.

这将返回一个`DS.RecordArray`的实例。跟记录一样，记录数组开始的时候状态也是加载中，并且`length`为0，但是已经可以在模板文件中使用了。当服务端返回结果时，模板会监听数组长度的变化，从而自动的更新自己的内容。

Note: `DS.RecordArray` is not a JavaScript array, it is an object that
implements `Ember.Enumerable`. If you want to, for example, retrieve
records by index, you must use the `objectAt(index)` method. Since the
object is not a JavaScript array, using the `[]` notation will not work.
For more information, see [Ember.Enumerable][1] and [Ember.Array][2].

注意：`DS.RecordArray`不是一个Javascript数组，它是一个实现了`Ember.Enumerable`接口的对象。如果需要通过索引来获取对象，可以使用`objectAt(index)`方法。由于该对象不是Javascript数组，因此不能使用`[]`来取其中的元素。更多详细信息请查看[Ember.Enumerable][1]和[Ember.Array][2]。

[1]: http://emberjs.com/api/classes/Ember.Enumerable.html
[2]: http://emberjs.com/api/classes/Ember.Array.html

### Queries

### 查询

You can query the server by passing a hash  to `find()`.

通过将一个哈希传递给`find()`方法，可以实现查询：

```js
var people = App.Person.find({ name: "Peter" });
```

The contents of the hash is opaque to Ember Data; it is up to your
server to interpret it and return a list of records.

哈希的内容对于Ember Data来说是透明的，它将被服务器端解析并返回对应的记录。
