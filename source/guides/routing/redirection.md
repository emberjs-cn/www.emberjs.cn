英文原文：[http://emberjs.com/guides/routing/redirection/](http://emberjs.com/guides/routing/redirection/)


## 重定向到不同的URL

如果你想从一个路由重定向到另外一个路由，只要在路由处理方法中实现一个`redirect`钩子即可。

```javascript
App.Router.map(function() {
  this.resource('posts');
});

App.IndexRoute = Ember.Route.extend({
  redirect: function() {
    this.transitionTo('posts');
  }
});
```

你可以基于其他的应用状态，来进行有条件的切换。

```javascript
App.Router.map(function() {
  this.resource('topCharts', function() {
    this.route('choose', { path: '/' });
    this.route('albums');
    this.route('songs');
    this.route('artists');
    this.route('playlists');
  });
});

App.TopChartsChooseRoute = Ember.Route.extend({
  redirect: function() {
    var lastFilter = this.controllerFor('application').get('lastFilter');
    this.transitionTo('topCharts.' + lastFilter || 'songs');
  }
});

// Superclass to be used by all of the filter routes below
App.FilterRoute = Ember.Route.extend({
  enter: function() {
    var controller = this.controllerFor('application');
    controller.set('lastFilter', this.templateName);
  }
});

App.TopChartsSongsRoute = App.FilterRoute.extend();
App.TopChartsAlbumsRoute = App.FilterRoute.extend();
App.TopChartsArtistsRoute = App.FilterRoute.extend();
App.TopChartsPlaylistsRoute = App.FilterRoute.extend();
```


在上面这个例子中，用户浏览到`/`网址的时候会被立即跳转到用户曾经访问过的最后过滤网址。第一次访问`/`的时候，会被跳转到`songs`网址。

你的路由还可以选择在特定的情况下才跳转。如果`redirect`钩子没有跳转到新的路由，剩下的钩子们(`model`, `setupController`, `renderTemplate`)还会照常执行。