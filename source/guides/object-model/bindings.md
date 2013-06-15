英文原文：[http://emberjs.com/guides/object-model/bindings/](http://emberjs.com/guides/object-model/bindings/)

## 绑定

一个绑定在两个属性之间建立了一个连接，当其中一个发生改变时，另外一个将自动更新为新的值。绑定连接同一对象中属性，也可以连接不同对象的属性。不同于其他一些也实现了类似绑定的框架，Ember.js中的绑定可以在任意对象中使用，而并不紧紧局限于视图和模型。

建立一个双向的关联最简单的方法是添加一个具有相同名称，但以`Binding`为后缀的新属性，并指定一个从全局域开始的路径：

```javascript
App.wife = Ember.Object.create({
  householdIncome: 80000
});

App.husband = Ember.Object.create({
  householdIncomeBinding: 'App.wife.householdIncome'
});

App.husband.get('householdIncome'); // 80000

// Someone gets raise.
App.husband.set('householdIncome', 90000);
App.wife.get('householdIncome'); // 90000
```

需要注意的是绑定并不会在发生变化时立即得到更新。Ember.js将等待应用代码全部执行完毕后才对变更进行同步，因此可以随意对一个绑定的属性进行修改，而无需担心会引发无止境的同步。

## 单向绑定

单向绑定顾名思义只会向一个方向传播更新。通常情况下，使用单向绑定只是为了优化性能，其实完全可以使用更为简洁的双向绑定的语法来实现单向绑定（因为如果一个双向绑定只有一端会发生变化的话，其实际上就是一个单向绑定）。

```javascript
App.user = Ember.Object.create({
  fullName: "Kara Gates"
});

App.userView = Ember.View.create({
  userNameBinding: Ember.Binding.oneWay('App.user.fullName')
});

// Changing the name of the user object changes
// the value on the view.
App.user.set('fullName', "Krang Gates");
// App.userView.userName will become "Krang Gates"

// ...but changes to the view don't make it back to
// the object.
App.userView.set('userName', "Truckasaurus Gates");
App.user.get('fullName'); // "Krang Gates"
```
