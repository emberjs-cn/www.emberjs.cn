英文原文：[http://emberjs.com/guides/getting-started/modeling-data](http://emberjs.com/guides/getting-started/modeling-data)

## Modeling Your Data

## 为数据建立模型

Next we will create a model class to describe todo items and a data store to track them locally. 

接下来我们建立一个模型用来描述todo项和一个存储器（store）进行本地追踪（track them locally）。

Create a file at `js/models/todo.js` and put the following code inside:

新建一个名为`js/models/todo.js`的文件，加入以下代码：

```javascript
Todos.Todo = DS.Model.extend({
  title: DS.attr('string'),
  isCompleted: DS.attr('boolean')
});
```

This code creates a new class `Todo` and places it within your application's namespace. Each todo will have two attributes: `title` and `isCompleted`.

这段代码创建了一个新的`Todo`类，并将它置于你应用的命名空间下。每一个todo有两个属性： `title` 和 `isCompleted`。

Create a file at `js/models/store.js` and put the following code inside:

新建一个名为`js/models/store.js`的文件，加入以下代码：

```javascript
Todos.Store = DS.Store.extend({
  revision: 12,
  adapter: 'DS.FixtureAdapter'
});
```

This code creates a new class `Store` and places it within your application's namespace. The store will track local instances of `Todos.Todo`. It will persist these instances using the built-in `DS.FixtureAdapter`, an adapter for using fixture data in the early stages of development before long-term persistence is required.

这段代码创建了一个新的`Store`类，并将它置于你应用的命名空间下。这个Store会追踪本地 `Todos.Todo` 的所有实例，它会使用内置的`DS.FixtureAdapter`来持久化这些实例。在开发初期，我们还不需要对数据进行永久保存时，我们可以使用`DS.FixtureAdapter`，它是一个用于静态数据（fixture data）的适配器。

You may place these files anywhere you like (even just putting all code into the same file), but this guide will assume you have separated them into their own files and named them as indicated.

你可以将这两个文件放在任意你喜欢的地方（甚至把它们所有的代码放在同一个文件内），但是本指南假定你将它们分开了，并且按照前面讲的进行命名。

Finally, update your `index.html` to include references to these new files:

最后，更新`index.html`，将下列引用添加到其中：

```html
<!-- ... additional lines truncated for brevity ... -->
<!-- ... 为确保简洁，略去头尾代码 ... -->
  <script src="js/models/store.js"></script>
  <script src="js/models/todo.js"></script>
</body>
<!-- ... additional lines truncated for brevity ... -->
<!-- ... 为确保简洁，略去头尾代码 ... -->
```

Reload your web browser to ensure that all files have been referenced correctly and no errors occur.

重新加载浏览器页面，确保所有的文件被正确引用，且没有错误产生。

### Live Preview
### 在线演示
<a class="jsbin-embed" href="http://jsbin.com/ovizun/2/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>

### Additional Resources

  * [Changes in this step in `diff` format](https://github.com/emberjs/quickstart-code-sample/commit/979ba3a329b8157bb199fda4b8c6a43bab5b6900)
  * [Defining A Store Guide](/guides/models/defining-a-store)
  * [Defining Models Guide](/guides/models/defining-models)

### 附加资源

  * [采用`diff`格式显示这步骤所作的修改](https://github.com/emberjs/quickstart-code-sample/commit/979ba3a329b8157bb199fda4b8c6a43bab5b6900)
  * [创建一个存储器指南](/guides/models/defining-a-store)
  * [定义模型指南](/guides/models/defining-models)
