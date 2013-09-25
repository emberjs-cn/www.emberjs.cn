## The REST Adapter

## REST适配器

By default, your store will use `DS.RESTAdapter` to load and save
records. The REST adapter assumes that the URLs and JSON associated with
each model are conventional; this means that, if you follow the rules,
you will not need to configure the adapter or write any code in order to
get started.

默认情况下，`store`使用`DS.RESTAdapter`来加载和保存记录。REST适配器假定URLs和每个对象对应的JSON都符合惯例。也就是说，只要遵从规则，就可以在不对适配器进行任何配置和编写任何代码的情况下使用适配器。

### URL Conventions

### URL惯例

The REST adapter is smart enough to determine the URLs it communicates
with based on the name of the model. For example, if you ask for a
`Post` by ID:

REST适配器通过模型的名称来生成需要进行通信的URLs。例如，如下代码展示了如何通过ID来获取对应的`Post`：

```js
var post = App.Post.find(1);
```

The REST adapter will automatically send a `GET` request to `/posts/1`.

REST适配器会自动发送一个`GET`请求到`/posts/1`。

The actions you can take on a record map onto the following URLs in the
REST adapter:

针对记录的操作在REST适配器里被映射为如下的URLs：

<table>
  <thead>
    <tr><th>Action</th><th>HTTP Verb</th><th>URL</th></tr>
  </thead>
  <tbody>
    <tr><th>Find</th><td>GET</td><td>/people/123</td></tr>
    <tr><th>Find All</th><td>GET</td><td>/people</td></tr>
    <tr><th>Update</th><td>PUT</td><td>/people/123</td></tr>
    <tr><th>Create</th><td>POST</td><td>/people</td></tr>
    <tr><th>Delete</th><td>DELETE</td><td>/people/123</td></tr>
  </tbody>
</table>

#### Pluralization Customization

#### 自定义复数形态

Irregular or uncountable pluralizations can be specified via `Ember.Inflector.inflector`:

不规则或不可数名词复数可以通过`Ember.Inflector.inflector`来指定：

```js
Ember.Inflector.inflector.irregular('formula', 'formulae');
Ember.Inflector.inflector.uncountable('advice');
```

This will tell the REST adapter that requests for `App.Formula` requests
should go to `/formulae/1` instead of `/formulae/1`.

如上的配置下，REST适配器会采用`/formulae/1`来获取`App.Formula`，而不是使用`/formulae/1`。

#### Endpoint Path Customization

#### 自定义端点路径

Endpoint paths can be prefixed with a namespace by setting the `namespace`
property on the adapter:

端点路径可以有一个命名空间前缀，该前缀通过适配器的`namespace`属性来进行配置：

```js
DS.RESTAdapter.reopen({
  namespace: 'api/1'
});
```

Requests for `App.Person` would now target `/api/1/people/1`.

现在`App.Person`的请求就会变为`/api/1/people/1`。

#### Host Customization

#### 自定义宿主

An adapter can target other hosts by setting the `url` property.

适配器可以通过设置`url`属性来指向其他的宿主。

```js
DS.RESTAdapter.reopen({
  url: 'https://api.example.com'
});
```

Requests for `App.Person` would now target `https://api.example.com/people/1`.

现在`App.Person`的请求就会变为`https://api.example.com/people/1`。

### JSON Conventions

### JSON惯例

When requesting a record, the REST adapter expects your server to return
a JSON representation of the record that conforms to the following
conventions.

当请求一个记录时，REST适配器期望服务器返回的记录的JSON表示遵从如下惯例。

#### JSON Root

#### JSON根

The primary record being returned should be in a named root. For
example, if you request a record from `/people/123`, the response should
be nested inside a property called `person`:

返回的主记录必须拥有一个命名的根。例如，如果从`/people/123`请求一个记录，那么响应就应该被嵌套在`person`属性下。

```js
{
  "person": {
    "first_name": "Jeff",
    "last_name": "Atwood"
  }
}
```

#### Underscored Attribute Names

#### 以下划线分割额属性名称

Attribute names should be the underscored version of the attribute name
in your Ember Data models. For example, if you have a model like this:

属性名称在`Ember Data`模型中应该是以下划线分割的形式。例如，有一个如下的模型：

```js
App.Person = DS.Model.extend({
  firstName: DS.attr('string'),
  lastName: DS.attr('string'),

  isPersonOfTheYear: DS.attr('boolean')
});
```

The JSON returned from your server should look like this:

那么从服务器返回的JSON格式应该为：

```js
{
  "person": {
    "first_name": "Barack",
    "last_name": "Obama",
    "is_person_of_the_year": true
  }
}
```

Irregular keys can be mapped on the adapter. If the JSON
has a key of `lastNameOfPerson`, and the desired attribute
name is simply `lastName`, inform the adapter:

不规则的`keys`可以在适配器中进行映射。如果返回的JSON包含一个名为`lastNameOfPerson`的`key`，而期望的属性名称为`lastName`，在适配器里配置即可：

```js
App.Person = DS.Model.extend({
  lastName: DS.attr('string')
});
DS.RESTAdapter.map('App.Person', {
  lastName: { key: 'lastNameOfPerson' }
});
```

#### Relationships

#### 关联

References to other records should be done by ID. For example, if you
have a model with a `hasMany` relationship:

对其他对象的引用应该通过ID来进行关联。例如，如果有一个模型拥有一个`hasMany`的关联：

```js
App.Post = DS.Model.extend({
  comments: DS.hasMany('App.Comment')
});
```

The JSON should encode the relationship as an array of IDs:

JSON应该将该关联编码成一个ID的数组：

```js
{
  "post": {
    "comment_ids": [1, 2, 3]
  }
}
```

`Comments` for a `post` can be loaded by `post.get('comments')`. The REST adapter
will send a `GET` request to `/comments?ids[]=1&ids[]=2&ids[]=3`

一篇文章的评论可以通过`post.get('comments')`来进行获取。REST适配器将发送一个`GET`请求至`/comments?ids[]=1&ids[]=2&ids[]=3`。

Any `belongsTo` relationships in the JSON representation should be the
underscored version of the Ember Data model's name, with the string
`_id` appended. For example, if you have a model:

而JSON表示中的任何`belongsTo`关联，应该为以下划线分割的`Ember
Data`模型名称加上`_id`后缀，例如，有如下模型：

```js
App.Comment = DS.Model.extend({
  post: DS.belongsTo('App.Post')
});
```

The JSON should encode the relationship as an ID to another record:

JSON应该将关联编码为另外一个记录的ID：

```js
{
  "comment": {
    "post_id": 1
  }
}
```

#### Sideloaded Relationships

#### 旁路加载关联

To reduce the number of HTTP requests necessary, you can sideload
additional records in your JSON response. Sideloaded records live
outside the JSON root, and are represented as an array of hashes:

为了减少HTTP请求的次数，可以从把JSON响应中的附加对象进行旁路加载。旁路加载的记录在JSON根之外，并作为一个哈希数组存在：

```js
{
  "post": {
    "id": 1,
    "title": "Rails is omakase",
    "comment_ids": [1, 2, 3]
  },

  "comments": [{
    "id": 1,
    "body": "But is it _lightweight_ omakase?"
  },
  {
    "id": 2,
    "body": "I for one welcome our new omakase overlords"
  },
  {
    "id": 3,
    "body": "Put me on the fast track to a delicious dinner"
  }]
}
```

### Creating Custom Transformations

### 创建自定义变换

In some circumstances, the built in attribute types of `string`,
`number`, `boolean`, and `date` may be inadequate. For example, a
server may return a non-standard date format.

在一些环境中，内建的属性类型`string`、`number`、`boolean`和`date`可能不够准确。例如，服务可能返回一个非标准的日期格式。

The `RESTAdapter`, like any Ember adapter, can have new transforms
registered for use as attributes:

`RESTAdapter`可以注册像属性一样使用的新的转换，就如同其他Ember适配器。

```js
DS.RESTAdapter.registerTransform('coordinatePoint', {
  serialize: function(value) {
    return [value.get('x'), value.get('y')];
  },
  deserialize: function(value) {
    return Ember.create({ x: value[0], y: value[1] });
  }
});
App.Cursor = DS.Model.extend({
  position: DS.attr('coordinatePoint')
});
```

When `coordinatePoint` is received from the API, it is
expected to be an array:

当从API接收到`coordinatePoint`时，`coordinatePoint`应该是一个数组：

```js
{
  cursor: {
    position: [4,9]
  }
}
```

But once loaded on a model instance, it will behave as an object:

但是当一个对象实例一旦被加载，`coordinatePoint`则变成了一个对象：

```js
var cursor = App.Cursor.find(1);
cursor.get('position.x'); //=> 4
cursor.get('position.y'); //=> 9
```

If `position` is modified and saved, it will pass through the
`serialize` function in the transform and again be presented as
an array in JSON.

如果`position`被修改和保存，那么它会被传递给`serialize`，将其转换为JSON中的数组。
