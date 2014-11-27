英文原文：[http://emberjs.com/guides/getting-started/show-only-incomplete-todos/](http://emberjs.com/guides/getting-started/show-only-incomplete-todos/)

Next we'll update the application so a user can navigate to a url where only todos that are not complete are displayed.

接下来我们将对应用进行进一步的修改，使得用户可以导航至一个只显示未完成的待办事项列表的URL。

In `index.html` convert the `<a>` tag for 'Active' todos into a Handlebars `{{link-to}}` helper and remove the active class from the `<a>` tag for 'All':

在`index.html`中，将‘活动的’待办事项的`<a>`标签改为Handlebars的`{{link-to}}`助手，然后把所有(All)中的`<a>`标签里的 active class 移除：

```handlebars
{{! ... additional lines truncated for brevity ... }}
{{! ... 为保持代码简洁，在此省略了其他代码 ... }}
<li>
  <a href="all">All</a>
</li>
<li>
  {{#link-to "todos.active" activeClass="selected"}}Active{{/link-to}}
</li>
<li>
  <a href="completed">Completed</a>
</li>
{{! ... additional lines truncated for brevity ... }}
{{! ... 为保持代码简洁，在此省略了其他代码 ... }}
```

In `js/router.js` update the router to recognize this new path and implement a matching route:

在`js/router.js`中修改路由，使其可以识别新的路径，并实现对应的路由：

```javascript
Todos.Router.map(function() {
  this.resource('todos', { path: '/' }, function() {
    // additional child routes
    this.route('active');
  });
});

// ... additional lines truncated for brevity ...
// ... 为保持代码简洁，在此省略了其他代码 ... 
Todos.TodosActiveRoute = Ember.Route.extend({
  model: function(){
    return this.store.filter('todo', function(todo) {
      return !todo.get('isCompleted');
    });
  },
  renderTemplate: function(controller) {
    this.render('todos/index', {controller: controller});
  }
});
```

The model data for this route is the collection of todos whose `isCompleted` property is `false`. When a todo's `isCompleted` property changes this collection will automatically update to add or remove the todo appropriately.

本路由的模型数据是待办事项集合中`isCompleted`属性为`false`的子集。当一个待办事项的`isCompleted`属性发生改变，这个子集就会自动更新来添加或者删除对应的待办事项。

Normally transitioning into a new route changes the template rendered into the parent `{{outlet}}`, but in this case we'd like to reuse the existing `todos/index` template. We can accomplish this by implementing the `renderTemplate` method and calling `render` ourselves with the specific template and controller options.

通常情况下，切换至一个新的路由，都会改变渲染到父`{{outlet}}`中的模板，但是在这里，我们更希望可以重用`todos/index`模板。通过重写`renderTemplete`方法，并指定`render`方法调用时的模板和对应的控制器选项就可以实现。

Reload your web browser to ensure that there are no errors and the behavior described above occurs.

重载浏览器确保没有发生任何错误，并且上面定义的行为出现。

### Live Preview

### 在线演示

<a class="jsbin-embed" href="http://jsbin.com/gaqey/1/embed?output">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>

### Additional Resources

### 附加资源

  * [Changes in this step in `diff` format](https://github.com/emberjs/quickstart-code-sample/commit/2a1d35293a52e40d0125f552a1a8b2c01f759313)
  * [link-to API documentation](/api/classes/Ember.Handlebars.helpers.html#method_link-to)
  * [Route#renderTemplate API documentation](/api/classes/Ember.Route.html#method_renderTemplate)
  * [Route#render API documentation](/api/classes/Ember.Route.html#method_render)
  * [Ember Router Guide](/guides/routing)

  * [用`diff`格式显示改动](https://github.com/emberjs/quickstart-code-sample/commit/2a1d35293a52e40d0125f552a1a8b2c01f759313)
  * [link-to API文档](/api/classes/Ember.Handlebars.helpers.html#method_link-to)
  * [Route#renderTemplate API文档](/api/classes/Ember.Route.html#method_renderTemplate)
  * [Route#render API文档](/api/classes/Ember.Route.html#method_render)
  * [Ember路由指南](/guides/routing)
