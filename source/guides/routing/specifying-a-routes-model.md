英文原文: [http://emberjs.com/guides/routing/specifying-a-routes-model/](http://emberjs.com/guides/routing/specifying-a-routes-model/)

## 指定路由的模型

应用中的模板背后是由模型来支撑的。那么模板时如何知道需要显示哪些模型的呢？

例如，如果有一个`photos`模板，那么它是如何知道应该渲染哪一个模型的呢？

这正是`Ember.Route`的工作之一。通过定义一个与模板同名的，并实现其`model`方法的路由，是一种指定模板需要渲染的模型的方法。

例如，为了给`photos`模板提供一些模型数据，可以定义一个`App.PhotosRoute`对象：

```js
App.PhotosRoute = Ember.Route.extend({
  model: function() {
    return [{
      title: "Tomster",
      url: "http://emberjs.com/images/about/ember-productivity-sm.png"
    }, {
      title: "Eiffel Tower",
      url: "http://emberjs.com/images/about/ember-structure-sm.png"
    }];
  }
});
```

<a class="jsbin-embed" href="http://jsbin.com/oLUTEd/1/embed?js">JS Bin</a><script src="http://static.jsbin.com/js/embed.js"></script>

### 异步加载的模型
 
在上述例子中，模型数据在`model`钩子中是被同步返回的。也就是说数据是立即可用的，应用不需要花时间等待数据加载，例子中`model`钩子里面直接返回了硬编码的一组数据。

当然这与实际的情况并不总是吻合。更常见的是数据并不是同步的，而是需要通过网络异步加载。例如，可能需要通过一个服务端的JSON API来获取照片列表。

在数据是异步加载时，在`model`钩子里面只需要返回一个承诺，Ember就会等待承诺履行后才开始渲染模板。

如果对承诺不属性，可以姑且将其认为承诺就是代表了最终加载的数据的对象。例如，使用jQuery的`getJSON`方法，该方法就返回一个代表最终从网络加载的JSON的承诺。Ember使用这个承诺对象知道何时拥有了足够用来渲染的数据。

更多关于承诺的详细介绍，请参看异步路由指南中的[关于承诺](/guides/routing/asynchronous-routing/#toc_a-word-on-promises)部分。

下面看一个实际的例子。这里有一个从GitHub商获取最近的Ember.js的PR的路由：

```js
App.PullRequestsRoute = Ember.Route.extend({
  model: function() {
    return Ember.$.getJSON('https://api.github.com/repos/emberjs/ember.js/pulls');
  }
});
```
 
为了使得代码更加易读，这个例子看上去跟同步的没有什么两样，但是实际上它是异步完成的。这是因为jQuery的`getJSON()`方法返回了一个承诺。Ember会检测到`model`钩子返回的是一个承诺，然后一直等待直至承诺被履行时才渲染`pullRequest`模板。

（更多关于jQuery的XHR函数，请查看jQuery文档[jQuery.ajax](http://api.jquery.com/jQuery.ajax/)。）

因为Ember支持承诺，这使得Ember可以与所有采用承诺作为公共API一部分的持久化库一起工作。此外，利用关于承诺的内置惯例，还可以让代码变得更加清晰。

例如，假设需要修改上例，让模板只显示最近三个PR。通过采用承诺链，可以在将数据传递给模板之前修改请求返回的JSON。

```js
App.PullRequestsRoute = Ember.Route.extend({
  model: function() {
    var url = 'https://api.github.com/repos/emberjs/ember.js/pulls';
    return Ember.$.getJSON(url).then(function(data) {
      return data.splice(0, 3);
    });
  }
});
```

### 使用模型设置控制器

`model`钩子返回的数据上到底发生了些什么呢？

在默认情况下，`model`钩子返回的值，会设置为关联的控制器的`model`属性。例如，如果`App.PostsRoute`通过`model`钩子返回了一个对象，这个对象会设置为`App.PostsController`的`model`属性。

（模板是如何知道该使用哪个模型进行渲染的呢？模板通过查找其关联的控制器的`model`属性来进行渲染。例如，`photos`模板将会使用`App.PhotosController`的`model`属性来进行渲染。）

查看[设置控制器指南][1]一节，可以知道如何改变这个缺省行为。注意，如果重写了这一缺省行为，且未给控制器设置`model`属性，那么模板就无法获得用来渲染的数据。

[1]: /guides/routing/setting-up-a-controller

### 动态模型

有的路由总是显示相同的模型。例如，`/photos`路由将总是显示应用中所有照片的列表。用户离开该路由，然后再回来这个模型也不会发生改变。

然而，有的路由却需要根据用户的交互来显示不同的模型。例如，照片浏览器应用。`/photos`路由将使用照片列表作为模型来渲染`photos`模板，这个模型不会改变。但是当用户点击一个特定的照片，那么需要在`photo`模板中显示被选定的照片。如果用户回头点击另外一张不同的照片，这时需要一个不同的模型来渲染`photo`模板。

在这种情况下，需要在URL中不仅包含要渲染哪一个模板，还要知道使用哪一个模型。

在Ember中，通过_动态段_来定义路由可以完成该任务。

一个动态段是URL的一部分，动态段最终将被模型的ID取代。动态段的定义以分号(`:`)开始。照片例子中`photo`路由可以如下所示进行定义：

```js
App.Router.map(function() {
  this.resource('photo', { path: '/photos/:photo_id' });
});
```

在上例中，`photo`路由有一个动态段`:photo_id`。当用户进入`photo`路由来显示一个特定的照片模型时（通常是通过`{{link-to}}`助手），模型的ID会被自动的添加到URL中。

查看[链接](/guides/templates/links)可以查看更多关于使用`{{link-to}}`助手，传递一个模型，然后链接到指定路由。

例如，如果使用一个`id`属性值为`47`的模型，过渡到`photo`路由，那么在用户浏览器中的URL会更新为：

```
/photos/47
```

那么如果用户直接通过浏览器输入一个包含动态段的URL会发生什么呢？例如，用户可能重新加载页面，或者发送一个链接给朋友等。这时，由于应用是重新启动的，用于显示的Javascript模型对象已经不存在，所能得到的就只有模型的ID。

幸运的是，Ember会从URL中抽出动态段部分，并将其作为第一个参数，传递给`model`钩子：
 
```js
App.Router.map(function() {
  this.resource('photo', { path: '/photos/:photo_id' });
});
 
App.PhotoRoute = Ember.Route.extend({
  model: function(params) {
    return Ember.$.getJSON('/photos/'+params.photo_id);
  }
});
```
 
在有动态段的路由的`model`钩子中，需要通过传入的ID（比如`47`或者`post-slug`），转换为需要用来渲染模板的模型。在上面的例子中，使用了照片的ID（`params.photo_id`）来构造一个URL，来获取照片的JSON格式表示。一旦有了URL，就可以使用jQuery来获取一个表示JSON模型数据的一个承诺。

注意：一个具有动态段的路由只有在通过URL访问的时候，`model`钩子才会被调用。如果路由是从一个跳转进入的（例如：使用Handlebars的[link-to][2]助手时），模型上下文已经准备好了，因此`model`钩子这时不会被执行。没有动态段的路由其`model`钩子每次都会被执行。

[2]: /guides/templates/links

### Ember Data

许多Ember开发者都会使用一个模型库来处理查询、保存记录，这样比手动处理AJAX调用要简单很多。特别是使用一个可以缓存已经加载记录的模型库，会大大提升应用的性能。

为Ember定制的一个流行的模型库是Ember Data。需要了解更多关于使用Ember
Data来管理模型的内容，可以查看[模型](/guides/models/)指南一章。
