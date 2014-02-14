英文原文：[http://emberjs.com/guides/object-model/computed-properties/](http://emberjs.com/guides/object-model/computed-properties/)

## 什么是计算属性？

简单地来说，计算属性就是将函数声明为属性。通过定义一个如同函数一般的计算属性，Ember将会自动调用该函数来获取计算属性的值，此后就可以如同使用普通静态属性一样来使用计算属性。

在需要使用一个或者多个属性的变形，或者手动修改其数据的时候非常有用。

### 计算属性实操

下面就从一个简单的例子开始：

```javascript
App.Person = Ember.Object.extend({
  // these will be supplied by `create`
  firstName: null,
  lastName: null,

  fullName: function() {
    return this.get('firstName') + ' ' + this.get('lastName');
  }.property('firstName', 'lastName')
});

var ironMan = App.Person.create({
  firstName: "Tony",
  lastName:  "Stark"
});

ironMan.get('fullName') // "Tony Stark"
```

注意这里`fullName`函数是`property`。这里将函数声明为计算属性，参数则是告诉Ember，`fullName`依赖于`firstName`和`lastName`两个属性。

当访问`fullName`属性时，函数将被调用，并返回函数的返回值。上例中则是将`firstName`和`lastName`拼接起来。

### 链式计算属性

计算属性又可以用来定义新的计算属性。下面将使用`fullName`属性和其他的一些新加的属性，给上例添加一个`description`计算属性。

```javascript
App.Person = Ember.Object.extend({
  firstName: null,
  lastName: null,
  age: null,
  country: null,

  fullName: function() {
    return this.get('firstName') + ' ' + this.get('lastName');
  }.property('firstName', 'lastName'),

  description: function() {
    return this.get('fullName') + '; Age: ' + this.get('age') + '; Country: ' + this.get('country');
  }.property('fullName', 'age', 'country')
});

var captainAmerica = App.Person.create({
  firstName: 'Steve',
  lastName: 'Rogers',
  age: 80,
  country: 'USA'
});

captainAmerica.get('description'); // "Steve Rogers; Age: 80; Country: USA"
```

### 动态更新

计算属性默认情况下会监听所有其依赖的属性的变化，并在其被调用的时候进行更新。下面将使用动态属性的动态更新。

```javascript
captainAmerica.set('firstName', 'William');

captainAmerica.get('description'); // "William Rogers; Age: 80; Country: USA"
```

这里`firstName`的改变被`fullName`计算属性观测到，而`fullName`的改变又被`description`计算属性观测到。

设置任意依赖的属性导致的改变，将按照创建的计算属性链，一路向下传播，到所有依赖他们的计算属性。

### 设置计算属性

计算属性可以定义其在被设置的时候Ember需要做些什么工作。如果尝试设置一个计算属性，需要在调用的时候传入键值（属性名），以及将被设置的值。

```javascript
App.Person = Ember.Object.extend({
  firstName: null,
  lastName: null,

  fullName: function(key, value) {
    // setter
    if (arguments.length > 1) {
      var nameParts = value.split(/\s+/);
      this.set('firstName', nameParts[0]);
      this.set('lastName',  nameParts[1]);
    }

    // getter
    return this.get('firstName') + ' ' + this.get('lastName');
  }.property('firstName', 'lastName')
});

var captainAmerica = App.Person.create();
captainAmerica.set('fullName', "William Burnside");
captainAmerica.get('firstName'); // William
captainAmerica.get('lastName'); // Burnside
```

Ember在设置或者获取的时候都将调用计算属性，因此如果需要定义一个计算属性的设置器时，需要通过判断传入的参数的数量来判断是设置还获取。需要注意的是，如果设置器具有返回值，该值将作为属性的值进行缓存。
