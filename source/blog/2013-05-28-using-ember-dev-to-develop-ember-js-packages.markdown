---
title: 使用ember-dev开发Ember.js库
tags: Draft
author: Tower He
---

在第三期周报中，我们曾经推荐了[ember-dev](https://github.com/emberjs/ember-dev)。目前作者还不建议我们在生产环境中使用ember-dev来开发Ember.js包，主要原因是ember-dev目前还不够成熟，接口不稳定，另外也缺失了一些重要特性，比如项目目录结构生成器。尽管如此，也无法遮住ember-dev的光芒，通过其目前提供的功能，已经可以很好的帮助我们进行Ember.js扩展功能的开发。下面将一步步介绍如何使用ember-dev来开发一个扩展包。

_注意：_ ember-dev是用来开发Ember.js扩展包的，而不是用来开发Ember.js应用的。请注意区分！
