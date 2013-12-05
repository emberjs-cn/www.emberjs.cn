英文原文: [http://emberjs.com/guides/routing/loading-and-error-substates/](http://emberjs.com/guides/routing/loading-and-error-substates/)

除了[异步路由指南](/guides/routing/asynchronous-routing/)中描述的技术外，Ember路由还提供了通过使用`error`和`loading`子状态，来实现自定义路由间的异步过渡。

## `loading`子状态

考虑下面的情形：

```js
App.Router.map(function() {
  this.resource('articles', function() { // -> ArticlesRoute
    this.route('overview');              // -> ArticlesOverviewRoute
  });
});
```

如果导航到`articles/overview`，并且在`ArticlesRoute#model`中，返回了一个AJAX查询承诺，来加载需要花费较长时间才能完成加载的文章集合。在这其间，UI并不会有任何关于在做什么的实际性反馈；如果通过页面刷新进入到该页面，UI将会一直是空的，因为这时还没有完成进入路由，也没有显示任何模板；如果是从其他的路由进入`articles/overview`，那么会一直停留在之前路由渲染的模板，直到所有文章加载完成，这个时候`articles/overview`的所有模板才会被渲染，才可见。

那么，在这个过渡的过程中该如何添加一些反馈信息呢？

### `loading`事件

在深入讨论加载中子状态之前，理解`loading`事件的行为非常重要。

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

如果`FooSlowModelRoute`返回了一个较慢的承诺，那么`loading`事件就会在`FooRoute`上被触发（而不是`FooSlowModelRoute`上）。

### `loading`事件的缺省实现

之前已经介绍了可以使用一种层次化的结构来配置`loading`行为。此外，Ember还提供了一种实现了如下所示的缺省的`loading`处理器。

```js
App.Router.map(function() {
  this.resource('foo', function() {   // -> FooRoute
    this.resource('bar', function() { // -> BarRoute
      this.route('baz');              // -> BarBazRoute
    });
  });
});
```

如果`foo.bar.baz`路由返回了一个不会立即履行的承诺，Ember会在`foo.bar.baz`的层次结构中查找可以过渡的`loading`路由，查找路径为：

1. `foo.bar.loading`
2. `foo.loading`
3. `loading`

Ember会在上述的`loading`路由地址找一个路由，a) 该路由可能是如下所示定义的一个路由的子类：

1. `App.BarLoadingRoute`
2. `App.FooLoadingRoute`
3. `App.LoadingRoute`

b) 又或者是一个按照一定规则进行命名的`loading`模板：

1. `bar/loading`
2. `foo/loading`
3. `loading`

在一个较慢的异步过渡过程中，如果存在`loading`子状态/路由，Ember会先过渡到第一个找到的。这个到`loading`子状态的中间状态的过渡会立即发生（同步的），URL也不会发生改变。与其他在当另一个异步过渡活动时发生的过渡不同，该情况下的活动异步过渡不会被取消。

当进入一个`loading`子状态过渡后，对应该子状态的模板如果存在的话，会被渲染到父路由的主插口（outlet），例如`foo.bar.loading`模板会被渲染到`foo.bar`的插口中。（`loading`路由并不是特例，所有路由都是按照这种方式工作的。）

当`foo.bar.baz`主异步过渡完成时，会退出`loading`子状态，渲染的模板也会被移除，并进入`foo.bar.baz`，渲染其模板。

### 渴望型 VS 延迟型异步过渡

`loading`子状态都是可选的，如果提供了`loading`子状态，那么就表示强调了希望异步过渡为“渴望型”的。在缺少目标路由的`loading`子状态时，路由将依然停留在之前的过渡路由，知道所有目标路由的承诺得到履行，知会在过渡完全完成是一次性过渡到目标路由（渲染模板等）。但是如果提供了一个目标路由的`loading`子状态，那么就选择了“渴望型”过渡，这就表明与默认的“延迟型”不同，会首先退出当前路由（清除其模板等），并过渡到`loading`子状态。

这里也暗含了一个错误处理，例如，当过渡到一个路由失败时，延迟过渡（默认）会依然停留在原路由，而一个渴望过渡早就离开了之前的状态路由进入到`loading`子状态中了。

## `error`子状态

Ember为过渡提供了一种与`loading`事件/子状态类似的错误处理方法。

```js
App.Router.map(function() {
  this.resource('articles', function() { // -> ArticlesRoute
    this.route('overview');              // -> ArticlesOverviewRoute
  });
});
```

如果`ArticlesOverviewRoute`返回一个被拒绝的承诺（可能因为服务器端返回一个错误，又或者时用户没有登录等等），一个`error`事件将在`ArticlesOverviewRoute`被触发，并向上冒泡。可以使用这个`error`事件来处理并显示一个错误消息，例如重定向到登录页面等。与`loading`事件处理器实现类似，缺省的`error`事件处理器也会进入一个子状态来完成处理。

例如，在`ArticlesOverviewRoute#model`（或`beforeModel`、`afterModel`）中抛出了一个异常或者返回了一个被拒绝的承诺，那么会按照以下方式进行查找错误处理：


1. `ArticlesErrorRoute`路由或者`articles/error`模板
2. `ErrorRoute`路由或者`error`模板

如果之上任意一个被找到，路由将立即过渡到该子状态（不更新URL），错误的“原因”（例如抛出的异常或拒绝的承诺）会作为`model`传递给`error`子状态。

如果没有找到可以访问的`error`子状态，那么一条错误消息会在控制台中输出。

`loading`/`error`子状态处理的唯一区别是，`error`从过渡的中心路由开始向上冒泡。

## 遗留的`LoadingRoute`

之前的Ember版本（有些不慎）支持通过定义一个全局的`LoadingRoute`，该路由将在过渡遇到一个较慢的承诺或者完全退出一个过渡时被激活。因为`loading`模板作为顶层的视图来渲染，并没有放入到一个插口中，那么在这里处理可以显示一个加载中的指示器外几乎不能做其他的事情。与此相比较，`loading`事件/子状态提供了更强的控制力，如果希望模拟与遗留的`LoadingRoute`类似的行为，可以按照如下的例子来实现：

```js
App.ApplicationRoute = Ember.Route.extend({
  actions: {
    loading: function() {
      var view = Ember.View.create({
        templateName: 'global-loading',
        elementId: 'global-loading'
      }).append();
      
      this.router.one('didTransition', function() {
        view.destroy();
      });
    }
  }
});
```

上例实现了一个与`LoadingRoute`类型的行为，当路由进入一个`loading`状态时，在顶层添加了一个视图，并在完成过渡时删除加入的视图。
