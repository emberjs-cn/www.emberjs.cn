英文原文：[http://emberjs.com/guides/components/wrapping-content-in-a-component/](http://emberjs.com/guides/components/wrapping-content-in-a-component/)

中英对照：[http://emberjs.cn/bilingual_guides/components/wrapping-content-in-a-component/](http://emberjs.cn/bilingual_guides/components/wrapping-content-in-a-component/)

Sometimes, you may want to define a component that wraps content
provided by other templates.

有时候，可能需要定义一个组件来包裹其他模板提供的内容。

For example, imagine we are building a `blog-post` component that we can
use in our application to display a blog post:

例如，假设正在创建一个用于显示一篇博客的`blog-post`组件：

```handlebars
<script type="text/x-handlebars" id="components/blog-post">
  <h1>{{title}}</h1>
  <div class="body">{{body}}</div>
</script>
```

Now, we can use the `{{blog-post}}` component and pass it properties
in another template:

现在可以使用`{{blog-post}}`组件并且传递其他模板的属性到该组件：

```handlebars
{{blog-post title=title body=body}}
```

<a class="jsbin-embed" href="http://jsbin.com/obogub/1/embed?live">JS Bin</a><script src="http://static.jsbin.com/js/embed.js"></script>

(See [Passing Properties to a Component](/guides/components/passing-properties-to-a-component/) for more.)

（关于如何传递属性给组件，请参看[Passing Properties to a Component](/guides/components/passing-properties-to-a-component/)）

In this case, the content we wanted to display came from the model. But
what if we want the developer using our component to be able to provide custom
HTML content?

在本例中，用于显示的内容来源于模型。那么如果开发者想使用该组件来提供自定义的HTML内容该怎么做呢？

In addition to the simple form you've learned so far, components also
support being used in **block form**. In block form, components can be
passed a Handlebars template that is rendered inside the component's
template wherever the `{{yield}}` expression appears.

在已经描述的简单形式之外，组件还支持使用**块**的方式。在块方式下，可以传递一个Handlebars模板给组件，该模板将在组件模板中声明`{{yield}}`表达式的地方显示。

To use the block form, add a `#` character to the
beginning of the component name, then make sure to add a closing tag.
(See the Handlebars documentation on [block expressions](http://handlebarsjs.com/#block-expressions) for more.)

为了使用块方式，需要在使用组件的时候，在组名前加上`#`，并确定添加了结束标签。（详细内容参见模板文档中的[块表达式](http://handlebarsjs.com/#block-expressions)）。

In that case, we can use the `{{blog-post}}` component in **block form**
and tell Ember where the block content should be rendered using the
`{{yield}}` helper. To update the example above, we'll first change the component's
template:

在这种情况下，可以使用`{{blog-post}}`组件的**块方式**，并使用`{{yield}}`助手告知Ember块内容将被渲染到什么地方。为了更新上面的例子，首先需要修改组件的模板为：

```handlebars
<script type="text/x-handlebars" id="components/blog-post">
  <h1>{{title}}</h1>
  <div class="body">{{yield}}</div>
</script>
```

You can see that we've replaced `{{body}}` with `{{yield}}`. This tells
Ember that this content will be provided when the component is used.

由此可见，`{{body}}`被替换为`{{yield}}`。这告知Ember这里的内容会在组件使用的时候提供。

Next, we'll update the template using the component to use the block
form:

接下来，更新使用组件的模板采用块方式：

```handlebars
{{#blog-post title=title}}
  <p class="author">by {{author}}</p>
  {{body}}
{{/blog-post}} 
```

<a class="jsbin-embed" href="http://jsbin.com/osulic/1/embed?live">JS Bin</a><script src="http://static.jsbin.com/js/embed.js"></script>

It's important to note that the template scope inside the component
block is the same as outside. If a property is available in the template
outside the component, it is also available inside the component block.

这里需要注意的时，在组件块中的作用域与模板的作用域与外部模板的作用域是相同的。如果一个属性在组件外部的模板有效，那么其在组件块内部也有效。

This JSBin illustrates the concept:

下面的JSBin展示了这个概念：

<a class="jsbin-embed" href="http://jsbin.com/iqocuf/1/embed?live">JS Bin</a><script src="http://static.jsbin.com/js/embed.js"></script>
