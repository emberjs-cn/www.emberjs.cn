## Computed Properties

## 计算属性

Often, you will want a property that is computed based on other
properties. Ember's object model allows you to define computed
properties easily in a normal class definition.

在一些情况下，我们可能希望一个属性可以基于其他属性计算得到。`Ember`对象模型允许我们在普通的类中定义计算属性，如下所示：

```javascript
Person = Ember.Object.extend({
  // these will be supplied by `create`
  firstName: null,
  lastName: null,

  fullName: function() {
    var firstName = this.get('firstName');
    var lastName = this.get('lastName');

   return firstName + ' ' + lastName;
  }.property('firstName', 'lastName')
});

var tom = Person.create({
  firstName: "Tom",
  lastName: "Dale"
});

tom.get('fullName') // "Tom Dale"
```

The `property` method defines the function as a computed property, and
defines its dependencies. Those dependencies will come into play
later when we discuss bindings and observers.

`property`方法会将函数(在这里是fullName)视为一个计算属性，同时也定义了计算属性的依赖。那些依赖会在后面讨论绑定与观察者的时候详述。

When subclassing a class, you can override any computed properties.

在继承类的时候，你可以重载父类的计算属性。

### Setting Computed Properties

### 设置计算属性

You can also define what Ember should do when setting a computed
property. If you try to set a computed property, it will be invoked
with the key and value you want to set it to.

你也可以在设置计算属性的时候定义`Ember`将要执行的操作。如果你需要设置计算属性，那么你需要把key和value参数传递给它。


```javascript
Person = Ember.Object.extend({
  // these will be supplied by `create`
  firstName: null,
  lastName: null,

  fullName: function(key, value) {
    // getter
    if (arguments.length === 1) {
      var firstName = this.get('firstName');
      var lastName = this.get('lastName');

      return firstName + ' ' + lastName;

    // setter
    } else {
      var name = value.split(" ");

      this.set('firstName', name[0]);
      this.set('lastName', name[1]);

      return value;
    }
  }.property('firstName', 'lastName')
});

var person = Person.create();
person.set('fullName', "Peter Wagenet");
person.get('firstName') // Peter
person.get('lastName') // Wagenet
```

Ember will call the computed property for both setters and getters, and
you can check the number of arguments to determine whether it is being called
as a getter or a setter.

无论是getters还是setters，Ember都会调用计算属性。因此，可以通过根据传给计算属性的参数个数来判断是调用了getter还是setter。

