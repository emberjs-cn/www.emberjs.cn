英文原文：[http://emberjs.com/guides/components/passing-properties-to-a-component/](http://emberjs.com/guides/components/passing-properties-to-a-component/)

默认情况下，组件不能访问模板作用域下的属性。

例如，假设有一个用于显示一篇博客的`blog-post`组件：

```handlebars
<script type="text/x-handlebars" id="components/blog-post">
  <h1>Component: {{title}}</h1>
  <p>Lorem ipsum dolor sit amet.</p>
</script>
```

其中有一个Handlebars表达式`{{title}}`，用于将`title`属性的值输出到`<h1>`里。

现在假设有如下的模板和路由：

```js
App.IndexRoute = Ember.Route.extend({
  model: function() {
    return {
      title: "Rails is omakase"
    };
  }
});
```

```handlebars
{{! index.handlebars }}
<h1>Template: {{title}}</h1>
{{blog-post}}
```

运行这段代码，第一个`<h1>`（在外部模板中）显示了`title`属性，当时第二个`<h1>`（在组件中）的则是空的。

<a class="jsbin-embed" href="http://jsbin.com/ufedet/2/embed?live">JS Bin</a>

让`title`属性在组件中可用，可以修复这个问题。

```handlebars
{{blog-post title=title}}
```

这使得外部模板作用域下的`title`属性在组件模板有效，且有相同的名称`title`。

<a class="jsbin-embed" href="http://jsbin.com/ufedet/3/embed?live">JS Bin</a>
<script src="http://static.jsbin.com/js/embed.js"></script>

还是上面的例子，如果模型的`title`属性的名称为`name`，那么组件的使用需要修改为：

```
{{blog-post title=name}}
```

<a class="jsbin-embed" href="http://jsbin.com/ufedet/4/embed?live">JS Bin</a>
<script src="http://static.jsbin.com/js/embed.js"></script>

其实际上，就是采用类似`componentProperty=outerProperty`的语法，将外部作用域的一个属性通过命名属性绑定到了组件的作用域。

需要注意的是这些属性是绑定的，无论是在模型或组件中修改了其值，这些值都会被自动同步。在下面的例子中，在文本输入框中输入一些文本，无论是在外部模板还是组件内，或是说明中都被同步了。

<a class="jsbin-embed" href="http://jsbin.com/ufedet/5/embed?live">JS Bin</a>
<script src="http://static.jsbin.com/js/embed.js"></script>

此外，还可以在`{{#each}}`循环中来绑定属性。这将为每个条目创建一个组件并将在循环中绑定到每个模型。

```handlebars
{{#each}}
  {{blog-post title=title}}
{{/each}}
```
<a class="jsbin-embed" href="http://jsbin.com/ifuxey/2/embed?live">JS Bin</a>
<script src="http://static.jsbin.com/js/embed.js"></script>
