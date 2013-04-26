---
title: 为什么Discourse选择Ember.JS
tags: Recent Posts
author: Tower He
---

Discourse的推出在整个社区赚足了眼球，由于Discourse选择使用Ember.JS作为前端MVC框架，这促使Ember.JS也成为了热议的话题。一年多以前SproutCore2正式改名为Ember.JS后，本人持续的关注了Ember.JS的开发过程，见证着Ember.JS的成长。Ember.JS的API在整个社区共同协作的基础上日趋稳定，Ember.JS 1.0.rc1的推出，更是标着其API已经成熟。我相信越来越多基于Ember.JS实现的优秀的应用，将会像雨后春笋般涌现出来。

[Robin
Ward](http://eviltrout.com/)（Discourse的发起者之一）在2013年2月10日撰写了一片博文[Why Discourse Uses Ember.JS](http://eviltrout.com/2013/02/10/why-discourse-uses-emberjs.html)，从他个人的角度阐述了为什么Discourse选择Ember.JS作为前端MVC框架。一下为Robin Ward的几个核心观点：

* Ember.JS的文档简单易懂

Robin Ward通过与[Angular.JS
Guides](http://docs.angularjs.org/guide/directive)比较，Robin认为较Angular.JS而言，Ember.JS的文档简单易懂，对于初学者来说更是如此。

* Ember.JS早期已经取得了令人瞩目的成绩，近期更是有了大幅的改进

[Meteor](http://meteor.com/)在推出的时候，同时给出了一个非常精彩的示例，但是它却缺少了一些非常重要的安全特性。但是就Ember.JS而言，在其最早期的时候（我想应该是指0.9.x），其提供的功能就已经相当的棒了。Robin感慨选择用Ember.JS来开发Discourse的正确性。另外，从Ember.JS的首次发布到现在，其API经过了非常大的调整，运行也变得越来越快。最新的API里面包括一个新的_路由（Router）_接口，这从很大程度上进一步降低了让人讨厌的重复代码。

* Ember.JS核心开发团队在开源社区有骄人的历史成绩

Yehuda Katz在Rails
3和Bundler完成了让人称口叫绝的工作（还有Merb、jQuery等），而且团队的其他成员也非常的优秀。Yehuda在与Robin的交谈时说他自己已经疯狂的迷恋上了Ember.JS，而Robin也深信这一点，因为Ember.JS实在是太优秀了。

* Ember.JS采用了字符串类型的模板

Ember.JS与Angular.JS不一同的一点是其采用了字符串类型的模板，而Angular.JS采用的是DOM类型的。这点完全是因为Robin的个人喜好，但是他也强调了如果要做一些服务器端的渲染，那么字符串类型的模板要比DOM类型的容易很多，因为不需要启动一个完整的PhantomJS的环境。

* Ember.JS的运行循环

Ember.JS的运行循环机制是其能得意获得高性能的一个基础，Ember.JS采用批量更新的方式来保持DOM的同步。相比其他很多框架采用循环逐一进行同步更新的机制来说要快了许多。
