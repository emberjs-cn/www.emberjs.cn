### Problem

### 问题

You want to set multiple properties on an object with a single method call.

希望通过一次方法调用设置对象的多个属性值。

### Solution

### 解决方案

Use the `setProperties` method of `Ember.Object`.

使用`Ember.Object`的`setProperties`方法：

```js
person.setProperties({
  name: 'Gavin',
  age: 36
})
```

#### Example

#### 示例

<a class="jsbin-embed" href="http://emberjs.jsbin.com/uPaPEcO/2/edit?js,output">JS Bin</a>
