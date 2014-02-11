英文原文：[http://emberjs.com/guides/getting-started/displaying-the-number-of-incomplete-todos/](http://emberjs.com/guides/getting-started/displaying-the-number-of-incomplete-todos/)

接下来，我们将修改我们的应用，使其能反映实际完成的待办事项数量，取缔我们之前的硬编码。我们使用下面两个属相来更新`index.html`：

```handlebars
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
<span id="todo-count">
  <strong>{{remaining}}</strong> {{inflection}} left
</span>
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
```

在模板的控制器`Todos.TodosController`中实现以上的属性：

```javascript
actions: {
  // ... 为保持代码简洁，在此省略了其他代码 ...
},

// ... 为保持代码简洁，在此省略了其他代码 ...
remaining: function () {
  return this.filterBy('isCompleted', false).get('length');
}.property('@each.isCompleted'),

inflection: function () {
  var remaining = this.get('remaining');
  return remaining === 1 ? 'item' : 'items';
}.property('remaining'),
// ... 为保持代码简洁，在此省略了其他代码 ...
```

`remaining`属性表示`isCompleted`属性为假的待办事项的数量。如果任何待办事项的`isCompleted`属相发生改变，`remaining`将会被重新计算。如果`remaining`属性的值发生改变，那么模板中显示剩余的待办事项数量的部分将自动更新为新的值。

`inflection`属性根据当前列表中有多少待办事项来返回`item`的单数或复数形式。模板中显示剩余待办事项数量的部分将会自动更新该属性。

重新载入Web浏览器以确保没有任何错误发生。那么就可以看到正确的剩余待办事项数量。

### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/onOCIrA/1/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>
  
### 附加资源

  * [用`diff`格式呈现本次修改](https://github.com/emberjs/quickstart-code-sample/commit/b418407ed9666714c82d894d6b70f785674f7a45)
  * [计算属性指南](/guides/object-model/computed-properties/) 
