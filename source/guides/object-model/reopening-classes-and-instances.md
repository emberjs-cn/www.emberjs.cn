英文原文：[http://emberjs.com/guides/object-model/reopening-classes-and-instances/](http://emberjs.com/guides/object-model/reopening-classes-and-instances/)

Ember.js的类不需要一次性完成所有的定义。可以通过`reopen`方法重新打开一个类来定义新的属性。

```javascript
Person.reopen({
  isPerson: true
});

Person.create().get('isPerson') // true
```

当使用`reopen`时，还可以重写已有的方法。在重写的方法中可以通过`this._super`来调用被重写的方法。

```javascript
Person.reopen({
  // override `say` to add an ! at the end
  say: function(thing) {
    this._super(thing + "!");
  }
});
```

`reopen`用来添加被所有类的实例共享的实例方法和属性。它不能像Vanilla Javascript那样，用来为某一特定的实例来添加方法和属性（不使用prototype）。

但是如果需要为类添加方法和属性，则可以使用`reopenClass`方法。

```javascript
Person.reopenClass({
  createMan: function() {
    return Person.create({isMan: true})
  }
});

Person.createMan().get('isMan') // true
```
