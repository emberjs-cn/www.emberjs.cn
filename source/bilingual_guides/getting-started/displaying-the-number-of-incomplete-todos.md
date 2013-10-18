英文原文：[http://emberjs.com/guides/getting-started/displaying-the-number-of-incomplete-todos/](http://emberjs.com/guides/getting-started/displaying-the-number-of-incomplete-todos/)

## Displaying the number of incomplete todos

## 显示未完成待办事项的数量

Next we'll update our template's hard-coded count of completed todos to reflect the actual number of completed todos. Update `index.html` to use two properties:

接下来，我们将修改我们的应用，使其能反映实际完成的待办事项数量，取缔我们之前的硬编码。我们使用下面两个属相来更新`index.html`：

```handlebars
<!--- ... additional lines truncated for brevity ... -->
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
<span id="todo-count">
  <strong>{{remaining}}</strong> {{inflection}} left
</span>
<!--- ... additional lines truncated for brevity ... -->
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
```

Implement these properties as part of this template's controller, the `Todos.TodosController`:

在模板的控制器`Todos.TodosController`中实现以上的属性：

```javascript
// Hint: these lines MUST NOT go into the 'actions' object.
// 提示：下面的代码不能放入'actions'
// ... additional lines truncated for brevity ...
// ... 为保持代码简洁，在此省略了其他代码 ...
remaining: function () {
  return this.filterBy('isCompleted', false).get('length');
}.property('@each.isCompleted'),

inflection: function () {
  var remaining = this.get('remaining');
  return remaining === 1 ? 'item' : 'items';
}.property('remaining')
// ... additional lines truncated for brevity ...
// ... 为保持代码简洁，在此省略了其他代码 ...
```

The `remaining` property will return the number of todos whose `isCompleted` property is false. If the `isCompleted` value of any todo changes, this property will be recomputed. If the value has changed, the section of the template displaying the count will be automatically updated to reflect the new value.

`remaining`属性表示`isCompleted`属性为假的待办事项的数量。如果任何待办事项的`isCompleted`属相发生改变，`remaining`将会被重新计算。如果`remaining`属性的值发生改变，那么模板中显示剩余的待办事项数量的部分将自动更新为新的值。

The `inflection` property will return either a plural or singular version of the word "item" depending on how many todos are currently in the list. The section of the template displaying the count will be automatically updated to reflect the new value.

`inflection`属性根据当前列表中有多少待办事项来返回`item`的单数或复数形式。模板中显示剩余待办事项数量的部分将会自动更新该属性。

 Reload your web browser to ensure that no errors occur. You should now see an accurate number for remaining todos.

重新载入Web浏览器以确保没有任何错误发生。那么就可以看到正确的剩余待办事项数量。

### Live Preview

### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/onOCIrA/1/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>
  
### Additional Resources

### 附加资源

  * [Changes in this step in `diff` format](https://github.com/emberjs/quickstart-code-sample/commit/b418407ed9666714c82d894d6b70f785674f7a45)
  * [Computed Properties Guide](/guides/object-model/computed-properties/) 

  * [用`diff`格式呈现本次修改](https://github.com/emberjs/quickstart-code-sample/commit/b418407ed9666714c82d894d6b70f785674f7a45)
  * [计算属性指南](/guides/object-model/computed-properties/) 
