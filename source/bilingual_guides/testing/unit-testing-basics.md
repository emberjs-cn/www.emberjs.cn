As it is the basic object type in Ember, being able to test a simple
`Ember.Object` sets the foundation for testing more specific parts of your
Ember application such as controllers, components, etc. Testing an `Ember.Object`
is as simple as creating an instance of the object, setting its state, and
running assertions against the object. By way of example lets look at a few
common cases.

尽管`Ember.Object`是Ember中得基础对象类型，然后能够测试一个简单的`Ember.Object`是能测试Ember应用各个特定部分的基础。如控制器、组件等。测试`Ember.Object`就如创建一个对象实例一样简单，设置其状态并针对对象进行断言。作为实例，下面将来介绍一些一般性的场景。

### Testing Computed Properties

### 测试计算属性

Let's start by looking at an object that has a `computedFoo` computed property
based on a `foo` property.

下面从一个具有基于`foo`属性的`computedFoo`计算属性的对象开始。

```javascript
App.SomeThing = Ember.Object.extend({
  foo: 'bar',
  computedFoo: function(){
    return 'computed ' + this.get('foo');
  }.property('foo')
});
```

Within the test we'll create an instance, update the `foo` property (which
should trigger the computed property), and assert that the logic in our
computed property is working correctly.

在测试中，创建了一个实例，更新实例的`foo`属性（这将触发计算属性），然后断言计算属性中得逻辑工作正常。

```javascript
module('Unit: SomeThing');

test('computedFoo correctly concats foo', function() {
  var someThing = App.SomeThing.create();
  someThing.set('foo', 'baz');
  equal(someThing.get('computedFoo'), 'computed baz');
});
```

#### Live Example

#### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/miziz/embed?output">Unit Testing 
Basics: Computed Properties</a>

<a class="jsbin-embed" href="http://jsbin.com/miziz/embed?output">单元测试基础：计算属性</a>

### Testing Object Methods

### 测试对象方法

Next let's look at testing logic found within an object's method. In this case
the `testMethod` method alters some internal state of the object (by updating
the `foo` property).

下面再看一个测试对象方法逻辑的例子。在这里`testMethod`方法修改了对象的一些内部状态（更新了`foo`属性）。

```javascript
App.SomeThing = Ember.Object.extend({
  foo: 'bar',
  testMethod: function() {
    this.set('foo', 'baz');
  }
});
```

To test it, we create an instance of our class `SomeThing` as defined above, 
call the `testMethod` method and assert that the internal state is correct as a 
result of the method call.

为了测试这个方法，首先创建了一个`SomeThing`的实例，调用其`testMethod`，然后断言内部状态与期望的一样。

```javascript
module('Unit: SomeThing');

test('calling testMethod updates foo', function() {
  var someThing = App.SomeThing.create();
  someThing.testMethod();
  equal(someThing.get('foo'), 'baz');
});
```

#### Live Example

#### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/weroh/embed?output">Unit Testing 
Basics: Method Side Effects</a>

<a class="jsbin-embed"
href="http://jsbin.com/weroh/embed?output">单元测试基础：方法负效应</a>

In the event the object's method returns a value you can simply assert that the
return value is calculated correctly. Suppose our object has a `calc` method
that returns a value based on some internal state.

在这里对象的方法返回了一个值，可以通过简单的断言来判断值是否被正确计算。假设对象有一个`calc`方法，其基于一些内部的状态返回一个值。

```javascript
App.SomeThing = Ember.Object.extend({
  count: 0,
  calc: function() {
    this.incrementProperty('count');
    return 'count: ' + this.get('count');
  }
});
```

The test would call the `calc` method and assert it gets back the correct value.

测试要调用`calc`方法并断言其返回正确的值。

```javascript
module('Unit: SomeThing');

test('testMethod returns incremented count', function() {
  var someThing = App.SomeThing.create();
  equal(someThing.calc(), 'count: 1');
  equal(someThing.calc(), 'count: 2');
});
```

#### Live Example

#### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/qutar/embed?output">Unit Testing 
Basics: Method Side Effects</a>

<a class="jsbin-embed" href="http://jsbin.com/qutar/embed?output">单元测试基础：方法负效应</a>

### Testing Observers

### 测试观察器

Suppose we have an object that has an observable method based on the `foo`
property.

假设有一个对象其有一个观察`foo`属性的方法。

```javascript
App.SomeThing = Ember.Object.extend({
  foo: 'bar',
  other: 'no',
  doSomething: function(){
    this.set('other', 'yes');
  }.observes('foo')
});
```

In order to test the `doSomething` method we create an instance of `SomeThing`,
update the observed property (`foo`), and assert that the expected effects are present.

为了测试`doSomething`方法，首先创建一个`SomeThing`实例，然后修改被观察的属性（`foo`），并断言期待的效果出现。

```javascript
module('Unit: SomeThing');

test('doSomething observer sets other prop', function() {
  var someThing = App.SomeThing.create();
  someThing.set('foo', 'baz');
  equal(someThing.get('other'), 'yes');
});
```

#### Live Example

#### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/daxok/embed?output">Unit Testing Basics: Observers</a>

<a class="jsbin-embed" href="http://jsbin.com/daxok/embed?output">单元测试基础：观察器</a>

<script src="http://static.jsbin.com/js/embed.js"></script>
