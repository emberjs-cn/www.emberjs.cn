英文原文：[http://emberjs.com/guides/models/finding-models/](http://emberjs.com/guides/models/finding-models/)

## 查找模型

通过将记录的唯一ID传递给`find()`方法，可以获取记录：

```js
var post = App.Post.find(1);
```

如果该ID的记录已经被创建，那么它将被立即返回。这个特性被称为 _标示符映射_ 。

否则，一个新的记录将被创建，其状态将被设置为加载中，并且返回。返回的记录可以在模板文件中使用；因为Ember.js中一切都是支持绑定的，因此模板在记录完成加载后会自动得到更新。

### 查找所有记录

如果调用`find()`方法时不带任何参数，将返回该模型的所有记录：

```js
var posts = App.Post.find();
```

这将返回一个`DS.RecordArray`的实例。跟记录一样，记录数组开始的时候状态也是加载中，并且`length`为0，但是已经可以在模板文件中使用了。当服务端返回结果时，模板会监听数组长度的变化，从而自动的更新自己的内容。

注意：`DS.RecordArray`不是一个Javascript数组，它是一个实现了`Ember.Enumerable`接口的对象。如果需要通过索引来获取对象，可以使用`objectAt(index)`方法。由于该对象不是Javascript数组，因此不能使用`[]`来取其中的元素。更多详细信息请查看[Ember.Enumerable][1]和[Ember.Array][2]。

[1]: http://emberjs.com/api/classes/Ember.Enumerable.html
[2]: http://emberjs.com/api/classes/Ember.Array.html

### 查询

通过将一个哈希传递给`find()`方法，可以实现查询：

```js
var people = App.Person.find({ name: "Peter" });
```

哈希的内容对于Ember Data来说是透明的，它将被服务器端解析并返回对应的记录。
