## Enumerables

## 枚举

In Ember.js, an Enumerable is any object that contains a number of child
objects, and which allows you to work with those children using the
`Ember.Enumerable` API. The most common Enumerable in the majority of
apps is the native JavaScript array, which Ember.js extends to conform
to the Enumerable interface.

在Ember.js中，任何包含子对象集合的，并允许使用`Ember.Enumerable`接口来访问这些子对象的对象称为枚举。在大部分应用中最为常见的枚举是Ember.js为了确保枚举接口的一致性，而进行过扩展的Javascript的原生数组。

By providing a standardized interface for dealing with enumerables,
Ember.js allows you to completely change the way your underlying data is
stored without having to modify the other parts of your application that
access it.

通过提供一个标准接口来处理枚举，Ember.js允许在不改变应用程序其他使用到枚举的部分的情况下，完全的改变数据的存储方式。

For example, you might display a list of items from fixture data during
development. If you switch the underlying data from synchronous fixtures
to an array that fetches data from the server lazily, your view,
template and controller code do not change at all.

例如，在开发过程中，显示的列表条目是通过固定的测试数据来加载。当将该列表条目数据从同步的测试数据切换为从服务器延迟加载的模式来获取的时候，试图、模板和控制器代码不需要进行任何修改。

The Enumerable API follows ECMAScript specifications as much as
possible. This minimizes incompatibility with other libraries, and
allows Ember.js to use the native browser implementations in arrays
where available.

枚举API尽可能的遵从ECMAScript规范，这将与其他库的不兼容情况降至最低，并且允许Ember.js使用浏览器自身实现的数组。

For instance, all Enumerables support the standard `forEach` method:

例如，所有的枚举都支持标准的`forEach`方法：

```javascript
[1,2,3].forEach(function(item) {
  console.log(item);
});

//=> 1
//=> 2
//=> 3
```

In general, Enumerable methods, like `forEach`, take an optional second
parameter, which will become the value of `this` in the callback
function:

通常情况下，类似`forEach`这样的枚举方法都支持一个可选第二参数，该参数值将用作回调函数里的`this`：

```javascript
var array = [1,2,3];

array.forEach(function(item) {
  console.log(item, this.indexOf(item));
}, array)

//=> 1 0
//=> 2 1
//=> 3 2
```

### Enumerables in Ember.js

### Ember.js中的枚举

Usually, objects that represent lists implement the Enumerable interface. Some examples:

通常，代表一个列表的对象实现枚举接口。例如：

 * **Array** - Ember extends the native JavaScript `Array` with the
   Enumerable interface (unless you [disable prototype
   extensions.](/guides/configuring-ember/disabling-prototype-extensions/))
 * **Array** -
   Ember采用枚举接口扩展Javascript原生`Array`（除非[显示关闭prototype扩展](/guides/configuring-ember/disabling-prototype-extensions/))
 * **Ember.ArrayController** - A controller that wraps an underlying array and
   adds additional functionality for the view layer.
 * **Ember.ArrayController** - 一种控制器其包裹了一个数组和其他一些视图层的辅助功能。
 * **Ember.Set** - A data structure that can efficiently answer whether it
   includes an object.
 * **Ember.Set** - 一种数据结构其可以高效的回答是否包含某一个对象。

### API Overview

### API概要

In this guide, we'll explore some of the most common Enumerable
conveniences. For the full list, please see the [Ember.Enumerable API
reference documentation.](/api/classes/Ember.Enumerable.html)

在本指南中，将讲述一些最为常用的枚举惯例。完整的内容请查看[Ember.Enumerable API参考文档](http://emberjs.com/api/classes/Ember.Enumerable.html)

#### Iterating Over an Enumerable

#### 遍历枚举

To enumerate all the values of an enumerable object, use the `forEach` method:

为了遍历枚举对象的所有值，可以使用`forEach`方法：

```javascript
var food = ["Poi", "Ono", "Adobo Chicken"];

food.forEach(function(item, index) {
  console.log('Menu Item %@: %@'.fmt(index+1, item));
});

// Menu Item 1: Poi
// Menu Item 2: Ono
// Menu Item 3: Adobo Chicken
```

#### Making an Array Copy

#### 拷贝数组

You can make a native array copy of any object that implements
`Ember.Enumerable` by calling the `toArray()` method:

可以通过调用实现了`Ember.Enumerable`接口的任意对象的`toArray()`方法来将其创建一个原生的数组。

```javascript
var states = Ember.Set.create();

states.add("Hawaii");
states.add("California")

states.toArray()
//=> ["Hawaii", "California"]
```

Note that in many enumerables, such as the `Ember.Set` used in this
example, the order of the resulting array is not guaranteed.

注意在很多枚举中，例如在本例中使用的`Ember.Set`，生成的数组元素的顺序无法得到保证。

#### First and Last Objects

#### 首尾对象

All Enumerables expose `firstObject` and `lastObject` properties
that you can bind to.

所有枚举提供`firstObject`和`lastObject`属性来获取首尾对象。

```javascript
var animals = ["rooster", "pig"];

animals.get('lastObject');
//=> "pig"

animals.pushObject("peacock");

animals.get('lastObject');
//=> "peacock"
```

#### Map

#### 映射

You can easily transform each item in an enumerable using the
`map()` method, which creates a new array with results of calling a
function on each item in the enumerable.

通过使用`map()`方法，可以方便的转换枚举中的每个元素。该方法使用对每个元素进行处理后的结果创建一个新的数组。

```javascript
var words = ["goodbye", "cruel", "world"];

var emphaticWords = words.map(function(item) {
  return item + "!";
});
// ["goodbye!", "cruel!", "world!"]
```

If your enumerable is composed of objects, there is a `mapBy()`
method that will extract the named property from each of those objects
in turn and return a new array:

如果枚举由对象构成，那么通过`mapBy()`方法可以抽取对象指定的属性，来形成一个新的数组：

```javascript
var hawaii = Ember.Object.create({
  capital: "Honolulu"
});

var california = Ember.Object.create({
  capital: "Sacramento"
});

var states = [hawaii, california];

states.mapBy('capital');
//=> ["Honolulu", "Sacramento"]
```

#### Filtering

#### 过滤

Another common task to perform on an Enumerable is to take the
Enumerable as input, and return an Array after filtering it based on
some criteria.

另外一个常规任务是将一个枚举作为输入，为其设定一些过滤条件来返回一个新的数组。

For arbitrary filtering, use the `filter` method.  The filter method
expects the callback to return `true` if Ember should include it in the
final Array, and `false` or `undefined` if Ember should not.

对于采用`filter`方法的任意过滤。如果回调方法返回`true`，那么Ember将在返回结果中包含该元素，如果返回`false`或者`undefined`则不包含。

```javascript
var arr = [1,2,3,4,5];

arr.filter(function(item, index, self) {
  if (item < 4) { return true; }
})

// returns [1,2,3]
```

When working with a collection of Ember objects, you will often want to filter a set of objects based upon the value of some property. The `filterBy` method provides a shortcut.

当处理一个Ember对象的集合时，经常需要基于对象的某些属性值来过滤。`filterBy`方法可以快速的实现此过滤。

```javascript
Todo = Ember.Object.extend({
  title: null,
  isDone: false
});

todos = [
  Todo.create({ title: 'Write code', isDone: true }),
  Todo.create({ title: 'Go to sleep' })
];

todos.filterBy('isDone', true);

// returns an Array containing only items with `isDone == true`
```

If you want to return just the first matched value, rather than an Array containing all of the matched values, you can use `find` and `findBy`, which work just like `filter` and `filterBy`, but return only one item.

如果只想返回第一个匹配的值，而不是一个包含所有匹配值的数组，可以使用`find`和`findBy`方法，其工作原理与`filter`和`filterBy`一样，不同的是只返回一个元素。

#### Aggregate Information (All or Any)

#### 聚合信息（全部或者部分）

If you want to find out whether every item in an Enumerable matches some condition, you can use the `every` method:

如果希望检查是否所有的枚举的元素都符合某些条件，可以使用`every`方法：

```javascript
Person = Ember.Object.extend({
  name: null,
  isHappy: false
});

var people = [
  Person.create({ name: 'Yehuda', isHappy: true }),
  Person.create({ name: 'Majd', isHappy: false })
];

people.every(function(person, index, self) {
  if(person.get('isHappy')) { return true; }
});

// returns false
```

If you want to find out whether at least one item in an Enumerable matches some conditions, you can use the `some` method:

如果希望检查是否枚举的元素至少有一个符合某些条件，那么可以使用`some`方法：

```javascript
people.some(function(person, index, self) {
  if(person.get('isHappy')) { return true; }
});

// returns true
```

Just like the filtering methods, the `every` and `some` methods have analogous `everyBy` and `anyBy` methods.

如同过滤方法一样，`every`和`some`也有`everyBy`和`anyBy`方法。

```javascript
people.everyBy('isHappy', true) // false
people.anyBy('isHappy', true)  // true
```

