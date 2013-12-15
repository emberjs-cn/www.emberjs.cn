### Before the model is known

### 在获取模型之前

If you want to redirect from one route to another, you can do the transition in
the `beforeModel` hook of your route handler.

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

### After the model is known

### 在获取模型之后

If you need some information about the current model in order to decide about
the redirection, you should either use the `afterModel` or the `redirect` hook. They
receive the resolved model as the first parameter and the transition as the second one,
and thus function as aliases. (In fact, the default implementation of `afterModel` just calls `redirect`.)

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

When transitioning to the `PostsRoute` it turns out that there is only one post,
the current transition is aborted in favor of redirecting to the `PostRoute`
with the single post object being its model.

当过渡到`PostsRoute`路由时，如果发现只有一篇文章，那么当前的过渡会被取消，并重定向到`PostRoute`路由，来显示这一篇文章。

### Based on other application state

### 基于应用的其他状态

You can conditionally transition based on some other application state.

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

In this example, navigating to the `/` URL immediately transitions into
the last filter URL that the user was at. The first time, it transitions
to the `/songs` URL.

在上面这个例子中，用户浏览到`/`网址的时候会被立即跳转到用户曾经访问过的最后过滤网址。第一次访问`/`的时候，会被跳转到`songs`网址。

Your route can also choose to transition only in some cases. If the
`beforeModel` hook does not abort or transition to a new route, the remaining
hooks (`model`, `afterModel`, `setupController`, `renderTemplate`) will execute
as usual.

路由还可以选择在特定的情况下才跳转。如果`beforeModel`钩子没有跳转到新的路由，剩下的钩子(`model`, `afterModel`,`setupController`, `renderTemplate`)还会照常执行。
