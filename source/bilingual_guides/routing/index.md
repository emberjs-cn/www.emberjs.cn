英文原文：[http://emberjs.com/guides/routing/](http://emberjs.com/guides/routing/)

## 路由 (Routing)

As users interact with your application, it moves through many
different states. Ember.js gives you helpful tools for managing
that state in a way that scales with your application.

当用户使用你的应用时, 应用可能要在不同的状态之间进行切换。
Ember.js为你提供了许多帮助工具用于管理那些随着应用规模变化而变化的状态

To understand why this is important, imagine we are writing a web app
for managing a blog. At any given time, we should be able to answer
questions like: _Is the user currently logged in? Are they an admin
user? What post are they looking at? Is the settings screen open?  Are
they editing the current post?_

为了说明它的重要性，设想一下我们在编写一个管理博客的web应用。
在任何时刻，我们都应该能回答类似这样的问题：
_当前的访问者已经登陆了吗？他是管理员吗？他在看哪一篇文章？开放了设置页面了吗？他在修改当前文章吗？_

In Ember.js, each of the possible states in your application is
represented by a URL. Because all of the questions we asked above—
_Are we logged in?  What post are we looking at?_ —are encapsulated by
route handlers for the URLs, answering them is both simple and accurate.

在Ember.js内，应用中的每一个可能的状态都会映射到一个URL上。通过将URL封装到路由处理器（route
handlers）中, 我们可以简单而清晰地回答上面所问的问题：_登陆了吗？在看哪篇文章？_

At any given time, your application has one or more _active route
handlers_. The active handlers can change for one of two reasons:

在任何时刻，你的应用中都会有一个或多个活跃的路由处理器。下列两个条件都可以触发它们：

1. The user interacted with a view, which generated an event that caused
   the URL to change.

   用户与视图发生交互，产生事件导致URL改变。

2. The user changed the URL manually (e.g., via the back button), or the
   page was loaded for the first time.

   用户手动改变URL（如: 点击后退按钮），或者是第一次载入页面。

When the current URL changes, the newly active route handlers may do one
or more of the following:

当前的URL发生改变时，活跃的新路由处理器可能会做以下事情：

1. Conditionally redirect to a new URL.

   根据条件选择跳转到新的URL上

2. Update a controller so that it represents a particular model.

   更新控制器（controller）以便映射到特定的模型（model）上

3. Change the template on screen, or place a new template into an
   existing outlet.

   更改屏幕(浏览器窗口）上的模板，或者在已存在的出口（outlet）上替换新的模板

###（记录追踪路由的变化）Logging Route Changes

As your application increases in complexity, it can be helpful to see exactly what is going on with the router. To have Ember write out transition events to the log, simply modify your `Ember.Application`:

当你的应用变得越来越复杂，明白路由究竟发生了什么是很有帮助的。只要简单的修改一下你的Ember.Application，就可以让ember记录路由的事件转换。

```javascript
App = Ember.Application.create({
  LOG_TRANSITIONS: true
});
```

###Specifying a Root URL

If your Ember application is one of multiple web applications served from the same domain, it may be necessary to indicate to the router what the root URL for your Ember application is. By default, Ember will assume it is served from the root of your domain.

If for example, you wanted to serve your blogging application from www.emberjs.com/blog/, it would be necessary to specify a root URL of `/blog/`.

This can be achieved by setting the rootURL on the router:

```js
App.Router.reopen({
  rootURL: '/blog/'
});
```
