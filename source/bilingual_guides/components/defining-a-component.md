英文原文：[http://emberjs.com/guides/components/defining-a-component/](http://emberjs.com/guides/components/defining-a-component/)

中英对照：[http://emberjs.cn/bilingual_guides/components/defining-a-component/](http://emberjs.cn/bilingual_guides/components/defining-a-component/)

To define a component, create a template whose name starts with
`components/`. To define a new component, `{{blog-post}}` for example,
create a `components/blog-post` template.

为了定义一个组件，需要先创建一个名字以`components/`开始的模板。例如：如果需要定义一个新组建`{{blog-post}}`，需要创建`components/blog-post`模板。

<aside>
  **Note:** Components must have a dash in their name. So `blog-post` is an acceptable name,
  but `post` is not. This prevents clashes with current or future HTML element names, and
  ensures Ember picks up the components automatically.

  **注意：** 组件名必须包含'-'。因此`blog-post`是一个合法的命名，而`post`则不是。这样避免了与当前或者今后的HTML元素的冲突，并确保Ember能自动加载组件。
</aside>

If you are including your Handlebars templates inside an HTML file via
`<script>` tags, it would look like this:

如果在HTML文件中使用`<script>`标签来定义Handlebars模板，模板定义方法如下：

```handlebars
<script type="text/x-handlebars" id="components/blog-post">
  <h1>Blog Post</h1>
  <p>Lorem ipsum dolor sit amet.</p>
</script>
```

If you're using build tools, create a Handlebars file at
`templates/components/blog-post.handlebars`.

如果使用了编译工具，那么应该创建一个名为`templates/components/blog-post.handlebars`的Handlebars文件。

Having a template whose name starts with `components/` creates a
component of the same name. Given the above template, you can now use the
`{{blog-post}}` custom element:

如果存在一个模板以`components/`开始的模板，那么就创建了一个与模板同名的组件。如果给定了上述的模板，那么就可以使用`{{blog-post}}`这个自定义元素了。

```handlebars
<h1>My Blog</h1>
{{#each}}
  {{blog-post}}
{{/each}}
```

<a class="jsbin-embed" href="http://jsbin.com/ifuxey/1/embed?live,html">JS Bin</a><script src="http://static.jsbin.com/js/embed.js"></script>

Each component, under the hood, is backed by an element. By default
Ember will use a `<div>` element to contain your component's template.
To learn how to change the element Ember uses for your component, see
[Customizing a Component's Element](/guides/components/customizing-a-components-element).

每个组件都由一个元素组成。默认情况下，Ember使用`<div>`元素来包裹组件模板。阅读[Customizing a Component's Element](/guides/components/customizing-a-components-element)可以学习如何修改Ember默认使用的元素。

### Defining a Component Subclass

### 定义组件子类

Often times, your components will just encapsulate certain snippets of
Handlebars templates that you find yourself using over and over. In
those cases, you do not need to write any JavaScript at all. Just define
the Handlebars template as described above and use the component that is
created.

通常情况下，组件只封装一些会被不停的重复使用的Handlebars模板片段。在这些情况下，不需要编写任何Javascript代码，只需要像之前所述，定义好Handlebars模板，就能使用组件了。

If you need to customize the behavior of the component you'll
need to define a subclass of `Ember.Component`. For example, you would
need a custom subclass if you wanted to change a component's element,
respond to actions from the component's template, or manually make
changes to the component's element using JavaScript.

如果需要自定义组件的行为，那么需要定义一个`Ember.Component`的子类。例如，如果需要改变包裹组件的元素的时候，需要响应组件模板操作的时候，或需要通过Javascript手动修改组件元素的时候，就需要一个自定义的子类。

Ember knows which subclass powers a component based on its name. For
example, if you have a component called `blog-post`, you would create a
subclass called `App.BlogPostComponent`. If your component was called
`audio-player-controls`, the class name would be
`App.AudioPlayerControlsComponent`.

Ember通过子类的命名来确定其对应的组件。例如，如果有一个名为`blog-post`的组件，那么就应该创建一个名为`App.BlogPostComponent`的子类。如果组件命名为`audio-player-controls`，那么子类的命名应该为`App.AudioPlayerControlsComponents`。

In other words, Ember will look for a class with the camelized name of
the component, followed by `Component`.

换句话说，Ember采用组件名的驼峰形式再加上`Component`作为后缀的类名，来查找与其对应的类。

<table>
  <thead>
  <tr>
    <th>组件名（Component Name）</th>
    <th>组件类（Component Class）</th>
  </tr>
  </thead>
  <tr>
    <td><code>blog-post</code></td>
    <td><code>App.BlogPostComponent</code></td>
  </tr>
  <tr>
    <td><code>audio-player-controls</code></td>
    <td><code>App.AudioPlayerControlsComponent</code></td>
  </tr>
</table>
