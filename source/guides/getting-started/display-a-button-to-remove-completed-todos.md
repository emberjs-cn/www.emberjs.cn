英文原文：[http://emberjs.com/guides/getting-started/displaying-a-button-to-remove-completed-todos/](http://emberjs.com/guides/getting-started/displaying-a-button-to-remove-completed-todos/)

TodoMVC允许用户通过点击一个按钮来删除所有已完成的待办事项。这个按钮只在存在已完成的待办事项的时候才显示，并显示已完成的数量。当点击该按钮时，所有已完成的待办事项将被删除。

在此，我们来实现这个功能。在`index.html`中，修改静态的`<button>`以便清除所有已完成的待办事项：

```handlebars
<!--- ... additional lines truncated for brevity ... -->
{{#if hasCompleted}}
  <button id="clear-completed" {{action "clearCompleted"}}>
    Clear completed ({{completed}})
  </button>
{{/if}}
<!--- ... additional lines truncated for brevity ... -->
```

在`js/controllers/todos_controller.js`中实现匹配属性和一个在按钮点击时被调用的方法。该方法实现删除已完成待办事项和将这些改变持久化。

```javascript
// ... additional lines truncated for brevity ...
actions: {
  clearCompleted: function () {
    var completed = this.filterBy('isCompleted', true);
    completed.invoke('deleteRecord');

    this.get('store').commit();
  }
},
hasCompleted: function () {
  return this.get('completed') > 0;
}.property('completed'),

completed: function () {
  return this.filterBy('isCompleted', true).get('length');
}.property('@each.isCompleted')
// ... additional lines truncated for brevity ...
```

重载浏览器确保没有任何错误，并且上面描述的功能正常。

### 在线演示

<a class="jsbin-embed" href="http://jsbin.com/ULovoJI/1/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>

### 附加资源

  * [用`diff`格式显示改动](https://github.com/emberjs/quickstart-code-sample/commit/1da450a8d693f083873a086d0d21e031ee3c129e)
  * [Handlebars条件语句指南](/guides/templates/conditionals)
  * [Enumerables指南](/guides/enumerables)
