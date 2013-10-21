英文原文：[http://emberjs.com/guides/getting-started/show-all-todos-again/](http://emberjs.com/guides/getting-started/show-all-todos-again/)

Next we can update the application to allow navigating back to the list of all todos. 

接下来我们将对应用进行进一步的修改，使得用户可以查看所有待办事项。

In `index.html` convert the `<a>` tag for 'All' todos into a Handlebars `{{link-to}}` helper:

在`index.html`中，将‘全部’待办事项的`<a>`标签改为Handlebars的`{{link-to}}`助手：

```handlebars
<!--- ... additional lines truncated for brevity ... -->
<li>
  {{#link-to "todos.index" activeClass="selected"}}All{{/link-to}}
</li>
<li>
  {{#link-to "todos.active" activeClass="selected"}}Active{{/link-to}}
</li>
<li>
  {{#link-to "todos.completed" activeClass="selected"}}Completed{{/link-to}}
</li>
<!--- ... additional lines truncated for brevity ... -->
```

Reload your web browser to ensure that there are no errors. You should be able to navigate between urls for all, active, and completed todos.

重载浏览器确保没有任何错误。现在应该可以在不同状态（全部、活动和已完成）的待办事项的URL之间进行切换了。

### Live Preview

### 在线演示

<a class="jsbin-embed" href="http://jsbin.com/uYuGA/1/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>

### Additional Resources

### 附加资源

  * [Changes in this step in `diff` format](https://github.com/emberjs/quickstart-code-sample/commit/843ff914873081560e4ba97df0237b8595b6ae51)
  * [link-to API documentation](/api/classes/Ember.Handlebars.helpers.html#method_link-to)

  * [用`diff`格式显示改动](https://github.com/emberjs/quickstart-code-sample/commit/843ff914873081560e4ba97df0237b8595b6ae51)
  * [link-to API文档](/api/classes/Ember.Handlebars.helpers.html#method_link-to)
