### Problem

### 问题

You want to base the value of one property on the value of another property.

希望对象的一个属性是基于其另外一个属性的值。

### Solution

### 解决方案

Use one of the computed property macros like `Ember.computed.alias` or `Ember.computed.equal`

使用计算属性宏来定义，如：`Ember.computed.alias`或`Ember.computed.equal`。

```js
App.Person = Ember.Object.extend({
	firstName : null,
	lastName : null,
	surname : Ember.computed.alias("lastName"),
	eligibleForRetirement: Ember.computed.gte("age", 65)
});
```

### Discussion

### 讨论

Ember.js includes a number of macros that will help create properties whose values are based
on the values of other properties, correctly connecting them with bindings so they remain
updated when values change. These all are stored on the `Ember.computed` object
and [documented in the API documentation](http://emberjs.com/api/#method_computed)

Ember.js包含了一系列可以用于帮助创建基于其他属性的值的属性，正确的使用绑定来连接它们可以在值发生改变的时候，自动得到更新。这些都被保存在`Ember.computed`对象中，[API文档](http://emberjs.com/api/#method_computed)中有详细的描述。

#### Example

#### 示例

<a class="jsbin-embed" href="http://emberjs.jsbin.com/AfufoSO/3/edit?output">JS Bin</a>
