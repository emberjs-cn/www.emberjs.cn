英文原文：[http://emberjs.com/guides/object-model/classes-and-instances/](http://emberjs.com/guides/object-model/classes-and-instances/)

定义一个新的`Ember`的_类_，只需要调用`Ember.Object`的`extend()`方法即可：

```javascript
App.Person = Ember.Object.extend({
  say: function(thing) {
    alert(thing);
  }
});
```

这里定义了一个新的`App.Person`的类，并且为该类定义了一个`say()`方法。

通过调用一个现有类的`extend()`方法，可以定义类的_子类_。例如可以通过定义一个`Ember`内建的`Ember.View`的子类来进行扩展：

```js
App.PersonView = Ember.View.extend({
  tagName: 'li',
  classNameBindings: ['isAdministrator']
});
```

当定义一个子类的时候，可以重写父类已有的方法。尽管重写了父类的方法，依然可以在重写的方法中通过`_super()`来调用被重写的父类方法。例如：

```javascript
App.Person = Ember.Object.extend({
  say: function(thing) {
    var name = this.get('name');

    alert(name + " says: " + thing);
  }
});

App.Soldier = App.Person.extend({
  say: function(thing) {
    this._super(thing + ", sir!");
  }
});

var yehuda = App.Soldier.create({
  name: "Yehuda Katz"
});

yehuda.say("Yes");
// alerts "Yehuda Katz says: Yes, sir!"
```

### 创建实例

当定义了一个类之后，就可以通过调用`create()`方法来创建类的_实例_。所有定义在类中的方法、属性、计算属性，都可以通过创建的实例来访问或调用。例如：

```javascript
var person = Person.create();
person.say("Hello") // alerts " says: Hello"
```

当创建一个类的实例时，可以将实例属性的初始值以`hash`形式的参数传给`create()`方法，从而实现对属性的初始化。例如：

```javascript
Person = Ember.Object.extend({
  helloWorld: function() {
    alert("Hi, my name is " + this.get('name'));
  }
});

var tom = Person.create({
  name: "Tom Dale"
});

tom.helloWorld() // alerts "Hi my name is Tom Dale"
```

考虑到性能问题，实例的计算属性或方法不能在调用`create()`方法的时候进行重定义。同样也不可以在此时定义新的计算属性或方法。因此，在调用`create()`方法时，只能设置基本属性。如果需要定义或者重新定义计算属性或方法，可以通过定义一个新的子类来实现。

按照惯例，用来保存类名的属性和变量名需首字母大写，而实例名首字母不大写。例如：变量`Person`代表一个类，而`person`则代表一个实例（通常是类`Person`的实例）。在`Ember`应用中，应该采用这样的命名惯例。

### 初始化实例

当一个实例被创建后，实例的`init`方法会被自动调用。可以通过自定义`init`方法，来对新实例进行初始化。

```js
Person = Ember.Object.extend({
  init: function() {
    var name = this.get('name');
    alert(name + ", reporting for duty!");
  }
});

Person.create({
  name: "Stefan Penner"
});

// alerts "Stefan Penner, reporting for duty!"
```

假若继承了一个`Ember`内建的类，例如`Ember.View`或是`Ember.ArrayController`，并且重写了`init`方法，一定要在重写的`init`方法中调用`this._super()`！如果没有调用该方法，系统可能无法正常完成一些重要的初始化工作，从而导致应用出现一些怪异的行为。

当访问一个对象的属性时，应该使用`get`方法，而设置属性值时则应该使用`set`方法。例如：

```js
var person = App.Person.create();

var name = person.get('name');
person.set('name', "Tobias Fünke");
```

请记住使用这些属性访问方法，否则计算属性不会重新计算，观测也不会被触发，模板也无法得到正常的更新。
