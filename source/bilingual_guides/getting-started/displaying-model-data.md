## Displaying Model Data

## 显示模型数据

Next we'll update our application to display dynamic todos, replacing our hard coded section in the `todos` template.

接下来，我们将更新我们的应用，使其可以显示动态的待办事项，而不再是显示我们在`todos`模板中硬编码的内容。

Inside the file `js/router.js` implement a `TodosRoute` object with a `model` function that returns all the existing todos:

在`js/router.js`这个文件中，通过`model`函数实现了一个`TodosRoute`对象，这个函数的返回值是所有现存的待办事项：

```javascript
Todos.TodosRoute = Ember.Route.extend({
  model: function () {
    return this.store.find('todo');
  }
});
```

Because we hadn't implemented this object before, Ember.js provided a `Route` for us with the default behavior of rendering a matching template named `todos` using its [naming conventions for object creation](/guides/concepts/naming-conventions/).

由于之前我们一直都没有实现这个对象，所以Ember.js默认根据[对象创建的命名惯例](/guides/concepts/naming-conventions/)为我们创建了一个`Route`，这个被Ember.js自动创建的`Route`将会默认渲染一个名为`todos`的模板。

Now that we need custom behavior (returning a specific set of models), we implement the class and add the desired behavior.

现在我们需要自定义的行为（返回一个指定的对象集合），因此我们实现了这个类，并为其添加了期望的行为。

Update `index.html` to replace the static `<li>` elements with a Handlebars `{{each}}` helper and a dynamic `{{title}}` for each item.

通过删除`index.html`中的静态元素`<li>`，用Handlebars的`{{each}}`助手和每项元素的动态`{{title}}`来替代。

```handlebars
<!--- ... additional lines truncated for brevity ... -->
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
<ul id="todo-list">
  {{#each}}
    <li>
      <input type="checkbox" class="toggle">
      <label>{{title}}</label><button class="destroy"></button>
    </li>
  {{/each}}
</ul>
<!--- ... additional lines truncated for brevity ... -->
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
```

The template loops over the content of its controller. This controller is an instance of `ArrayController` that Ember.js has provided for us as the container for our models. Because we don't need custom behavior for this object yet, we can use the default object provided by the framework.

上面的模板遍历了其控制器的`content`。这里的控制器是一个`ArrayController`的实例，`ArrayController`是Ember.js提供的用于存储我们的对象的容器。因为我们这里并不需要为这个对象添加自定义行为，所以可以使用框架提供的缺省对象。

Reload your web browser to ensure that all files have been referenced correctly and no errors occur.

重新载入你的Web浏览器，以确保所有文件均被正确引用，且没有发生任何错误。

### Live Preview
### 在线演示
<a class="jsbin-embed" href="http://jsbin.com/EJISAne/1/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>
  
### Additional Resources
### 附加资源

  * [Changes in this step in `diff` format](https://github.com/emberjs/quickstart-code-sample/commit/87bd57700110d9dd0b351c4d4855edf90baac3a8)
  * [Templates Guide](/guides/templates/handlebars-basics)
  * [Controllers Guide](/guides/controllers)
  * [Naming Conventions Guide](/guides/concepts/naming-conventions)

  * [用`diff`格式呈现本次修改](https://github.com/emberjs/quickstart-code-sample/commit/87bd57700110d9dd0b351c4d4855edf90baac3a8)
  * [模板指南](/guides/templates/handlebars-basics)
  * [控制器指南](/guides/controllers)
  * [命名惯例指南](/guides/concepts/naming-conventions)
