英文原文：[http://emberjs.com/guides/object-model/observers/](http://emberjs.com/guides/object-model/observers/)

Ember 为包括计算后属性在内的任意一种属性提供了观察器。可以通过使用 `addObserver` 方法来为一个对象设置一个观察器：

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

### 观察器与异步

Ember中的观察器目前都是同步的。这就意味着一旦其观察的属性发生改变就立刻会被触发。因为这样，找到属性没有被及时同步就变得容易了：

```javascript
Person.reopen({
  lastNameChanged: function() {
    // 该观察器和 fullName 都依赖于 lastName。因为观察器都是异步的，当该函数被调用时， 
    // fullName 还没有被更新，因此这里会打印出 fullName 的旧值。
    console.log(this.get('fullName'));
  }.observes('lastName')
});
```

如果观察了多个属性，那么同步行为也会导致观察器被多次触发：

```javascript
Person.reopen({
  partOfNameChanged: function() {
    // 因为 firstName 和 lastName 都被设置了，将触发两次更新
  }.observes('firstName', 'lastName')
});

person.set('firstName', 'John');
person.set('lastName', 'Smith');
```

为了处理这些问题，就需要使用`Ember.run.once`。这样可以确保所有需要处理的过程都只会发生一次，并且在下一个运行循环里面所有绑定都会同步：

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

### 观察器与对象初始化

观察器只有对象完成了初始化过程之后才会被触发。

如果需要在初始化过程中就触发一个观察器，那么不能依赖于`set`的负效应。而应该在观察器上，通过使用`.on('init')`指定观察器应该在初始化后执行：

```javascript
App.Person = Ember.Object.extend({
  init: function() {
    this.set('salutation', "Mr/Ms");
  },

  salutationDidChange: function() {
    // 一些 salutation 的负效应正在改变
  }.observes('salutation').on('init')
});
```

### 未使用的计算属性不触发观察器

如果从未`get`一个计算属性，那么即使它依赖的键发生改变了，观察器也不会被触发。可以认为这时是计算属性值从一个未知值转换为另一个。

这通常都不会影响到应用代码，因为计算属性几乎总是在被观察到的同时被取用。例如，取得一个计算属性的值，然后将其放入DOM中（或者用D3画出），然后观察它，以便在属性发生改变的时候自动更新DOM。

如果需要观察一个计算属性，当前并不获取它，只需要将其放入到`init`方法中。

### 不用原型扩展

在没有原型扩展的前提下使用 Ember 的时候，可以用 `Ember.observer` 方法来定义内联式观察器：

```javascript
Person.reopen({
  fullNameChanged: Ember.observer('fullName', function() {
    // 这是内联式版本的 .addObserver
  })
});
```

### 类定义之外

同样也可以在一个类的定义之外，使用`addObserver`为一个对象添加一个观察器：

```javascript
person.addObserver('fullName', function() {
  // 更新的处理
});
```
