英文原文：[http://emberjs.com/guides/models/defining-models/](http://emberjs.com/guides/models/defining-models/)

A model is a class that defines the properties and behavior of the
data that you present to the user. Anything that the user expects to see
if they leave your app and come back later (or if they refresh the page)
should be represented by a model.

模型是一个定义了需要呈现给用户的数据的属性和行为的类。任何用户往返于应用（或者刷新页面）能看到的内容都需要使用模型来表示。

For every model in your application, create a subclass of `DS.Model`:

应用中所有的模型，都继承与`DS.Model`：

```javascript
App.Person = DS.Model.extend();
```

After you have defined a model class, you can start finding and creating
records of that type. When interacting with the store, you will need to
specify a record's type using the model name. For example, the store's
`find()` method expects a string as the first argument to tell it what
type of record to find:

在定义了一个模型类之后，就可以开始查询或者创建一个属于这个类型的记录。当与仓库进行交互时，需要使用模型的名称来指定记录的类型。例如，仓库的`find()`方法需要一个字符串类型的值作为第一个参数，用于指定需要查询的记录类型：

```js
store.find('person', 1);
```

The table below shows how model names map to model classes.

下表说明了模型名称是如何映射到模型的类的。

<table>
  <thead>
  <tr>
    <th>模型名称</th>
    <th>模型类</th>
  </tr>
  </thead>
  <tr>
    <td><code>photo</code></td>
    <td><code>App.Photo</code></td>
  </tr>
  <tr>
    <td><code>admin-user-profile</code></td>
    <td><code>App.AdminUserProfile</code></td>
  </tr>
</table>

### Defining Attributes

### 定义属性

You can specify which attributes a model has by using `DS.attr`.

模型的属性是通过`DS.attr`来进行声明的。

```javascript
var attr = DS.attr;

App.Person = DS.Model.extend({
  firstName: attr(),
  lastName: attr(),
  birthday: attr()
});
```

Attributes are used when turning the JSON payload returned from your
server into a record, and when serializing a record to save back to the
server after it has been modified.

属性主要由两个作用，其一是用于转换从服务器返回的JSON数据到记录；其二是序列化一个被修改的记录，将其变动保存到服务器端。

You can use attributes just like any other property, including as part of a
computed property. Frequently, you will want to define computed
properties that combine or transform primitive attributes.

属性（Attribute）可以跟其他属性（Property）一样看待，包括计算属性。应用中经常需要使用计算属性来联合或者转换一个原生属性（Attribute）的值。

```javascript
var attr = DS.attr;

App.Person = DS.Model.extend({
  firstName: attr(),
  lastName: attr(),

  fullName: function() {
    return this.get('firstName') + ' ' + this.get('lastName');
  }.property('firstName', 'lastName')
});
```

For more about adding computed properties to your classes, see [Computed Properties](/guides/object-model/computed-properties).

关于如何为类添加计算属性，可以参看[计算属性](/guides/object-model/computed-properties)。

If you don't specify the type of the attribute, it will be whatever was
provided by the server. You can make sure that an attribute is always
coerced into a particular type by passing a `type` option to `attr`:

如果没有指定属性的类型，属性类型与服务器端返回的保持一致。可以通过`attr`设定属性的类型`type`，来确保将服务器返回的数据强制转换为指定的类型。

```js
App.Person = DS.Model.extend({
  birthday: DS.attr('date')
});
```

The default adapter supports attribute types of `string`,
`number`, `boolean`, and `date`. Custom adapters may offer additional
attribute types, and new types can be registered as transforms. See the
[documentation section on the REST Adapter](/guides/models/the-rest-adapter).

默认情况下，REST 适配器支持的属性类型有`string`, `number`, `boolean`和`date`。
传统的适配器会提供额外的属性类型，并支持你注册自定义的属性类型。
详情请查看[documentation section on the REST Adapter](/guides/models/the-rest-adapter)。

### 定义关联模型（Defining Relationships）

Ember Data includes several built-in relationship types to help you
define how your models relate to each other.

Ember Data 包括了几个内置的关联类型，以帮助你确定你的模型如何相互关联的。

#### 一对一（One-to-One）

To declare a one-to-one relationship between two models, use
`DS.belongsTo`:

使用`DS.belongsTo`在两个模型间声明一对一的关系。

```js
App.User = DS.Model.extend({
  profile: DS.belongsTo('profile')
});

App.Profile = DS.Model.extend({
  user: DS.belongsTo('user')
});
```

#### 一对多（One-to-Many）

To declare a one-to-many relationship between two models, use
`DS.belongsTo` in combination with `DS.hasMany`, like this:

使用`DS.belongsTo`结合`DS.hasMany`来声明两个模型间的一对多关系，示例如下：

```js
App.Post = DS.Model.extend({
  comments: DS.hasMany('comment')
});

App.Comment = DS.Model.extend({
  post: DS.belongsTo('post')
});
```

#### 多对多（Many-to-Many）

To declare a many-to-many relationship between two models, use
`DS.hasMany`:

使用`DS.hasMany`来声明两个模型间的多对多关系。

```js
App.Post = DS.Model.extend({
  tags: DS.hasMany('tag')
});

App.Tag = DS.Model.extend({
  posts: DS.hasMany('post')
});
```

#### Explicit Inverses
#### 显式反转

Ember Data will do its best to discover which relationships map to one
another. In the one-to-many code above, for example, Ember Data can figure out that
changing the `comments` relationship should update the `post`
relationship on the inverse because `post` is the only relationship to
that model.

Ember
Data会尽最大努力去自动发现关联关系的映射关系。在上例的一对多的情况下，修改了`comments`会自动更新`post`，应为这是唯一的一个关联模型。

However, sometimes you may have multiple `belongsTo`/`hasMany`s for the
same type. You can specify which property on the related model is the
inverse using `DS.attr`'s `inverse` option:

但是，有时候对同一个类型有多个`belongsTo`/`hasMany`关联关系。这时可以通过指定在反向端使用`DS.attr`的`inverse`选项来指定其关联的模型：

```javascript
var belongsTo = DS.belongsTo,
    hasMany = DS.hasMany;

App.Comment = DS.Model.extend({
  onePost: belongsTo("post"),
  twoPost: belongsTo("post"),
  redPost: belongsTo("post"),
  bluePost: belongsTo("post")
});


App.Post = DS.Model.extend({
  comments: hasMany('comment', {
    inverse: 'redPost'
  })
});
```

You can also specify an inverse on a `belongsTo`, which works how you'd
expect.

当然也可以在`belongsTo`一侧指定，它将按照预期那样工作。

#### Embedded Objects

#### 嵌套对象

When you have a data structure where the embedded data doesn't use or
need ids, you have to specify that the `belongsTo` relationship is
contained by the `hasMany` relationship.

当有数据结构的嵌套数据不使用或者需要IDS，必须指定`hasMany`包含的`belongsTo`。

To do this, you need to extend the adapter that your app is using to
load the data with the embedded structure.

为了这样，需要扩展应用使用的适配器来加载包含嵌套结构的数据。

```javascript
App.Comment = DS.Model.extend({});

App.Post = DS.Model.extend({
  comments: DS.hasMany('comment')
});

App.Adapter.map('App.Post', {
  comments: { embedded: 'always' }
});
```
