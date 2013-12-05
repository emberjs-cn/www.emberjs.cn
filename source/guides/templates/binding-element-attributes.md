英文原文：[http://emberjs.com/guides/templates/binding-element-attributes/](http://emberjs.com/guides/templates/binding-element-attributes/)

除了普通文本，你可能也希望在模板中包含可以将其属性绑定到控制器的HTML元素。

例如，想象一下你的控制器中包含这样一个属性，它包含指向一幅图像的URL地址：

```handlebars
<div id="logo">
  <img {{bind-attr src=logoUrl}} alt="Logo">
</div>
```

上面代码将生成如下的HTML代码：

```html
<div id="logo">
  <img src="http://www.example.com/images/logo.png" alt="Logo">
</div>
```

如果你使用`{{bind-attr}}`绑定一个布尔类型的属性,
它将增加或移除指定属性。例如下面的模板：

```handlebars
<input type="checkbox" {{bind-attr disabled=isAdministrator}}>
```

如果`isAdministrator`的值是`true`，`Handlebars`将生成如下所示的HTML元素：

```html
<input type="checkbox" disabled>
```

否则，如果`isAdministrator`是`false`，生成的HTML元素如下：

```html
<input type="checkbox">
```
