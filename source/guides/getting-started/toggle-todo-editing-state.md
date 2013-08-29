英文原文：[http://emberjs.com/guides/getting-started/toggle-todo-editing-state/](http://emberjs.com/guides/getting-started/toggle-todo-editing-state/)

## 切换显示和编辑状态

TodoMVC支持用户通过双击每个待办事项来显示一个`<input>`文本编辑框，这样用户可以通过它修改待办事项的标题。每个待办事项的`<li>`元素通过`editing`这个CSS类来获得样式及位置信息。

接下来我们将更新我们的应用，使其支持用户切换到待办事项的编辑状态。我们在`index.html`中更新Handlebars的`{{each}}`助手的内容为：

```handlebars
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
{{#each controller itemController="todo"}}
  <li {{bind-attr class="isCompleted:completed isEditing:editing"}}>
    {{#if isEditing}}
      <input class='edit'>
    {{else}}
      {{view Ember.Checkbox checkedBinding="isCompleted" class="toggle"}}
      <label {{action "editTodo" on="doubleClick"}}>{{title}}</label><button class="destroy"></button>
    {{/if}}
  </li>
{{/each}}
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
```

上述代码为我们的应用增加了三个新的行为：

* 当控制器的`isEditing`属性为真时，添加CSS类`editing`，为假时，则删除。
* 在`<label>`上添加了一个`{{action}}`助手，当双击的时候将调用当前待办事项控制器的`editTodo`方法。
* 最后，使用`{{if}}`助手来包裹我们的待办事项，这样当编辑的时候能显示一个文本编辑框`<input>`，当不在编辑状态时显示待办事项的标题。

下面我们在`js/controllers/todo_controller.js`中为模板行为实现对应的逻辑：

```javascript
// ... 为保持代码简洁，在此省略了其他代码 ...
isEditing: false,

editTodo: function () {
  this.set('isEditing', true);
},
// ... 为保持代码简洁，在此省略了其他代码 ...
```

上述代码我们将此类型的控制器的`isEditing`缺省值设置为`false`，当`editTodo`操作被调用时，将对应控制器的`isEditing`属性设置为`true`。这个过程将自动触发使用了`isEditing`的模板的部分，来更新其渲染的内容。

重新载入Web浏览器以确保没有任何错误发生。那么就可以通过双击一个待办事项来编辑它。

### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/ururuc/2/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script> 
  
### 附加资源

  * [用`diff`格式呈现本次修改](https://github.com/emberjs/quickstart-code-sample/commit/7eb87f8f987714385e8381197ec7c77215df8cf9)
  * [Handlebars条件表达式指南](/guides/templates/conditionals)
  * [bind-attr API文档](http://emberjs.com/api/classes/Ember.Handlebars.helpers.html#method_bind-attr)
  * [action API文档](http://emberjs.com/api/classes/Ember.Handlebars.helpers.html#method_action)
  * [Peter Wagenet编写的bind和bind-attr文章](http://www.emberist.com/2012/04/06/bind-and-bindattr.html)
