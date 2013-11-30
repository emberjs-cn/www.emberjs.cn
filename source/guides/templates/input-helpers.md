英文原文：[http://emberjs.com/guides/templates/input-helpers/](http://emberjs.com/guides/templates/input-helpers/)

## 输入助手

Ember.js中的`{{input}}`和`{{textarea}}`助手是创建通用表单控件最简单的方法。`{{input}}`包裹了Ember.js内置的[Ember.TextField][1]和[Ember.Checkbox][2]视图，而`{{textarea}}`则包裹了[Ember.TextArea][3]视图。使用这些助手使得创建这些输入视图跟使用传统的`<input>`或`<textarea>`元素完全一样。

[1]: /api/classes/Ember.TextField.html
[2]: /api/classes/Ember.Checkbox.html
[3]: /api/classes/Ember.TextArea.html

### 文本输入框

```handlebars
{{input value="http://www.facebook.com"}}
```

将会变为：

```html
<input type="text" value="http://www.facebook.com"/>
```

可以将下列标准的`<input>`属性传给`input`助手：

* `value`
* `size`
* `name`
* `pattern`
* `placeholder`
* `disabled`
* `maxlength`
* `tabindex`

如果这些属性被设置为一个引号引起来的字符串，那么它们的值将被直接设置到元素上，如同上面的示例中一样。但是，如果没有使用引号，那么属性的值就会与模板当前渲染的上下文的一个属性进行绑定。例如：

```handlebars
{{input type="text" value=firstName disabled=entryNotAllowed size="50"}}
```

将绑定`disabled`属性到当前上下文的`entryNotAllowed`。

### 复选框

通过设定`{{input}}`助手的`type`，可以创建复选框：

```handlebars
{{input type="checkbox" name="isAdmin" checked=isAdmin}}
```

复选框支持以下属性：

* `checked`
* `disabled`
* `tabindex`
* `indeterminate`
* `name`

这些属性也可以与之前所说的一样进行设置，或者绑定。

### 多行文本输入框

```handlebars
{{textarea value=name cols="80" rows="6"}}
```

将绑定文本域的值到当前上下文的`name`属性。

`{{textarea}}`支持绑定或者设置如下属性：

* `rows`
* `cols`
* `placeholder`
* `disabled`
* `maxlength`
* `tabindex`

### 扩展内置控件

查看指南中[内置视图][4]一节来学习如何扩展视图。

[4]: /guides/views/built-in-views
