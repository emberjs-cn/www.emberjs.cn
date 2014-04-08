英文原文：[http://emberjs.com/guides/models/working-with-records/](http://emberjs.com/guides/models/working-with-records/)

## 修改属性

一旦一条记录已经加载进来，你就可以开始修改它的属性(attributes)了。属性（attributes）和Ember.js中对象的普通属性（properties）差不多。（译注：这两个词我都译成了属性，读者自行判定其中潜在的区别）。修改记录就是修改记录的属性。

```js
var tyrion = this.store.find('person', 1);
// ...after the record has loaded
tyrion.set('firstName', "Yollo");
```

Ember.js能提供的所有便利在修改属性都适用。比如，你可以用`Ember.Object`的`incrementProperty`助手方法。

```js
person.incrementProperty('age');
// Happy birthday!
```

你可以通过isDirty属性来判断一条记录是否被更改，且尚未保存。此外使用`changedAttributes`函数还可以查看记录哪些部分被修改了，以及这些部分被修改前的值是什么。`changedAttributes`返回一个对象，其键值是被改变的属性，而值是一个数组`[oldValue, newValue]`。

```js
person.get('isAdmin');      //=> false
person.get('isDirty');      //=> false
person.set('isAdmin', true);
person.get('isDirty');      //=> true
person.changedAttributes(); //=> { isAdmin: [false, true] }
```

此时，可以通过`save()`将改变持久化，也可以回滚做的改变。调用`rollback()`会将所有`changedAttributes`设置回其原来的值。

```js
person.get('isDirty');      //=> true
person.changedAttributes(); //=> { isAdmin: [false, true] }

person.rollback();

person.get('isDirty');      //=> false
person.get('isAdmin');      //=> false
person.changedAttributes(); //=> {}
```
