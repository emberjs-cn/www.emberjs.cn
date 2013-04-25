英文原文：[http://emberjs.cn/guides/configuring-ember/disabling-prototype-extensions/](http://emberjs.cn/guides/configuring-ember/disabling-prototype-extensions/)

## 禁用`prototype`扩展

默认情况下，Ember.js 以下列方式对原生的JavaScript对象进行基于原型的扩展：


* `Array`被扩展用来实现`Ember.Enumerable`, `Ember.MutableEnumerable`, `Ember.MutableArray` 和 `Ember.Array`接口。此举填补了本来不支持 ECMAScript 5 数组方法的浏览器的空白，为数组增加了便捷方法和属性，同时使数据的变化可观察。
* `String`被扩展了诸如`camelize()`和`fmt()`的便捷方法。
* `Function`通过`property()`扩展了将函数注解为计算属性的方法，还扩展了将方程注解为观察者的方法，这些方法为`observes()`或`observesBefore()`。


这就是Ember.js增强原生原型的范围。我们仔细权衡了改变这些原型的利弊，因此推荐多数Ember.js开发者能使用这些扩展。这些扩展显著地减少了必须输入的样板文件代码量。

然后，我们也理解有时你的Ember.js程序会嵌入到一个你不能控制的环境中。经常是将第三方JavaScript代码嵌入到其他页面中时，或是当将应用一块一块地迁移到更先进的Ember.js架构中来的时候。

那些情况下，你不能或不想修改原生的原型，Ember.js允许你彻底关闭上面所说的扩展。


只要将`EXTEND_PROTOTYPES`标志为设为`false`即可。

```javascript
window.Ember = {};
Ember.EXTEND_PROTOTYPES = false;
```

需要注意的是，上面的代码必须在Ember.js加载 **之前** 运行。如果你在Ember.js运行了之后再设置此标志位，那么原生的原型就已经被修改过了。


### 没有基于原型的扩展的情况

要想程序正常运作，你得手动扩展或创建对象，与之前创建对象的过程一样。



#### 数组

原生数组不再继续实现监控自身变化所需的功能。如果你关闭了基于原型的扩展并且试图在模板的`{{#each}}`等助手方法中使用原生数组的话，Ember.js就没办法检测到数组的内容变化，模板也不会随着数组的变化而自动更新。


另外，你试图将`Ember.ArrayController`的内容设置为普通的原生数组时，Ember.js会报一个异常，因为原生数组已然不再继续实现`Ember.Array`接口了。


当然你可以将原生数组强制转换成实现了必需接口的数组，只要你使用`Ember.A`这个便捷方法就可以了。

```javascript
var islands = ['Oahu', 'Kauai'];
islands.contains('Oahu');
//=> TypeError: Object Oahu,Kauai has no method 'contains'
//=> 类型错误: Oahu,Kauai 对象没有 'contains' 方法

// Convert `islands` to an array that implements the
// Ember enumerable and array interfaces
//将`islands`转换为实现了Ember枚举以及数组接口的数组
Ember.A(islands);

islands.contains('Oahu');
//=> true
```

#### 字符串


字符串不再拥有[Ember.String API reference.](/api/classes/Ember.String.html)中描述的便捷方法。然而，你可以使用`Ember.String`对象中名称类似的方法并将字符串作为第一个参数传进来：


```javascript
"my_cool_class".camelize();
//=> TypeError: Object my_cool_class has no method 'camelize'
//=> 类型错误: my_cool_class 对象没有`camelize`方法

Ember.String.camelize("my_cool_class");
//=> "myCoolClass"
```

#### Functions

#### 函数


用`Ember.computed()`方法来包裹函数以标记计算属性。

```javascript
// This won't work:
//这样的代码不会起作用：
fullName: function() {
  return this.get('firstName') + ' ' + this.get('lastName');
}.property('firstName', 'lastName')


// Instead, do this:
//你需要这样做：
fullName: Ember.computed(function() {
  return this.get('firstName') + ' ' + this.get('lastName');
}).property('firstName', 'lastName')
```

用`Ember.observer()`来标记观察者：

```javascript
// This won't work:
//这样的代码不会起作用：
fullNameDidChange: function() {
  console.log("Full name changed");
}.observes('fullName')


// Instead, do this:
//你需要这样做：
fullNameDidChange: Ember.observer(function() {
  console.log("Full name changed");
}, 'fullName')
```
