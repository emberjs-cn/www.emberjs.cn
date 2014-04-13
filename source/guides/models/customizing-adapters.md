英文原文：[http://emberjs.com/guides/models/customizing-adapters/](http://emberjs.com/guides/models/customizing-adapters/)

在Ember Data中，处理与后台数据仓库通信的逻辑是通过`Adapter`来完成的。Ember Data适配器内置了一些关于[REST API](http://jsonapi.org)的假定。如果后台的实现与Ember Data假定的惯例不同，那么通过扩展缺省的适配器可能很容易的实现。

有时因为一些原因需要自定义适配器，例如需要使用下划线风格的URL，使用REST外的其他媒介来与后台通信，或者是使用[本地后台](https://github.com/rpflorence/ember-localstorage-adapter).

扩展适配器在Ember Data中是一个常见的过程。Ember的立场是应该通过扩展适配器来添加不同的功能，而非添加标识。这样可以使得代码更加容易测试，更加易于理解，同时也降低了可能需要扩展适配器的用户的代码。

如果后台具有一定的一致性规则，那么可以定义一个`ApplicationAdapter`。`ApplicationAdapter`的优先级比缺省的适配器高，但是又会被模型特定的适配器取代。

```js
App.ApplicationAdapter = DS.RESTAdapter.extend({
    // Application specific overrides go here
});
```

如果一个模型的后台有一些特殊的规则，那么可以定义一个模型特定的适配器，并将适配器命名为："ModelName" + "Adapter"。

```js
App.PostAdapter = DS.RESTAdapter.extend({
  namespace: 'api/v1'
});
```

缺省情况下，Ember Data内置了一些非常有用的适配器。可以根据自己的实际情况，选择其中之一作为起点来自定义适配器。

- [DS.Adapter](/api/data/classes/DS.Adapter.html)是最基础的适配器，其自身不包含任何功能。如果需要创建一个与Ember适配器有根本性区别的适配器，那么可以这里入手。

- [DS.FixtureAdapter](/api/data/classes/DS.FixtureAdapter.html)是一个用来从内存中加载记录的适配器，常用于开发和测试阶段。

- [DS.RESTAdapter](/api/data/classes/DS.RESTAdapter.html)是最通用的扩展适配器。`RESTAdapter`可以实现`store`与HTTP服务器之间通过XHR交互JSON数据。大部分使用JSON
  API的Ember应用都应该使用`RESTAdapter`。

- [DS.ActiveModelAdapter](/api/data/classes/DS.ActiveModelAdapter.html)是一个`RESTAdapter`的特列，用于与Rails风格的REST API协同工作。

## 自定义RESTAdapter

[DS.RESTAdapter](/api/data/classes/DS.RESTAdapter.html)是Ember
Data提供的一个最通用的扩展适配器。它提供了一些非常有用的，可以扩展来与非标准化的后台接口通信的钩子。

#### 自定义端点路径

`namespace`属性用来指定一个特定的url前缀。

```js
App.ApplicationAdapter = DS.RESTAdapter.extend({
  namespace: 'api/1'
});
```

`App.Person`的请求将会发至`/api/1/people/1`。

#### 自定义主机

缺省情况下，适配器认为主机是当前域。如果希望指定一个新的域，那么可以通过设置适配器的`host`属性来指定。

```js
App.ApplicationAdapter = DS.RESTAdapter.extend({
  host: 'https://api.example.com'
});
```

`App.Person`的请求将会发至`https://api.example.com/people/1`。

#### 自定义路径

缺省情况下，`RESTAdapter`尝试将模型名进行驼峰化和复数化来作为路径名。如果这种惯例并不符合使用的后台接口，可以通过重载`pathForType`方法来实现。

例如，并不需要将模型名称复数化，需要采用下划线分割的模式替代驼峰命名，那么可以这样来重载`pathForType`方法：

```js
App.ApplicationAdapter = DS.RESTAdapter.extend({
  pathForType: function(type) {
    return Ember.String.underscore(type);
  }
});
```

`App.Person`的请求将会发至`/person/1`。
`App.UserProfile`的请求将会发至`/user_profile/1`。

#### 创作适配器

`defaultSerializer`属性可以用来指定适配器使用的序列化对象。这只在没有模型特定的序列化对象，也没有`ApplicationSerializer`的情况下。

在一个应用中，指定一个`ApplicationSerializer`比较容易。但是如果自定了一个通信的适配器，并且没有指定一个`ApplicationSerializer`，那么设定`defaultSerializer`属性，来确保Ember的行为正确性比较重要。

```js
MyCustomAdapterAdapter = DS.RESTAdapter.extend({
  defaultSerializer: '-default'
});
```

## 社区适配器

如果Ember Data内置的适配器并不能很好的与使用的后台工作，可以查看社区维护的Ember Data适配器，看有不有合适的选择。可以去一下地方去查找：

- [GitHub](https://github.com/search?q=ember+data+adapter&ref=cmdform)
- [Bower](http://bower.io/search/?q=ember-data-)
