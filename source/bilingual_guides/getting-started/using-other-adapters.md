英文原文：[http://emberjs.com/guides/getting-started/using-other-adapters/](http://emberjs.com/guides/getting-started/using-other-adapters/)

Finally we'll replace our fixture data with real persistence so todos will remain between application loads by replacing the fixture adapter with a `localstorage`-aware adapter instead.

最后我们将修改之前使用的夹具数据为真实持久化的数据。这样才能在每次应用加载的时候保持代办事项。该功能通过将夹具适配器替换为`localstorage`适配器就能实现。

Change `js/application.js` to:

修改`js/application.js`为：

```javascript
window.Todos = Ember.Application.create();

Todos.ApplicationAdapter = DS.LSAdapter.extend({
   namespace: 'todos-emberjs'
 });
```

The local storage adapter, written by Ryan Florence, can be downloaded [from its source](https://raw.github.com/rpflorence/ember-localstorage-adapter/master/localstorage_adapter.js). Add it to your project as `js/libs/localstorage_adapter.js`. You may place this file anywhere you like (even just putting all code into the same file), but this guide will assume you have created the file and named it as indicated.

`localstorage`适配器由Ryan
Florence编写，可以从[其源](https://raw.github.com/rpflorence/ember-localstorage-adapter/master/localstorage_adapter.js)下载。将其添加至项目的`js/libs/localstorage_adapter.js`。当然你也可以将其放置到任何你喜欢的位置（或者将所有代码放置到一个文件中），不过本指南假设你按照指定的路径保存文件和对其命名。

In `index.html` include `js/libs/localstorage_adapter.js` as a dependency:

在`index.html`引入`js/libs/localstorage_adapter.js`依赖：

```html
<!--- ... additional lines truncated for brevity ... -->
<script src="js/libs/ember-data.js"></script>
<script src="js/libs/localstorage_adapter.js"></script>
<script src="js/application.js"></script>
 <!--- ... additional lines truncated for brevity ... -->
```

Reload your application. Todos you manage will now persist after the application has been closed.

重载应用，现在待办事项在应用被关闭后依然会被保存。

### Live Preview

### 在线演示

<a class="jsbin-embed" href="http://jsbin.com/aZIXaYo/1/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>

### Additional Resources

### 附加资源

  * [Changes in this step in `diff` format](https://github.com/emberjs/quickstart-code-sample/commit/81801d87da42d0c83685ff946c46de68589ce38f)
  * [LocalStorage Adapter on GitHub](https://github.com/rpflorence/ember-localstorage-adapter)

  * [用`diff`格式显示改动](https://github.com/emberjs/quickstart-code-sample/commit/81801d87da42d0c83685ff946c46de68589ce38f)
  * [LocalStorage Adapter on GitHub](https://github.com/rpflorence/ember-localstorage-adapter)
