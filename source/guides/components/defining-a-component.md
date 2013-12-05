英文原文：[http://emberjs.com/guides/components/defining-a-component/](http://emberjs.com/guides/components/defining-a-component/)

为了定义一个组件，需要先创建一个名字以`components/`开始的模板。例如：如果需要定义一个新组建`{{blog-post}}`，需要创建`components/blog-post`模板。

<aside>
  **注意：** 组件名必须包含'-'。因此`blog-post`是一个合法的命名，而`post`则不是。这样避免了与当前或者今后的HTML元素的冲突，并确保Ember能自动加载组件。
</aside>

如果在HTML文件中使用`<script>`标签来定义Handlebars模板，模板定义方法如下：

```handlebars
<script type="text/x-handlebars" id="components/blog-post">
  <h1>Blog Post</h1>
  <p>Lorem ipsum dolor sit amet.</p>
</script>
```

如果使用了编译工具，那么应该创建一个名为`templates/components/blog-post.handlebars`的Handlebars文件。

如果存在一个模板以`components/`开始的模板，那么就创建了一个与模板同名的组件。如果给定了上述的模板，那么就可以使用`{{blog-post}}`这个自定义元素了。

```handlebars
<h1>My Blog</h1>
{{#each}}
  {{blog-post}}
{{/each}}
```

<a class="jsbin-embed" href="http://jsbin.com/ifuxey/1/embed?live,html">JS Bin</a><script src="http://static.jsbin.com/js/embed.js"></script>

每个组件都由一个元素组成。默认情况下，Ember使用`<div>`元素来包裹组件模板。阅读[Customizing a Component's Element](/guides/components/customizing-a-components-element)可以学习如何修改Ember默认使用的元素。

### 定义组件子类

通常情况下，组件只封装一些会被不停的重复使用的Handlebars模板片段。在这些情况下，不需要编写任何Javascript代码，只需要像之前所述，定义好Handlebars模板，就能使用组件了。

如果需要自定义组件的行为，那么需要定义一个`Ember.Component`的子类。例如，如果需要改变包裹组件的元素的时候，需要响应组件模板操作的时候，或需要通过Javascript手动修改组件元素的时候，就需要一个自定义的子类。

Ember通过子类的命名来确定其对应的组件。例如，如果有一个名为`blog-post`的组件，那么就应该创建一个名为`App.BlogPostComponent`的子类。如果组件命名为`audio-player-controls`，那么子类的命名应该为`App.AudioPlayerControlsComponents`。

换句话说，Ember采用组件名的驼峰形式再加上`Component`作为后缀的类名，来查找与其对应的类。

<table>
  <thead>
  <tr>
    <th>组件名</th>
    <th>组件类</th>
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
