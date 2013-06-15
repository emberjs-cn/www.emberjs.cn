英文原文：[http://emberjs.com/guides/understanding-ember/keeping-templates-up-to-date/](http://emberjs.com/guides/understanding-ember/keeping-templates-up-to-date/)

## Keeping Templates Up-to-Date

## 模板自动更新

In order to know which part of your HTML to update when an underlying property changes, Handlebars will insert marker elements with a unique ID. If you look at your application while it's running, you might notice these extra elements:

为了知道当一个属性改变时，HTML中哪一部分需要更新，Handlebars添加了一些具有唯一ID的标签。如果在应用运行期查看过其代码，那么应该见到过如下的元素：

```html
My new car is
<script id="metamorph-0-start" type="text/x-placeholder"></script>
blue
<script id="metamorph-0-end" type="text/x-placeholder"></script>.
```

Because all Handlebars expressions are wrapped in these markers, make sure each HTML tag stays inside the same block. For example, you shouldn't do this:

因为所有的Handlebars表达式均被包裹在这些标签里，请确保所有的HTML标签都是闭合的。例如，不能像下面这样：

```handlebars
{{! Don't do it! }}
<div {{#if isUrgent}}class="urgent"{{/if}}>
```

If you want to avoid your property output getting wrapped in these markers, use the `unbound` helper:

如果不希望输出的属性被这些标签包裹，那么可以使用`unbound`助手：

```handlebars
My new car is {{unbound color}}.
```

Your output will be free of markers, but be careful, because the output won't be automatically updated!

如上输出不会被标签包裹，但是需要注意的是这样的输出不会自动更新！

```html
My new car is blue.
```
