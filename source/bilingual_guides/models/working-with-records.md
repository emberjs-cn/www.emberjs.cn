## Modifying Attributes

## 修改属性

Once a record has been loaded, you can begin making changes to its
attributes. Attributes behave just like normal properties in Ember.js
objects. Making changes is as simple as setting the attribute you
want to change:

一旦一条记录已经加载进来，你就可以开始修改它的属性(attributes)了。属性（attributes）和Ember.js中对象的普通属性（properties）差不多。（译注：这两个词我都译成了属性，读者自行判定其中潜在的区别）。修改记录就是修改记录的属性。

```javascript
var tyrion = this.store.find('person', 1);
// ...after the record has loaded
tyrion.set('firstName', "Yollo");
```

All of the Ember.js conveniences are available for
modifying attributes. For example, you can use `Ember.Object`'s
`incrementProperty` helper:

Ember.js能提供的所有便利在修改属性都适用。比如，你可以用`Ember.Object`的`incrementProperty`助手方法。


```javascript
person.incrementProperty('age'); // Happy birthday!
```

You can tell if a record has outstanding changes that have not yet been
saved by checking its `isDirty` property. You can also see what parts of
the record were changed and what the original value was using the
`changedAttributes` function.  `changedAttributes` returns an object,
whose keys are the changed properties and values are an array of values
`[oldValue, newValue]`.

你可以通过isDirty属性来判断一条记录是否被更改，且尚未保存。此外使用`changedAttributes`函数还可以查看记录哪些部分被修改了，以及这些部分被修改前的值是什么。`changedAttributes`返回一个对象，其键值是被改变的属性，而值是一个数组`[oldValue, newValue]`。

```js
person.get('isAdmin');      //=> false
person.get('isDirty');      //=> false
person.set('isAdmin', true);
person.get('isDirty');      //=> true
person.changedAttributes(); //=> { isAdmin: [false, true] }
```

At this point, you can either persist your changes via `save()` or you
can rollback your changes. Calling `rollback()` reverts all the
`changedAttributes` to their original value

此时，可以通过`save()`将改变持久化，也可以回滚做的改变。调用`rollback()`会将所有`changedAttributes`设置回其原来的值。

```js
person.get('isDirty');      //=> true
person.changedAttributes(); //=> { isAdmin: [false, true] }

person.rollback();

person.get('isDirty');      //=> false
person.get('isAdmin');      //=> false
person.changedAttributes(); //=> {}
```
