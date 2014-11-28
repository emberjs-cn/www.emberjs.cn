英文原文：[http://emberjs.com/guides/getting-started/modeling-data](http://emberjs.com/guides/getting-started/modeling-data)

## Modeling Your Data

## 为数据建立模型

Next we will create a model class to describe todo items. 

接下来我们建立一个模型用来描述todo项。

Create a file at `js/models/todo.js` and put the following code inside:

新建一个名为 `js/models/todo.js` 的文件，加入以下代码：

```javascript
Todos.Todo = DS.Model.extend({
  title: DS.attr('string'),
  isCompleted: DS.attr('boolean')
});
```

This code creates a new class `Todo` and places it within your application's namespace. Each todo will have two attributes: `title` and `isCompleted`.

这段代码创建了一个新的 `Todo` 类，并将它置于你应用的命名空间下。每一个todo有两个属性： `title` 和 `isCompleted`。

You may place this file anywhere you like (even just putting all code into the same file), but this guide will assume you have created a file and named it as indicated.

你可以将这个文件放在任意你喜欢的地方（甚至把它们所有的代码放在同一个文件内），但是本指南假定你创建了一个文件并按照前面讲的进行命名。

Finally, update your `index.html` to include a reference to this new file:

最后，更新 `index.html` ，将下列引用添加到这个新文件中：

```html
<!-- ... additional lines truncated for brevity ... -->
<!-- ... 为确保简洁，略去头尾代码 ... -->
  <script src="js/models/todo.js"></script>
</body>
<!-- ... additional lines truncated for brevity ... -->
<!-- ... 为确保简洁，略去头尾代码 ... -->
```

Reload your web browser to ensure that all files have been referenced correctly and no errors occur.

重新加载浏览器页面，确保所有的文件被正确引用，且没有错误产生。

### Live Preview
### 在线演示
<a class="jsbin-embed" href="http://jsbin.com/AJoyOGo/1/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>

### Additional Resources

  * [Changes in this step in `diff` format](https://github.com/emberjs/quickstart-code-sample/commit/a1ccdb43df29d316a7729321764c00b8d850fcd1)
  * [Models Guide](/guides/models)

### 附加资源

  * [采用`diff`格式显示这步骤所作的修改](https://github.com/emberjs/quickstart-code-sample/commit/a1ccdb43df29d316a7729321764c00b8d850fcd1)
  * [模型指南](/guides/models)
