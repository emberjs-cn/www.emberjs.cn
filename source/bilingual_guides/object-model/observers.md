英文原文：[http://emberjs.com/guides/object-model/observers/](http://emberjs.com/guides/object-model/observers/)

Ember supports observing any property, including computed properties.
You can set up an observer on an object by using the `observes`
method on a function.

Ember 为包括计算后属性在内的任意一种属性提供了观察器。可以通过使用 `addObserver` 方法来为一个对象设置一个观察器。

```javascript
Person = Ember.Object.extend({
  // 这些属性将由 `create` 提供
  firstName: null,
  lastName: null,

  fullName: function() {
    var firstName = this.get('firstName');
    var lastName = this.get('lastName');

    return firstName + ' ' + lastName;
  }.property('firstName', 'lastName'),
  
  fullNameChanged: function() {
    // 处理改变
  }.observes('fullName').on('init')
});

var person = Person.create({
  firstName: "Yehuda",
  lastName: "Katz"
});

person.set('firstName', "Brohuda"); // 观察器将被触发
```

Because the `fullName` computed property depends on `firstName`,
updating `firstName` will fire observers on `fullName` as well.

由于 `fullName` 这个计算后属性依赖于 `firstName` 的变化，所以在更新 `firstName` 时也将触发 `fullName` 上的观察器。

### Observers and asynchrony

### 观察器与异步

Observers in Ember are currently synchronous. This means that they will fire
as soon as one of the properties they observe changes. Because of this, it
is easy to introduce bugs where properties are not yet synchronized:

Ember中的观察器目前都是同步的。这就意味着一旦其观察的属性发生改变就立刻会被触发。因为这样，找到属性没有被及时同步就变得容易了：

```javascript
Person.reopen({
  lastNameChanged: function() {
    // The observer depends on lastName and so does fullName. Because observers
    // are synchronous, when this function is called the value of fullName is
    // not updated yet so this will log the old value of fullName
    console.log(this.get('fullName'));
  }.observes('lastName')
});
```

This synchronous behaviour can also lead to observers being fired multiple
times when observing multiple properties:

如果观察了多个属性，那么同步行为也会导致观察器被多次触发：

```javascript
Person.reopen({
  partOfNameChanged: function() {
    // Because both firstName and lastName were set, this observer will fire twice.
  }.observes('firstName', 'lastName')
});

person.set('firstName', 'John');
person.set('lastName', 'Smith');
```

To get around these problems, you should make use of `Ember.run.once`. This will
ensure that any processing you need to do only happens once, and happens in the
next run loop once all bindings are synchronized:

为了处理这些问题，就需要使用`Ember.run.once`。这样可以确保所有需要处理的过程都只会发生一次，并且在下一个运行循环里面所有绑定都会同步：

```javascript
Person.reopen({
  partOfNameChanged: function() {
    Ember.run.once(this, 'processFullName');
  }.observes('firstName', 'lastName'),

  processFullName: function() {
    // This will only fire once if you set two properties at the same time, and
    // will also happen in the next run loop once all properties are synchronized
    console.log(this.get('fullName'));
  }
});

person.set('firstName', 'John');
person.set('lastName', 'Smith');
```

### Observers and object initialization

### 观察器与对象初始化

Observers never fire until after the initialization of an object is complete.

观察器只有对象完成了初始化过程之后才会被触发。

If you need an observer to fire as part of the initialization process, you
cannot rely on the side effect of set. Instead, specify that the observer
should also run after init by using `.on('init')`:

如果需要在初始化过程中就触发一个观察器，那么不能依赖于`set`的负效应。而应该在观察器上，通过使用`.on('init')`指定观察器应该在初始化后执行：

```javascript
App.Person = Ember.Object.extend({
  init: function() {
    this.set('salutation', "Mr/Ms");
  },

  salutationDidChange: function() {
    // some side effect of salutation changing
  }.observes('salutation').on('init')
});
```

### Unconsumed Computed Properties Do Not Trigger Observers

### 未使用的计算属性不触发观察器

If you never `get` a computed property, its observers will not fire even if
its dependent keys change. You can think of the value changing from one unknown
value to another.

如果从未`get`一个计算属性，那么即使它依赖的键发生改变了，观察器也不会被触发。可以认为这时是计算属性值从一个未知值转换为另一个。

This doesn't usually affect application code because computed properties are
almost always observed at the same time as they are fetched. For example, you get
the value of a computed property, put it in DOM (or draw it with D3), and then
observe it so you can update the DOM once the property changes.

这通常都不会影响到应用代码，因为计算属性几乎总是在被观察到的同时被取用。例如，取得一个计算属性的值，然后将其放入DOM中（或者用D3画出），然后观察它，以便在属性发生改变的时候自动更新DOM。

If you need to observe a computed property but aren't currently retrieving it,
just get it in your init method.

如果需要观察一个计算属性，当前并不获取它，只需要将其放入到`init`方法中。


### Without prototype extensions

### 不用原型扩展

You can define inline observers by using the `Ember.observer` method if you
are using Ember without prototype extensions:

在没有原型扩展的前提下使用 Ember 的时候，可以用 `Ember.observer` 方法来定义内联式观察器：

```javascript
Person.reopen({
  fullNameChanged: Ember.observer('fullName', function() {
    // 这是内联式版本的 .addObserver
  })
});
```

### Outside of class definitions

### 类定义之外

You can also add observers to an object outside of a class definition
using addObserver:

同样也可以在一个类的定义之外，使用`addObserver`为一个对象添加一个观察器：

```javascript
person.addObserver('fullName', function() {
  // deal with the change
});
```
