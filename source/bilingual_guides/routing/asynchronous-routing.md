This section covers some more advanced features of the router and its
capability for handling complex async logic within your app.

本节内容主要介绍一些路由的高级特性，以及路由是如何处理应用中的一些复杂异步逻辑的。

### A Word on Promises...

### 承诺简介

Ember's approach to handling asynchronous logic in the router makes
heavy use of the concept of Promises. In short, promises are objects that
represent an eventual value. A promise can either _fulfill_
(successfully resolve the value) or _reject_ (fail to resolve the
value). The way to retrieve this eventual value, or handle the cases
when the promise rejects, is via the promise's `then` method, which
accepts two optional callbacks, one for fulfillment and one for
rejection. If the promise fulfills, the fulfillment handler gets called
with the fulfilled value as its sole argument, and if the promise rejects, 
the rejection handler gets called with a reason for the rejection as its
sole argument. For example:

Ember在路由中处理异步逻辑的方案主要依赖于承诺（Promise）。简单地说，承诺就是代表了最后的值的对象。承诺可以被履行（成功的获得了最后的结果）也可以被拒绝（没有获得最后的结果）。处理获取最后的值，或者承诺被拒绝的方法是通过承诺的`then`方法来实现的。该方法接收两个可选的回调函数，一个用于履行承诺时执行，一个则是在拒绝时执行。如果一个承诺被履行，那么最后的值会作为履行处理函数的参数传入；如果一个承诺被拒绝，拒绝的原因会作为拒绝处理函数的参数传入。例如：

```js
var promise = fetchTheAnswer();

promise.then(fulfill, reject);

function fulfill(answer) {
  console.log("The answer is " + answer);
}

function reject(reason) {
  console.log("Couldn't get the answer! Reason: " + reason);
}
```

Much of the power of promises comes from the fact that they can be
chained together to perform sequential asynchronous operations:

承诺的强大很大程度来源于承诺可以连接在一起，形成一个有序的异步操作链：

```js
// Note: jQuery AJAX methods return promises
var usernamesPromise = Ember.$.getJSON('/usernames.json');

usernamesPromise.then(fetchPhotosOfUsers)
                .then(applyInstagramFilters)
                .then(uploadTrendyPhotoAlbum)
                .then(displaySuccessMessage, handleErrors);
```

In the above example, if any of the methods
`fetchPhotosOfUsers`, `applyInstagramFilters`, or
`uploadTrendyPhotoAlbum` returns a promise that rejects,
`handleErrors` will be called with
the reason for the failure. In this manner, promises approximate an
asynchronous form of try-catch statements that prevent the rightward
flow of nested callback after nested callback and facilitate a saner
approach to managing complex asynchronous logic in your applications.

在上述的例子中，如果`fetchPhotosOfUsers`、`applyInstagramFilters`、或`uploadTrendyPhotoAlbum`中任意一个方法返回的承诺被拒绝了，`handleErrors`将会被调用，并且告知拒绝的原因。在这种方式下，承诺将异步行为组织为与`try-catch`相似的形式，避免了一层层向右嵌套的回调，提供了一种健全有效的管理应用中异步逻辑的方案。

This guide doesn't intend to fully delve into all the different ways
promises can be used, but if you'd like a more thorough introduction,
take a look at the readme for [RSVP](https://github.com/tildeio/rsvp.js), 
the promise library that Ember uses. 

本指南中并不涉及承诺工作的各种场景，如果希望知道更多的关于承诺的介绍，可以查看Ember使用的[RSVP](https://github.com/tildeio/rsvp.js)的README文件。

### The Router Pauses for Promises

### 路由会为承诺暂停

When transitioning between routes, the Ember router collects all of the
models (via the `model` hook) that will be passed to the route's
controllers at the end of the transition. If the `model` hook (or the related
`beforeModel` or `afterModel` hooks) return normal (non-promise) objects or 
arrays, the transition will complete immediately. But if the `model` hook 
(or the related `beforeModel` or `afterModel` hooks) returns a promise (or 
if a promise was provided as an argument to `transitionTo`), the transition 
will pause until that promise fulfills or rejects.

当在路由间过渡时，Ember的路由通过`model`钩子获取所有将会在过渡的最后传递给路由控制器的模型。如果`model`钩子（或相关的`beforeModel`或`afterModel`钩子）返回的是普通的对象或数组（非承诺），那么过渡会立即完成。但是如果`model`钩子（包括`beforeModel`和`afterModel`钩子）返回一个承诺（或者将一个承诺作为参数传递给`transitionTo`方法），那么过渡将暂停直到承诺被履行或者拒绝。

<aside>
**Note:** The router considers any object with a `then` method
defined on it to be a promise.
**注意：**路由认为任何一个定义了`then`方法的对象都是一个承诺。
</aside>

If the promise fulfills, the transition will pick up where it left off and
begin resolving the next (child) route's model, pausing if it too is a
promise, and so on, until all destination route models have been
resolved. The values passed to the `setupController` hook for each route
will be the fulfilled values from the promises.

如果承诺得到履行，那么过渡将从其停止的地方开始，并着手处理下一个路由（子路由）的模型，如果这个路由依然返回一个承诺，那么又将暂停进行等待，以此类推，知道所有目标路由的模型都被获取到了。传递给每个路由的`setupController`钩子的值都是履行完承诺后的值。

A basic example:

一个基本的示例：

```js
App.TardyRoute = Ember.Route.extend({
  model: function() {
    return new Ember.RSVP.Promise(function(resolve) {
      Ember.run.later(function() {
        resolve({ msg: "Hold Your Horses" });
      }, 3000);
    });
  }, 

  setupController: function(controller, model) {
    console.log(model.msg); // "Hold Your Horses"
  }
});
```

When transitioning into `TardyRoute`, the `model` hook will be called and
return a promise that won't resolve until 3 seconds later, during which time
the router will be paused in mid-transition. When the promise eventually
fulfills, the router will continue transitioning and eventually call
`TardyRoute`'s `setupController` hook with the resolved object.

当过渡到`TardyRoute`时，路由的`model`钩子将被调用，并且返回一个要三秒后才会被履行的承诺，在此期间路由会被暂停在一个中间状态。当承诺最后被履行时，路由将继续过渡并最后将获得的对象传递给`TardyRoute`的`setupController`钩子。

This pause-on-promise behavior is extremely valuable for when you need
to guarantee that a route's data has fully loaded before displaying a
new template. 

当在显示一个新模板之前需要确保路由的数据被完全加载成功的情况下，这种暂停在承诺的行为非常有用。

### When Promises Reject...

### 当承诺被拒绝时

We've covered the case when a model promise fulfills, but what if it rejects? 

之前讲到了一个承诺被履行的情况会是什么样，那么如果承诺被拒绝了又会是怎样呢？

By default, if a model promise rejects during a transition, the transition is
aborted, no new destination route templates are rendered, and an error
is logged to the console.

在默认的情况下，如果一个模型承诺在过渡过程中被拒绝了，那么过渡就会被取消，不会有新目标路由的模板被渲染，控制台也会同时记录一条错误。

You can configure this error-handling logic via the `error` handler on
the route's `actions` hash. When a promise rejects, an `error` event
will be fired on that route and bubble up to `ApplicationRoute`'s
default error handler unless it is handled by a custom error handler
along the way, e.g.:

通过在路由的`actions`哈希里，定义一个`error`处理器，可以用来处理承诺被拒绝的情况。当一个承诺被拒绝时，路由上会被触发一个`error`事件，如果没有自定义的错误处理，那么该事件会一直冒泡直至`ApplicationRoute`提供的缺省错误处理器。

```js
App.GoodForNothingRoute = Ember.Route.extend({
  model: function() {
    return Ember.RSVP.reject("FAIL");
  },

  actions: {
    error: function(reason) {
      alert(reason); // "FAIL"

      // Can transition to another route here, e.g.
      // this.transitionTo('index');

      // Uncomment the line below to bubble this error event:
      // return true;
    }
  }
});
```

In the above example, the error event would stop right at
`GoodForNothingRoute`'s error handler and not continue to bubble. To
make the event continue bubbling up to `ApplicationRoute`, you can
return true from the error handler.

在上述例子中，错误事件将停留在`GoodForNothingRoute`的错误处理器中，而不会往上冒泡。如果需要继续让事件向上冒泡到`ApplicationRoute`，那么需要在错误处理器里面返回`true`。

### Recovering from Rejection

### 从拒绝处恢复

Rejected model promises halt transitions, but because promises are chainable,
you can catch promise rejects within the `model` hook itself and convert 
them into fulfills that won't halt the transition.

被拒绝的模型承诺会停止过渡，但是由于承诺是可以链式相连的，那么就可以在`model`钩子里面捕获到承诺的拒绝，然后将其转换为履行，这样就不会停止过渡了。

```js
App.FunkyRoute = Ember.Route.extend({
  model: function() {
    return iHopeThisWorks().then(null, function() {
      // Promise rejected, fulfill with some default value to
      // use as the route's model and continue on with the transition
      return { msg: "Recovered from rejected promise" };
    });
  }
});
```

### `beforeModel` and `afterModel`

### `beforeModel`和`afterModel`

The `model` hook covers many use cases for pause-on-promise transitions,
but sometimes you'll need the help of the related hooks `beforeModel`
and `afterModel`. The most common reason for this is that if you're
transitioning into a route with a dynamic URL segment via `{{link-to}}` or
`transitionTo` (as opposed to a transition caused by a URL change), 
the model for the route you're transitioning into will have already been
specified (e.g. `{{#link-to 'article' article}}` or
`this.transitionTo('article', article)`), in which case the `model` hook
won't get called. In these cases, you'll need to make use of either
the `beforeModel` or `afterModel` hook to house any logic while the
router is still gathering all of the route's models to perform a
transition.

`model`钩子包含了基于承诺暂停过渡的许多应用场景，但是有的时候还是需要`beforeModel`和`afterModel`这两个钩子来提供帮助。最常见的原因是通过`{{link-to}}`或者`{{transitionTo}}`（最为URL改变导致的过渡的对比）过渡到一个具有动态URL端，这时将过渡到的路由的模型早早就被指定了（例如`{{#link-to 'article' article}}`或者`this.transitionTo('article', article)`），这种情况下，`model`钩子并不会被调用。当路由正在收集所有路由的模型来执行过渡时，就需要使用`beforeModel`和`afterModel`钩子来处理所有逻辑。

#### `beforeModel`

#### `beforeModel`

Easily the more useful of the two, the `beforeModel` hook is called
before the router attempts to resolve the model for the given route. In
other words, it is called before the `model` hook gets called, or, if
`model` doesn't get called, it is called before the router attempts to
resolve any model promises passed in for that route.

`beforeModel`钩子是这两个中更为常用到的一个，`beforeModel`在路由器尝试解决给定路由的模型时被调用。或者说，它是在`model`钩子被调用前调用的。如果`model`钩子不会被调用，那么`beforeModel`会在路由器尝试解决传入到路由的模型承诺之前被调用。

Like `model`, returning a promise from `beforeModel` will pause the
transition until it resolves, or will fire an `error` if it rejects.

跟`model`一样，如果`beforeModel`返回一个承诺，那么路由将会被暂停至承诺被履行时，或者是在承诺被拒绝时触发一个`error`事件。

The following is a far-from-exhaustive list of use cases in which
`beforeModel` is very handy:

下面详细的列出了`beforeModel`非常有用的几种用例：

- Deciding whether to redirect to another route before performing a
  potentially wasteful server query in `model`
- Ensuring that the user has an authentication token before proceeding
  onward to `model`
- Loading application code required by this route 

- 决定是否在执行一个潜在的在`model`中的费时的服务器端查询之前跳转到其他的路由
- 确定用户在执行`model`之前有一个身份令牌
- 加载路由所需要的应用代码

```js
App.SecretArticlesRoute  = Ember.Route.extend({
  beforeModel: function() {
    if (!this.controllerFor('auth').get('isLoggedIn')) {
      this.transitionTo('login');
    }
  }
});
```

[See the API Docs for `beforeModel`](/api/classes/Ember.Route.html#method_beforeModel)

[查看`beforeModel`API文档](/api/classes/Ember.Route.html#method_afterModel)

#### `afterModel`

#### `afterModel`

The `afterModel` hook is called after a route's model (which might be a
promise) is resolved, and follows the same pause-on-promise semantics as
`model` and `beforeModel`. It is passed the already-resolved model 
and can therefore perform any additional logic that
depends on the fully resolved value of a model.

`afterModel`钩子在路由的模型（可能是一个承诺）被解决之后调用，并与`model`和`beforeModel`一样，遵从基于承诺的暂停原则。`afterModel`将传入被解决的模型，并可以在这个已经完全解决了的模型上添加一些附件的逻辑操作。

```js
App.ArticlesRoute = Ember.Route.extend({
  model: function() {
    // App.Article.find() returns a promise-like object
    // (it has a `then` method that can be used like a promise)
    return App.Article.find();
  },
  afterModel: function(articles) {
    if (articles.get('length') === 1) {
      this.transitionTo('article.show', articles.get('firstObject'));
    }
  }
});
```

You might be wondering why we can't just put the `afterModel` logic
into the fulfill handler of the promise returned from `model`; the
reason, as mentioned above, is that transitions initiated 
via `{{link-to}}` or `transitionTo` likely already provided the
model for this route, so `model` wouldn't be called in these cases.

这里也许对为什么不将`afterModel`的逻辑放入`model`承诺履行时要执行的处理器而感到好奇；其实原因很简单，而且之前也提到过，就是当过渡是被如`{{link-to}}`或`transitionTo`之类的提供了模型给路由的情况时，`model`钩子并不会被调用。

[See the API Docs for `afterModel`](/api/classes/Ember.Route.html#method_afterModel)

[查看`afterModel`API文档](/api/classes/Ember.Route.html#method_afterModel)

### More Resources

### 更多资源

- [Embercasts: Client-side Authentication Part 2](http://www.embercasts.com/episodes/client-side-authentication-part-2)
- [RC6 Blog Post describing these new features](/blog/2013/06/23/ember-1-0-rc6.html)

- [Embercasts: 客户端身份验证2](http://www.embercasts.com/episodes/client-side-authentication-part-2)
- [RC6发布的文章中的描述](/blog/2013/06/23/ember-1-0-rc6.html)
