英文原文：[http://emberjs.com/guides/models/defining-models/](http://emberjs.com/guides/models/defining-models/)

## 定义模型

你可以通过创建`DS.Model`的子类来表示每一种类型的模型：

```javascript
App.Person = DS.Model.extend();
```

### 属性标志

你可以通过`DS.attr`指定模型具有哪些属性。你可以像其他属性一样使用属性标志，包括作为计算属性的一部分。

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

默认情况下，REST 适配器支持的属性类型有`string`, `number`, `boolean`和`date`。
传统的适配器会提供额外的属性类型，并支持你注册自定义的属性类型。
详情请查看[documentation section on the REST Adapter](/guides/models/the-rest-adapter)。

### 关联模型

Ember Data 包括了几个内置的关联类型，以帮助你确定你的模型如何相互关联的。

#### 一对一

使用`DS.belongsTo`在两个模型间声明一对一的关系。

```js
App.User = DS.Model.extend({
  profile: DS.belongsTo('App.Profile')
});

App.Profile = DS.Model.extend({
  user: DS.belongsTo('App.User')
});
```

#### 一对多

使用`DS.belongsTo`结合`DS.hasMany`来声明两个模型间的一对多关系，示例如下：

```js
App.Post = DS.Model.extend({
  comments: DS.hasMany('App.Comment')
});

App.Comment = DS.Model.extend({
  post: DS.belongsTo('App.Post')
});
```

#### 多对多

使用`DS.hasMany`来声明两个模型间的多对多关系。

```js
App.Post = DS.Model.extend({
  tags: DS.hasMany('App.Tag')
});

App.Tag = DS.Model.extend({
  posts: DS.hasMany('App.Post')
});
```

#### 显式反转

自[本周Ember.js，2012-11-2](http://emberjs.com/blog/2012/11/02/this-week-in-ember-js.html)起，

Ember Data知道当设定一个`belongsTo`的关联关系时，子应该要被添加到对应的父的`hasMany`关联关系中去。

但是不幸的是，它并不知道哪一个`hasMany`关联关系应该得到更新。因此，Ember
Data选择其找到的第一个拥有相同类型的子关联来进行更新。

因为可能存在许多具有相同类型的`belongsTo`/`hasMany`，这是可以显式的指定对应的反转对象：

```javascript
App.Comment = DS.Model.extend({
  onePost: DS.belongsTo("App.Post"),
  twoPost: DS.belongsTo("App.Post"),
  redPost: DS.belongsTo("App.Post"),
  bluePost: DS.belongsTo("App.Post")
});


App.Post = DS.Model.extend({
  comments: DS.hasMany('App.Comment', {
    inverse: 'redPost'
  })
});
```

当然也可以在`belongsTo`一侧指定，它将按照预期那样工作。


#### 嵌套对象

当有数据结构的嵌套数据不使用或者需要IDS，必须指定`hasMany`包含的`belongsTo`。

为了这样，需要扩展应用使用的适配器来加载包含嵌套结构的数据。

```javascript
App.Comment = DS.Model.extend({});

App.Post = DS.Model.extend({
  comments: DS.hasMany('App.Comment')
});

App.Adapter.map('App.Post', {
  comments: { embedded: 'always' }
});
```
