## 应用模板（The Application Template）

The application template is the default template that is rendered when
your application starts. 

应用模板是当项目启动的时候渲染的默认模板。

You should put your header, footer, and any other decorative content
here. Additionally, you should have at least one `{{outlet}}`:
a placeholder that the router will fill in with the appropriate template
based on the current state of the application.

你应该把你的header、footer和其他装饰性的内容放在应用模板里面。另外，里面应该至少要有一个`{{outlet}}`占位符，到时路由系统会根据应用当前的状态载入适当的模板。

Here's an example template:

下面是一个模板的例子：

```handlebars
<header>
  <h1>Igor's Blog</h1>
</header>

<div>
  {{outlet}}
</div>

<footer>
  &copy;2013 Igor's Publishing, Inc.
</footer>
```

The header and footer will always be displayed on screen, but the
contents of the `<div>` will change depending on if the user is
currently at `/posts` or `/posts/15`, for example.

其中header和footer会一直显示在屏幕上，不过`<div>`里面的内容会根据当前所在页面而改变（`/posts`或`/posts/15`之类）。

If you are keeping your templates in HTML, create a `<script>` tag
without a template name. It will automatically be compiled and appended
to the screen.

如果你想要用HTML来写模板，你可以创建一个不带模板名字的`<script>`标签。它会自动被编译和加载到页面。

```html
<script type="text/x-handlebars">
  <div>
    {{outlet}}
  </div>
</script>
```

If you're using build tools to load your templates, make sure you name
the template `application`.

如果你在使用开发工具来加载你的模板，请确定把模板名字命名为`application`。

For more information, see [Templates](/guides/templates/handlebars-basics) and [Routing](/guides/routing/).

详细的内容可查看[Templates](/guides/templates/handlebars-basics) and [Routing](/guides/routing/)。
