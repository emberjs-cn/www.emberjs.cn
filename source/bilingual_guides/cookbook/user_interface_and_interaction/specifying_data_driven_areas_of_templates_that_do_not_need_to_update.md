### Problem

### 问题

You have a section of a template that is based on a data but you don't need the template to update

模板中有一部分基于一份数据，但是又不需要这部分模板在数据发生变化的时候自动更新。

### Solution

### 解决方案

Use the `{{unbound}}` Handlebars helper.

使用`{{unbound}}`Handlebars助手

```handlebars
{{unbound firstName}}
{{lastName}}
```

### Discussion

### 讨论

By default all uses of Handlebars helpers in Ember.js will use data bound values that will automatically update
the section of the template where a property changes after initial rendering.  Ember.Handlebars does this by
applying the `{{bind}}` helper automatically for you.

默认情况下，所有使用Ember.js中的Handlebars助手都会使用数据绑定，在完成初次渲染之后，这部分模板都会在绑定的数据发生变化时，得到自动更新。`Ember.Handlebars`默认应用了`{{bind}}`助手。

For example, the two following uses of Handlebars are identical in an Ember.js application:

例如，在一个Ember.js应用中的两种使用Handlebars助手的方法时等价的。

```handlebars
{{lastName}}
{{bind lastName}}
```

If you know that a property accessed in Handlebars will not change for the duration of the application's
life, you can specifiy that the property is not bound by applying the `{{unbound}}` helper. A property
that is not bound will avoid adding unncessary observers on a property.

如果在已知一个在Handlebars中访问的属性，在整个应用的生命周期中都不会发生改变，那么可以使用`{{unbound}}`助手来设定属性不需要绑定。不被绑定的属性避免了添加不必要的观察期。

#### Example

#### 例子

<a class="jsbin-embed" href="http://emberjs.jsbin.com/ayUkOWo/3/edit?output">JS Bin</a>
