### Problem

### 问题

You want to add CSS class names to your Ember Components.

需要给Ember Components（组件）添加CSS类名。

### Solution

### 解决方案

Set additional class names with the `classNames` property of subclassed components:

使用组件子类的`classNames`属性设置附件的CSS类名：

```js
App.AwesomeInputComponent = Ember.Component.extend({
  classNames: ['css-framework-fancy-class']  
})
```

```handlebars
{{awesome-input}}
```

```html
<div class="css-framework-fancy-class"></div>
```

### Discussion

### 讨论

If desired, you can apply multiple class names.

如果需要，可以添加多个CSS类名。

```js
classNames: ['bold', 'italic', 'blue']
```

#### Example

#### 示例

<a class="jsbin-embed" href="http://emberjs.jsbin.com/ifUDExu/2/edit?js,output">JS Bin</a>

See [Customizing a Component's Element](/guides/components/customizing-a-components-element/) for further examples.

查看[自定义组件元素](/guides/components/customizing-a-components-element/)获取更多示例。
