英文原文：[http://emberjs.com/guides/templates/binding-element-attributes/](http://emberjs.com/guides/templates/binding-element-attributes/)


## 绑定元素属性（Binding Element Attributes）

In addition to normal text, you may also want to have your templates
contain HTML elements whose attributes are bound to the controller.

除了普通文本，你可能也希望在模板中包含可以将其属性绑定到控制器的HTML元素。

For example, imagine your controller has a property that contains a URL
to an image:

例如，想象一下你的控制器中包含这样一个属性，它包含指向一幅图像的URL地址：

```handlebars
<div id="logo">
  <img {{bind-attr src=logoUrl}} alt="Logo">
</div>
```

This generates the following HTML:

上面代码将生成如下的HTML代码：

```html
<div id="logo">
  <img src="http://www.example.com/images/logo.png" alt="Logo">
</div>
```

If you use `{{bind-attr}}` with a Boolean value, it will add or remove
the specified attribute. For example, given this template:

如果你使用`{{bind-attr}}`绑定一个布尔类型的属性,
它将增加或移除指定属性。例如下面的模板：

```handlebars
<input type="checkbox" {{bind-attr disabled=isAdministrator}}>
```

If `isAdministrator` is `true`, Handlebars will produce the following
HTML element:

如果`isAdministrator`的值是`true`，`Handlebars`将生成如下所示的HTML元素：

```html
<input type="checkbox" disabled>
```

If `isAdministrator` is `false`, Handlebars will produce the following:

否则，如果`isAdministrator`是`false`，生成的HTML元素如下：

```html
<input type="checkbox">
```

### Adding data attributes

### 添加数据属性

By default, view helpers do not accept *data attributes*. For example

缺省情况下，视图助手不接受*数据属性*。例如：

```handlebars
{{#link-to "photos" data-toggle="dropdown"}}Photos{{/link-to}}

{{input type="text" data-toggle="tooltip" data-placement="bottom" title="Name"}}
```

renders the following HTML:

渲染出如下所示HTML：

```html
<a id="ember239" class="ember-view" href="#/photos">Photos</a>

<input id="ember257" class="ember-view ember-text-field" type="text">
```

There are two ways to enable support for data attributes. One way would be to add an 
attribute binding on the view, e.g. `Ember.LinkView` or `Ember.TextField` for the specific attribute:

启用数据属性支持有两种方法。第一种是在视图中添加一个属性绑定，例如`Ember.LinkView`或者`Ember.TextField`的特殊属性：

```javascript
Ember.LinkView.reopen({
  attributeBindings: ['data-toggle']
});

Ember.TextField.reopen({
  attributeBindings: ['data-toggle', 'data-placement']
});
```

Now the same handlebars code above renders the following HTML:

那么之前的`handlebars`代码渲染出如下所示的HTML：

```html
<a id="ember240" class="ember-view" href="#/photos" data-toggle="dropdown">Photos</a>

<input id="ember259" class="ember-view ember-text-field" 
       type="text" data-toggle="tooltip" data-placement="bottom">
```

You can also automatically bind data attributes on the base view with the
following:

此外也可以在视图基类上自动绑定数据属性，如下所示：

```javascript
Ember.View.reopen({
  init: function() {
    this._super();
    var self = this;

    // bind attributes beginning with 'data-'
    Em.keys(this).forEach(function(key) {
      if (key.substr(0, 5) === 'data-') {
        self.get('attributeBindings').pushObject(key);
      }
    });
  }
});
```

Now you can add as many data-attributes as you want without having to specify them by name.

现在可以添加任意的`data-attributes`，且不需要在视图中指定属性名称。
