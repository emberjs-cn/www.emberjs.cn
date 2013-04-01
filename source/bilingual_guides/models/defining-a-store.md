英文原文：[http://emberjs.com/guides/models/defining-a-store/](http://emberjs.com/guides/models/defining-a-store/)

## 创建一个存储器（Defining a Store）

Every application using Ember Data has a store. The store is the
repository that holds loaded models, and is responsible for retrieving
models that have not yet been loaded.

每一个使用 Ember Data 的应用都会有一个存储器。这个存储器会成为已加载模型的贮存器，并且检索还未被加载的模型。

Typically, you will interact with models directly, not the store.
However, you do need to tell Ember.js that you want Ember Data to manage
your models. To do so, simply define a subclass of `DS.Store` on your
`Ember.Application`:

通常，你可以直接跟模型交互，而不使用存储器。但是你需要让 Ember.js 知道你现在在使用 Ember Data 来管理你的模型。
要达到这样的目的，我们可以简单地在Ember.Application中定义一个DS.Store的子类，如下所示：

```js
App.Store = DS.Store.extend({
  revision: 12
});
```

Note the `revision` property defined here. This is the API revision
number, and is used by Ember Data to notify you of breaking changes to
the public API. This will be removed once Ember Data reaches 1.0. See
the [Breaking Changes document][1] for more information.

注意这里的`revision`属性，它是 API 的修订版本号，在Ember Data 1.0 版本之前用来提醒你公共 API 的重大更改。
查看[Breaking Changes 文档][1]以获取更多信息。

[1]: https://github.com/emberjs/data/blob/master/BREAKING_CHANGES.md

If you want to customize the store, you can do so when creating the
subclass. For example, if you wanted to use an adapter other than the
default `DS.RESTAdapter`, you would do so like this:

如果你想要定制存储器，你可以在创建子类的时候去定制。例如，如果你想要用另外一个适配器去替换默认的`DS.RESTAdapter`，你可以像下面这样做：

```js
App.Store = DS.Store.extend({
  revision: 12,
  adapter: 'App.MyCustomAdapter'
});
```
