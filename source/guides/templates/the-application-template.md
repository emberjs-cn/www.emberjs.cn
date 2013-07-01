英文原文：[http://emberjs.com/guides/application/the-application-template/](http://emberjs.com/guides/application/the-application-template/)

## 应用模板

应用模板是应用启动的时候默认渲染的模板。

你应该把你的header、footer和其他装饰性的内容放在应用模板里面。另外，应用模版中至少需要一个`{{outlet}}`占位符，以便路由能根据当前的URL将适当的模版渲染进来。

下面是一个应用模板的例子：

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

其中header和footer会一直显示在屏幕上，不过`<div>`里面的内容会根据用户所在位置而改变（`/posts`或`/posts/15`之类）。

如果你希望将应用模板放置在HTML文档中，你可以创建一个不带模板名字的`<script>`标签，它会自动被编译和加载到页面。

```html
<script type="text/x-handlebars">
  <div>
    {{outlet}}
  </div>
</script>
```

如果你使用编译工具来加载你的应用模板，请确定把模板名字命名为`application`。

详细的内容可查看[模板](/guides/templates/handlebars-basics) 和 [路由](/guides/routing/)。
