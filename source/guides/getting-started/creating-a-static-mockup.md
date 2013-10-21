英文原文：[http://emberjs.com/guides/getting-started/creating-a-static-mockup](http://emberjs.com/guides/getting-started/creating-a-static-mockup)

在开始编码之前，我们可以粗略地作出我们应用的布局。打开任意你喜欢的文本编辑器，新建一个文件，并命名为 `index.html` 。这个文件将会包含我们整个应用的HTML模板并请求图片、样式表和Javascript资源。

开始了，将下列文字加到 `index.html` 里：

```html
<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Ember.js • TodoMVC</title>
    <link rel="stylesheet" href="style.css">
  </head>
  <body>
    <script type="text/x-handlebars" data-template-name="todos">
    <section id="todoapp">
      <header id="header">
        <h1>todos</h1>
        <input type="text" id="new-todo" placeholder="What needs to be done?" />
      </header>

        <section id="main">
          <ul id="todo-list">
            <li class="completed">
              <input type="checkbox" class="toggle">
              <label>Learn Ember.js</label><button class="destroy"></button>
            </li>
            <li>
              <input type="checkbox" class="toggle">
              <label>...</label><button class="destroy"></button>
            </li>
            <li>
              <input type="checkbox" class="toggle">
              <label>Profit!</label><button class="destroy"></button>
            </li>
          </ul>

          <input type="checkbox" id="toggle-all">
        </section>

        <footer id="footer">
          <span id="todo-count">
            <strong>2</strong> todos left
          </span>
          <ul id="filters">
            <li>
              <a href="all" class="selected">All</a>
            </li>
            <li>
              <a href="active">Active</a>
            </li>
            <li>
              <a href="completed">Completed</a>
            </li>
          </ul>

          <button id="clear-completed">
            Clear completed (1)
          </button>
        </footer>
    </section>

    <footer id="info">
      <p>Double-click to edit a todo</p>
    </footer>
    </script>
  </body>
</html>
```

和这个页面相关的[样式](http://emberjs.com.s3.amazonaws.com/getting-started/style.css)和[背景图片](http://emberjs.com.s3.amazonaws.com/getting-started/bg.png)要放在与 `index.html` 相同的目录下。

在浏览器中打开 `index.html` 以确保所有的 `assets` 正确加载。这时你应该能够看见TodoMVC应用已经有三条我们采用硬编码（`hard-coded`）方式写上去的 `<li>` ，每个 `<li>` 显示的就是这条todo的要显示的内容了。

### 在线演示

<a class="jsbin-embed" href="http://jsbin.com/uduyip/2/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script> 

### 附加资源

  * [采用`diff`格式显示这步骤所作的修改](https://github.com/emberjs/quickstart-code-sample/commit/4d91f9fa1f6be4f4675b54babd3074550095c930)
  * [TodoMVC 样式表](http://emberjs.com.s3.amazonaws.com/getting-started/style.css)
  * [TodoMVC 背景图片](http://emberjs.com.s3.amazonaws.com/getting-started/bg.png)
