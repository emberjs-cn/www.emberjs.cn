---
title: 安全性发布 - Ember 1.0.1, 1.1.3, 1.2.1, and 1.3.1
tags: Releases, Recent Posts
---

因为开发者信任Ember.js在生产环境下来处理敏感的用户数据，因此Ember团队非常关注项目的安全问题。实际上，Ember是少数具有[清晰的安全策略](http://emberjs.com/security/)和一个[为安全问题专设的邮件列表](https://groups.google.com/forum/#!forum/ember-security)的Javascript项目之一。

今天发布的Ember.js
1.0.1，1.1.3，1.2.1，1.3.1和1.4.0-beta.2包含下面的重要的安全修复：

* 1.4.0-beta.2 -- [对比视图](https://github.com/emberjs/ember.js/compare/v1.4.0-beta.1...v1.4.0-beta.2)
* 1.3.1 -- [对比视图](https://github.com/emberjs/ember.js/compare/v1.3.0...v1.3.1)
* 1.2.1 -- [对比视图](https://github.com/emberjs/ember.js/compare/v1.2.0...v1.2.1)
* 1.1.3 -- [对比视图](https://github.com/emberjs/ember.js/compare/v1.1.2...v1.1.3)
* 1.0.1 -- [对比视图](https://github.com/emberjs/ember.js/compare/v1.0.0...v1.0.1)

本次修复包含两个潜在的XSS漏洞，可以通过下面两个链接获取更多信息：

* [CVE-2014-0013](https://groups.google.com/forum/#!topic/ember-security/2kpXXCxISS4)
* [CVE-2014-0014](https://groups.google.com/forum/#!topic/ember-security/PSE4RzTi6l4)

推荐马上更新项目。为了方便升级，本次发布的版本主要只包含了安全修复（1.4.0-beta.2除外，该版本是一个常规的beta发布，并包含了此次的安全修复）。

如果在生产环境下使用Ember.js，请考虑订阅[安全通知邮件列表](https://groups.google.com/forum/#!forum/ember-security)。该邮件列表流量非常低，且只包含安全通知。

## 更多内容

* [Ember.js安全策略公告](http://emberjs.com/blog/2013/04/05/announcing-the-ember-security-policy.html)
* [Ember.js安全策略](http://emberjs.com/security/)
* [Ember.js安全组](https://groups.google.com/forum/#!forum/ember-security)
