英文原文：[http://emberjs.com/guides/getting-started/modeling-data](http://emberjs.com/guides/getting-started/modeling-data)

接下来我们建立一个模型用来描述todo项。

新建一个名为 `js/models/todo.js` 的文件，加入以下代码：

```javascript
Todos.Todo = DS.Model.extend({
  title: DS.attr('string'),
  isCompleted: DS.attr('boolean')
});
```

这段代码创建了一个新的 `Todo` 类，并将它置于你应用的命名空间下。每一个todo有两个属性： `title` 和 `isCompleted`。

你可以将这两个文件放在任意你喜欢的地方（甚至把它们所有的代码放在同一个文件内），但是本指南假定你将它们分开了，并且按照前面讲的进行命名。

最后，更新 `index.html` ，将下列引用添加到其中：

```html
<!-- ... 为确保简洁，略去头尾代码 ... -->
  <script src="js/models/todo.js"></script>
</body>
<!-- ... 为确保简洁，略去头尾代码 ... -->
```

重新加载浏览器页面，确保所有的文件被正确引用，且没有错误产生。

### 在线演示
<a class="jsbin-embed" href="http://jsbin.com/AJoyOGo/1/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>

### 附加资源

  * [采用`diff`格式显示这步骤所作的修改](https://github.com/emberjs/quickstart-code-sample/commit/a1ccdb43df29d316a7729321764c00b8d850fcd1)
  * [Store使用指南](/guides/models/using-the-store)
  * [定义模型指南](/guides/models/defining-models)
