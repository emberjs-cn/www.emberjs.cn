英文原文：[http://emberjs.com/guides/getting-started/accepting-edits/](http://emberjs.com/guides/getting-started/accepting-edits/)

在上一步中我们修改了TodoMVC使其可以支持用户能够切换到一个文本输入框`<input>`来编辑一个待办事项的标题。接下来，我们将实现在`<input>`显示时立即当前焦点移至其上，开始接收用户的输入，并在用户按下`<enter>`键时或把焦点从编辑的`<input>`元素中移出时，将用户的修改持久化，并显示待办事项修改后的标题。

为了实现这一步，可以创建一个自定义的组件并且通过Handlebars来注册它，使得其在模板中可用。

首先我们需要创建一个新的文件`js/views/edit_todo_view.js`。你可以将该文件放置到任意你喜欢的地方（即使将所有代码放置在同一个文件中），不过本指南将假设你按照指定的方式创建和命名该文件。

在`js/views/edit_todo_view.js`中创建一个`Ember.TextField`的扩展：

```javascript
Todos.EditTodoView = Ember.TextField.extend({
  didInsertElement: function () {
    this.$().focus();
  }
});

Ember.Handlebars.helper('edit-todo', Todos.EditTodoView);
```

在`index.html`中引入这个新文件：

```html
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
  <script src="js/controllers/todo_controller.js"></script>
  <script src="js/views/edit_todo_view.js"></script>
</body>
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
```

在`index.html`中，将静态的`<input>`元素替换为自定义的`{{edit-todo}}`组件，连接`value`和操作：

```handlebars
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
{{#if isEditing}}
  {{edit-todo class="edit" value=title focus-out="acceptChanges"
                           insert-newline="acceptChanges"}}
{{else}}
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
```

点击`<enter>`键会触发`TodoController`实例的`acceptChanges`事件。焦点离开`<input>`时会出发`focus-out`事件，并调用视图的`TodoController`实例的`acceptChanges`方法。

此外，`TodoController`实例的`title`属性与`<input>`的`value`属性进行了绑定。控制器中并没有定义`title`属性，这样控制就保持默认的行为，将[所有请求代理](../controllers/#toc_representing-models)到其`model`之上。

增加一个CSS类`edit`。

在`js/controllers/todo_controller.js`中，添加在`EditTodoView`中调用的`acceptChanges`方法：

```javascript
// ... 为保持代码简洁，在此省略了其他代码 ...
actions: {
  editTodo: function () {
    this.set('isEditing', true);
  },
  acceptChanges: function () {
    this.set('isEditing', false);
    if (Ember.isEmpty(this.get('model.title'))) {
      this.send('removeTodo');
    } else {
      this.get('model').save();
    }       
  }
},
// ... 为保持代码简洁，在此省略了其他代码 ...
```

这个方法将控制器的`isEditing`属性设置为假，并提交所有针对该待办事项的修改。

### 在线演示

<a class="jsbin-embed" href="http://jsbin.com/USOlAna/1/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>

### 附加资源

  * [用`diff`格式呈现本次修改](https://github.com/emberjs/quickstart-code-sample/commit/a7e2f40da4d75342358acdfcbda7a05ccc90f348)
  * [控制器指南](/guides/controllers)
  * [Ember.TextField API文档](http://emberjs.com/api/classes/Ember.TextField.html)
