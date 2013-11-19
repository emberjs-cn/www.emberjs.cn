英文原文： [http://emberjs.com/guides/templates/rendering-with-helpers/](http://emberjs.com/guides/templates/rendering-with-helpers/)

## 用助手来渲染


Ember 提供了数个助手来协助你以不同的方式来渲染其他视图或模板


### `{{partial}}` 助手


`{{partial}}`接收一个模板作为其参数，然后恰当地渲染这个模板


`{{partial}}`不改变上下文或作用域。它只是简单地在当前作用域下将指定的模板渲染出来。

```handlebars
<script type="text/x-handlebars" data-template-name='_author'>
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

Partial的`data-template-name`必须以下划线开头（例如：`data-template-name='_author'`或者`data-template-name='foo/_bar'`）

### `{{view}}` 助手


此助手和 partial 类似，不同的是你需要提供一个视图类，而不是在当前模板内提供一个待渲染的模板。这个视图类控制哪个模板将被渲染，如下所示：

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
  Written by {{view.fullName}}
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


当使用 `{{partial "author"}}` 时：
* 不会创建 App.AuthorView 的实例
* 会渲染指定模板



当使用 `{{view App.AuthorView}}` 时：
* 会创建 App.AuthorView 的实例
* 会渲染与指定视图相关联的模板(默认的模板是 "author")


更多信息，请见[在模板中插入视图](/guides/views/inserting-views-in-templates)


### `{{render}}` 助手


`{{render}}` 需要两个参数：

* 第一个参数描述需要建立的上下文
* 第二个参数是可选参数，它接收一个模型，如果提供了这个参数，就会被传递给控制器。


`{{render}}` 可以完成以下几个功能：

* 如果没有提供model，那么将使用对应controller的单例实例
* 如果提供了model，那么将使用对应controller的一个独立实例
* 用此控制器渲染命名模板
* 设置相应控制器的模型


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


在此例中，render 助手会：

* 如果 App.AuthorView 存在，获取它的一个实例，否则就使用默认生成的视图
* 使用相应的模板（此处为默认的 "author"）
* 获取（或生成）AuthorController 的单体实例
* 设置 AuthorController的模型为{{render}}助手的第二个参数，此处为 post 里的 author 字段
* 根据前几步创建的上下文，恰当地渲染模板

`{{render}}` 不需要匹配路由。

`{{render}}` 与 `{{outlet}}` 类似。两者均负责通知`Ember`将这一部分页面用来渲染其他模板。

`{{outlet}}`: 路由器决定路由，并且创建合适的控制器/视图/模型
`{{render}}`: 你（直接或间接地）指定合适的控制器/视图/模型

注意： 如果在没有指定一个model的时候需要多次调用，就得使用下面的`{{control}}`助手。

### `{{control}}` 助手

`{{control}}` 与 render 类似，不同的是它每次调用均使用一个新的控制器实例，而不是每次都重用单体控制器。

此助手目前仍在开发中，以后极有可能变化很大。

注意：`{{control}}`助手默认是被禁用的。如果需要启用，那么需要在引入Ember之前设置：`ENV.EXPERIMENTAL_CONTROL_HELPER = true`。

### 比较表


#### 整体概念性比较


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

#### 基于特定实例的比较

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
    <td><code>{{partial "author"}}</code></td>
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
    <td><code>{{render "author" author}}</code></td>
    <td><code>author.hbs</code></td>
    <td>Author</td>
    <td><code>App.AuthorView</code></td>
    <td><code>App.AuthorController</code></td>
  </tr>
  </tbody>
</table>
