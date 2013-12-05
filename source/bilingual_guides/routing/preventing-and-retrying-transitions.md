During a route transition, the Ember Router passes a transition
object to the various hooks on the routes involved in the transition.
Any hook that has access to this transition object has the ability
to immediately abort the transition by calling `transition.abort()`, 
and if the transition object is stored, it can be re-attempted at a 
later time by calling `transition.retry()`.

在一个路由过渡过程中，Ember路由器将一个过渡对象传递给过渡相关的路由的各种钩子。任何可以访问过渡对象的钩子，都可以通过调用`transition.abort()`来立即取消当前过渡，如果保存了该过渡对象，那么在后续可以通过调用`transition.retry()`来重新尝试过渡。

### Preventing Transitions via `willTransition`

### 通过`willTransition`来阻止过渡

When a transition is attempted, whether via `{{link-to}}`, `transitionTo`,
or a URL change, a `willTransition` action is fired on the currently
active routes. This gives each active route, starting with the leaf-most
route, the opportunity to decide whether or not the transition should occur.

当尝试进行过渡时，无论是通过`{{link-to}}`，`transitionTo`，还是改变URL，都会在当前活动的路由上触发一个`willTransition`操作。这给从页节点开始，每个活动的路由一个可以决定是否发生一个过渡的机会。

Imagine your app is in a route that's displaying a complex form for the user
to fill out and the user accidentally navigates backwards. Unless the
transition is prevented, the user might lose all of the progress they
made on the form, which can make for a pretty frustrating user experience.

假设应用当前在一个提供了复杂的表单给用户填写的路由，用户却不小心回退了。那么除非过渡被阻止，否则用户在表单上的输入将全部丢失，这会导致极差的用户体验。

Here's one way this situation could be handled:

下面是一个可以处理这种情形的方案：

```js
App.FormRoute = Ember.Route.extend({
  actions: {
    willTransition: function(transition) {
      if (this.controllerFor('form').get('userHasEnteredData') &&
          !confirm("Are you sure you want to abandon progress?")) {
        transition.abort();
      } else {
        // Bubble the `willTransition` action so that
        // parent routes can decide whether or not to abort.
        return true;
      }
    }
  }
});
```

### Aborting Transitions Within `model`, `beforeModel`, `afterModel`

### 在`model`，`beforeModel`或`afterModel`中取消过渡

The `model`, `beforeModel`, and `afterModel` hooks described in
[Asynchronous Routing](/guides/routing/asynchronous-routing)
each get called with a transition object. This makes it possible for
destination routes to abort attempted transitions.

在[异步路由](/guides/routing/asynchronous-routing)中描述的`model`，`beforeModel`和`afterModel`钩子，每一个被调用时都传入了一个过渡对象。这让目标路由可以取消尝试进行的过渡。

```js
App.DiscoRoute = Ember.Route.extend({
  beforeModel: function(transition) {
    if (new Date() < new Date("January 1, 1980")) {
      alert("Sorry, you need a time machine to enter this route.");
      transition.abort();
    }
  }
});
```

### Storing and Retrying a Transition

### 保存并重试过渡

Aborted transitions can be retried at a later time. A common use case
for this is having an authenticated route redirect the user to a login
page, and then redirecting them back to the authenticated route once
they've logged in. 

被取消的过渡可以在之后某一时刻进行重试。一个常见的场景就是有一个身份验证的路由，将未通过验证的用户重定向到登录页面，当用户完成登录后，将用户又定向回之前请求的路由。

```js
App.SomeAuthenticatedRoute = Ember.Route.extend({
  beforeModel: function(transition) {
    if (!this.controllerFor('auth').get('userIsLoggedIn')) {
      var loginController = this.controllerFor('login');
      loginController.set('previousTransition', transition);
      this.transitionTo('login');
    }
  }
});

App.LoginController = Ember.Controller.extend({
  actions: {
    login: function() {
      // Log the user in, then reattempt previous transition if it exists.
      var previousTransition = this.get('previousTransition');
      if (previousTransition) {
        this.set('previousTransition', null);
        previousTransition.retry();
      } else {
        // Default back to homepage
        this.transitionToRoute('index');
      }
    }
  }
});
```

