英文原文： [http://emberjs.com/guides/templates/links/](http://emberjs.com/guides/templates/links/)

## Links (The `{{linkTo}}` Helper)

## 链接 (`{{linkTo}}`助手)

You create a link to a route using the `{{linkTo}}` helper.

你可以使用如下的方式创建一个指向一个路由的链接：

```js
App.Router.map(function() {
  this.resource("photos", function(){
    this.route("edit", { path: "/:photo_id" });
  });
});
```

```handlebars
<!-- photos.handlebars -->

<ul>
{{#each photo in photos}}
  <li>{{#linkTo photos.photo photo}}{{photo.title}}{{/linkTo}}</li>
{{/each}}
</ul>
```

If the model for the `photos` template is a list of three photos, the
rendered HTML would look something like this:

如果`photos`模板对应的模型拥有三张照片，那么，被渲染的HTML内容将如下所示：

```html
<ul>
  <li><a href="/photos/1">Happy Kittens</a></li>
  <li><a href="/photos/2">Puppy Running</a></li>
  <li><a href="/photos/3">Mountain Landscape</a></li>
</ul>
```

When the rendered link matches the current route, and the same object instance is passed into the helper, then the link is given `class="active"`.

当被渲染的链接与当前路由匹配时，并且传入{{linkTo}}助手的是相同的对象实例，那么链接的class被设置为active。

The `{{linkTo}}` helper takes:

* The name of a route. In this example, it would be `index`, `photos`, or
  `eidt`.
* If the route has a [dynamic segment](/guides/routing/defining-your-routes/#toc_dynamic-segments), 
  a model that represents the segment. By default, Ember.js will replace the segment with the
  value of the object's `id` property.
* An optional title which will be bound to the `a` title attribute

`{{linkTo}}`助手可以接收以下三个参数：

* 路由名称。在上面例子中，可以是`index`, `photos`或者 `edit`。
* 如果某个路由含有
  [动态段](/guides/routing/defining-your-routes/#toc_dynamic-segments),且有一个模型表示这个段。那么，默认情况下，`Ember.js`将会使用对象的`id`属性的值替换这个动态段。
* 此外，我们也可以提供一个链接名称绑定到`a`标签的`title`属性。

### Multiple Contexts

### 多个上下文

If the route is nested, you can supply a model for each dynamic
segment.

如果多个路由是互相嵌套的，那么你可以为每个动态段提供一个模型，如下所示：

```js
App.Router.map(function() {
  this.resource("photos", function(){
    this.resource("photo", { path: "/:photo_id" }, function(){
      this.route("comments");
      this.route("comment", { path: "/comments/:comment_id" });
    });
  });
});
```

In the `photoIndex` template:

`photoIndex`模板中的内容如下：

```handlebars
<div class="photo">
  {{body}}
</div>

<p>{{#linkTo photo.comment primaryComment}}Main Comment{{/linkTo}}</p>
```

Since only a single model was supplied, the link will inherit the
current photo for the dynamic segment `:photo_id`. The `primaryComment`
will become the new model for the `comment` route handler.

因为我们只提供了一个模型，所以链接将会使用当前照片的id作为动态段`:photo_id`的值。而`primaryComment`将成为`comment`路由处理器的新模型。

Alternatively, you could pass both a photo and a comment to the helper:

此外，你还可以同时给`{{linkTo}}`助手指定一张照片和一条评论，如下所示：

```handlebars
<p>
  {{#linkTo photo.comment nextPhoto primaryComment}}
    Main Comment for the Next Photo
  {{/linkTo}}
</p>
```

In this case, the models specified will populate both the `:photo_id`
and `:comment_id`. The specified `nextPhoto` will become the new
model for the `photo` handler and the `primaryComment` will become the
new model for the `comment` handler.

在这个例子中，指定的模型将同时提供`:photo_id`和`:comment_id`。指定的`nextPhoto`将称为`photo`路由处理器的新模型，同时，`primaryComment`将成为`comment`路由处理器的新模型。

When transitioning to a new URL, the router will only execute the
handler if:

* the handler became newly active, or
* the model for the handler changes

如果要链接到一个新的URL地址，在下面两种情况下，路由将只执行它的处理器：

* 处理器最近被激活，或者
* 路由处理器的模型发生了变化
