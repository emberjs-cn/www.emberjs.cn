英文原文：[http://emberjs.com/guides/cookbook/user\_interface\_and\_interaction/specifying\_data\_driven\_areas\_of\_templates\_that\_do\_not\_need\_to\_update](http://emberjs.com/guides/cookbook/user_interface_and_interaction/specifying_data_driven_areas_of_templates_that_do_not_need_to_update)

### 问题

模板中有一部分基于一份数据，但是又不需要这部分模板在数据发生变化的时候自动更新。

### 解决方案

使用`{{unbound}}`Handlebars助手

```handlebars
{{unbound firstName}}
{{lastName}}
```

### 讨论

默认情况下，所有使用Ember.js中的Handlebars助手都会使用数据绑定，在完成初次渲染之后，这部分模板都会在绑定的数据发生变化时，得到自动更新。`Ember.Handlebars`默认应用了`{{bind}}`助手。

例如，在一个Ember.js应用中的两种使用Handlebars助手的方法时等价的。

```handlebars
{{lastName}}
{{bind lastName}}
```

如果在已知一个在Handlebars中访问的属性，在整个应用的生命周期中都不会发生改变，那么可以使用`{{unbound}}`助手来设定属性不需要绑定。不被绑定的属性避免了添加不必要的观察期。

#### 例子

<a class="jsbin-embed" href="http://emberjs.jsbin.com/ayUkOWo/3/edit?output">JS Bin</a>
