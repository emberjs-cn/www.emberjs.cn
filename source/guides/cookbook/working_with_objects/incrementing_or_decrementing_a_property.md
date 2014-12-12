英文原文：[http://emberjs.com/guides/cookbook/working\_with\_objects/incrementing\_or\_decrementing\_a\_property](http://emberjs.com/guides/cookbook/working_with_objects/incrementing_or_decrementing_a_property)

### 问题

希望增加或者减少一个属性的值。

### 解决方案

使用`Ember.Object`的`incrementProperty`或`decrementProperty`方法。

增加属性值：

```js
person.incrementProperty('age');
```

减少属性值：

```js
person.decrementProperty('age');
```

### 讨论

可以选择指定需要增加或减少的值：

```js
person.incrementProperty('age', 10);
```

#### 示例

<a class="jsbin-embed" href="http://emberjs.jsbin.com/aTipaQO/2/edit?js,output">JS Bin</a>
