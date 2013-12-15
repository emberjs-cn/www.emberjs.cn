英文原文：[http://emberjs.com/guides/models/](http://emberjs.com/guides/models/)

## 模型

In Ember, every route has an associated model. This model is set by
implementing a route's `model` hook, by passing the model as an argument
to `{{link-to}}`, or by calling a route's `transitionTo()` method.

在Ember中，每个路由都有与之相关联的一个模型。这个模型通过路由的`model`钩子进行设置，可以是通过`{{link-to}}`传入的一个参数，也可以是调用路由的`transitionTo()`方法。

See [Specifying a Route's Model](/guides/routing/specifying-a-routes-model) for more information
on setting a route's model.

查看[指定一个路由的模型](/guides/routing/specifying-a-routes-model)可以获取关于设置路由模型的更多信息。

For simple applications, you can get by using jQuery to load JSON data
from a server, then use those JSON objects as models.

对于简单的应用来说，可以通过jQuery来从服务器加载JSON数据，并将这些数据对象作为模型。

However, using a model library that manages finding models, making
changes, and saving them back to the server can dramatically simplify
your code while improving the robustness and performance of your
application.

但是，使用一个模型库来管理查询、更改和将更改保存会服务器，将能大大的简化代码，也能提升应用的健壮性和性能。

Many Ember apps use [Ember Data][emberdata] to handle this.
Ember Data is a library that integrates tightly with Ember.js to make it
easy to retrieve records from a server, cache them for performance,
save updates back to the server, and create new records on the client.

许多Ember应用使用[Ember Data][emberdata]来这里模型。Ember
Data是一个与Ember.js紧密结合在一起，简化了客户端从服务器获取记录，在本地进行缓存，保存修改到服务器，创建新的记录等一系列的操作。

Without any configuration, Ember Data can load and save records and
their relationships served via a RESTful JSON API, provided it follows certain
conventions.

Ember Data不需要进行任何配置，就可以实现通过服务端提供的RESTful JSON
API加载和保存记录以及它们的管理关系，这些操作都遵从于特定的惯例。

If you need to integrate your Ember.js app with existing JSON APIs that
do not follow strong conventions, Ember Data is designed to be easily
configurable to work with whatever data your server returns.

如果需要将Ember.js应用与现有的、未遵从惯例的JSON APIs进行集成，Ember
Data也进行了充分的设计，通过简单的配置就可以实现使用服务端返回的数据。

Ember Data is also designed to work with streaming APIs like
socket.io, Firebase, or WebSockets. You can open a socket to your server
and push changes to records into the store whenever they occur.

Ember
Data同样适用于使用基于流的API，例如socket.io、Firebase或WebSockets。通过建立一个与服务器端的Socket连接，在记录发生变化的时候，将这些变更推送到本地仓库中（Store）。

Currently, Ember Data ships as a separate library from Ember.js. Until Ember Data is included
as part of the standard distribution, you can get your copy of the latest
passing build from [builds.emberjs.com][builds]:

目前，Ember Data还是作为Ember.js的一个独立的库。在Ember Data被作为标准配置的一部分之前，你可以从其[builds.emberjs.com][builds]下载最新的版本。

* [Development][development-build]
* [Minified][minified-build]
 
[emberdata]: https://github.com/emberjs/data
[builds]: http://emberjs.com/builds
[development-build]: http://builds.emberjs.com/canary/ember-data.js
[minified-build]: http://builds.emberjs.com/canary/ember-data.min.js

### Core Concepts

### 核心概念

Learning to use Ember Data is easiest once you understand some of the
concepts that underpin its design.

在理解了Ember Data设计的一些核心概念后，学习它就变得相对较为容易了。

#### Store

#### 仓库

The **store** is the central repository of records in your application.
You can think of the store as a cache of all of the records available in
your app. Both your application's controllers and routes have access to this
shared store; when they need to display or modify a record, they will
first ask the store for it.

**仓库**是应用用于存放记录的中心仓库。可以认为仓库是应用的所有数据的一个缓存。应用的控制器和路由都可以访问这个共享的仓库；当它们需要显示或者修改一个记录时，首先就需要访问仓库。

This instance of `DS.Store` is created for you automatically and is shared
among all of the objects in your application.

`DS.Store`的实例会被自动创建，并且该实例被应用中所有的对象所共享。

You will use the store to retrieve records, as well to create new ones.
For example, we might want to find an `App.Person` model with the ID of
`1` from our route's `model` hook:

可以使用该实例来获取记录，创建新的记录等。例如，需要在路由的`model`钩子中查找一个类型为`App.Person`，ID为`1`的记录：

```js
App.IndexRoute = Ember.Route.extend({
  model: function() {
    return this.store.find('person', 1);
  }
});
```

#### Models

#### 模型

A **model** is a class that defines the properties and behavior of the
data that you present to the user. Anything that the user expects to see
if they leave your app and come back later (or if they refresh the page)
should be represented by a model.

**模型**是一个类，它定义了需要呈现给用户的数据的属性和行为。任何用户期望在其离开应用或者回到应用时应该可见的数据，都应该通过一个模型来表示。

For example, if you were writing a web application for placing orders at
a restaurant, you might have models like `Order`, `LineItem`, and
`MenuItem`.

例如，如果正在编写一个可以给饭店下单的Web应用，那么这个应用中应该包含`Order`、`LineItem`和`MenuItem`这样的模型。

Fetching orders becomes very easy:

获取订单就变得非常的容易：

```js
this.store.find('order');
```

Models define the type of data that will be provided by your server. For
example, a `Person` model might have a `firstName` attribute that is a
string, and a `birthday` attribute that is a date:

模型定义了服务器提供的数据的类型。例如`Person`模型可能包含一个名为`firstName`的字符串类型的属性，还有一个名为`birthday`的日期类型的属性。

```js
App.Person = DS.Model.extend({
  firstName: DS.attr('string'),
  birthday:  DS.attr('date')
});
```

A model also describes its relationships with other objects. For
example, an `Order` may have many `LineItems`, and a `LineItem` may
belong to a particular `Order`.

模型也声明了其与其他对象的关系。例如，一个`Order`可以有许多`LineItems`，一个`LineItem`可以属于一个特定的`Order`。

```js
App.Order = DS.Model.extend({
  lineItems: DS.belongsTo('lineItem')
});

App.LineItem = DS.Model.extend({
  orders: DS.hasMany('order')
});
```

Models don't have any data themselves; they just define the properties and
behavior of specific instances, which are called _records_.

模型本身没有任何数据；模型只定义了其实例所具有的属性和行为，而这些实例被称为_记录_。

#### Records

#### 记录

A **record** is an instance of a model that contains data loaded from a
server. Your application can also create new records and save them back
to the server.

**记录**是模型的实例，包含了从服务器端加载而来的数据。应用本身也可以创建新的记录，并将新记录保存到服务器端。

Records are uniquely identified by two things:

记录由以下两个属性来唯一标识：

1. A model type.
2. A globally unique ID.

1. 模型类型
2. 一个全局唯一的ID

For example, if you were writing a contact management app, you might
have a model called `Person`. An individual record in your app might
have a type of `Person` and an ID of `1` or `steve-buscemi`.

例如，如果正在编写一个联系人管理的应用，有一个模型名为`Person`。那么在应用中，可能存在一个类型为`Person`，ID为`1`或者`steve-buscemi`的记录。

```js
this.store.find('person', 1); // => { id: 1, name: 'steve-buscemi' }
```

IDs are usually assigned by the server when you save them for the first
time, but you can also generate IDs client-side.

ID通常是在服务器端第一次创建记录的时候设定的，当然也可以在客户端生成ID。

#### Adapter

#### 适配器

An **adapter** is an object that knows about your particular server
backend and is responsible for translating requests for and changes to
records into the appropriate calls to your server.

**适配器**是一个知道特定的服务器后端的对象，主要负责将记录的变更转换为服务器端定义的接口类型，然后发送请求给服务器端。

For example, if your application asks for a `person` record with an ID
of `1`, how should Ember Data load it? Is it over HTTP or a WebSocket?
If it's HTTP, is the URL `/person/1` or `/resources/people/1`?

例如，如果应用需要一个ID为`1`的`person`记录，那么Ember Data是如何加载这个对象的呢？是通过HTTP，还是Websocket？如果是通过HTTP，那么URL会是`/person/1`，还是`/resources/people/1`呢？

The adapter is responsible for answering all of these questions.
Whenever your app asks the store for a record that it doesn't have
cached, it will ask the adapter for it. If you change a record and save
it, the store will hand the record to the adapter to send the
appropriate data to your server and confirm that the save was
successful.

适配器负责处理类似以上的所有问题。无论何时，当应用需要从仓库中获取一个没有被缓存的记录时，应用就会访问适配器来获取这个记录。如果改变了一个记录并准备保存改变时，仓库会将记录传递给适配器，然后由适配器负责将数据发送给服务器端，并确认保存是否成功。

#### Serializer

#### 序列化

A **serializer** is responsible for turning a raw JSON payload returned
from your server into a record object.

序列化主要负责将服务器端返回的原生JSON数据序列化为记录对象。

JSON APIs may represent attributes and relationships in many different
ways. For example, some attribute names may be `camelCased` and others
may be `under_scored`. Representing relationships is even more diverse:
they may be encoded as an array of IDs, an array of embedded objects, or
as foreign keys.

JSON API可能将属性、关联关系用不同的方式表示。例如，一些属性名可能采用了`驼峰式`命名规则，而另一些又使用了`下划线隔离`的命名规则。关联关系的表示方法更是五花八门：它们有可能会是一个ID数组，一个内嵌的对象集合，也可能是外键。

When the adapter gets a payload back for a particular record, it will
give that payload to the serializer to normalize into the form that
Ember Data is expecting.

当适配器从服务器端获取到一个特定记录的数据时，它将数据交给序列化对象，进而将数据转换为Ember Data期望的格式。

While most people will use a serializer for normalizing JSON, because
Ember Data treats these payloads as opaque objects, there's no reason
they couldn't be binary data stored in a `Blob` or
[ArrayBuffer](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Typed_arrays/ArrayBuffer).

大部分人都需要使用序列化来完成JSON数据的转换，因为Ember
Data将这些数据作为非透明的对象来处理，它们可能是以二进制数据被存储的，也可能是[ArrayBuffer](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Typed_arrays/ArrayBuffer)。

#### Automatic Caching

#### 自动化缓存

The store will automatically cache records for you. If a record had already
been loaded, asking for it a second time will always return the same
object instance. This minimizes the number of round-trips to the
server, and allows your application to render UI to the user as fast as
possible.

仓库会自动缓存记录。如果一个记录已经被加载了，那么再次访问它的时候，会返回同一个对象实例。这样大大减少了与服务器端的通信，使得应用可以更快的为用户渲染所需的UI。

For example, the first time your application asks the store for a
`person` record with an ID of `1`, it will fetch that information from
your server.

例如，应用第一次从仓库中获取一个ID为`1`的`person`记录时，将会从服务器端获取对象的数据。

However, the next time your app asks for a `person` with ID `1`, the
store will notice that it had already retrieved and cached that
information from the server. Instead of sending another request for the
same information, it will give your application the same record it had
provided it the first time.  This feature—always returning the same
record object, no matter how many times you look it up—is sometimes
called an _identity map_.

但是，当应用再次需要ID为`1`的`person`记录时，仓库会发现这个记录已经获取到了，并且缓存了该记录。那么仓库就不会再向服务器端发送请求去获取记录的数据，而是直接返回第一次时候获取到并构造出来的记录。这个特性使得不论请求这个记录多少次，都会返回同一个记录对象，这也被称为_Identity Map_

Using an identity map is important because it ensures that changes you
make in one part of your UI are propagated to other parts of the UI. It
also means that you don't have to manually keep records in sync—you can
ask for a record by ID and not have to worry about whether other parts
of your application have already asked for and loaded it.

使用标识符映射非常重要，因为这样确保了在一个UI上对一个记录的修改会自动传播到UI其他使用到该记录的UI。这样意味着不要手动去保持对象的同步，只需要使用ID来获取应用已经获取到的记录就可以了。

### Architecture Overview

### 架构简介

The first time your application asks the store for a record, the store
sees that it doesn't have a local copy and requests it from your
adapter. Your adapter will go and retrieve the record from your
persistence layer; typically, this will be a JSON representation of the
record served from an HTTP server.

应用第一次从仓库获取一个记录时，仓库会发现本地缓存并不存在一份被请求的记录的副本，这时会向适配器发请求。适配器将从持久层去获取记录；通常情况下，持久层都是一个HTTP服务，通过该服务可以获取到记录的一个JSON表示。

![Diagram showing process for finding an unloaded record](/images/guides/models/finding-unloaded-record-step1-diagram.png)

![未加载记录查询流程图](/images/guides/models/finding-unloaded-record-step1-diagram.png)

As illustrated in the diagram above, the adapter cannot always return the 
requested record immediately. In this case, the adapter must make an 
_asynchronous_ request to the server, and only when that request finishes 
loading can the record be created with its backing data.

如上图所示，适配器有时不能立即返回请求的记录。这时适配器必须向服务器发起一个_异步_的请求，当请求完成加载后，才能通过返回的数据创建请求的记录。

Because of this asynchronicity, the store immediately returns a
_promise_ from the `find()` method. Similarly, any requests that the
store makes to the adapter also return promises.

由于存在这样的异步性，仓库会从`find()`方法立即返回一个_承诺_。另外，所有请求需要仓库与适配器发生交互的话，都会返回承诺。

Once the request to the server returns with a JSON payload for the
requested record, the adapter resolves the promise it returned to the
store with the JSON.

一旦发给服务器端的请求返回被请求记录的JSON数据时，适配器会履行承诺，并将JSON传递给仓库。

The store then takes that JSON, initializes the record with the
JSON data, and resolves the promise returned to your application
with the newly-loaded record.

仓库这时就获取到了JSON，并使用JSON数据完成记录的初始化，并使用新加载的记录来履行已经返回到应用的承诺。

![Diagram showing process for finding an unloaded record after the payload has returned from the server](/images/guides/models/finding-unloaded-record-step2-diagram.png)

![未加载记录查询流程图 - 服务器返回数据后](/images/guides/models/finding-unloaded-record-step2-diagram.png)

Let's look at what happens if you request a record that the store
already has in its cache. 

下面将介绍一下当仓库已经缓存了请求的记录时会发生什么。

![Diagram showing process for finding an unloaded record after the payload has returned from the server](/images/guides/models/finding-loaded-record-diagram.png)

![已加载记录查询流程图](/images/guides/models/finding-loaded-record-diagram.png)

In this case, because the store already knew about the record, it
returns a promise that it resolves with the record immediately. It does
not need to ask the adapter (and, therefore, the server) for a copy
since it already has it saved locally.

在这种情形下，仓库已经缓存了请求的记录，不过它也将返回一个承诺，不同的是，这个承诺将会立即使用缓存的记录来履行。此时，由于仓库已经有了一份拷贝，所以不需要向适配器去请求（没有与服务器发生交互）。

---

These are the core concepts you should understand to get the most out of
Ember Data. The following sections go into more depth about each of
these concepts, and how to use them together.

以上是理解Ember Data工作原理的核心概念。下面的章节将一个个的深入讨论这些概念，介绍如何将它们串在一起使用。
