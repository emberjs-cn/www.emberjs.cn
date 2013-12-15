英文原文：[http://emberjs.com/guides/models/handling-metadata/](http://emberjs.com/guides/models/handling-metadata/)

与从仓库中返回的记录的同时，有时候需要处理一些元数据。*元数据*是除记录外，与特定*模型*或*类型*一同的数据。

分页是常见的一种元数据。例如一个博客拥有一次无法显示完的文章，那么就需要使用如下的查询：

```js
this.store.findQuery("post", {
  limit: 10,
  offset: 0
});
```

为了获取不同页面的数据，只需要以10为增量来修改`offset`。到目前为止，一切都正常。现在有一个问题，就是如何知道拥有多少页数据呢？服务器需要以元数据的形式返回所有的记录数。

默认情况下，Ember Data的JSON反序列化会查找一个名为`meta`的键：

```js
{
  "post": {
    "id": 1
    "title": "Progressive Enhancement is Dead",
    "comments": ["1", "2"],
    "_links": {
      "user": "/people/tomdale"
    },
    // ...
  },

  "meta": {
    "total": 100
  }
}
```

特定类型的元数据将被设置到`meta`中。可以使用`store.metadataFor`来获取。

```js
var meta = this.store.metadataFor("post");
```

现在`meta.total`可以用来计算拥有多少页文章了。

此外，通过重写`extractMeta`方法，可以自定义元数据抽取的方法。例如，服务器没有使用`meta`对象来返回元数据，而是返回了下面的格式：

```js
{
  "post": [
    // ...
  ],
  "total": 100
}
```

那么可以这样来抽取元数据：

```js
App.ApplicationSerializer = DS.RESTSerializer.extend({
  extractMeta: function(store, type, payload) {
    if (payload && payload.total) {
      store.metaForType(type, { total: payload.total });  // sets the metadata for "post"
      delete payload.total;  // keeps ember data from trying to parse "total" as a record
    }
  }
});
```
