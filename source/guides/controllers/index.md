英文原文:[http://emberjs.cn/guides/controllers](http://emberjs.cn.guides/controllers)

## 控制器(Controllers)

A controller may have one or both of these responsibilities:

一个控制器会有很多职能。但它应该至少包括下面的一个或着二个：

* Representing a model for a template.
* 一个模板能体现出一个模型的数据结构
* Storing application properties that do not need to be saved to the server.
* 应用程序的属性存储不需要发送到服务器


Most of your controllers will be very small. Unlike other
frameworks, where the state of your application is spread amongst many
controllers, in Ember.js, we encapsulate that state in the router. This
allows your controllers to be lightweight and focused on one thing.

或许你的大多数控制器并不是很大。在其它框架下，你的应用程序状态会在不同控制器之间不停传播，而在Ember.js下，我们能通过路由来封装其状态进而传播。这么做可以让你的控制器专注于某一单一事件和达到控制器的轻量级。

### 体现模型结构(Representing Models)

Templates are always connected to controllers, not models. This makes it
easy to separate display-specific properties from model-specific
properties.

和控制器始终保持连接的是模板而不是模型。这使得控制器控制模板要单独显示模型中某一特定属性是很容易的。

Often, however, it is convenient for your templates to be able to
retrieve properties directly from a model. Ember.js makes this easy with
`Ember.ObjectController` and `Ember.ArrayController`.

通常，这样会让模板很容易的检索到相应模型中的属性。Ember.js使得
`Ember.ObjectController` 与`Ember.ArrayController`更容易联系起来。 

### 应用程序的存储性能 (Storing Application Properties)

Often, your application will need to store information that does not
belong in the model. Any time you need to save information that does not
need to be persisted to the server, you should put it in a controller.

通常，你的应用程序是需要一个store来存储信息而不是一个模型。有时候，你需要将数据保存到本地而不是服务器就可以通过控制器来实现。

For example, imagine your application has a search field that is always
present. You would have a `SearchController` with a `query` property, to
which the search field would be bound.

例如，现在你的应用程序中有一个搜索功能。它有一个`SearchController`和`query`属性，通过搜索控制器和查询字段的绑定实现搜索功能。

If your user wants to search, she would type her query in the search
field, then hit the enter key.

如果你的用户想要搜索，他应该将要搜索的字段输入到搜索框然后按下enter键

When your router initiates the query to the server, it should retrieve
the current query from the `SearchController`, instead of trying to
retrieve it from the search field.

这样查询请求将通过路由器发送到服务器，它会通过检索当前的`SearchController`进行查询，而不是检索当前字段进行查询。

