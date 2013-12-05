英文原文：[http://emberjs.com/guides/cookbook/working_with_objects/setting_multiple_properties_at_once](http://emberjs.com/guides/cookbook/working_with_objects/setting_multiple_properties_at_once)

### 问题

希望通过一次方法调用设置对象的多个属性值。

### 解决方案

使用`Ember.Object`的`setProperties`方法：

```js
person.setProperties({
  name: 'Gavin',
  age: 36
})
```

#### 示例

<a class="jsbin-embed" href="http://emberjs.jsbin.com/uPaPEcO/2/edit?js,output">JS Bin</a>

