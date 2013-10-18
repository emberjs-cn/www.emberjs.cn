英文原文：[http://emberjs.com/guides/routing/redirection/](http://emberjs.com/guides/routing/redirection/)

### Before the model is known

If you want to redirect from one route to another, you can do the transition in
the `beforeModel` hook of your route handler.

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

If you need some information about the current model in order to decide about
the redirection, you should either use the `afterModel` or the `redirect` hook. They
receive the resolved model as the first parameter and the transition as the second one,
and thus function as aliases. (In fact, the default implementation of `afterModel` just calls `redirect`.)

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

### Based on other application state

You can conditionally transition based on some other application state.

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

你的路由还可以选择在特定的情况下才跳转。如果`beforeModel`钩子没有跳转到新的路由，剩下的钩子们(`model`, `afterModel`,`setupController`, `renderTemplate`)还会照常执行。
