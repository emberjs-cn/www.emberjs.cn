## Rendering with Helpers

## 用助手方法来渲染

Ember provides several helpers that allow you to render other views and templates in different ways.

Ember 提供了数个助手方法来协助你以不同的方式来渲染其他视图或模板

### The `{{partial}}` Helper

### `{{partial}}` 助手方法

`{{partial}}` takes the template to be rendered as an argument, and renders that template in place.

`{{partial}}`需要一个待渲染的模板作为参数并立即渲染此模板。

`{{partial}}` does not change context or scope.  It simply drops the given template into place with the current scope.  

`{{partial}}`不改变上下文或作用域。它只是简单地在当前作用域下将指定的模板渲染出来。

```handlebars
<script type="text/x-handlebars" data-template-name='author'>
  Written by {{author.firstName}} {{author.lastName}}
</script>

<script type="text/x-handlebars" data-template-name='post'>
  <h1>{{title}}</h1>
  <div>{{body}}</div>
  {{partial "author"}}
</script>
```

```html
<div>
  <h1>Why You Should Use Ember.JS</h1>
  <div>Because it's awesome!</div>
  Written by Yehuda Katz
</div>
```

Note: in cases where you may have used `{{template}}` in the past, you should likely use `{{partial}}` instead.

注意：如果你之前用过 `{{template}}` 助手方法，很有可能你就应该用 `{{partial}}` 来代替它了。

### The `{{view}}` Helper

### `{{view}}` 助手方法

This helper works like the partial helper, except instead of providing a template to be rendered within the current template, you provide a view class.  The view controls what template is rendered.

此助手方法和 partial 类似，不同的是你需要提供一个视图类，而不是在当前模板内提供一个待渲染的模板。

```javascript
App.AuthorView = Ember.View.extend({
  // We are setting templateName manually here to the default value
  templateName: "author",

  // A fullName property should probably go on App.Author, 
  // but we're doing it here for the example
  fullName: (function() {
    return this.get("author").get("firstName") + " " + this.get("author").get("lastName");
  }).property("firstName","lastName")
})
```

```handlebars
<script type="text/x-handlebars" data-template-name='author'>
  Written by {{fullName}}
</script>

<script type="text/x-handlebars" data-template-name='post'>
  <h1>{{title}}</h1>
  <div>{{body}}</div>
  {{view App.AuthorView authorBinding=author}}
</script>
```

```html
<div>
  <h1>Why You Should Use Ember.JS</h1>
  <div>Because it's awesome!</div>
  Written by Yehuda Katz
</div>
```

When using `{{partial "author"}}`:

* No instance of App.AuthorView will be created
* The given template will be rendered

当使用 `{{partial "author"}}` 时：
* 不会创建 App.AuthorView 的实例
* 会渲染指定模板


When using `{{view App.AuthorView}}`:

* An instance of App.AuthorView will be created
* It will be rendered here, using the template associated with that view (the default template being "author")

当使用 `{{view App.AuthorView}}` 时：
* 会创建 App.AuthorView 的实例
* 会渲染与指定视图相关联的模板(默认的模板是 "author")

For more information, see [Inserting Views in Templates](/guides/views/inserting-views-in-templates)

更多信息，请见[在模板中插入视图](/guides/views/inserting-views-in-templates)

### The `{{render}}` Helper

### `{{render}}` 助手方法

`{{render}}` takes two parameters:

* The first parameter describes the context to be setup
* The optional second parameter is a model, which will be passed to the controller if provided

`{{render}}` 需要两个参数：

* 第一个参数描述需要建立的上下文
* 可选的第二个参数是模型，如果提供了此参数，则它会被传递给控制器

`{{render}}` does several things:

* Gets the singleton instance of the corresponding controller
* Renders the named template using this controller
* Sets the model of the corresponding controller 

`{{render}}` 做一些事情：

* 获取相应控制器的单体实例
* 用此控制器渲染命名模板
* 设置相应控制器的模型

Modifying the post / author example slightly:

稍微修改一下 post / author 的例子：

```handlebars
<script type="text/x-handlebars" data-template-name='author'>
  Written by {{firstName}} {{lastName}}. 
  Total Posts: {{postCount}}
</script>

<script type="text/x-handlebars" data-template-name='post'>
  <h1>{{title}}</h1>
  <div>{{body}}</div>
  {{render "author" author}}
</script>
```

```javascript
App.AuthorController = Ember.ObjectController.extend({
  postCount: function() { 
    return App.Post.countForAuthor(this.get("model"));
  }.property("model","App.Post.@each.author")
})
```

In this example, render will:

* Gets an instance of App.AuthorView if that class exists, otherwise uses a default generated view
* Use the corresponding template (in this case the default of "author")
* Get (or generate) the singleton instance of AuthorController
* Set the AuthorController's model to the 2nd argument passed to render, here the author field on the post
* Render the template in place, with the context created in the previous steps.

在此例中，render 助手方法会：

* 如果 App.AuthorView 存在，获取它的一个实例，否则就使用默认生成的视图
* 使用相应的模板（此处为默认的 "author"）
* 获取（或生成）AuthorController 的单体实例
* 设置 AuthorController 的模型为第二个传递过来的参数，此处为 post 里的 author 字段
* 在上一步创建的上下文中立即渲染模板

`{{render}}` does not require the presence of a matching route.  

`{{render}}` is similar to `{{outlet}}`. Both tell Ember to devote this portion of the page to something.

`{{outlet}}`: The router determines the route and sets up the appropriate controllers/views/models.
`{{render}}`: You specify (directly and indirectly) the appropriate controllers/views/models.

`{{render}}` 不需要匹配路由。

`{{render}}` 与 `{{outlet}}` 类似。两者均责成 Ember 将此部分的页面交给某物。

`{{outlet}}`: 路由器绝对路由，并且创建合适的控制器/视图/模型
`{{render}}`: 你（直接或间接地）指定合适的控制器/视图/模型




Note: `{{render}}` cannot be called multiple times for the same route.  For that you'll need `{{control}}`.

注意： `{{render}}` 不能在同一个路由中多次调用。不然就得用 `{{control}}`。


### The `{{control}}` Helper

### `{{control}}` 助手方法

`{{control}}` works like render, except it uses a new controller instance for every call, instead of reusing the singleton controller.

This helper is currently under heavy development, and will likely change soon.

`{{control}}` 与 render 类似，不同的是它每次调用均使用一个新的控制器实例，而不是每次都重用单体控制器。

此助手方法目前仍在开发中，以后极有可能变化很大。


### Comparison Table

### 比较表

#### General

#### 笼统比较

<table>
  <thead>
  <tr>
    <th>Helper</th>
    <th>Template</th>
    <th>Model</th>
    <th>View</th>
    <th>Controller</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>{{partial}}</code></td>
    <td>Specified Template</td>
    <td>Current Model</td>
    <td>Current View</td>
    <td>Current Controller</td>
  </tr>
  <tr>
    <td><code>{{view}}</code></td>
    <td>View's Template</td>
    <td>Current Model</td>
    <td>Specified View</td>
    <td>Current Controller</td>
  </tr>
  <tr>
    <td><code>{{render}}</code></td>
    <td>View's Template</td>
    <td>Specified Model</td>
    <td>Specified View</td>
    <td>Specified Controller</td>
  </tr>
  </tbody>
</table>

<table>
  <thead>
  <tr>
    <th>助手</th>
    <th>模板</th>
    <th>模型</th>
    <th>视图</th>
    <th>控制器</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>{{partial}}</code></td>
    <td>指定模板</td>
    <td>当前模型</td>
    <td>当前视图</td>
    <td>当前控制器</td>
  </tr>
  <tr>
    <td><code>{{view}}</code></td>
    <td>视图的模板</td>
    <td>当前模型</td>
    <td>指定视图</td>
    <td>当前控制器</td>
  </tr>
  <tr>
    <td><code>{{render}}</code></td>
    <td>视图的模板</td>
    <td>指定模型</td>
    <td>指定视图</td>
    <td>指定控制器</td>
  </tr>
  </tbody>
</table>

#### Specific

#### 细致比较

<table>
  <thead>
  <tr>
    <th>助手</th>
    <th>模板</th>
    <th>模型</th>
    <th>视图</th>
    <th>控制器</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>{{partial author}}</code></td>
    <td><code>author.hbs</code></td>
    <td>Post</td>
    <td><code>App.PostView</code></td>
    <td><code>App.PostController</code></td>
  </tr>
  <tr>
    <td><code>{{view App.AuthorView}}</code></td>
    <td><code>author.hbs</code></td>
    <td>Post</td>
    <td><code>App.AuthorView</code></td>
    <td><code>App.PostController</code></td>
  </tr>
  <tr>
    <td><code>{{render author author}}</code></td>
    <td><code>author.hbs</code></td>
    <td>Author</td>
    <td><code>App.AuthorView</code></td>
    <td><code>App.AuthorController</code></td>
  </tr>
  </tbody>
</table>