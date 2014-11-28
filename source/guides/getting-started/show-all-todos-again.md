英文原文：[http://emberjs.com/guides/getting-started/show-all-todos-again/](http://emberjs.com/guides/getting-started/show-all-todos-again/)

接下来我们将对应用进行进一步的修改，使得用户可以查看所有待办事项。

在`index.html`中，将‘全部’待办事项的`<a>`标签改为Handlebars的`{{link-to}}`助手：

```handlebars
{{! ... 为保持代码简洁，在此省略了其他代码 ... }}
<li>
  {{#link-to "todos.index" activeClass="selected"}}All{{/link-to}}
</li>
<li>
  {{#link-to "todos.active" activeClass="selected"}}Active{{/link-to}}
</li>
<li>
  {{#link-to "todos.completed" activeClass="selected"}}Completed{{/link-to}}
</li>
{{! ... 为保持代码简洁，在此省略了其他代码 ... }}
```

重载浏览器确保没有任何错误。现在应该可以在不同状态（全部、活动和已完成）的待办事项的URL之间进行切换了。

### 在线演示

<a class="jsbin-embed" href="http://jsbin.com/jowipi/1/embed?output">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>

### 附加资源

  * [用`diff`格式显示改动](https://github.com/emberjs/quickstart-code-sample/commit/843ff914873081560e4ba97df0237b8595b6ae51)
  * [link-to API文档](/api/classes/Ember.Handlebars.helpers.html#method_link-to)
