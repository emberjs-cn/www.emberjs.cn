英文原文：[http://emberjs.com/guides/getting-started/adding-child-routes/](http://emberjs.com/guides/getting-started/adding-child-routes/)

接下来我们将模板切分为一系列嵌套的模板，这样我们可以在不同的待办事项列表间转换来响应用户的交互。

在`index.html`中，添加一个新的Handlebars模板标签`<script>`到文档的`<body>`中，并命名为`todos/index`，然后将整个`<ul>`移入到其中：

```html
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
<body>
<script type="text/x-handlebars" data-template-name="todos/index">
  <ul id="todo-list">
    {{#each todo in model itemController="todo"}}
      <li {{bind-attr class="todo.isCompleted:completed todo.isEditing:editing"}}>
        {{#if todo.isEditing}}
          {{edit-todo class="edit" value=todo.title focus-out="acceptChanges" insert-newline="acceptChanges"}}
        {{else}}
          {{input type="checkbox" checked=todo.isCompleted class="toggle"}}
          <label {{action "editTodo" on="doubleClick"}}>{{todo.title}}</label><button {{action "removeTodo"}} class="destroy"></button>
        {{/if}}
      </li>
    {{/each}}
  </ul>
</script>
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
```

在`<ul>`原来所处位置添加一个Handlebars的`{{outlet}}`助手：

```handlebars
{{! ... 为保持代码简洁，在此省略了其他代码 ... }}
<section id="main">
  {{outlet}}

  <input type="checkbox" id="toggle-all">
</section>
{{! ... 为保持代码简洁，在此省略了其他代码 ... }}
```

`{{outlet}}`Handlebars助手指定了模板中的一部分，将根据我们在不同的路由间切换而动态更新。我们第一个子路由将在此列出所有的待办事项。

在`js/router.js`中，使用一个额外的空函数作为参数，来更新路由中`todos`的映射，使其可以接受子路由，并为其添加`index`路由：

```javascript
Todos.Router.map(function () {
  this.resource('todos', { path: '/' }, function () {
    // 其他子路由以后在这里添加
  });
});

// ... 为保持代码简洁，在此省略了其他代码 ...

Todos.TodosIndexRoute = Ember.Route.extend({
  model: function() {
    return this.modelFor('todos');
  }
});
```

当应用从`'/'`加载时，Ember.js将进入`todos`路由并跟之前一样渲染`todos`模板。这也将转换到`todos.index`路由，并使用`todos/index`模板来填充`todos`模板中的`{{outlet}}`。模板使用的模型数据是`TodosIndexRoute`的`model`方法的返回的值。这表示该路由的模型与`TodoRoute`的模型相同。

映射关系在[命名惯例指南](/guides/concepts/naming-conventions)有详细的描述。

### 在线演示

<a class="jsbin-embed" href="http://jsbin.com/teheni/1/embed?output">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>

### 附件资源

  * [用`diff`格式呈现本次修改](https://github.com/emberjs/quickstart-code-sample/commit/3bab8f1519ffc1ca2d5a12d1de35e4c764c91f05)
  * [Ember路由指南](/guides/routing)
  * [Ember控制器指南](/guides/controllers)
  * [outlet API文档](/api/classes/Ember.Handlebars.helpers.html#method_outlet)
