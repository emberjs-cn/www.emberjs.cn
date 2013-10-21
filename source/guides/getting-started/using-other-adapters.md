英文原文：[http://emberjs.com/guides/getting-started/using-other-adapters/](http://emberjs.com/guides/getting-started/using-other-adapters/)

最后我们将修改之前使用的夹具数据为真实持久化的数据。这样才能在每次应用加载的时候保持代办事项。该功能通过将夹具适配器替换为`localstorage`适配器就能实现。

修改`js/application.js`为：

```javascript
window.Todos = Ember.Application.create();

Todos.ApplicationAdapter = DS.LSAdapter.extend({
   namespace: 'todos-emberjs'
 });
```

`localstorage`适配器由Ryan Florence编写，可以从[其源](https://github.com/rpflorence/ember-localstorage-adapter)下载。将其添加至项目的`js/libs/localstorage_adapter.js`。当然你也可以将其放置到任何你喜欢的位置（或者将所有代码放置到一个文件中），不过本指南假设你按照指定的路径保存文件和对其命名。

在`index.html`引入`js/libs/localstorage_adapter.js`依赖：

```html
<!--- ... additional lines truncated for brevity ... -->
<script src="js/libs/ember-data.js"></script>
<script src="js/libs/localstorage_adapter.js"></script>
<script src="js/application.js"></script>
 <!--- ... additional lines truncated for brevity ... -->
```

重载应用，现在待办事项在应用被关闭后依然会被保存。

### 在线演示

<a class="jsbin-embed" href="http://jsbin.com/aZIXaYo/1/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>

### 附加资源

  * [用`diff`格式显示改动](https://github.com/emberjs/quickstart-code-sample/commit/81801d87da42d0c83685ff946c46de68589ce38f)
  * [LocalStorage Adapter on GitHub](https://github.com/rpflorence/ember-localstorage-adapter)
