英文原文: [http://emberjs.com/guides/routing/preventing-and-retrying-transitions/](http://emberjs.com/guides/routing/preventing-and-retrying-transitions/)

在一个路由过渡过程中，Ember路由器将一个过渡对象传递给过渡相关的路由的各种钩子。任何可以访问过渡对象的钩子，都可以通过调用`transition.abort()`来立即取消当前过渡，如果保存了该过渡对象，那么在后续可以通过调用`transition.retry()`来重新尝试过渡。

### 通过`willTransition`来阻止过渡

当尝试进行过渡时，无论是通过`{{link-to}}`，`transitionTo`，还是改变URL，都会在当前活动的路由上触发一个`willTransition`操作。这给从页节点开始，每个活动的路由一个可以决定是否发生一个过渡的机会。

假设应用当前在一个提供了复杂的表单给用户填写的路由，用户却不小心回退了。那么除非过渡被阻止，否则用户在表单上的输入将全部丢失，这会导致极差的用户体验。

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

当用户点击`{{link-to}}`助手时，或者应用使用`transitionTo`初始化一个过渡时，过渡将被取消并且URL也将保持不变。但是如果使用浏览器的后退按钮来退出`FormRoute`，或者如果用户手动的修改URL，那么在`willTransition`操作被调用之前，将被导航到新的URL。这样浏览器就会显示新的URl，即便在`willTransition`中调用了`transition.abort()`。

### 在`model`，`beforeModel`或`afterModel`中取消过渡

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

### 保存并重试过渡

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
