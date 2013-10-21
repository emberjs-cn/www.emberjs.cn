英文原文：[http://emberjs.com/guides/getting-started/using-fixutres/](http://emberjs.com/guides/getting-started/using-fixtures/)

现在，我们添加一些静态数据。在我们连接应用服务器对数据进行永久持久化之前，使用静态数据是在应用中添加示例数据的一种很好的方式。

首先，更新`js/application.js`来指定应用的`ApplicationAdapter`是扩展自`DS.FixtureAdapter`。适配器主要负责与应用的一个数据源进行通信。通常可能会是一个Web服务器接口，但是在此使用了一个加载夹具数据的适配器：

```javascript
window.Todos = Ember.Application.create();

Todos.ApplicationAdapter = DS.FixtureAdapter.extend();
```

接下来，更新 `js/models/todo.js` ，添加如下数据：

```javascript
// ... 为确保简洁，略去头尾代码 ...
Todos.Todo.FIXTURES = [
 {
   id: 1,
   title: 'Learn Ember.js',
   isCompleted: true
 },
 {
   id: 2,
   title: '...',
   isCompleted: false
 },
 {
   id: 3,
   title: 'Profit!',
   isCompleted: false
 }
];
```

重新加载浏览器页面，确保所有的文件被正确引用，且没有错误产生。

### 在线演示
<a class="jsbin-embed" href="http://jsbin.com/Ovuw/1/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>

### 附加资源

  * [采用`diff`格式显示这步骤所作的修改](https://github.com/emberjs/quickstart-code-sample/commit/a586fc9de92cad626ea816e9bb29445525678098)
