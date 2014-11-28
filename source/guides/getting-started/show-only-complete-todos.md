英文原文：[http://emberjs.com/guides/getting-started/show-only-complete-todos/](http://emberjs.com/guides/getting-started/show-only-complete-todos/)

接下来我们将对应用进行进一步的修改，使得用户可以导航只一个只显示已完成的待办事项列表的URL。

在`index.html`中，将‘已完成’待办事项的`<a>`标签改为Handlebars的`{{link-to}}`助手：

```handlebars
{{! ... 为保持代码简洁，在此省略了其他代码 ... }}
<li>
  <a href="all">All</a>
</li>
<li>
  {{#link-to "todos.active" activeClass="selected"}}Active{{/link-to}}
</li>
<li>
  {{#link-to "todos.completed" activeClass="selected"}}Completed{{/link-to}}
</li>
{{! ... 为保持代码简洁，在此省略了其他代码 ... }}
```

在`js/router.js`中修改路由，使其可以识别新的路径，并实现对应的路由：

```javascript
Todos.Router.map(function() {
  this.resource('todos', { path: '/' }, function() {
    // additional child routes
    this.route('active');
    this.route('completed');
  });
});

// ... additional lines truncated for brevity ...

Todos.TodosCompletedRoute = Ember.Route.extend({
  model: function() {
    return this.store.filter('todo', function(todo) {
      return todo.get('isCompleted');
    });
  },
  renderTemplate: function(controller) {
    this.render('todos/index', {controller: controller});
  }
});
```

本路由的模型数据是待办事项集合中`isCompleted`属性为`true`的子集。当一个待办事项的`isCompleted`属性发生改变，这个子集就会自动更新来添加或者删除对应的待办事项。

本路由的模型数据是待办事项集合中`isCompleted`属性为`true`的子集。就像我们最近看到的激活待办事项的类似功能，改变待办事项的 `isCompleted` 属性会自动触发该子集的刷新，因此更新UI。

`TodosCompletedRoute` 也有类似的目的来激活待办事项 - 复用现存的 `todos/index` 模板，而不必创建一个新的模板。

重载浏览器确保没有发生任何错误，并且上面定义的行为出现。

### 在线演示

<a class="jsbin-embed" href="http://jsbin.com/heviqo/1/embed?output">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>

### 附加资源

  * [用`diff`格式显示改动](https://github.com/emberjs/quickstart-code-sample/commit/bba939a11197552e3a927bcb3a3adb9430e4f331)
  * [link-to API文档](/api/classes/Ember.Handlebars.helpers.html#method_link-to)
  * [Route#renderTemplate API文档](/api/classes/Ember.Route.html#method_renderTemplate)
  * [Route#render API文档](/api/classes/Ember.Route.html#method_render)
  * [Ember路由指南](/guides/routing)
