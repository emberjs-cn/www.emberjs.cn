### Problem

### 问题

You want to add or remove CSS class names to your Ember Components based on properties of the component.

希望基于组件属性添加和删除Ember组件CSS类名。

### Solution

### 解决方案

Add property names to the `classNameBindings` property of subclassed components.

添加属性名称到组件子类的`classNameBindings`属性。

### Discussion

### 讨论

You can apply classes based on properties of the component, or even by properties bound to data passed into the component.This is done by binding the class attribute using `classNameBindings`.

可以基于组件属性应用CSS类，或通过绑定到传入组件的数据来实现。这是通过绑定元素的`class`属性到`classNameBindings`来实现的。

```js
classNameBindings: ['active'],
active: true
```

You can also set the class name based on a computed property.

同样也可以使用一个计算属性来设置CSS类名。

```js
classNameBindings: ['isActive'],
isActive: function() {
  return 'active';
}.property('someAttribute')
```

Another way would be to bind the class name to a bound property.

其他能够将类名绑定到一个绑定属性的方法。

```js
classNameBindings: ['isRelated:relative'],
isRelatedBinding: "content.isRelated" // value resolves to boolean
```

#### Example

#### 示例

<a class="jsbin-embed" href="http://emberjs.jsbin.com/AwAYUwe/2/edit?js,output">JS Bin</a>

See [Customizing a Component's Element](/guides/components/customizing-a-components-element/) for further examples.

查看[自定义组件元素](/guides/components/customizing-a-components-element/)获取更多示例。
