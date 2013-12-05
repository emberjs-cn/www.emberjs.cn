英文原文：[http://emberjs.com/guides/cookbook/user_interface_and_interaction/adding_css_classes_to_your_components](http://emberjs.com/guides/cookbook/user_interface_and_interaction/adding_css_classes_to_your_components)

### 问题

需要给Ember Components（组件）添加CSS类名。

### 解决方案

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

### 讨论

如果需要，可以添加多个CSS类名。

```js
classNames: ['bold', 'italic', 'blue']
```

#### 示例

<a class="jsbin-embed" href="http://emberjs.jsbin.com/ifUDExu/2/edit?js,output">JS Bin</a>

查看[自定义组件元素](/guides/components/customizing-a-components-element/)获取更多示例。
