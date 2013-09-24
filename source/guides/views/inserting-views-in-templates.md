英文原文：[http://emberjs.com/guides/views/inserting-views-in-templates/](http://emberjs.com/guides/views/inserting-views-in-templates/)

## 在模板中插入视图

到目前为止，我们已经讨论了如何为单独的视图编写模板。然而，随着应用开发的深入，为了封装页面上的不同区域，你可能会经常需要创建一个层次化的视图结构。每个视图负责处理事件和维护需要显示的属性。

### `{{view}}`

为了将一个子视图添加到父视图中，可以使用`{{view}}`助手，它接受一个视图类的路径参数。

```javascript
// 定义父视图
App.UserView = Ember.View.extend({
  templateName: 'user',

  firstName: "Albert",
  lastName: "Hofmann"
});

// 定义子视图
App.InfoView = Ember.View.extend({
  templateName: 'info',

  posts: 25,
  hobbies: "Riding bicycles"
});
```

```html
<script type="text/x-handlebars" data-template-name="user">
  User: {{view.firstName}} {{view.lastName}}
  {{view App.InfoView}}
</script>
```

```html
<script type="text/x-handlebars" data-template-name="info">
  <b>Posts:</b> {{view.posts}}
  <br>
  <b>Hobbies:</b> {{view.hobbies}}
</script>
```

如果我们想要创建一个`App.UserView`的实例并渲染它，我们就会得到如下的`DOM`:

```html
User: Albert Hofmann
<div>
  <b>Posts:</b> 25
  <br>
  <b>Hobbies:</b> Riding bicycles
</div>
```

#### 相对路径

你可以使用一个子视图与其父视图之间的相对路径，而不使用绝对路径。例如，我们可以像这样嵌套上面的视图层次结构：

```javascript
App.UserView = Ember.View.extend({
  templateName: 'user',

  firstName: "Albert",
  lastName: "Hofmann",

  infoView: Ember.View.extend({
    templateName: 'info',

    posts: 25,
    hobbies: "Riding bicycles"
  })
});
```

```handlebars
User: {{view.firstName}} {{view.lastName}}
{{view view.infoView}}
```

当以这种形式组织视图类时，要确保属性名称首字母小写，因为`Ember`会把以大写字母开头的属性解释为全局属性。

### 设置子视图模板

如果你想在主模板中声明子视图类所使用的模板的话，可以使用`{{view}}`助手的区块形式。我们可以将上面的例子改写如下：

```javascript
App.UserView = Ember.View.extend({
  templateName: 'user',

  firstName: "Albert",
  lastName: "Hofmann"
});

App.InfoView = Ember.View.extend({
  posts: 25,
  hobbies: "Riding bicycles"
});
```

```handlebars
User: {{view.firstName}} {{view.lastName}}
{{#view App.InfoView}}
  <b>Posts:</b> {{view.posts}}
  <br>
  <b>Hobbies:</b> {{view.hobbies}}
{{/view}}
```

当你这么做的时候，把它想象成视图对应着页面上的一部分，这样会更容易理解。同时，这允许你对这一部分页面的事件处理逻辑进行封装。
