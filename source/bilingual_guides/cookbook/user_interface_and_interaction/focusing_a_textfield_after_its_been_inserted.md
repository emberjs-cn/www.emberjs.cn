### Problem

### 问题

You have an Ember.TextField instance that you would like become focused after it's been inserted.

创建了一个`Ember.TextField`实例，希望在其被插入DOM后，当前焦点在该文本框上。

### Solution

### 解决方案

Subclass `Ember.TextField` and define a method marked with
`.on('didInsertElement')`. Inside this method apply `focus`
to the text field by accessing the components's jQuery `$` property:

继承`Ember.TextField`，并且定义使用`.on('didInsertElement')`标记的方法。在方法内调用组件的jQuery`$`的`focus`方法。

```javascript
App.FocusInputComponent = Ember.TextField.extend({
  becomeFocused: function() {
    this.$().focus();
  }.on('didInsertElement')
});
```

For the component's template:

组件模板：

```handlebars
Focus Input component!
```

```handlebars
{{focus-input}}
```

### Discussion

### 讨论

Custom components provide a way to extend native HTML elements with new behavior
like autofocusing.

自定义组件提供了一个可以扩展原生的HTML元素，使其具有如自动对焦这样的功能。

Our App.FocusInputComponent is an extension of the Ember.TextField component
with a `becomeFocused` method added. After it is added to the DOM, every
component in Ember.js has access to an underlying jQuery object. This object wraps
the component's element and provides a unified, cross-browser interface for DOM
manipulations like triggering focus.

`App.FocusInputComponent`是一个`Ember.TextField`的扩展组件，其中添加了一个`becomeFocused`方法。在组件被添加到DOM中之后，每一个Ember.js下的组件都可以访问对应的jQuery对象。这个对象包裹着组件的元素，并且提供了统一的、跨浏览器的接口来操作DOM，比如触发对焦。

Because we can only work with these DOM features once an Ember.js component has
been added to the DOM we need to wait for this event to occur. Component's have a
`didInsertElement` event that is triggered when the component has been added to the
DOM.

因为只能在Ember.js组件被加入到DOM，才能使用这些DOM特性，因此需要收到加入DOM事件的通知。组件有一个`didInsertElement`事件，该事件在组件被加入到DOM中后被触发。

By default Ember.js extends the native `Function.prototype` object to include a
number of additional functions, the `on` function among them.  `on` gives us a declarative
syntax for signify that a method should be called when a specific event has fired. In this case,
we want to call our new `becomeFocused` method when the `didInsertElement` is fired for an instance 
of our component.

在缺省情况下，Ember.js扩展了原生的`Function.prototype`对象来包含一系列的附加函数，`on`函数就是其中的一个。通过`on`函数，可以以声明的方式来标记一个方法在指定的事件发生时被调用。在这个例子中，`becomeFocused`方法会在组件实例的`didInsertElement`发生时被调用。

Prototype extension can be disabled by setting the `Ember.EXTEND_PROTOTYPES` property to false.

设置`Ember.EXTEND_PROTOTYPES`属性为`false`，可以关闭prototype扩展。

#### Example

#### 示例

<a class="jsbin-embed" href="http://emberjs.jsbin.com/iZiWaZE/2/edit?js,output">JS Bin</a>
