英文原文：[http://emberjs.com/guides/getting-started/deleting-todos/](http://emberjs.com/guides/getting-started/deleting-todos/)

## Deleting A Model

## 删除模型

TodoMVC displays a button for removing todos next to each todo when its `<li>` is hovered. Clicking this button will remove the todo and update the display of remaining incomplete todos and remaining completed todos appropriately.

当光标悬浮在待办事项的`<li>`标签之上时，TodoMVC会在其上显示一个删除待办事项的按钮。点击该按钮，将删除对应的待办事项，并更新显示的完成和未完成待办事项的相关信息。

In `index.html` update the static `<button>` element to include an `{{action}}` Handlebars helper:

在`index.html`中，在静态的`<button>`元素上增加一个`{{action}}`Handlebar助手：

```handlebars
<!--- ... additional lines truncated for brevity ... -->
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
<button {{action "removeTodo"}} class="destroy"></button>
<!--- ... additional lines truncated for brevity ... -->
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
```

In `js/controllers/todo_controller.js` implement the `removeTodo` method referenced in the template's `{{action}}` Handlebars helper:

在`js/controllers/todo_controller.js`中，实现在模板中的`{{action}}`Handlebars助手引用的`removeTodo`方法：

```javascript
// ... additional lines truncated for brevity ...
// ... 为保持代码简洁，在此省略了其他代码 ...
actions: {
	removeTodo: function () {
	  var todo = this.get('model');
	  todo.deleteRecord();
	  todo.save();
	},
}
// ... additional lines truncated for brevity ...
// ... 为保持代码简洁，在此省略了其他代码 ...
```

This method will delete the todo locally and then persist this data change.

本方法将从本地删除待办事项，并将数据的改变持久化。

Because the todo is no longer part of the collection of all todos, its `<li>` element in the page will be automatically removed for us. If the deleted todo was incomplete, the count of remaining todos will be decreased by one and the display of this number will be automatically re-rendered. If the new count results in an inflection change between "item" and "items" this area of the page will be automatically re-rendered.

因为删除的待办事项不再是所有待办事项集合的一部分，因此其对应的`<li>`元素将自动的从页面上移除。如果被删除的待办事项是未完成的，那么对应的未完成待办事项的数量将减一，显示该数字的部分也将自动重新渲染。如果数量的变化导致`item`和`items`间的变形，那么对应的页面部分也将自动重新渲染。

Reload your web browser to ensure that there are no errors and the behaviors described above occurs. 

重新载入Web浏览器以确保没有任何错误发生，并且之前描述的行为均工作正常。

### Live Preview

### 在线演示

<a class="jsbin-embed" href="http://jsbin.com/eREkanA/1/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>

### Additional Resources

### 附加资源

  * [Changes in this step in `diff` format](https://github.com/emberjs/quickstart-code-sample/commit/14e1f129f76bae8f8ea6a73de1e24d810678a8fe)
  * [action API documention](http://emberjs.com/api/classes/Ember.Handlebars.helpers.html#method_action)

  * [用`diff`格式呈现本次修改](https://github.com/emberjs/quickstart-code-sample/commit/14e1f129f76bae8f8ea6a73de1e24d810678a8fe)
  * [action API文档](http://emberjs.com/api/classes/Ember.Handlebars.helpers.html#method_action)
