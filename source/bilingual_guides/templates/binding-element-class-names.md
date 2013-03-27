英文原文:[http://emberjs.com/guides/templates/binding-element-class-names/](http://emberjs.com/guides/templates/binding-element-class-names/)


## 绑定元素类名称 （Binding Element Class Names)

An HTML element's `class` attribute can be bound like any other
attribute:

像其他所有属性一样，HTML元素的`class`属性也可以被绑定，如下所示：

```handlebars
<div {{bindAttr class="priority"}}>
  Warning!
</div>
```

If the controller's `priority` property is `"p4"`, this template will emit the following HTML:

如果控制器的`priority`属性的值是`"p4"`,上面的模板将生成如下的HTML：

```html
<div class="p4">
  Warning!
</div>
```

### 绑定布尔值 （Binding to Boolean Values)

If the value to which you bind is a Boolean, Ember.js will apply the
dasherized version of the property name as a class:

如果你要绑定的值是布尔类型,`Ember.js`会将属性名称用中划线连接来作为类的名称：

```handlebars
<div {{bindAttr class="isUrgent"}}>
  Warning!
</div>
```

If `isUrgent` is true, this emits the following HTML:

如果`isUrgent`的值为真，上面的模板就会生成下面的HTML:

```html
<div class="is-urgent">
  Warning!
</div>
```

If `isUrgent` is false, no class name is added:

否则，如果`isUrgent`是假,就不会添加类：

```html
<div>
  Warning!
</div>
```

If you want to explicitly provide a class name (instead of Ember.js
dasherizing the property name), use the following syntax:

如果你想要显示的提供一个类的名称(而不使用`Ember.js`自动生成的中划线形式)，那么，你可以使用下面的语法：

```handlebars
<div {{bindAttr class="isUrgent:urgent"}}>
  Warning!
</div>
```

Instead of the dasherized name, this will produce:

这样就不会产生中划线形式的名称，取而代之的将产生如下的名称：

```html
<div class="urgent">
  Warning!
</div>
```

You can also specify a class name to add when the property is `false`:

你也可以像下面这样显示的指定当一个属性为`false`时要添加的类的名称：

```handlebars
<div {{bindAttr class="isEnabled:enabled:disabled"}}>
  Warning!
</div>
```

In this case, if the `isEnabled` property is `true`, the `enabled`
class will be added. If the property is `false`, the class `disabled`
will be added.

在上面例子中,如果`isEnabled`属性的值是`true`,就会添加`enabled`类。否则，如果属性值为`false`,就会添加`disabled`类。

This syntax can also be used to add a class if a property is `false`
and remove it if the property is `true`, so this:

这种语法也可以用来在属性值为`false`时添加一个类,而在属性值为`true`时移除它，所以下面的例子：

```handlebars
<div {{bindAttr class="isEnabled::disabled"}}>
  Warning!
</div>
```

Will add the class `disabled` when `isEnabled` is `false` and add no
class if `isEnabled` is `true`.

将会在`isEnabled`是`false`时添加`disabled`类，而在`isEnabled`为`true`时不添加类。

### 静态类 (Static Classes)

If you need an element to have a combination of static and bound
classes, you should include the static class in the list of bound
properties, prefixed by a colon:

如果你想要一个混合了静态类和绑定类的元素,你需要将静态类包含在绑定属性列表中,以`:`为前缀：

```handlebars
<div {{bindAttr class=":high-priority isUrgent"}}>
  Warning!
</div>
```

This will add the literal `high-priority` class to the element:

这会直接把`high-priority`类加到元素中去：

```html
<div class="high-priority is-urgent">
  Warning!
</div>
```

Bound class names and static class names cannot be combined. The
following example **will not work**:

绑定类名称和静态类名称不能混合在一起。下面的例子**就不会起什么作用**：

```handlebars
<div class="high-priority" {{bindAttr class="isUrgent"}}>
  Warning!
</div>
```

### 绑定多个类 （Binding Multiple Classes)

Unlike other element attributes, you can bind multiple classes:

与其他元素属性不同的是，你可以绑定多个类：

```handlebars
<div {{bindAttr class="isUrgent priority"}}>
  Warning!
</div>
```

This works how you would expect, applying the rules described above in
order:

`Ember.js`将依次对每个类执行上述准则，从而达到你所想要的效果：

```html
<div class="is-urgent p4">
  Warning!
</div>
```

