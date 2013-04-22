## Modifying Attributes

## 修改属性

Once a record has been loaded, you can begin making changes to its
attributes. Attributes behave just like normal properties in Ember.js
objects. Making changes is as simple as setting the attribute you
want to change:

一旦一条记录已经加载进来，你就可以开始修改它的属性(attributes)了。属性（attributes）和Ember.js中对象的普通属性（properties）差不多。（译注：这两个词我都译成了属性，读者自行判定其中潜在的区别）。修改记录就是修改记录的属性。

```js
var tyrion = App.Person.find(1);
// ...after the record has loaded
tyrion.set('firstName', "Yollo");
```

All of the Ember.js conveniences are available for
modifying attributes. For example, you can use `Ember.Object`'s
`incrementProperty` helper:

Ember.js能提供的所有便利在修改属性都适用。比如，你可以用`Ember.Object`的`incrementProperty`助手方法。


```js
person.incrementProperty('age');
// Happy birthday!
```

You can tell if a record has outstanding changes that have not yet been
saved by checking its `isDirty` property.

你可以通过isDirty属性来判断一条记录是否被更改，且尚未保存。

```js
person.get('isDirty');
//=> false

person.set('isAdmin', true);

person.get('isDirty');
//=> true
```

Make sure that a record has finished loading before you try to modify.
If you attempt to modify a record before it has finished loading, Ember
Data will raise an exception. For more information, see [Model
Lifecycle][1].

在修改一条记录前，得保证记录已经被完整地加载进来。如果记录尚未完成加载就修改，Ember Data会抛出一个异常。想了解更多信息，见[模型生命周期][1].

[1]: /guides/models/model-lifecycle
