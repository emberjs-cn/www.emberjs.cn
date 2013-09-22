英文原文：[http://emberjs.com/guides/controllers/dependencies-between-controllers/](http://emberjs.com/guides/controllers/dependencies-between-controllers/)

## 管理控制器间的依赖（Managing Dependencies Between Controllers）

Sometimes, especially when nesting resources, we find ourselves needing
to have some kind of connection between two controllers. Let's take this
router as an example:

有时候，特别是在嵌套资源时，可能需要为两个控制器建立某种联系。以下面的路由为例：

```javascript
App.Router.map(function() {
  this.resource("post", { path: "/posts/:post_id" }, function() {
    this.resource("comments", { path: "/comments" });
  });
});
```

If we visit a `/posts/1/comments` URL, our `Post` model will get
loaded into a `PostController`'s model, which means it is not directly
accessible in the `CommentsController`. We might however want to display
some information about it in the `comments` template.

如果访问`/posts/1/comments`这个URL，`Post`模型会被设置为`PostController`的模型，其不可以在`CommentsController`中直接引用。然而又需要在`comments`模板中显示一些与其相关的信息。

To be able to do this we define our `CommentsController` to `need` the
`PostController`
which has our desired `Post` model.

为了实现这个功能，可以在`CommentsController`中声明其需要一个代表`Post`模型的`PostController`。

```javascript
App.CommentsController = Ember.ArrayController.extend({
  needs: "post"
});
```

This tells Ember that our `CommentsController` should be able to access
its parent `PostController`, which can be done via `controllers.post`
(either in the template or in the controller itself).

这里告诉`Ember`，`CommentsController`应该能通过`controllers.post`来访问其父控制器`PostController`。（在模板和控制器中均可访问）。

```handlebars
<h1>Comments for {{controllers.post.title}}</h1>

<ul>
  {{#each comments}}
    <li>{{text}}</li>
  {{/each}}
</ul>
```

We can also create a binding to give ourselves a shorter way to access
the `PostController` (since it is an `ObjectController`, we don't need or
want the `Post` instance directly).

通过创建一个绑定，可以提供一种更为简便的方式来访问`PostController`（因为`PostController`是一个`ObjectController`，这里并不直接需要一个`Post`实例）。

```javascript
App.CommentsController = Ember.ArrayController.extend({
  needs: "post",
  post: Ember.computed.alias("controllers.post")
});
```

For more information about bindings, see the API docs for
+`Ember.Binding`.

更多关于绑定的信息，请查看API中的`Ember.Binding`。
