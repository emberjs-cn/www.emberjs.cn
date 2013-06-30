英文原文：[http://emberjs.com/guides/getting-started/toggle-todo-editing-state/](http://emberjs.com/guides/getting-started/toggle-todo-editing-state/)

## Toggling between showing and editing states

## 切换显示和编辑状态

TodoMVC allows users to double click each todo to display a text `<input>` element where the todo's title can be updated. Additionally the `<li>` element for each todo obtains the CSS class `editing` for style and positioning.

TodoMVC支持用户通过双击每个待办事项来显示一个`<input>`文本编辑框，这样用户可以通过它修改待办事项的标题。每个待办事项的`<li>`元素通过`editing`这个CSS类来获得样式及位置信息。

We'll update the application to allow users to toggle into this editing state for a todo. In `index.html` update the contents of the `{{each}}` Handlebars helper to:

接下来我们将更新我们的应用，使其支持用户切换到待办事项的编辑状态。我们在`index.html`中更新Handlebars的`{{each}}`助手的内容为：

```handlebars
 <!--- ... additional lines truncated for brevity ... -->
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
{{#each controller itemController="todo"}}
  <li {{bindAttr class="isCompleted:completed isEditing:editing"}}>
    {{#if isEditing}}
      <input class='edit'>
    {{else}}
      {{view Ember.Checkbox checkedBinding="isCompleted" class="toggle"}}
      <label {{action "editTodo" on="doubleClick"}}>{{title}}</label><button class="destroy"></button>
    {{/if}}
  </li>
{{/each}}
 <!--- ... additional lines truncated for brevity ... -->
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
```

The above code applies three new behaviors to our application: it applies the CSS class `editing` when the controller's `isEditing` property is true and removes it when the `isEditing` property is false. We add a new `{{action}}` helper to the `<label>` so double-clicks will call `editTodo` on 
this todo's controller. Finally, we wrap our todo in a Handlebars `{{if}}` helper so a text `<input>` will display when we are editing and the todos title will display when we are not editing.

上述代码为我们的应用增加了三个新的行为：

* 当控制器的`isEditing`属性为真时，添加CSS类`editing`，为假时，则删除。
* 在`<label>`上添加了一个`{{action}}`助手，当双击的时候将调用当前待办事项控制器的`editTodo`方法。
* 最后，使用`{{if}}`助手来包裹我们的待办事项，这样当编辑的时候能显示一个文本编辑框`<input>`，当不在编辑状态时显示待办事项的标题。

Inside `js/controllers/todo_controller.js` we'll implement the matching logic for this template behavior:

下面我们在`js/controllers/todo_controller.js`中为模板行为实现对应的逻辑：

```javascript
// ... additional lines truncated for brevity ...
// ... 为保持代码简洁，在此省略了其他代码 ...
isEditing: false,

editTodo: function () {
  this.set('isEditing', true);
},
// ... additional lines truncated for brevity ...
// ... 为保持代码简洁，在此省略了其他代码 ...
```

Above we defined an initial `isEditing` value of `false` for controllers of this type and said that when the `editTodo` action is called it should set the `isEditing` property of this controller to `true`.  This will automatically trigger the sections of template that use `isEditing` to update their rendered content.

上述代码我们将此类型的控制器的`isEditing`缺省值设置为`false`，当`editTodo`操作被调用时，将对应控制器的`isEditing`属性设置为`true`。这个过程将自动触发使用了`isEditing`的模板的部分，来更新其渲染的内容。

Reload your web browser to ensure that no errors occur. You can now double-click a todo to edit it.

重新载入Web浏览器以确保没有任何错误发生。那么就可以通过双击一个待办事项来编辑它。

### Live Preview

### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/ururuc/2/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script> 
  
### Additional Resources

### 附加资源

  * [Changes in this step in `diff` format](https://github.com/emberjs/quickstart-code-sample/commit/7eb87f8f987714385e8381197ec7c77215df8cf9)
  * [Handlebars Conditionals Guide](/guides/templates/conditionals)
  * [bindAttr API documentation](http://emberjs.com/api/classes/Ember.Handlebars.helpers.html#method_bindAttr)
  * [action API documentation](http://emberjs.com/api/classes/Ember.Handlebars.helpers.html#method_action)
  * [bind and bindAttr article by Peter Wagenet](http://www.emberist.com/2012/04/06/bind-and-bindattr.html)

  * [用`diff`格式呈现本次修改](https://github.com/emberjs/quickstart-code-sample/commit/7eb87f8f987714385e8381197ec7c77215df8cf9)
  * [Handlebars条件表达式指南](/guides/templates/conditionals)
  * [bindAttr API文档](http://emberjs.com/api/classes/Ember.Handlebars.helpers.html#method_bindAttr)
  * [action API文档](http://emberjs.com/api/classes/Ember.Handlebars.helpers.html#method_action)
  * [Peter Wagenet编写的bind和bindAttr文章](http://www.emberist.com/2012/04/06/bind-and-bindattr.html)
