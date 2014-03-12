英文原文：[http://emberjs.com/guides/models/connecting-to-an-http-server/](http://emberjs.com/guides/models/connecting-to-an-http-server/)

如果Ember应用需要从HTTP服务器加载JSON数据，本指南将介绍如何配置Ember Data来从服务器端加载记录，不论服务器返回的数据格式是什么样子。

仓库使用了一个称为_适配器_，知道如何通过网络进行通信的对象。默认情况下，仓库会使用`DS.RESTAdapter`，一个可以与HTTP服务器通过XHR进行JSON数据交互的适配器。

本指南分为两部分。第一部分介绍适配器的默认行为，包括将从哪些URL获取记录，和期望的JSON格式。

第二部分介绍如何重新定义这些默认行为，如请求数据的URL和JSON的结构。

### URL约定

REST适配器使用模型的名称来判定将要发送JSON的URL。

例如，用ID来请求一个`App.Photo`的记录：

```js
App.PhotoRoute = Ember.Route.extend({
  model: function(params) {
    return this.store.find('photo', params.photo_id);
  }
});
```

REST适配器将发送一个`GET`请求到`/photos/1`。

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

### JSON约定

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

### 自定义适配器

自定义REST适配器，需要定义一个`DS.RESTAdapter`的子类，并将其命名为`App.ApplicationAdapter`。接下来只需要重新定义它的属性和方法，就可以自定义记录如何加载和保存了。

### 自定义URL

#### URL前缀

如果JSON API并不在主机的根目录，而是在一个其他的路径下，那么需要为请求设置一个URL前缀。

例如，在使用了版本化的JSON API时，请求一个特定的`person`可能需要发送请求到`/api/v1/people/1`。

这种情况下，需要设置`namespace`属性为`api/v1`。

```js
App.ApplicationAdapter = DS.RESTAdapter.extend({
  namespace: 'api/v1'
});
```

现在请求一个ID为`1`的`person`就会发送请求到`/api/v1/people/1`。

#### URL主机

如果JSON API的主机与提供Ember应用服务的主机不同，那么需要修改发送HTTP请求的主机。

注意为了使其正常工作，需要使用支持[CORS](http://www.html5rocks.com/en/tutorials/cors/)的浏览器，并且服务器需要配置支持发送正确的CORS头。

修改请求对应的目标主机，需要设置`host`属性：

```js
App.ApplicationAdapter = DS.RESTAdapter.extend({
  host: 'https://api.example.com'
});
```

现在请求一个ID为`1`的`person`就会发送请求到`https://api.example.com/people/1`。

#### 自定义HTTP头

一些API需要指定HTTP头，例如提供一个API密钥。任意键值对HTTP头可以通过`RESTAdapter`的`headers`属性来进行设置，Ember Data会将这些头设置到到每个Ajax请求中去。

例如：

```js
App.ApplicationAdapter = DS.RESTAdapter.extend({
  headers: {
    "API_KEY": "secret key",
    "ANOTHER_HEADER": "Some header value"
  }
});
```

请求任意资源都会包含如下的HTTP头。

```http
ANOTHER_HEADER: Some header value
API_KEY: secret key
```
