英文原文：[http://emberjs.com/guides/getting-started/adding-child-routes/](http://emberjs.com/guides/getting-started/adding-child-routes/)

## Adding Child Routes

## 添加子路由

Next we will split our single template into a set of nested templates so we can transition between different lists of todos in reaction to user interaction.

接下来我们将模板切分为一系列嵌套的模板，这样我们可以在不同的待办事项列表间转换来响应用户的交互。

In `index.html` move the entire `<ul>` of todos into a new template named `todos/index` by adding a new Handlebars template `<script>` tag inside the `<body>` of the document:

在`index.html`中，添加一个新的Handlebars模板标签`<script>`到文档的`<body>`中，并命名为`todos/index`，然后将整个`<ul>`移入到其中：

```html
<script type="text/x-handlebars" data-template-name="todos/index">
  <ul id="todo-list">
    {{#each itemController="todo"}}
      <li {{bind-attr class="isCompleted:completed isEditing:editing"}}>
        {{#if isEditing}}
          {{edit-todo class="edit" value=title focus-out="acceptChanges" insert-newline="acceptChanges"}}
        {{else}}
          {{input type="checkbox" checked=isCompleted class="toggle"}}
          <label {{action "editTodo" on="doubleClick"}}>{{title}}</label><button {{action "removeTodo"}} class="destroy"></button>
        {{/if}}
      </li>
    {{/each}}
  </ul>
</script>
```

Still within `index.html` place a Handlebars `{{outlet}}` helper where the `<ul>` was previously:

在`<ul>`原来所处位置添加一个Handlebars的`{{outlet}}`助手：

```handlebars
<!--- ... additional lines truncated for brevity ... -->
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
<section id="main">
  {{outlet}}

  <input type="checkbox" id="toggle-all">
</section>
<!--- ... additional lines truncated for brevity ... -->
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
```

The `{{outlet}}` Handlebars helper designates an area of a template that will dynamically update as we transition between routes. Our first new child route will fill this area with the list of all todos in the application.

`{{outlet}}`Handlebars助手指定了模板中的一部分，将根据我们在不同的路由间切换而动态更新。我们第一个子路由将在此列出所有的待办事项。

In `js/router.js` update the router to change the `todos` mapping, with an additional empty function parameter so it can accept child routes, and add this first `index` route:

在`js/router.js`中，使用一个额外的空函数作为参数，来更新路由中`todos`的映射，使其可以接受子路由，并为其添加`index`路由：

```javascript
Todos.Router.map(function () {
  this.resource('todos', { path: '/' }, function () {
    // additional child routes
    // 其他子路由
  });
});

// ... additional lines truncated for brevity ...
// ... 为保持代码简洁，在此省略了其他代码 ...

Todos.TodosIndexRoute = Ember.Route.extend({
  model: function () {
    return this.modelFor('todos');
  }
});
```

When the application loads at the url `'/'` Ember.js will enter the `todos` route and render the `todos` template as before. It will also transition into the `todos.index` route and fill the `{{outlet}}` in the `todos` template with the `todos/index` template.  The model data for this template is the result of the `model` method of `TodosIndexRoute`, which indicates that the model for this route is the same model as for the `TodosRoute`.

当应用从`'/'`加载时，Ember.js将进入`todos`路由并跟之前一样渲染`todos`模板。这也将转换到`todos.index`路由，并使用`todos/index`模板来填充`todos`模板中的`{{outlet}}`。模板使用的模型数据是`TodosIndexRoute`的`model`方法的返回的值。这表示该路由的模型与`TodoRoute`的模型相同。

This mapping is described in more detail in the [Naming Conventions Guide](/guides/concepts/naming-conventions).

映射关系在[命名惯例指南](/guides/concepts/naming-conventions)有详细的描述。

### Live Preview

### 在线演示

<a class="jsbin-embed" href="http://jsbin.com/oweNovo/1/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>

### Additional Resources

### 附件资源

  * [Changes in this step in `diff` format](https://github.com/emberjs/quickstart-code-sample/commit/3bab8f1519ffc1ca2d5a12d1de35e4c764c91f05)
  * [Ember Router Guide](/guides/routing)
  * [Ember Controller Guide](/guides/controllers)
  * [outlet API documentation](http://emberjs.com/api/classes/Ember.Handlebars.helpers.html#method_outlet)

  * [用`diff`格式呈现本次修改](https://github.com/emberjs/quickstart-code-sample/commit/3bab8f1519ffc1ca2d5a12d1de35e4c764c91f05)
  * [Ember路由指南](/guides/routing)
  * [Ember控制器指南](/guides/controllers)
  * [outlet API文档](http://emberjs.com/api/classes/Ember.Handlebars.helpers.html#method_outlet)
