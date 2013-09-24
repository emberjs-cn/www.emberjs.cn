英文原文：[http://emberjs.com/guides/getting-started/creating-a-new-model/](http://emberjs.com/guides/getting-started/creating-a-new-model/)

## Creating New Model Instance

## 创建新的模型实例

Next we'll update our static HTML `<input>` to an Ember view that can expose more complex behaviors.  Update `index.html` to replace the new todo `<input>` with an `Ember.TextField`:

接下来，我们将更新我们的静态HTML`<input>`为一个Ember视图，以便能够提供更多复杂一些的行为。我们将`index.html`中的新建待办事项的`<input>`替换为一个`{{input}}`：

```handlebars
<!--- ... additional lines truncated for brevity ... -->
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
<h1>todos</h1>
{{input type="text" id="new-todo" placeholder="What needs to be done?" 
              value=newTitle action="createTodo"}}
<!--- ... additional lines truncated for brevity ... -->
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
```

This will render an `<input>` element at this location with the same `id` and `placeholder` attributes applied. It will also connect the `newTitle` property of this template's controller to the `value` attribute of the `<input>`. When one changes, the other will automatically update to remain synchronized.

上述模板将在这渲染一个具有相同`id`和`placeholder`属性的`<input>`元素。并且将这个模板对应的控制器的`newTitle`属性与`<input>`的`value`属性相连。当一个发生改变时，另外一个将自动保持同步。

Additionally, we connect user interaction (pressing the `<enter>` key) to a method `createTodo` on this template's controller.

另外，我们还将使用模板控制器的`createTodo`方法来处理用户交互（按下`<enter>`键）。

Because we have not needed a custom controller behavior until this point, Ember.js provided a default controller object for this template. To handle our new behavior, we can implement the controller class Ember.js expects to find [according to its naming conventions](/guides/concepts/naming-conventions) and add our custom behavior. This new controller class will automatically be associated with this template for us.

因此目前我们并不需要自定义控制器行为，Ember.js为模板提供了一个缺省的控制器。为了处理新的行为，我们可以实现一个Ember可以根据[命名惯例](/guides/concepts/naming-conventions)找到，并能添加自定义行为的控制器。这个新控制器类将自动的关联到该模板。

Add a `js/controllers/todos_controller.js` file. You may place this file anywhere you like (even just putting all code into the same file), but this guide will assume you have created the file and named it as indicated.

添加一个`js/controllers/todos_controller.js`文件。你可以将该文件放置到任意你喜欢的地方（即使将所有代码放置在同一个文件中），不过本指南将假设你按照指定的方式创建和命名该文件。

Inside `js/controllers/todos_controller.js` implement the controller Ember.js expects to find [according to its naming conventions](/guides/concepts/naming-conventions):

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

This controller will now respond to user action by using its `newTitle` property as the title of a new todo whose `isCompleted` property is false.  Then it will clear its `newTitle` property which will synchronize to the template and reset the textfield. Finally, it persists any unsaved changes on the todo.

上述控制器现在负责使用`newTitle`属性作为一个`isCompleted`属性为假的新待办事项的标题的用户操作。接着将清除这个将用于同步模板和重置文本框的`newTitle`属性。最后将待办事项所有未保存的修改持久化。

In `index.html` include `js/controllers/todos_controller.js` as a dependency:

在`index.html`中包含`js/controllers/todos_controller.js`依赖：

```html
<!--- ... additional lines truncated for brevity ... -->
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
   <script src="js/models/todo.js"></script>
   <script src="js/controllers/todos_controller.js"></script>
 </body>
 <!--- ... additional lines truncated for brevity ... -->
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
```

Reload your web browser to ensure that all files have been referenced correctly and no errors occur. You should now be able to add additional todos by entering a title in the `<input>` and hitting the `<enter>` key.

重新载入Web浏览器以确保所有被引用的文件正确无误且没有任何错误发生。现在可以通过在`<input>`中输入一个标题，然后点击`<enter>`键来添加其他的待办事项。

### Live Preview

### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/ImukUZO/1/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script> 

### Additional Resources

### 附加资源

  * [Changes in this step in `diff` format](https://github.com/emberjs/quickstart-code-sample/commit/60feb5f369c8eecd9df3f561fbd01595353ce803)
  * [Ember.TextField API documention](/api/classes/Ember.TextField.html)
  * [Ember Controller Guide](/guides/controllers)
  * [Naming Conventions Guide](/guides/concepts/naming-conventions)

  * [用`diff`格式呈现本次修改](https://github.com/emberjs/quickstart-code-sample/commit/60feb5f369c8eecd9df3f561fbd01595353ce803)
  * [Ember.TextField API文档](http://emberjs.com/guides/templates/handlebars-basics)
  * [控制器指南](/guides/controllers)
  * [命名惯例指南](/guides/concepts/naming-conventions)
