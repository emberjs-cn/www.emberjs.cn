英文原文：[http://emberjs.com/guides/getting-started/using-fixutres/](http://emberjs.com/guides/getting-started/using-fixutres/)

## Using Fixtures

## 使用静态数据

Now we'll add fixture data. Fixtures are a way to put sample data into an application before connecting the application to long-term persistence.

现在，我们添加一些静态数据。在我们连接应用服务器对数据进行永久持久化之前，使用静态数据是在应用中添加示例数据的一种很好的方式。

Update the file at `js/models/todo.js` to include the following fixture data:

更新 `js/models/todo.js` ，添加如下数据：

```javascript
// ... additional lines truncated for brevity ...
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

Reload your web browser to ensure that all files have been referenced correctly and no errors occur.

重新加载浏览器页面，确保所有的文件被正确引用，且没有错误产生。

### Live Preview
### 在线演示
<a class="jsbin-embed" href="http://jsbin.com/akoguw/2/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>

### Additional Resources

  * [Changes in this step in `diff` format](https://github.com/emberjs/quickstart-code-sample/commit/9e6e638f4d156399e38b17ae36e191d9cb1f2797)

### 附加资源

  * [采用`diff`格式显示这步骤所作的修改](https://github.com/emberjs/quickstart-code-sample/commit/9e6e638f4d156399e38b17ae36e191d9cb1f2797)
