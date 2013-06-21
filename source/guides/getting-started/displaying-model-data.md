## 显示模型数据

接下来，我们将更新我们的应用，使其可以显示动态的待办事项，而不再是显示我们在`todos`模板中硬编码的内容。

在`js/router.js`这个文件中，通过`model`函数实现了一个`TodosRoute`对象，这个函数的返回值是所有现存的待办事项：

```javascript
Todos.TodosRoute = Ember.Route.extend({
  model: function () {
    return Todos.Todo.find();
  }
});
```

由于之前我们一直都没有实现这个对象，所以Ember.js默认根据[对象创建的命名惯例](/guides/concepts/naming-conventions/)为我们创建了一个`Route`，这个被Ember.js自动创建的`Route`将会默认渲染一个名为`todos`的模板。

现在我们需要自定义的行为（返回一个指定的对象集合），因此我们实现了这个类，并为其添加了期望的行为。

通过删除`index.html`中的静态元素`<li>`，用Handlebars的`{{each}}`助手和每项元素的动态`{{title}}`来替代。

```handlebars
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
<ul id="todo-list">
  {{#each controller}}
    <li>
      <input type="checkbox" class="toggle">
      <label>{{title}}</label><button class="destroy"></button>
    </li>
  {{/each}}
</ul>
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
```

上面的模板遍历了其控制器的`content`。这里的控制器是一个`ArrayController`的实例，`ArrayController`是Ember.js提供的用于存储我们的对象的容器。因为我们这里并不需要为这个对象添加自定义行为，所以可以使用框架提供的缺省对象。

重新载入你的Web浏览器，以确保所有文件均被正确引用，且没有发生任何错误。

### 在线演示
<a class="jsbin-embed" href="http://jsbin.com/ihugoj/2/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>
  
### 附加资源

  * [用`diff`格式呈现本次修改](https://github.com/emberjs/quickstart-code-sample/commit/72b1ccde5e157b20fcfe5da9bd52496e73533d47)
  * [模板指南](/guides/templates/handlebars-basics)
  * [控制器指南](/guides/controllers)
  * [命名惯例指南](/guides/concepts/naming-conventions)
