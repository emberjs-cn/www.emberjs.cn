英文原文:[http://emberjs.com/guides/templates/binding-element-class-names/](http://emberjs.com/guides/templates/binding-element-class-names/)

像其他所有属性一样，HTML元素的`class`属性也可以被绑定，如下所示：

```handlebars
<div {{bind-attr class="priority"}}>
  Warning!
</div>
```

如果控制器的`priority`属性的值是`"p4"`,上面的模板将生成如下的HTML：

```html
<div class="p4">
  Warning!
</div>
```

### 绑定布尔值

如果你要绑定的值是布尔类型,`Ember.js`会将属性名称用中划线连接来作为类的名称：

```handlebars
<div {{bind-attr class="isUrgent"}}>
  Warning!
</div>
```

如果`isUrgent`的值为真，上面的模板就会生成下面的HTML:

```html
<div class="is-urgent">
  Warning!
</div>
```

否则，如果`isUrgent`是假,就不会添加类：

```html
<div>
  Warning!
</div>
```

如果你想要显示的提供一个类的名称(而不使用`Ember.js`自动生成的中划线形式)，那么，你可以使用下面的语法：

```handlebars
<div {{bind-attr class="isUrgent:urgent"}}>
  Warning!
</div>
```

这样就不会产生中划线形式的名称，取而代之的将产生如下的名称：

```html
<div class="urgent">
  Warning!
</div>
```

你也可以像下面这样显示的指定当一个属性为`false`时要添加的类的名称：

```handlebars
<div {{bind-attr class="isEnabled:enabled:disabled"}}>
  Warning!
</div>
```

在上面例子中,如果`isEnabled`属性的值是`true`,就会添加`enabled`类。否则，如果属性值为`false`,就会添加`disabled`类。

这种语法也可以用来在属性值为`false`时添加一个类,而在属性值为`true`时移除它，所以下面的例子：

```handlebars
<div {{bind-attr class="isEnabled::disabled"}}>
  Warning!
</div>
```

将会在`isEnabled`是`false`时添加`disabled`类，而在`isEnabled`为`true`时不添加类。

### 静态类

如果你想要一个混合了静态类和绑定类的元素,你需要将静态类包含在绑定属性列表中,以`:`为前缀：

```handlebars
<div {{bind-attr class=":high-priority isUrgent"}}>
  Warning!
</div>
```

这会直接把`high-priority`类加到元素中去：

```html
<div class="high-priority is-urgent">
  Warning!
</div>
```

绑定类名称和静态类名称不能混合在一起。下面的例子**就不会起什么作用**：

```handlebars
<div class="high-priority" {{bind-attr class="isUrgent"}}>
  Warning!
</div>
```

### 绑定多个类

与其他元素属性不同的是，你可以绑定多个类：

```handlebars
<div {{bind-attr class="isUrgent priority"}}>
  Warning!
</div>
```

`Ember.js`将依次对每个类执行上述准则，从而达到你所想要的效果：

```html
<div class="is-urgent p4">
  Warning!
</div>
```

