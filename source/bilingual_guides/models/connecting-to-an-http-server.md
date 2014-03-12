If your Ember application needs to load JSON data from an HTTP
server, this guide will walk you through the process of configuring
Ember Data to load records in whatever format your server returns.

如果Ember应用需要从HTTP服务器加载JSON数据，本指南将介绍如何配置Ember Data来从服务器端加载记录，不论服务器返回的数据格式是什么样子。

The store uses an object called an _adapter_ to know how to
communicate over the network. By default, the store will use
`DS.RESTAdapter`, an adapter that communicates with an HTTP server by
transmitting JSON via XHR.

仓库使用了一个称为_适配器_，知道如何通过网络进行通信的对象。默认情况下，仓库会使用`DS.RESTAdapter`，一个可以与HTTP服务器通过XHR进行JSON数据交互的适配器。

This guide is divided into two sections. The first section covers what
the default behavior of the adapter is, including what URLs it will
request records from and what format it expects the JSON to be in.

本指南分为两部分。第一部分介绍适配器的默认行为，包括将从哪些URL获取记录，和期望的JSON格式。

The second section covers how to override these default settings to
customize things like which URLs data is requested from and how the JSON
data is structured.

第二部分介绍如何重新定义这些默认行为，如请求数据的URL和JSON的结构。

### URL Conventions

### URL约定

The REST adapter uses the name of the model to determine what URL to
send JSON to.

REST适配器使用模型的名称来判定将要发送JSON的URL。

For example, if you ask for an `App.Photo` record by ID:

例如，用ID来请求一个`App.Photo`的记录：

```js
App.PhotoRoute = Ember.Route.extend({
  model: function(params) {
    return this.store.find('photo', params.photo_id);
  }
});
```

The REST adapter will automatically send a `GET` request to `/photos/1`.

REST适配器将发送一个`GET`请求到`/photos/1`。

The actions you can take on a record map onto the following URLs in the
REST adapter:

可以在记录上执行的操作，在REST适配器中被映射到如下的URL上：

<table>
  <thead>
    <tr><th>操作</th><th>HTTP Verb</th><th>URL</th></tr>
  </thead>
  <tbody>
    <tr><th>查询</th><td>GET</td><td>/people/123</td></tr>
    <tr><th>查询所有</th><td>GET</td><td>/people</td></tr>
    <tr><th>更新</th><td>PUT</td><td>/people/123</td></tr>
    <tr><th>创建</th><td>POST</td><td>/people</td></tr>
    <tr><th>删除</th><td>DELETE</td><td>/people/123</td></tr>
  </tbody>
</table>

### JSON Conventions

### JSON约定

Given the following models:

给定如下模型：

```js
var attr = DS.attr,
    hasMany = DS.hasMany,
    belongsTo = DS.belongsTo;

App.Post = DS.Model.extend({
  title: attr(),
  comments: hasMany('comment'),
  user: belongsTo('user')
});

App.Comment = DS.Model.extend({
  body: attr()
});
```

Ember Data expects that a `GET` request to `/posts/1` would
return the JSON in the following format:

Ember Data期望一个发送到`/posts/1`请求将返回如下的JSON格式：

```js
{
  "post": {
    "id": 1,
    "title": "Rails is omakase",
    "comments": ["1", "2"],
    "user" : "dhh"
  },

  "comments": [{
    "id": "1",
    "body": "Rails is unagi"
  }, {
    "id": "2",
    "body": "Omakase O_o"
  }]
}
```

### Customizing the Adapter

### 自定义适配器

To customize the REST adapter, define a subclass of `DS.RESTAdapter` and
name it `App.ApplicationAdapter`. You can then override its properties
and methods to customize how records are retrieved and saved.

自定义REST适配器，需要定义一个`DS.RESTAdapter`的子类，并将其命名为`App.ApplicationAdapter`。接下来只需要重新定义它的属性和方法，就可以自定义记录如何加载和保存了。

### Customizing URLs

### 自定义URL

#### URL Prefix

#### URL前缀

If your JSON API lives somewhere other than on the host root,
you can set a prefix that will be added to all requests.

如果JSON API并不在主机的根目录，而是在一个其他的路径下，那么需要为请求设置一个URL前缀。

For example, if you are using a versioned JSON API, a request for a
particular person might go to `/api/v1/people/1`.

例如，在使用了版本化的JSON API时，请求一个特定的`person`可能需要发送请求到`/api/v1/people/1`。

In that case, set `namespace` property to `api/v1`.

这种情况下，需要设置`namespace`属性为`api/v1`。

```js
App.ApplicationAdapter = DS.RESTAdapter.extend({
  namespace: 'api/v1'
});
```

Requests for a `person` with ID `1`  would now go to `/api/v1/people/1`.

现在请求一个ID为`1`的`person`就会发送请求到`/api/v1/people/1`。

#### URL Host

#### URL主机

If your JSON API runs on a different domain than the one serving your
Ember app, you can change the host used to make HTTP requests.

如果JSON API的主机与提供Ember应用服务的主机不同，那么需要修改发送HTTP请求的主机。

Note that in order for this to work, you will need to be using a browser
that supports [CORS](http://www.html5rocks.com/en/tutorials/cors/), and
your server will need to be configured to send the correct CORS headers.

注意为了使其正常工作，需要使用支持[CORS](http://www.html5rocks.com/en/tutorials/cors/)的浏览器，并且服务器需要配置支持发送正确的CORS头。

To change the host that requests are sent to, set the `host` property:

修改请求对应的目标主机，需要设置`host`属性：

```js
App.ApplicationAdapter = DS.RESTAdapter.extend({
  host: 'https://api.example.com'
});
```

Requests for a `person` with ID `1` would now target `https://api.example.com/people/1`.

现在请求一个ID为`1`的`person`就会发送请求到`https://api.example.com/people/1`。

#### Custom HTTP Headers

#### 自定义HTTP头

Some APIs require HTTP headers, e.g. to provide an API key. Arbitrary
headers can be set as key/value pairs on the `RESTAdapter`'s `headers`
property and Ember Data will send them along with each ajax request.

一些API需要指定HTTP头，例如提供一个API密钥。任意键值对HTTP头可以通过`RESTAdapter`的`headers`属性来进行设置，Ember Data会将这些头设置到到每个Ajax请求中去。

For Example

例如：

```js
App.ApplicationAdapter = DS.RESTAdapter.extend({
  headers: {
    "API_KEY": "secret key",
    "ANOTHER_HEADER": "Some header value"
  }
});
```

Requests for any resource will include the following HTTP headers.

请求任意资源都会包含如下的HTTP头。

```http
ANOTHER_HEADER: Some header value
API_KEY: secret key
```
