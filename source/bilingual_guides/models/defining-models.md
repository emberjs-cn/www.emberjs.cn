英文原文：[http://emberjs.com/guides/models/defining-models/](http://emberjs.com/guides/models/defining-models/)

A model is a class that defines the properties and behavior of the
data that you present to the user. Anything that the user expects to see
if they leave your app and come back later (or if they refresh the page)
should be represented by a model.

For every model in your application, create a subclass of `DS.Model`:

```javascript
App.Person = DS.Model.extend();
```

After you have defined a model class, you can start finding and creating
records of that type. When interacting with the store, you will need to
specify a record's type using the model name. For example, the store's
`find()` method expects a string as the first argument to tell it what
type of record to find:

```js
store.find('person', 1);
```

The table below shows how model names map to model classes.

<table>
  <thead>
  <tr>
    <th>Model Name</th>
    <th>Model Class</th>
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

You can specify which attributes a model has by using `DS.attr`.

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

You can use attributes just like any other property, including as part of a
computed property. Frequently, you will want to define computed
properties that combine or transform primitive attributes.

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

If you don't specify the type of the attribute, it will be whatever was
provided by the server. You can make sure that an attribute is always
coerced into a particular type by passing a `type` option to `attr`:

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

However, sometimes you may have multiple `belongsTo`/`hasMany`s for the
same type. You can specify which property on the related model is the
inverse using `DS.attr`'s `inverse` option:

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
