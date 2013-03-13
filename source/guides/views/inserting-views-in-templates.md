## 在模版中插入视图 (Inserting Views in Templates)

So far, we've discussed writing templates for a single view. However, as your application grows, you will often want to create a hierarchy of views to encapsulate different areas on the page. Each view is responsible for handling events and maintaining the properties needed to display it.

到目前为止，我们已经讨论了为一个单独的视图写模板。然而，随着应用开发深入，你将经常需要创建一个层次结构的视图来封装在页面上不同的区域。每个视图负责处理事件和维护需要显示的属性。

### `{{view}}`

To add a child view to a parent, use the `{{view}}` helper, which takes a path to a view class.

为了将一个子视图添加到父视图中，可以使用`{{view}}`助手，它接受一个视图类的路径参数。

```javascript
// Define parent view
// 定义父视图
App.UserView = Ember.View.extend({
  templateName: 'user',

  firstName: "Albert",
  lastName: "Hofmann"
});

// Define child view
// 定义子视图
App.InfoView = Ember.View.extend({
  templateName: 'info',

  posts: 25,
  hobbies: "Riding bicycles"
});
```

```handlebars
User: {{view.firstName}} {{view.lastName}}
{{view App.InfoView}}
```

```handlebars
<b>Posts:</b> {{view.posts}}
<br>
<b>Hobbies:</b> {{view.hobbies}}
```

If we were to create an instance of `App.UserView` and render it, we would get
a DOM representation like this:

如果我们想要创建一个`App.UserView`的实例并渲染它，我们会得到如下的`DOM`表示方法：

```html
User: Albert Hofmann
<div>
  <b>Posts:</b> 25
  <br>
  <b>Hobbies:</b> Riding bicycles
</div>
```

#### 相对路径 (Relative Paths)

Instead of specifying an absolute path, you can also specify which view class
to use relative to the parent view. For example, we could nest the above view
hierarchy like this:

你可以声明哪个视图类使用相对的父视图而不是声明一个绝对路径。例如，我们可以像这样嵌套上面的视图层次结构：

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

When nesting a view class like this, make sure to use a lowercase
letter, as Ember will interpret a property with a capital letter as a
global property.

当以这种形式组织视图类时，要确保使用小写字母，因为`Ember`会把以大写字母开头的属性解释为全局属性。

### 设置子视图模板 (Setting Child View Templates)

If you'd like to specify the template your child views use inline in
the main template, you can use the block form of the `{{view}}` helper.
We might rewrite the above example like this:

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

When you do this, it may be helpful to think of it as assigning views to
portions of the page. This allows you to encapsulate event handling for just
that part of the page.

当你这么做的时候，把它想象成将视图应用到页面上的一部分的会更容易理解。这可以允许你只为页面中的那一部分封装事件处理器。