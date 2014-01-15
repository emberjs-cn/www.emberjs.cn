英文原文：[http://emberjs.com/guides/routing/redirection/](http://emberjs.com/guides/routing/redirection/)

### 过渡与重定向

在路由中调用`transitionTo`或者在控制器中调用`transitionToRoute`，将停止当前正在进行的过渡，并开启一个新的，这也用作重定向。`transitionTo`具有参数，其行为与[link-to](/guides/templates/links)助手相同。

* 如果过渡到一个没有动态段的路由，路由的`model`钩子始终都会运行。

* 如果路由具有动态段，那么需要传入一个模型或者一个标识符给每个段。传入一个模型不会调用`model`钩子，传入一个标识符会触发`model`钩子，标识符可以通过参数获取。详细内容请查看[链接](/guides/templates/links)。

### 在获取模型之前

如果希望从一个路由重定向到另一个路由，可以在`beforeModel`钩子中进行过渡。

```javascript
App.Router.map(function() {
  this.resource('posts');
});

App.IndexRoute = Ember.Route.extend({
  beforeModel: function() {
    this.transitionTo('posts');
  }
});
```

### 在获取模型之后

如果需要从当前模型中获取重定向的信息来决定跳转到哪里，可以使用`afterModel`和`redirect`这两个钩子来实现。`afterModel`和`redirect`的第一个参数都是路由的模型，过渡对象作为第二个参数，两个钩子本质是一样的。（`afterModel`钩子的缺省实现只是对`redirect`钩子的调用。

```javascript

App.Router.map(function() {
  this.resource('posts');
  this.resource('post', { path: '/post/:post_id' });
});

App.PostsRoute = Ember.Route.extend({
  afterModel: function(posts, transition) {
    if (posts.length === 1) {
      this.transitionTo('post', posts[0]);
    }
  }
});
```

当过渡到`PostsRoute`路由时，如果发现只有一篇文章，那么当前的过渡会被取消，并重定向到`PostRoute`路由，来显示这一篇文章。

### 基于应用的其他状态

条件过渡可以基于应用的一些其他的状态。

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
  beforeModel: function() {
    var lastFilter = this.controllerFor('application').get('lastFilter');
    this.transitionTo('topCharts.' + lastFilter || 'songs');
  }
});

// Superclass to be used by all of the filter routes below
App.FilterRoute = Ember.Route.extend({
  activate: function() {
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

路由还可以选择在特定的情况下才跳转。如果`beforeModel`钩子没有跳转到新的路由，剩下的钩子(`model`, `afterModel`,`setupController`, `renderTemplate`)还会照常执行。
