英文原文：[http://emberjs.com/guides/cookbook/event_handling_and_data_binding/binding_properties_of_an_object_to_its_own_properties](http://emberjs.com/guides/cookbook/event_handling_and_data_binding/binding_properties_of_an_object_to_its_own_properties)

### 问题

希望对象的一个属性是基于其另外一个属性的值。

### 解决方案

使用计算属性宏来定义，如：`Ember.computed.alias`或`Ember.computed.equal`。

```js
App.Person = Ember.Object.extend({
	firstName : null,
	lastName : null,
	surname : Ember.computed.alias("lastName"),
	eligibleForRetirement: Ember.computed.gte("age", 65)
});
```

### 讨论

Ember.js包含了一系列可以用于帮助创建基于其他属性的值的属性，正确的使用绑定来连接它们可以在值发生改变的时候，自动得到更新。这些都被保存在`Ember.computed`对象中，[API文档](http://emberjs.com/api/#method_computed)中有详细的描述。

#### 示例

<a class="jsbin-embed" href="http://emberjs.jsbin.com/AfufoSO/3/edit?output">JS Bin</a>
