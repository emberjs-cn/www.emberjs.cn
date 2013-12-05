英文原文：[http://emberjs.com/guides/routing/specifying-the-location-api/](http://emberjs.com/guides/routing/specifying-the-location-api/)

默认情况下，路由通过浏览器的哈希来加载应用程序的起始状态，并且你在程序里点来点去的时候也是通过哈希来保持同步的。
目前，这依赖于浏览器中的[hashchange](http://caniuse.com/hashchange)事件。

下面的这个路由会将你从`/#/posts/new` 带到 `posts.new` 路由中去。

```javascript
App.Router.map(function() {
  this.resource('posts', function() {
    this.route('new');
  });
});
```

如果你想`/posts/new` 这样的地址起作用，你可以用浏览器的[history](http://caniuse.com/history) API来知会路由器。

需要注意服务器必须能接收Ember应用定义的所有路由。

```js
App.Router.reopen({
  location: 'history'
});
```

最终，如果你一点儿都不想浏览器的URL地址与你的应用程序交互，你可以彻底地禁用掉地址API。这在测试环境里很适用，或者你想用路由来管理状态，但是暂时又不想路由把URL搞乱掉（比如你将你的程序嵌入到一个大的网页里的时候）。

```js
App.Router.reopen({
  location: 'none'
});
```
