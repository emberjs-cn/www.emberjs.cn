英文原文: [http://emberjs.com/guides/routing/specifying-a-routes-model/](http://emberjs.com/guides/routing/specifying-a-routes-model/)

## 指定路由的模型 （Specifying a Route's Model）

Templates in your application are backed by models. But how do templates
know which model they should display?

应用中的模板背后是由模型来支撑的。那么模板时如何知道需要显示哪些模型的呢？

For example, if you have a `photos` template, how does it know which
model to render?

例如，如果有一个`photos`模板，那么它是如何知道应该渲染哪一个模型的呢？

This is one of the jobs of an `Ember.Route`. You can tell a template
which model it should render by defining a route with the same name as
the template, and implementing its `model` hook.

这正是`Ember.Route`的工作之一。通过定义一个与模板同名的，并实现其`model`方法的路由，是一种指定模板需要渲染的模型的方法。

For example, to provide some model data to the `photos` template, we
would define an `App.PhotosRoute` object:

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

### Asynchronously Loading Models

### 异步加载的模型
 
In the above example, the model data was returned synchronously from the
`model` hook. This means that the data was available immediately and
your application did not need to wait for it to load, in this case
because we immediately returned an array of hardcoded data.

在上述例子中，模型数据在`model`钩子中是被同步返回的。也就是说数据是立即可用的，应用不需要花时间等待数据加载，例子中`model`钩子里面直接返回了硬编码的一组数据。

Of course, this is not always realistic. Usually, the data will not be
available synchronously, but instead must be loaded asynchronously over
the network. For example, we may want to retrieve the list of photos
from a JSON API available on our server.

当然这与实际的情况并不总是吻合。更常见的是数据并不是同步的，而是需要通过网络异步加载。例如，可能需要通过一个服务端的JSON API来获取照片列表。

In cases where data is available asynchronously, you can just return a
promise from the `model` hook, and Ember will wait until that promise is
resolved before rendering the template.

在数据是异步加载时，在`model`钩子里面只需要返回一个承诺，Ember就会等待承诺履行后才开始渲染模板。

If you're unfamiliar with promises, the basic idea is that they are
objects that represent eventual values. For example, if you use jQuery's
`getJSON()` method, it will return a promise for the JSON that is
eventually returned over the network. Ember uses this promise object to
know when it has enough data to continue rendering.

如果对承诺不属性，可以姑且将其认为承诺就是代表了最终加载的数据的对象。例如，使用jQuery的`getJSON`方法，该方法就返回一个代表最终从网络加载的JSON的承诺。Ember使用这个承诺对象知道何时拥有了足够用来渲染的数据。

For more about promises, see [A Word on
Promises](/guides/routing/asynchronous-routing/#toc_a-word-on-promises)
in the Asynchronous Routing guide.

更多关于承诺的详细介绍，请参看异步路由指南中的[关于承诺](/guides/routing/asynchronous-routing/#toc_a-word-on-promises)部分。

Let's look at an example in action. Here's a route that loads the most
recent pull requests sent to Ember.js on GitHub:

下面看一个实际的例子。这里有一个从GitHub商获取最近的Ember.js的PR的路由：

```js
App.PullRequestsRoute = Ember.Route.extend({
  model: function() {
    return Ember.$.getJSON('https://api.github.com/repos/emberjs/ember.js/pulls');
  }
});
```
 
While this example looks like it's synchronous, making it easy to read
and reason about, it's actually completely asynchronous. That's because
jQuery's `getJSON()` method returns a promise. Ember will detect the
fact that you've returned a promise from the `model` hook, and wait
until that promise resolves to render the `pullRequest` template.

为了使得代码更加易读，这个例子看上去跟同步的没有什么两样，但是实际上它是异步完成的。这是因为jQuery的`getJSON()`方法返回了一个承诺。Ember会检测到`model`钩子返回的是一个承诺，然后一直等待直至承诺被履行时才渲染`pullRequest`模板。

(For more information on jQuery's XHR functionality, see
[jQuery.ajax](http://api.jquery.com/jQuery.ajax/) in the jQuery
documentation.)

（更多关于jQuery的XHR函数，请查看jQuery文档[jQuery.ajax](http://api.jquery.com/jQuery.ajax/)。）

Because Ember supports promises, it can work with any persistence
library that uses them as part of its public API. You can also use many
of the conveniences built in to promises to make your code even nicer.

因为Ember支持承诺，这使得Ember可以与所有采用承诺作为公共API一部分的持久化库一起工作。此外，利用关于承诺的内置惯例，还可以让代码变得更加清晰。

For example, imagine if we wanted to modify the above example so that
the template only displayed the three most recent pull requests. We can
rely on promise chaining to modify the data returned from the JSON
request before it gets passed to the template:

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

### Setting Up Controllers with the Model

### 使用模型设置控制器

So what actually happens with the value you return from the `model`
hook?

`model`钩子返回的数据上到底发生了些什么呢？

By default, the value returned from your `model` hook will be assigned
to the `model` property of the associated controller. For example, if your
`App.PostsRoute` returns an object from its `model` hook, that object
will be set as the `model` property of the `App.PostsController`.

在默认情况下，`model`钩子返回的值，会设置为关联的控制器的`model`属性。例如，如果`App.PostsRoute`通过`model`钩子返回了一个对象，这个对象会设置为`App.PostsController`的`model`属性。

(This, under the hood, is how templates know which model to render: they
look at their associated controller's `model` property. For example, the
`photos` template will render whatever the `App.PhotosController`'s
`model` property is set to.)

（模板是如何知道该使用哪个模型进行渲染的呢？模板通过查找其关联的控制器的`model`属性来进行渲染。例如，`photos`模板将会使用`App.PhotosController`的`model`属性来进行渲染。）

See the [Setting Up a Controller guide][1] to learn how to change this
default behavior. Note that if you override the default behavior and do
not set the `model` property on a controller, your template will not
have any data to render!

查看[设置控制器指南][1]一节，可以知道如何改变这个缺省行为。注意，如果重写了这一缺省行为，且未给控制器设置`model`属性，那么模板就无法获得用来渲染的数据。

[1]: /guides/routing/setting-up-a-controller

### 动态模型（Dynamic Models）

Some routes always display the same model. For example, the `/photos`
route will always display the same list of photos available in the
application. If your user leaves this route and comes back later, the
model does not change.

有的路由总是显示相同的模型。例如，`/photos`路由将总是显示应用中所有照片的列表。用户离开该路由，然后再回来这个模型也不会发生改变。

However, you will often have a route whose model will change depending
on user interaction. For example, imagine a photo viewer app. The
`/photos` route will render the `photos` template with the list of
photos as the model, which never changes. But when the user clicks on a
particular photo, we want to display that model with the `photo`
template. If the user goes back and clicks on a different photo, we want
to display the `photo` template again, this time with a different model.

然而，有的路由却需要根据用户的交互来显示不同的模型。例如，照片浏览器应用。`/photos`路由将使用照片列表作为模型来渲染`photos`模板，这个模型不会改变。但是当用户点击一个特定的照片，那么需要在`photo`模板中显示被选定的照片。如果用户回头点击另外一张不同的照片，这时需要一个不同的模型来渲染`photo`模板。

In cases like this, it's important that we include some information in
the URL about not only which template to display, but also which model.

在这种情况下，需要在URL中不仅包含要渲染哪一个模板，还要知道使用哪一个模型。

In Ember, this is accomplished by defining routes with _dynamic segments_.

在Ember中，通过_动态段_来定义路由可以完成该任务。

A dynamic segment is a part of the URL that is filled in by the current
model's ID. Dynamic segments always start with a colon (`:`). Our photo
example might have its `photo` route defined like this:

一个动态段是URL的一部分，动态段最终将被模型的ID取代。动态段的定义以分号(`:`)开始。照片例子中`photo`路由可以如下所示进行定义：

```js
App.Router.map(function() {
  this.resource('photo', { path: '/photos/:photo_id' });
});
```

In this example, the `photo` route has a dynamic segment `:photo_id`.
When the user goes to the `photo` route to display a particular photo
model (usually via the `{{link-to}}` helper), that model's ID will be
placed into the URL automatically.

在上例中，`photo`路由有一个动态段`:photo_id`。当用户进入`photo`路由来显示一个特定的照片模型时（通常是通过`{{link-to}}`助手），模型的ID会被自动的添加到URL中。

See [Links](/guides/templates/links) for more information about linking
to a route with a model using the `{{link-to}}` helper.

查看[链接](/guides/templates/links)可以查看更多关于使用`{{link-to}}`助手，传递一个模型，然后链接到指定路由。

For example, if you transitioned to the `photo` route with a model whose
`id` property was `47`, the URL in the user's browser would be updated
to:

例如，如果使用一个`id`属性值为`47`的模型，过渡到`photo`路由，那么在用户浏览器中的URL会更新为：

```
/photos/47
```

What happens if the user visits your application directly with a URL
that contains a dynamic segment? For example, they might reload the
page, or send the link to a friend, who clicks on it. At that point,
because we are starting the application up from scratch, the actual
JavaScript model object to display has been lost; all we have is the ID
from the URL.

那么如果用户直接通过浏览器输入一个包含动态段的URL会发生什么呢？例如，用户可能重新加载页面，或者发送一个链接给朋友等。这时，由于应用是重新启动的，用于显示的Javascript模型对象已经不存在，所能得到的就只有模型的ID。

Luckily, Ember will extract any dynamic segments from the URL for
you and pass them as a hash to the `model` hook as the first argument:

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
 
In the `model` hook for routes with dynamic segments, it's your job to
turn the ID (something like `47` or `post-slug`) into a model that can
be rendered by the route's template. In the above example, we use the
photo's ID (`params.photo_id`) to construct a URL for the JSON
representation of that photo. Once we have the URL, we use jQuery to
return a promise for the JSON model data.

在有动态段的路由的`model`钩子中，需要通过传入的ID（比如`47`或者`post-slug`），转换为需要用来渲染模板的模型。在上面的例子中，使用了照片的ID（`params.photo_id`）来构造一个URL，来获取照片的JSON格式表示。一旦有了URL，就可以使用jQuery来获取一个表示JSON模型数据的一个承诺。

Note: A route with a dynamic segment will only have its `model` hook called
when it is entered via the URL. If the route is entered through a transition
(e.g. when using the [link-to][2] Handlebars helper), then a model context is
already provided and the hook is not executed. Routes without dynamic segments
will always execute the model hook.

注意：一个具有动态段的路由只有在通过URL访问的时候，`model`钩子才会被调用。如果路由是从一个跳转进入的（例如：使用Handlebars的[link-to][2]助手时），模型上下文已经准备好了，因此`model`钩子这时不会被执行。没有动态段的路由其`model`钩子每次都会被执行。

[2]: /guides/templates/links

### Ember Data

### Ember Data

Many Ember developers use a model library to make finding and saving
records easier than manually managing Ajax calls. In particular, using a
model library allows you to cache records that have been loaded,
significantly improving the performance of your application.

许多Ember开发者都会使用一个模型库来处理查询、保存记录，这样比手动处理AJAX调用要简单很多。特别是使用一个可以缓存已经加载记录的模型库，会大大提升应用的性能。

One popular model library built for Ember is Ember Data. To learn more
about using Ember Data to manage your models, see the
[Models](/guides/models) guide.

为Ember定制的一个流行的模型库是Ember Data。需要了解更多关于使用Ember
Data来管理模型的内容，可以查看[模型](/guides/models/)指南一章。
