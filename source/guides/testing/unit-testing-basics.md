英文原文：[http://emberjs.com/guides/testing/unit-testing-basics/](http://emberjs.com/guides/testing/unit-testing-basics/)

尽管`Ember.Object`是Ember中得基础对象类型，然后能够测试一个简单的`Ember.Object`是能测试Ember应用各个特定部分的基础。如控制器、组件等。测试`Ember.Object`就如创建一个对象实例一样简单，设置其状态并针对对象进行断言。作为实例，下面将来介绍一些一般性的场景。

### 测试计算属性

下面从一个具有基于`foo`属性的`computedFoo`计算属性的对象开始。

```javascript
App.SomeThing = Ember.Object.extend({
  foo: 'bar',
  computedFoo: function(){
    return 'computed ' + this.get('foo');
  }.property('foo')
});
```

在测试中，创建了一个实例，更新实例的`foo`属性（这将触发计算属性），然后断言计算属性中得逻辑工作正常。

```javascript
module('Unit: SomeThing');

test('computedFoo correctly concats foo', function() {
  var someThing = App.SomeThing.create();
  someThing.set('foo', 'baz');
  equal(someThing.get('computedFoo'), 'computed baz');
});
```

#### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/miziz/embed?output">单元测试基础：计算属性</a>

### 测试对象方法

下面再看一个测试对象方法逻辑的例子。在这里`testMethod`方法修改了对象的一些内部状态（更新了`foo`属性）。

```javascript
App.SomeThing = Ember.Object.extend({
  foo: 'bar',
  testMethod: function() {
    this.set('foo', 'baz');
  }
});
```

为了测试这个方法，首先创建了一个`SomeThing`的实例，调用其`testMethod`，然后断言内部状态与期望的一样。

```javascript
module('Unit: SomeThing');

test('calling testMethod updates foo', function() {
  var someThing = App.SomeThing.create();
  someThing.testMethod();
  equal(someThing.get('foo'), 'baz');
});
```

#### 在线示例

<a class="jsbin-embed"
href="http://jsbin.com/weroh/embed?output">单元测试基础：方法负效应</a>

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

测试要调用`calc`方法并断言其返回正确的值。

```javascript
module('Unit: SomeThing');

test('testMethod returns incremented count', function() {
  var someThing = App.SomeThing.create();
  equal(someThing.calc(), 'count: 1');
  equal(someThing.calc(), 'count: 2');
});
```

#### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/qutar/embed?output">单元测试基础：方法负效应</a>

### 测试观察器

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

为了测试`doSomething`方法，首先创建一个`SomeThing`实例，然后修改被观察的属性（`foo`），并断言期待的效果出现。

```javascript
module('Unit: SomeThing');

test('doSomething observer sets other prop', function() {
  var someThing = App.SomeThing.create();
  someThing.set('foo', 'baz');
  equal(someThing.get('other'), 'yes');
});
```

#### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/daxok/embed?output">单元测试基础：观察器</a>

<script src="http://static.jsbin.com/js/embed.js"></script>
