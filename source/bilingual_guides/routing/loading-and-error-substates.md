In addition to the techniques described in the
[Asynchronous Routing Guide](http://emberjs.com/guides/routing/asynchronous-routing/),
the Ember Router provides powerful yet overridable
conventions for customizing asynchronous transitions
between routes by making use of `error` and `loading`
substates.

除了[异步路由指南](/guides/routing/asynchronous-routing/)中描述的技术外，Ember路由还提供了通过使用`error`和`loading`子状态，来实现自定义路由间的异步过渡。

## `loading` substates

## `loading`子状态

Consider the following:

考虑下面的情形：

```js
App.Router.map(function() {
  this.resource('articles', function() { // -> ArticlesRoute
    this.route('overview');              // -> ArticlesOverviewRoute
  });
});
```

If you navigate to `articles/overview`, and in `ArticlesRoute#model`, 
you return an AJAX query promise to load all of
the articles that takes a long time to complete.
During this time, your UI isn't really giving you any feedback as to
what's happening; if you're entering this route after a full page
refresh, your UI will be entirely blank, as you have not actually
finished fully entering any route and haven't yet displayed any
templates; if you're navigating to `articles/overview` from another
route, you'll continue to see the templates from the previous route
until the articles finish loading, and then, boom, suddenly all the
templates for `articles/overview` load. 

如果导航到`articles/overview`，并且在`ArticlesRoute#model`中，返回了一个AJAX查询承诺，来加载需要花费较长时间才能完成加载的文章集合。在这其间，UI并不会有任何关于在做什么的实际性反馈；如果通过页面刷新进入到该页面，UI将会一直是空的，因为这时还没有完成进入路由，也没有显示任何模板；如果是从其他的路由进入`articles/overview`，那么会一直停留在之前路由渲染的模板，直到所有文章加载完成，这个时候`articles/overview`的所有模板才会被渲染，才可见。

So, how can we provide some visual feedback during the transition?

那么，在这个过渡的过程中该如何添加一些反馈信息呢？

### The `loading` event

### `loading`事件

Before going into detail about loading substates, it's important
to understand the behavior of the `loading` event.

在深入讨论加载中子状态之前，理解`loading`事件的行为非常重要。

The Ember Router allows you to return promises from the various
`beforeModel`/`model`/`afterModel` hooks in the course of a transition
(described [here](http://emberjs.com/guides/routing/asynchronous-routing/)).
These promises pause the transition until they fulfill, at which point
the transition will resume. If you return a promise from
one of these hooks, and it doesn't immediately resolve, a `loading`
event will be fired on that route and bubble upward to
`ApplicationRoute`. For example:

Ember路由允许通过`beforeModel`/`model`/`afterModel`各种钩子在一个过渡的过程中返回承诺（[详细介绍](/guides/routing/asynchronous-routing)）。这些承诺在其被履行前会将过渡暂停。如果在其中一个钩子中返回了承诺，并且这个承诺没有理解解决，那么`loading`事件就会在该路由被触发，并且一直向上冒泡到`ApplicationRoute`。例如：

```js
App.Router.map(function() {
  this.resource('foo', function() { // -> FooRoute
    this.route('slowModel');        // -> FooSlowModelRoute
  });
});

App.FooSlowModelRoute = Ember.Route.extend({
  model: function() {
    return somePromiseThatTakesAWhileToResolve();
  },
  actions: {
    loading: function(transition, originRoute) {
      // displayLoadingSpinner();

      // Return true to bubble this event to `FooRoute`
      // or `ApplicationRoute`.
      return true;
    }
  }
});
```

If `FooRoute#model` had returned the slow promise, the `loading`
event would have fired on `FooRoute` (and not `FooSlowModelRoute`).

如果`FooSlowModelRoute`返回了一个较慢的承诺，那么`loading`事件就会在`FooRoute`上被触发（而不是`FooSlowModelRoute`上）。

### The default implementation of the `loading` event

### `loading`事件的缺省实现

So already, you have a hook to allow you to configure loading
behavior in a hierarchical manner. But in addition to this, Ember
provides a default implementation of the `loading` handler that implements
the following loading substate behavior we've been alluding to.

之前已经介绍了可以使用一种层次化的结构来配置`loading`行为。此外，Ember还提供了一种实现了如下所示的缺省的`loading`处理器。

```js
App.Router.map(function() {
  this.resource('foo', function() {       // -> FooRoute
    this.resource('foo.bar', function() { // -> FooBarRoute
      this.route('baz');                  // -> FooBarBazRoute
    });
  });
});
```

If a route with the path `foo.bar.baz` returns a promise that doesn't immediately
resolve, Ember will try to find a `loading` route in the hierarchy 
above `foo.bar.baz` that it can transition into, starting with
`foo.bar.baz`'s sibling:

如果`foo.bar.baz`路由返回了一个不会立即履行的承诺，Ember会在`foo.bar.baz`的层次结构中查找可以过渡的`loading`路由，查找路径为：

1. `foo.bar.loading`
2. `foo.loading`
3. `loading`

Ember will find a loading route at the above location if either a) a 
Route subclass has been defined for such a route, e.g.

Ember会在上述的`loading`路由地址找一个路由，a) 该路由可能是如下所示定义的一个路由的子类：

1. `App.FooBarLoadingRoute`
2. `App.FooLoadingRoute`
3. `App.LoadingRoute`

or b) a properly-named loading template has been found, e.g.

b) 又或者是一个按照一定规则进行命名的`loading`模板：

1. `foo/bar/loading`
2. `foo/loading`
3. `loading`

During a slow asynchronous transition, Ember will transition into the
first loading sub-state/route that it finds, if one exists. The
intermediate transition into the loading substate happens immediately 
(synchronously), the URL won't be updated, and, unlike other transitions
that happen while another asynchronous transition is active, the
currently active async transition won't be aborted.

在一个较慢的异步过渡过程中，如果存在`loading`子状态/路由，Ember会先过渡到第一个找到的。这个到`loading`子状态的中间状态的过渡会立即发生（同步的），URL也不会发生改变。与其他在当另一个异步过渡活动时发生的过渡不同，该情况下的活动异步过渡不会被取消。

After transitioning into a loading substate, the corresponding template
for that substate, if present, will be rendered into the main outlet of
the parent route, e.g. `foo.bar.loading`'s template would render into 
`foo.bar`'s outlet. (This isn't particular to loading routes; all
routes behave this way by default.)

当进入一个`loading`子状态过渡后，对应该子状态的模板如果存在的话，会被渲染到父路由的主插口（outlet），例如`foo.bar.loading`模板会被渲染到`foo.bar`的插口中。（`loading`路由并不是特例，所有路由都是按照这种方式工作的。）

Once the main async transition into `foo.bar.baz` completes, the loading
substate will be exited, its template torn down, `foo.bar.baz` will be
entered, and its templates rendered.

当`foo.bar.baz`主异步过渡完成时，会退出`loading`子状态，渲染的模板也会被移除，并进入`foo.bar.baz`，渲染其模板。

### Eager vs. Lazy Async Transitions

### 渴望型 VS 延迟型异步过渡

Loading substates are optional, but if you provide one,
you are essentially telling Ember that you
want this async transition to be "eager"; in the absence of destination
route loading substates, the router will "lazily" remain on the pre-transition route
while all of the destination routes' promises resolve, and only fully
transition to the destination route (and renders its templates, etc.)
once the transition is complete. But once you provide a destination
route loading substate, you are opting into an "eager" transition, which
is to say that, unlike the "lazy" default, you will eagerly exit the
source routes (and tear down their templates, etc) in order to
transition into this substate. URLs always update immediately unless the
transition was aborted or redirected within the same run loop.

`loading`子状态都是可选的，如果提供了`loading`子状态，那么就表示强调了希望异步过渡为“渴望型”的。在缺少目标路由的`loading`子状态时，路由将依然停留在之前的过渡路由，知道所有目标路由的承诺得到履行，知会在过渡完全完成是一次性过渡到目标路由（渲染模板等）。但是如果提供了一个目标路由的`loading`子状态，那么就选择了“渴望型”过渡，这就表明与默认的“延迟型”不同，会首先退出当前路由（清除其模板等），并过渡到`loading`子状态。除非过渡被取消或者在同一运行循环中被重定向，否则URL都会理解更新。

This has implications on error handling, i.e. when a transition into
another route fails, a lazy transition will (by default) just remain on the
previous route, whereas an eager transition will have already left the
pre-transition route to enter a loading substate.

这里也暗含了一个错误处理，例如，当过渡到一个路由失败时，延迟过渡（默认）会依然停留在原路由，而一个渴望过渡早就离开了之前的状态路由进入到`loading`子状态中了。

## `error` substates

## `error`子状态

Ember provides an analogous approach to `loading` events/substates in
the case of errors encountered during a transition.

Ember为过渡提供了一种与`loading`事件/子状态类似的错误处理方法。

```js
App.Router.map(function() {
  this.resource('articles', function() { // -> ArticlesRoute
    this.route('overview');              // -> ArticlesOverviewRoute
  });
});
```

If `ArticlesOverviewRoute#model` returns a promise that rejects (because, for
instance, the server returned an error, or the user isn't logged in,
etc.), an `error` event will fire on `ArticlesOverviewRoute` and bubble upward.
This `error` event can be handled and used to display an error message,
redirect to a login page, etc., but similar to how the default `loading`
event handlers are implemented, the default `error` handlers
will look for an appropriate error substate to
enter, if one can be found.

如果`ArticlesOverviewRoute`返回一个被拒绝的承诺（可能因为服务器端返回一个错误，又或者时用户没有登录等等），一个`error`事件将在`ArticlesOverviewRoute`被触发，并向上冒泡。可以使用这个`error`事件来处理并显示一个错误消息，例如重定向到登录页面等。与`loading`事件处理器实现类似，缺省的`error`事件处理器也会进入一个子状态来完成处理。

For instance, an error thrown or rejecting promise returned from
`ArticlesOverviewRoute#model` (or `beforeModel` or `afterModel`) 
will look for:

例如，在`ArticlesOverviewRoute#model`（或`beforeModel`、`afterModel`）中抛出了一个异常或者返回了一个被拒绝的承诺，那么会按照以下方式进行查找错误处理：

1. Either `ArticlesErrorRoute` or `articles/error` template
2. Either `ErrorRoute` or `error` template

1. `ArticlesErrorRoute`路由或者`articles/error`模板
2. `ErrorRoute`路由或者`error`模板

If one of the above is found, the router will immediately transition into
that substate (without updating the URL). The "reason" for the error 
(i.e. the exception thrown or the promise reject value) will be passed
to that error state as its `model`.

如果之上任意一个被找到，路由将立即过渡到该子状态（不更新URL），错误的“原因”（例如抛出的异常或拒绝的承诺）会作为`model`传递给`error`子状态。

If no viable error substates can be found, an error message will be
logged.

如果没有找到可以访问的`error`子状态，那么一条错误消息会在控制台中输出。

The only way in which `loading`/`error` substate resolution differs is
that `error` events will continue to bubble above a transition's pivot
route.

`loading`/`error`子状态处理的唯一区别是，`error`从过渡的中心路由开始向上冒泡。

### `error` substates with dynamic segments

### 带动态段的`error`子状态

Routes with dynamic segments are often mapped to a mental model of "two
separate levels." Take for example:

带动态段的路由通常映射到一个模型的两个不同的层面。例如：

```js
App.Router.map(function() {
  this.resource('foo', {path: '/foo/:id'}, function() {
    this.route('baz');
  });
});

App.FooRoute = Ember.Route.extend({
  model: function(params) {
    return new Ember.RSVP.Promise(function(resolve, reject) {
       reject("Error");
    });
  }
});
```

In the URL hierarchy you would visit `/foo/12` which would result in rendering
the `foo` template into the `application` template's `outlet`. In the event of
an error while attempting to load the `foo` route you would also render the
top-level `error` template into the `application` template's `outlet`. This is
intentionally parallel behavior as the `foo` route is never successfully
entered. In order to create a `foo` scope for errors and render `foo/error`
into `foo`'s `outlet` you would need to split the dynamic segment:

在URL层次中，访问`/foo/12`将会导致将`foo`模板渲染到`application`模板的`outlet`处。当尝试加载一个`foo`路由发生一个错误事件，会将顶层的`error`模板渲染到`application`模板的`outlet`。这感觉就好像`foo`路由就从未正确进入过一般。为了创建一个`foo`范围的错误信息，并渲染`foo/error`到`foo`的`outlet`中，那么需要将动态段分离：

```js
App.Router.map(function() {
  this.resource('foo', {path: '/foo'}, function() {
    this.resource('elem', {path: ':id'}, function() {
      this.route('baz');
    });
  });
});
```

[Example JSBin](http://emberjs.jsbin.com/ucanam/4279)

## Legacy `LoadingRoute`

## 遗留的`LoadingRoute`

Previous versions of Ember (somewhat inadvertently) allowed you to define a global `LoadingRoute`
which would be activated whenever a slow promise was encountered during
a transition and exited upon completion of the transition. Because the
`loading` template rendered as a top-level view and not within an
outlet, it could be used for little more than displaying a loading
spinner during slow transitions. Loading events/substates give you far
more control, but if you'd like to emulate something similar to the legacy
`LoadingRoute` behavior, you could do as follows:

之前的Ember版本（有些不慎）支持通过定义一个全局的`LoadingRoute`，该路由将在过渡遇到一个较慢的承诺或者完全退出一个过渡时被激活。因为`loading`模板作为顶层的视图来渲染，并没有放入到一个插口中，那么在这里处理可以显示一个加载中的指示器外几乎不能做其他的事情。与此相比较，`loading`事件/子状态提供了更强的控制力，如果希望模拟与遗留的`LoadingRoute`类似的行为，可以按照如下的例子来实现：

```js
App.LoadingView = Ember.View.extend({
  templateName: 'global-loading',
  elementId: 'global-loading'
});

App.ApplicationRoute = Ember.Route.extend({
  actions: {
    loading: function() {
      var view = this.container.lookup('view:loading').append();
      this.router.one('didTransition', view, 'destroy');
    }
  }
});
```

[Example JSBin](http://emberjs.jsbin.com/ucanam/3307)

This will, like the legacy `LoadingRoute`, append a top-level view when the
router goes into a loading state, and tear down the view once the
transition finishes.

[JSBin示例](http://emberjs.jsbin.com/ucanam/3307)

上例实现了一个与`LoadingRoute`类型的行为，当路由进入一个`loading`状态时，在顶层添加了一个视图，并在完成过渡时删除加入的视图。
