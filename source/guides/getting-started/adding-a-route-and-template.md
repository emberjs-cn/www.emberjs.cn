英文原文：[http://emberjs.com/guides/getting-started/adding-a-route-and-template](http://emberjs.com/guides/getting-started/adding-a-route-and-template)

接下来，我们将会创建一个Ember.js应用、一个路由（'`/`'），并且将我们的静态页面转换为Handlebars模板。

在 `js` 目录下，为应用添加一个 `js/application.js` 文件，为路由添加一个 `js/router.js` 文件。你可以将这两个文件放在任意你喜欢的地方（甚至把它们所有的代码放在同一个文件内），但是本指南假定你将它们分开了，并且按照前面讲的进行命名。

在 `js/application.js` 文件中添加如下代码：

```javascript
window.Todos = Ember.Application.create();
```

这会创建一个 `Ember.Application` 的实例，并将它作为你本地浏览器JavaScript环境的一个名为`Todos`的变量供使用。

在 `js/router.js` 文件中添加如下代码：

```javascript
Todos.Router.map(function () {
  this.resource('todos', { path: '/' });
});
```

这会告诉Ember.js，当应用的URL与 `'/'` 匹配时，渲染（render） `todos` 模板。

接着，更新 `index.html` 里的代码，将 `<body>` 里的内容包在一个Handlebars的 `<script>` 标签中，并引用 `js/application.js` 和 `js/router.js`：

```html
<!-- ... 为确保简洁，略去头尾代码 ... -->
<body>
  <script type="text/x-handlebars" data-template-name="todos">

    <section id="todoapp">
      ... additional lines truncated for brevity ...
    </section>

    <footer id="info">
      <p>Double-click to edit a todo</p>
    </footer>
  
  </script>

<!-- ... Ember.js 和其他 javascript 依赖库 ... -->
  <script src="js/application.js"></script>
  <script src="js/router.js"></script>
</body>
<!-- ... 为确保简洁，略去头尾代码 ... -->
```

重新加载浏览器页面，确保所有的文件被正确引用，且没有错误产生。

### 在线演示
<a class="jsbin-embed" href="http://jsbin.com/OKEMIJi/1/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>

### 附加资源

  * [采用`diff`格式显示这步骤所作的修改](https://github.com/emberjs/quickstart-code-sample/commit/8775d1bf4c05eb82adf178be4429e5b868ac145b)
  * [Handlebars指南](/guides/templates/handlebars-basics)
  * [Ember.Application指南](/guides/application)
  * [Ember.Application API文档](/api/classes/Ember.Application.html)
