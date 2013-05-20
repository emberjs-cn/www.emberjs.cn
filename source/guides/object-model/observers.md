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
  }.property('firstName', 'lastName')
});

var person = Person.create({
  firstName: "Yehuda",
  lastName: "Katz"
});

person.addObserver('fullName', function() {
  // 根据变化（fullName）进行处理
});

person.set('firstName', "Brohuda"); // 观察器将被触发
```

由于 `fullName` 这个计算后属性依赖于 `firstName` 的变化，所以在更新 `firstName` 时也将触发 `fullName` 上的观察器。

因为观察器是如此普遍，Ember 提供了一种在类定义中定义内联式观察器的途径。

```javascript
Person.reopen({
  fullNameChanged: function() {
    // 这是内联式版本的 .addObserver
  }.observes('fullName')
});
```

在没有原型扩展的前提下使用 Ember 的时候，你可以用 `Ember.observer` 方法来定义内联式观察器：

```javascript
Person.reopen({
  fullNameChanged: Ember.observer(function() {
    // 这是内联式版本的 .addObserver
  }, 'fullName')
});
```

[source_link]: http://emberjs.com/guides/object-model/observers/
[wiki_observer]: http://zh.wikipedia.org/wiki/%E8%A7%82%E5%AF%9F%E8%80%85%E6%A8%A1%E5%BC%8F