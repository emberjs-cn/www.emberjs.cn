英文原文：[http://emberjs.com/guides/understanding-ember/keeping-templates-up-to-date/](http://emberjs.com/guides/understanding-ember/keeping-templates-up-to-date/)

## 模板自动更新

为了知道当一个属性改变时，HTML中哪一部分需要更新，Handlebars添加了一些具有唯一ID的标签。如果在应用运行期查看过其代码，那么应该见到过如下的元素：

```html
My new car is
<script id="metamorph-0-start" type="text/x-placeholder"></script>
blue
<script id="metamorph-0-end" type="text/x-placeholder"></script>.
```

因为所有的Handlebars表达式均被包裹在这些标签里，请确保所有的HTML标签都是闭合的。例如，不能像下面这样：

```handlebars
{{! Don't do it! }}
<div {{#if isUrgent}}class="urgent"{{/if}}>
```

如果不希望输出的属性被这些标签包裹，那么可以使用`unbound`助手：

```handlebars
My new car is {{unbound color}}.
```

如上输出不会被标签包裹，但是需要注意的是这样的输出不会自动更新！

```html
My new car is blue.
```
