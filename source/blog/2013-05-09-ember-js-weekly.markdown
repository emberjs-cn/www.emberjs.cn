---
title: 第三期周报
tags: Weekly
author: Tower He
---

本周Ember.js热点：

### 读物

#### [在Ember.js中创建计算宏](http://www.thesoftwaresimpleton.com/blog/2013/04/27/macro/)

在定义计算属性的时候，经常会碰到多个属性需要编写大致相同的逻辑代码。通过计算宏，可以将这种重复降低到最低。

#### [Ember.js JSON APIs](http://jsonapi.org)

详细介绍了JSON
APIs的两种不同风格（ID风格和URL风格）。ID风格简单易用，也是我们通常采用的风格，其问题在于需要客户端能够根据ID来猜测API的地址，这样会将服务端API的结构禁锢，当API变得庞大时，可能会导致问题。@wycats建议我们先从ID风格的入手，如果可能的话，再换成URL风格的。

#### [Ember.js Application Development How-to](http://it-ebooks.info/book/2032/)

本书通过一个实际的例子一步步为你介绍了如何开发一个Ember.js应用。另外，其中还包括了一些高级的关于Ember.js核心概念的例子，有助于你进一步扩展你对Ember.js的认识和技巧。感谢[@inDream](http://discuss.emberjs.cn/users/inDream)分享！

### 视频

#### [Ember.ListView介绍](http://www.youtube.com/watch?v=i3vEjbjV8Sk)

本视频介绍了一个Ember.js的新控件 - Ember.ListView。列表视图是在开发应用过程中非常常用的一个控件。

### 库、代码和工具

#### [ember-i18n](https://github.com/jamesarosen/ember-i18n)

一个简单使用的国际化工具，可以让我们的Ember.js很容易的支持国际化。

#### [ember-dev](https://github.com/emberjs/ember-dev)

ember-dev是一个用于开发Ember.js扩展的一个辅助工具，[ember-data](https://github.com/emberjs/data)便是基于ember-dev来构建的](https://github.com/emberjs/data)便是基于ember-dev来构建的。如果准备开发一个Ember.js的扩展，这将是你的不二之选。
