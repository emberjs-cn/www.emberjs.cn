英文原文：[http://emberjs.com/guides/getting-started/display-a-button-to-remove-completed-todos/](http://emberjs.com/guides/getting-started/display-a-button-to-remove-completed-todos/)

TodoMVC allows users to delete all completed todos at once by clicking a button. This button is visible only when there are any completed todos, displays the number of completed todos, and removes all completed todos from the application when clicked.

TodoMVC允许用户通过点击一个按钮来删除所有已完成的待办事项。这个按钮只在存在已完成的待办事项的时候才显示，并显示已完成的数量。当点击该按钮时，所有已完成的待办事项将被删除。

In this step, we'll implement that behavior. In `index.html` update the static `<button>` for clearing all completed todos:

在此，我们来实现这个功能。在`index.html`中，修改静态的`<button>`以便清除所有已完成的待办事项：

```handlebars
{{! ... additional lines truncated for brevity ... }}
{{! ... 为保持代码简洁，在此省略了其他代码 ... }}
{{#if hasCompleted}}
  <button id="clear-completed" {{action "clearCompleted"}}>
    Clear completed ({{completed}})
  </button>
{{/if}}
{{! ... additional lines truncated for brevity ... }}
{{! ... 为保持代码简洁，在此省略了其他代码 ... }}
```

In `js/controllers/todos_controller.js` implement the matching properties and a method that will clear completed todos and persist these changes when the button is clicked:

在`js/controllers/todos_controller.js`中实现匹配属性和一个在按钮点击时被调用的方法。该方法实现删除已完成待办事项和将这些改变持久化。

```javascript
// ... additional lines truncated for brevity ...
// ... 为保持代码简洁，在此省略了其他代码 ...
actions: {
  clearCompleted: function() {
    var completed = this.filterBy('isCompleted', true);
    completed.invoke('deleteRecord');
    completed.invoke('save');
  },
  // ... additional lines truncated for brevity ...
// ... 为保持代码简洁，在此省略了其他代码 ...
},
hasCompleted: function() {
  return this.get('completed') > 0;
}.property('completed'),

completed: function() {
  return this.filterBy('isCompleted', true).get('length');
}.property('@each.isCompleted'),
// ... additional lines truncated for brevity ...
// ... 为保持代码简洁，在此省略了其他代码 ...
```

The `completed` and `clearCompleted` methods both invoke the `filterBy` method, which is part of the [ArrayController](/api/classes/Ember.ArrayController.html#method_filterProperty) API and returns an instance of [EmberArray](http://emberjs.com/api/classes/Ember.Array.html) which contains only the items for which the callback returns true.  The `clearCompleted` method also invokes the `invoke` method which is part of the [EmberArray](http://emberjs.com/api/classes/Ember.Array.html#method_invoke) API.  `invoke` will execute a method on each object in the Array if the method exists on that object.

`completed` 和 `clearCompleted` 方法都调用 `filterBy` 方法，它是[ArrayController](/api/classes/Ember.ArrayController.html#method_filterProperty) API的一部分，并且返回一个[EmberArray](http://emberjs.com/api/classes/Ember.Array.html)的实例，该实例包含回调返回为真的条目。`clearCompleted` 方法同样调用 `invoke` 方法，该方法是[EmberArray](http://emberjs.com/api/classes/Ember.Array.html#method_invoke) API的一部分。`invoke` 将会在数组中的每个对象上执行一个方法，如果这个对象上存在方法的话。

Reload your web browser to ensure that there are no errors and the behavior described above occurs.

重载浏览器确保没有任何错误，并且上面描述的功能正常。

### Live Preview

### 在线演示

<a class="jsbin-embed" href="http://jsbin.com/yoxije/1/embed?output">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>

### Additional Resources

### 附加资源

  * [Changes in this step in `diff` format](https://github.com/emberjs/quickstart-code-sample/commit/1da450a8d693f083873a086d0d21e031ee3c129e)
  * [Handlebars Conditionals Guide](/guides/templates/conditionals)
  * [Enumerables Guide](/guides/enumerables)

  * [用`diff`格式显示改动](https://github.com/emberjs/quickstart-code-sample/commit/1da450a8d693f083873a086d0d21e031ee3c129e)
  * [Handlebars条件语句指南](/guides/templates/conditionals)
  * [Enumerables指南](/guides/enumerables)
