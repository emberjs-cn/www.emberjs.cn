英文原文： [http://emberjs.com/guides/templates/links/](http://emberjs.com/guides/templates/links/)

## 链接 (`{{link-to}}`助手)

你可以使用如下的方式创建一个指向一个路由的链接：

```js
App.Router.map(function() {
  this.resource("photos", function(){
    this.route("edit", { path: "/:photo_id" });
  });
});
```

```handlebars
{{! photos.handlebars }}

<ul>
{{#each photo in photos}}
  <li>{{#link-to 'photos.edit' photo}}{{photo.title}}{{/link-to}}</li>
{{/each}}
</ul>
```

如果`photos`模板对应的模型拥有三张照片，那么，被渲染的HTML内容将如下所示：

```html
<ul>
  <li><a href="/photos/1">Happy Kittens</a></li>
  <li><a href="/photos/2">Puppy Running</a></li>
  <li><a href="/photos/3">Mountain Landscape</a></li>
</ul>
```

当被渲染的链接与当前路由匹配时，并且传入{{link-to}}助手的是相同的对象实例，那么链接的class被设置为active。

`{{link-to}}`助手可以接收以下三个参数：

* 路由名称。在上面例子中，可以是`index`, `photos`或者 `photos.edit`。
* 每个[动态段](/guides/routing/defining-your-routes/#toc_dynamic-segments)最多对应一个模型。默认情况下，Ember.js将使用对应对象的`id`属性来替换动态段。
  如果没有模型可以传给助手，也可以用一个ID值来取代。这个值被用来替换路由的[动态段](/guides/routing/defining-your-routes/#toc_dynamic-segments)，并确保`model`钩子被触发。
* 此外，我们也可以提供一个链接名称绑定到`a`标签的`title`属性。

```handlebars
{{! photos.handlebars }}

{{#link-to 'photo.edit' 1}}
  First Photo Ever
{{/link-to}}
```

### 多动态段示例

如果多个路由是互相嵌套的，那么你可以为每个动态段提供一个模型或者模型标识符，如下所示：

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

```handlebars
{{! photoIndex.handlebars }}

<div class="photo">
  {{body}}
</div>

<p>{{#link-to 'photo.comment' primaryComment}}Main Comment{{/link-to}}</p>
```

如果只指定了一个模型，其将用于代表最内层的动态段`:comment_id`，而`:photo_id`将使用当前的`photo`对象。

此外，你还可以同时给`{{link-to}}`助手指定一张照片和一条评论，如下所示：

```handlebars
<p>
  {{#link-to 'photo.comment' nextPhoto primaryComment}}
    Main Comment for the Next Photo
  {{/link-to}}
</p>
```

在上述示例中，`PhotoRoute`的模型钩子的参数会包含`params.photo_id = 5`。`CommentRoute`的`model`钩子不会执行，因为传入了一个`comment`段的模型对象。评论的ID会根据`CommentRoute`的`serialize`钩子来填写URL。

### 给链接添加附加属性

当生成一个链接时，有时候还需要为其添加附加属性。通过`link-to`助手的附加参数，可以完成该功能：

```handlebars
<p>
  {{link-to 'photo.edit' photo class="btn btn-primary"}}
</p>
```

大部分HTML属性如`class`和`rel`都可以这样来添加。当添加样式类名时，Ember还会添加`ember-view`和可能的`active`样式类。
