英文原文：[http://emberjs.com/guides/cookbook/user_interface_and_interaction/focusing_a_textfield_after_its_been_inserted](http://emberjs.com/guides/cookbook/user_interface_and_interaction/focusing_a_textfield_after_its_been_inserted)

### 问题

创建了一个`Ember.TextField`实例，希望在其被插入DOM后，当前焦点在该文本框上。

### 解决方案

继承`Ember.TextField`，并且定义使用`.on('didInsertElement')`标记的方法。在方法内调用组件的jQuery`$`的`focus`方法。

```javascript
App.FocusInputComponent = Ember.TextField.extend({
  becomeFocused: function() {
    this.$().focus();
  }.on('didInsertElement')
});
```

组件模板：

```handlebars
Focus Input component!
```

```handlebars
{{focus-input}}
```

### 讨论

自定义组件提供了一个可以扩展原生的HTML元素，使其具有如自动对焦这样的功能。

`App.FocusInputComponent`是一个`Ember.TextField`的扩展组件，其中添加了一个`becomeFocused`方法。在组件被添加到DOM中之后，每一个Ember.js下的组件都可以访问对应的jQuery对象。这个对象包裹着组件的元素，并且提供了统一的、跨浏览器的接口来操作DOM，比如触发对焦。

因为只能在Ember.js组件被加入到DOM，才能使用这些DOM特性，因此需要收到加入DOM事件的通知。组件有一个`didInsertElement`事件，该事件在组件被加入到DOM中后被触发。

在缺省情况下，Ember.js扩展了原生的`Function.prototype`对象来包含一系列的附加函数，`on`函数就是其中的一个。通过`on`函数，可以以声明的方式来标记一个方法在指定的事件发生时被调用。在这个例子中，`becomeFocused`方法会在组件实例的`didInsertElement`发生时被调用。

设置`Ember.EXTEND_PROTOTYPES`属性为`false`，可以关闭prototype扩展。

#### 示例

<a class="jsbin-embed" href="http://emberjs.jsbin.com/OlUGODo/4/edit?html,js,output">JS Bin</a>
