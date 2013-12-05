### Problem

### 问题

You want to increment or decrement a property.

希望增加或者减少一个属性的值。

### Solution

### 解决方案

Use the `incrementProperty` or `decrementProperty` methods of `Ember.Object`.

使用`Ember.Object`的`incrementProperty`或`decrementProperty`方法。

To increment:

增加属性值：

```js
person.incrementProperty('age');
```

To decrement:

减少属性值：

```js
person.decrementProperty('age');
```

### Discussion

### 讨论

You can optionally specify a value to increment or decrement by:

可以选择指定需要增加或减少的值：

```js
person.incrementProperty('age', 10);
```

#### Example

#### 示例

<a class="jsbin-embed" href="http://emberjs.jsbin.com/aTipaQO/2/edit?js,output">JS Bin</a>
