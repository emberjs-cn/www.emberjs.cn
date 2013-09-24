英文原文：[http://emberjs.com/guides/getting-started/creating-a-new-model/](http://emberjs.com/guides/getting-started/creating-a-new-model/)

## 创建新的模型实例

接下来，我们将更新我们的静态HTML`<input>`为一个Ember视图，以便能够提供更多复杂一些的行为。我们将`index.html`中的新建待办事项的`<input>`替换为一个`{{input}}`：

```handlebars
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
<h1>todos</h1>
{{input type="text" id="new-todo" placeholder="What needs to be done?" 
              value=newTitle action="createTodo"}}
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
```

上述模板将在这渲染一个具有相同`id`和`placeholder`属性的`<input>`元素。并且将这个模板对应的控制器的`newTitle`属性与`<input>`的`value`属性相连。当一个发生改变时，另外一个将自动保持同步。

另外，我们还将使用模板控制器的`createTodo`方法来处理用户交互（按下`<enter>`键）。

因此目前我们并不需要自定义控制器行为，Ember.js为模板提供了一个缺省的控制器。为了处理新的行为，我们可以实现一个Ember可以根据[命名惯例](/guides/concepts/naming-conventions)找到，并能添加自定义行为的控制器。这个新控制器类将自动的关联到该模板。

添加一个`js/controllers/todos_controller.js`文件。你可以将该文件放置到任意你喜欢的地方（即使将所有代码放置在同一个文件中），不过本指南将假设你按照指定的方式创建和命名该文件。

在`js/controllers/todos_controller.js`中实现了Ember.js根据[命名惯例](/guides/concepts/naming-conventions)可以找到的控制器：

```javascript
Todos.TodosController = Ember.ArrayController.extend({
  actions: {
    createTodo: function () {
      // Get the todo title set by the "New Todo" text field
      var title = this.get('newTitle');
      if (!title.trim()) { return; }

      // Create the new Todo model
      var todo = Todos.Todo.createRecord({
        title: title,
        isCompleted: false
      });

      // Clear the "New Todo" text field
      this.set('newTitle', '');

      // Save the new model
      todo.save();
    }
  }
});
```

上述控制器现在负责使用`newTitle`属性作为一个`isCompleted`属性为假的新待办事项的标题的用户操作。接着将清除这个将用于同步模板和重置文本框的`newTitle`属性。最后将待办事项所有未保存的修改持久化。

在`index.html`中包含`js/controllers/todos_controller.js`依赖：

```html
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
   <script src="js/models/todo.js"></script>
   <script src="js/controllers/todos_controller.js"></script>
 </body>
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
```

重新载入Web浏览器以确保所有被引用的文件正确无误且没有任何错误发生。现在可以通过在`<input>`中输入一个标题，然后点击`<enter>`键来添加其他的待办事项。

### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/ImukUZO/1/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script> 

### 附加资源

  * [用`diff`格式呈现本次修改](https://github.com/emberjs/quickstart-code-sample/commit/60feb5f369c8eecd9df3f561fbd01595353ce803)
  * [Ember.TextField API文档](/guides/templates/handlebars-basics)
  * [控制器指南](/guides/controllers)
  * [命名惯例指南](/guides/concepts/naming-conventions)
