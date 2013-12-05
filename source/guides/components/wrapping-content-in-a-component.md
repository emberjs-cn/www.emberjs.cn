英文原文：[http://emberjs.com/guides/components/wrapping-content-in-a-component/](http://emberjs.com/guides/components/wrapping-content-in-a-component/)

有时候，可能需要定义一个组件来包裹其他模板提供的内容。

例如，假设正在创建一个用于显示一篇博客的`blog-post`组件：

```handlebars
<script type="text/x-handlebars" id="components/blog-post">
  <h1>{{title}}</h1>
  <div class="body">{{body}}</div>
</script>
```

现在可以使用`{{blog-post}}`组件并且传递其他模板的属性到该组件：

```handlebars
{{blog-post title=title body=body}}
```

<a class="jsbin-embed" href="http://jsbin.com/obogub/1/embed?live">JS Bin</a><script src="http://static.jsbin.com/js/embed.js"></script>

（关于如何传递属性给组件，请参看[Passing Properties to a Component](/guides/components/passing-properties-to-a-component/)）

在本例中，用于显示的内容来源于模型。那么如果开发者想使用该组件来提供自定义的HTML内容该怎么做呢？

在已经描述的简单形式之外，组件还支持使用**块**的方式。在块方式下，可以传递一个Handlebars模板给组件，该模板将在组件模板中声明`{{yield}}`表达式的地方显示。

为了使用块方式，需要在使用组件的时候，在组名前加上`#`，并确定添加了结束标签。（详细内容参见模板文档中的[块表达式](http://handlebarsjs.com/#block-expressions)）。

在这种情况下，可以使用`{{blog-post}}`组件的**块方式**，并使用`{{yield}}`助手告知Ember块内容将被渲染到什么地方。为了更新上面的例子，首先需要修改组件的模板为：

```handlebars
<script type="text/x-handlebars" id="components/blog-post">
  <h1>{{title}}</h1>
  <div class="body">{{yield}}</div>
</script>
```

由此可见，`{{body}}`被替换为`{{yield}}`。这告知Ember这里的内容会在组件使用的时候提供。

接下来，更新使用组件的模板采用块方式：

```handlebars
{{#blog-post title=title}}
  <p class="author">by {{author}}</p>
  {{body}}
{{/blog-post}} 
```

<a class="jsbin-embed" href="http://jsbin.com/osulic/1/embed?live">JS Bin</a><script src="http://static.jsbin.com/js/embed.js"></script>

这里需要注意的时，在组件块中的作用域与模板的作用域与外部模板的作用域是相同的。如果一个属性在组件外部的模板有效，那么其在组件块内部也有效。

下面的JSBin展示了这个概念：

<a class="jsbin-embed" href="http://jsbin.com/iqocuf/1/embed?live">JS Bin</a><script src="http://static.jsbin.com/js/embed.js"></script>
