英文原文：[http://emberjs.com/guides/models/](http://emberjs.com/guides/models/)

## 模型（Models）

In most Ember.js apps, models are handled by [Ember Data][1]. Ember Data
is a library, built with and for Ember.js, designed to make it easy to
retrieve records from a server, make changes in the browser, then save
those changes back to the server.

在大部分的 Ember.js 应用里，模型是通过 [Ember Data][1] 来处理的。Ember
Data 是一个由 Ember.js 写的库，它使我们可以很方便从服务器端取回记录并动态改变浏览器中的内容，然后保存这些更改回服务器。

It provides many of the facilities you'd find in server-side ORMs like
ActiveRecord, but is designed specifically for the unique environment of
JavaScript in the browser.

你可以在服务器端找到像 ActiveRecord 这样的 ORM，不过它提供了专门为浏览器端的 Javascript 环境设计的工具方法。

Without any configuration, Ember Data can load and save records and
relationships served via a RESTful JSON API, provided it follows certain
conventions.

Ember Data 并不需要任务配置就可以通过 RESTful JSON API 的惯例来加载和保存记录和关系。

We also understand that there exist many web service APIs in the world,
many of them crazy, inconsistent, and out of your control. Ember Data is
designed to be configurable to work with whatever persistence layer you
want, from the ordinary to the exotic.

我们也知道世界上还有很多Web服务的API，其中许多会是荒唐的，矛盾的和容易失去控制。
Ember Data 被设计成可配置的，无论你想要怎么样的持久层它都可以满足。

Currently, Ember Data ships as a separate library from Ember.js, while
we expand the adapter API to support more features. The API described in
this section tends to be stable, however.  Until Ember Data is included
as part of the standard distribution, you can get your copy from the
[GitHub page][1].

目前，当我们需要扩展适配器的 API 来支持更多的功能时，Ember Data 会作为 Ember.js 一个独立的库。
但是本节中提到的 API 已经趋于稳定。直到 Ember Data 作为标准配置的一部分，你可以从[GitHub page][1]获取它的副本。

[1]: https://github.com/emberjs/data
