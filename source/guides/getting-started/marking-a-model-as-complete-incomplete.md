英文原文：[http://emberjs.com/guides/getting-started/marking-a-model-as-complete-incomplete/](http://emberjs.com/guides/getting-started/marking-a-model-as-complete-incomplete/)

接下来我们将更新我们的应用，允许用户将一个待办事项标记为完成或者为完成，并将更新信息持久化。

在`index.html`中更新模板，通过添加一个`itemController`参数在Handlebars的`{{each}}`助手中，将每个待办事项包裹在其自己的控制器中。接着将静态的`<input type="checkbox">`转换为一个`{{input}}`：

```handlebars
<!-- ... 为保持代码简洁，在此省略了其他代码 ... -->
{{#each itemController="todo"}}
  <li {{bind-attr class="isCompleted:completed"}}>
    {{input type="checkbox" checked=isCompleted class="toggle"}}
    <label>{{title}}</label><button class="destroy"></button>
  </li>
{{/each}}
<!-- ... 为保持代码简洁，在此省略了其他代码 ... -->
```

当`{{input}}`被渲染时，将询问控制器属性`isCompleted`属性的当前值是什么。当有用户点击了这个输入时，将调用控制器的`isCompleted`属性，参数是真或假依赖于输入的选中属性的值。

在应用中，实现一个通过匹配用作`itemController`值的名称的类`Todos.TodoController`，来为每个待办事项实现一个控制器。为这段代码创建一个新文件`js/controllers/todo_controller.js`。你可以将该文件放置到任意你喜欢的地方（即使将所有代码放置在同一个文件中），不过本指南将假设你按照指定的方式创建和命名该文件。

在`js/controllers/todo_controller.js`中为`Todos.TodoController`和其`isCompleted`属性添加代码：

```javascript
Todos.TodoController = Ember.ObjectController.extend({
  isCompleted: function(key, value){
    var model = this.get('model');

    if (value === undefined) {
      // property being used as a getter
      return model.get('isCompleted');
    } else {
      // property being used as a setter
      model.set('isCompleted', value);
      model.save();
      return value;
    }
  }.property('model.isCompleted')
});
```

当模板中需要显示待办事项的当前`isCompleted`状态，这个属性将这个问题委派给其底层的`model`。当被调用时因为用户触发了模板中的复选框而带有一个参数，那么这个属性将设置`model`的`isCompleted`属性为传入的参数值（`true`或者`false`），并将模型的变更持久化，返回传入的值以便复选框显示正确。

`isCompleted`函数被声明为一个[计算属性](/guides/object-model/computed-properties/)，其值依赖于`model.isCompleted`。

在`index.html`中包含`js/controllers/todo_controller.js`依赖：

```html
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
    <script src="js/models/todo.js"></script>
    <script src="js/controllers/todos_controller.js"></script>
    <script src="js/controllers/todo_controller.js"></script>
  </body>
  <!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
```

重新载入Web浏览器以确保所有被引用的文件正确无误且没有任何错误发生。现在可以改变一个待办事项的`isCompleted`属性。

### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/UDoPajA/1/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>

### 附加资源

  * [用`diff`格式呈现本次修改](https://github.com/emberjs/quickstart-code-sample/commit/8d469c04c237f39a58903a3856409a2592cc18a9)
  * [Ember.Checkbox API文档](http://emberjs.com/guides/templates/handlebars-basics)
  * [控制器指南](/guides/controllers)
  * [计算属性指南](/guides/object-model/computed-properties/)
  * [命名惯例指南](/guides/concepts/naming-conventions)
