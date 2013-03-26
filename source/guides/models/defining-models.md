英文原文：[http://emberjs.com/guides/models/defining-models/](http://emberjs.com/guides/models/defining-models/)

## 定义模型（Defining Models）

For every type of model you'd like to represent, create a new subclass of
`DS.Model`:

你可以通过创建`DS.Model`的子类来表示每一种类型的模型：

```javascript
App.Person = DS.Model.extend();
```

### 属性标志（Attributes）

You can specify which attributes a model has by using `DS.attr`. You can
use attributes just like any other property, including as part of a
computed property.

你可以通过`DS.attr`指定模型哪些属性标志（attributes）。你可以像其他属性一样使用属性标志，包括作为计算属性的一部分。

```javascript
App.Person = DS.Model.extend({
  firstName: DS.attr('string'),
  lastName: DS.attr('string'),
  birthday: DS.attr('date'),

  fullName: function() {
    return this.get('firstName') + ' ' + this.get('lastName');
  }.property('firstName', 'lastName')
});
```

By default, the REST adapter supports attribute types of `string`,
`number`, `boolean`, and `date`. Custom adapters may offer additional
attribute types, and new types can be registered as transforms. See the
[documentation section on the REST Adapter](/guides/models/the-rest-adapter).

默认情况下，REST 适配器支持的属性类型有`string`, `number`, `boolean`和`date`。
传统的适配器会提供额外的属性类型，并支持你注册自定义的属性类型。
详情请查看[documentation section on the REST Adapter](/guides/models/the-rest-adapter)。

### 关联模型（Relationships）

Ember Data includes several built-in relationship types to help you
define how your models relate to each other.

Ember Data 包括了几个内置的方法，以帮助你确定你的模型如何相互关联的。

#### 一对一（One-to-One）

To declare a one-to-one relationship between two models, use
`DS.belongsTo`:

使用`DS.belongsTo`在两个模型间声明一对一的关系。

```js
App.User = DS.Model.extend({
  profile: DS.belongsTo('App.Profile')
});

App.Profile = DS.Model.extend({
  user: DS.belongsTo('App.User')
});
```

#### 一对多（One-to-Many）

To declare a one-to-many relationship between two models, use
`DS.belongsTo` in combination with `DS.hasMany`, like this:

使用`DS.belongsTo`结合`DS.hasMany`来声明两个模型间的一对多关系，示例如下：

```js
App.Post = DS.Model.extend({
  comments: DS.hasMany('App.Comment')
});

App.Comment = DS.Model.extend({
  post: DS.belongsTo('App.Post')
});
```

#### 多对多（Many-to-Many）

To declare a many-to-many relationship between two models, use
`DS.hasMany`:

使用`DS.hasMany`来声明两个模型间的多对多关系。

```js
App.Post = DS.Model.extend({
  tags: DS.hasMany('App.Tag')
});

App.Tag = DS.Model.extend({
  posts: DS.hasMany('App.Post')
});
```
