## 观察器

原文：[http://emberjs.com/guides/object-model/observers/][source_link]

> 译者按：Observer 通常都被译为“观察者模式”，它是一种软件设计模式，有时也叫做“发布/订阅（Pub/Sub）模式”，可参看 [Wikipedia 里的“观察者模式”词条][wiki_observer]。在本指南中之所以译为“观察器”，是因为在这里 Observers 的意思是“Ember.js 框架用来实现观察者设计模式所使用的机制”，因此与惯用译法略有差别。

Ember 为包括计算后属性在内的任意一种属性提供了观察器。你可以通过使用 `addObserver` 方法来为一个对象设置一个观察器。

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

由于 `fullName` 这个计算后属性依赖于 `firstName` 的变化，所以在更新 `firstName` 时也将触发 `fullName` 上的观察器。

### 观察模式与异步调用

目前Ember的观察模式是同步的. 这意味着更新将在properties发生改变的时候触发，因此，在properties没有被同步的时候很容易
导致Bug。


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

当观察绑定在多个properties上时，同步的更新将会被触发多次

```javascript
Person.reopen({
  partOfNameChanged: function() {
    // 因为firstName 和 lastName 都被设置了，将触发两次更新
  }.observes('firstName', 'lastName')
});

person.set('firstName', 'John');
person.set('lastName', 'Smith');
```

解决这类问题的方法是，利用`Ember.run.once`. 它可以保证任何你所需要的同步更新在一次全部完成；

```javascript
Person.reopen({
  partOfNameChanged: function() {
    Ember.run.once(this, 'processFullName');
  }.observes('firstName', 'lastName'),

  processFullName: function() {
    // 如果两个属性都被设置，同步更新会一步到位
    console.log(this.get('fullName'));
  }
});

person.set('firstName', 'John');
person.set('lastName', 'Smith');
```

### 观察者与对象初始化

观察模式的更新在对象初始化完成后才会被触发。

如果你需要在初始化过程中触发一个更新,你不能依赖set方法. 观察绑定更新只能在init完成后通过`.on('init')`来完成:

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

### 未被使用的计算属性，不要触发观察绑定

如果你从未 `get`某个计算属性,即使它依赖的属性发生改变也不会触发绑定的更新， 你可以把它想象成从某个“unknown”值
变成了另一个“unknown“值。

这通常不会影响代码，因为计算属性通常在他们的值被获取到的同时完成绑定更新。例如， 你获得了一个计算属性的值，将其放在DOM 上(或者利用D3渲染出来),然后对其开始”观察“，以在属性值发生变化的同时更新DOM。


如果你需要观察一个计算属性但是目前没有获得其值，可以在init方法中获得它。


### 无 prototype extensions

在没有原型扩展的前提下使用 Ember 的时候，你可以用 `Ember.observer` 方法来定义内联式观察器

```javascript
Person.reopen({
  fullNameChanged: Ember.observer('fullName', function() {
    // 这是内联式版本的 .addObserver
  })
});
```

### Class定义之外进行观察者绑定

同样，你可以利用addObserver在class定义之外，将observers绑定到对象上：

```javascript
person.addObserver('fullName', function() {
  // 更新的处理
});
```
