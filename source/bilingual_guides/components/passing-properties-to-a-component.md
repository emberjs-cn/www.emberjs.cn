英文原文：[http://emberjs.com/guides/components/passing-properties-to-a-component/](http://emberjs.com/guides/components/passing-properties-to-a-component/)

中英对照：[http://emberjs.cn/bilingual_guides/components/passing-properties-to-a-component/](http://emberjs.cn/bilingual_guides/components/passing-properties-to-a-component/)

By default a component does not have access to properties in the
template scope in which it is used.

默认情况下，组件不能访问模板作用域下的属性。

For example, imagine you have a `blog-post` component that is used to
display a blog post:

例如，假设有一个用于显示一篇博客的`blog-post`组件：

```handlebars
<script type="text/x-handlebars" id="components/blog-post">
  <h1>Component: {{title}}</h1>
  <p>Lorem ipsum dolor sit amet.</p>
</script>
```

You can see that it has a `{{title}}` Handlebars expression to print the
value of the `title` property inside the `<h1>`.

其中有一个Handlebars表达式`{{title}}`，用于将`title`属性的值输出到`<h1>`里。

Now imagine we have the following template and route:

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

Running this code, you will see that the first `<h1>` (from the outer
template) displays the `title` property, but the second `<h1>` (from
inside the component) is empty.

运行这段代码，第一个`<h1>`（在外部模板中）显示了`title`属性，当时第二个`<h1>`（在组件中）的则是空的。

<a class="jsbin-embed" href="http://jsbin.com/ufedet/2/embed?live">JS Bin</a>

We can fix this by making the `title` property available to the
component:

让`title`属性在组件中可用，可以修复这个问题。

```handlebars
{{blog-post title=title}}
```

This will make the `title` property in the outer template scope
available inside the component's template using the same name, `title`.

这使得外部模板作用域下的`title`属性在组件模板有效，且有相同的名称`title`。

<a class="jsbin-embed" href="http://jsbin.com/ufedet/3/embed?live">JS Bin</a>
<script src="http://static.jsbin.com/js/embed.js"></script>

If, in the above example, the model's `title` property was instead
called `name`, we would change the component usage to:

还是上面的例子，如果模型的`title`属性的名称为`name`，那么组件的使用需要修改为：

```
{{blog-post title=name}}
```

<a class="jsbin-embed" href="http://jsbin.com/ufedet/4/embed?live">JS Bin</a>
<script src="http://static.jsbin.com/js/embed.js"></script>

In other words, you are binding a named property from the outer scope to
a named property in the component scope, with the syntax
`componentProperty=outerProperty`.

其实际上，就是采用类似`componentProperty=outerProperty`的语法，将外部作用域的一个属性通过命名属性绑定到了组件的作用域。

It is important to note that the value of these properties is bound.
Whether you change the value on the model or inside the component, the
values stay in sync. In the following example, type some text in the
text field either in the outer template or inside the component and note
how they stay in sync.

需要注意的是这些属性是绑定的，无论是在模型或组件中修改了其值，这些值都会被自动同步。在下面的例子中，在文本输入框中输入一些文本，无论是在外部模板还是组件内，或是说明中都被同步了。

<a class="jsbin-embed" href="http://jsbin.com/ufedet/5/embed?live">JS Bin</a>
<script src="http://static.jsbin.com/js/embed.js"></script>

You can also bind properties from inside an `{{#each}}` loop. This will
create a component for each item and bind it to each model in the loop.

此外，还可以在`{{#each}}`循环中来绑定属性。这将为每个条目创建一个组件并将在循环中绑定到每个模型。

```handlebars
{{#each}}
  {{blog-post title=title}}
{{/each}}
```
<a class="jsbin-embed" href="http://jsbin.com/ifuxey/2/embed?live">JS Bin</a>
<script src="http://static.jsbin.com/js/embed.js"></script>

