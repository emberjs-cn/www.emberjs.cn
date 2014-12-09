英文原文：[http://emberjs.com/guides/cookbook/user\_interface\_and\_interaction/adding\_css\_classes\_to\_your\_components\_based\_on\_properties](http://emberjs.com/guides/cookbook/user_interface_and_interaction/adding_css_classes_to_your_components_based_on_properties)

### 问题

希望基于组件属性添加和删除Ember组件CSS类名。

### 解决方案

添加属性名称到组件子类的`classNameBindings`属性。

### 讨论

可以基于组件属性应用CSS类，或通过绑定到传入组件的数据来实现。这是通过绑定元素的`class`属性到`classNameBindings`来实现的。

```js
classNameBindings: ['active'],
active: true
```

同样也可以使用一个计算属性来设置CSS类名。

```js
classNameBindings: ['isActive'],
isActive: function() {
  return 'active';
}.property('someAttribute')
```

其他能够将类名绑定到一个绑定属性的方法。

```js
classNameBindings: ['isRelated:relative'],
isRelatedBinding: "content.isRelated" // value resolves to boolean
```

#### 示例

<a class="jsbin-embed" href="http://emberjs.jsbin.com/AwAYUwe/2/edit?js,output">JS Bin</a>

查看[自定义组件元素](/guides/components/customizing-a-components-element/)获取更多示例。
