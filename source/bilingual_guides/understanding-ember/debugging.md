英文原文：[http://emberjs.com/guides/understanding-ember/debugging/](http://emberjs.com/guides/understanding-ember/debugging/)

### Debugging Ember and Ember Data

### 调试Ember和Ember Data

Here are some tips you can use to help debug your Ember application.

下面是一些调试Ember应用的小技巧。

Also, check out the
[ember-extension](https://github.com/tildeio/ember-extension)
project, which adds an Ember tab to Chrome DevTools that allows you
to inspect Ember objects in your application.

另外，检出[ember-extension](https://github.com/tildeio/ember-extension)项目，ember-extension是一个Chrome开发工具，可以用来查看应用中的Ember对象。

## Routing

## 路由

#### Log router transitions

#### 在日志中输出路由转换信息

```javascript
window.App = Ember.Application.create({
  // Basic logging, e.g. "Transitioned into 'post'"
  // 基础日志，例如：'Transitioned into 'post'"
  LOG_TRANSITIONS: true, 

  // Extremely detailed logging, highlighting every internal
  // step made while transitioning into a route, including
  // `beforeModel`, `model`, and `afterModel` hooks, and
  // information about redirects and aborted transition

  // 更为详尽的日志，记录切换到一个路由时所有的内部步骤，包括：
  // `beforeModel`，`model`和`afterModel`钩子，以及跳转和取消的切换的信息
  LOG_TRANSITIONS_INTERNAL: true
});
```

#### View all registered routes

#### 查看所有注册的路由

```javascript
Ember.keys(App.Router.router.recognizer.names)
```

####  Get current route name / path

#### 获取当前路由名/路径

Ember installs the current route name and path on your
app's `ApplicationController` as the properties
`currentRouteName` and `currentPath`. `currentRouteName`'s
value (e.g. `"comments.edit"`) can be used as the destination parameter of 
`transitionTo` and the `{{linkTo}}` Handlebars helper, while 
`currentPath` serves as a full descriptor of each
parent route that has been entered (e.g. `"admin.posts.show.comments.edit"`).

Ember在`ApplicationController`中以`currentRouteName`和`currentPath`属性来记录当前路由和路径。`currentRouteName`的值（例如："comments.edit"）可以用来作为`transitionTo`和`{{linkTo}}`Handlebars助手的目标参数，`currentPath`完整表述了路由进入的整个路径（如：`"admin.posts.show.comments.edit"`）。

## Views / Templates

## 视图/模板

#### Log view lookups

#### 在日志中输出视图查询

```javascript
window.App = Ember.Application.create({
  LOG_VIEW_LOOKUPS: true
});
```

#### Get the View object from its DOM Element's ID

#### 通过DOM元素ID获取视图对象
 
```javascript
Ember.View.views['ember605']
```

#### View all registered templates

#### 查看所有注册模板

```javascript
Ember.keys(Ember.TEMPLATES)
```

#### Handlebars Debugging Helpers

#### Handlebars调试助手

```handlebars
{{debugger}}
{{log record}}
```

## Controllers

## 控制器

#### LOG generated controller 

#### 在日志中记录自动生成的控制器

```javascript
window.App = Ember.Application.create({
  LOG_ACTIVE_GENERATION: true
});
```

## Ember Data

#### View ember-data's identity map

#### 查看ember-data的标示符映射

```javascript
// all records in memory
App.__container__.lookup('store:main').recordCache 

// attributes
App.__container__.lookup('store:main').recordCache[2].get('data.attributes')

// loaded associations
App.__container__.lookup('store:main').recordCache[2].get('comments')
```

## Observers / Binding

## 观察器/绑定

#### See all observers for a object, key

#### 查看一个对象、键值的所有观察器

```javascript
Ember.observersFor(comments, keyName);
```

#### Log object bindings

#### 在日志中记录对象绑定

```javascript
Ember.LOG_BINDINGS = true
```

## 其他

#### View an instance of something from the container

#### 查看容器中的实例

```javascript
App.__container__.lookup("controller:posts")
App.__container__.lookup("route:application")
```

#### Dealing with deprecations

#### 处理废弃信息

```javascript
Ember.ENV.RAISE_ON_DEPRECATION = true
Ember.LOG_STACKTRACE_ON_DEPRECATION = true
```

#### Implement a `Ember.onerror` hook to log all errors in production

#### 实现一个`Ember.oneerror`钩子来记录生产环境下的所有错误

```javascript
Ember.onerror = function(error) {
  Em.$.ajax('/error-notification', 'POST', {
    stack: error.stack,
    otherInformation: 'exception message'
  });
}
```

#### Import the console

#### 引入控制台

If you are using imports with Ember, be sure to import the console:

如果使用imports，需要引入控制台：

```javascript
Ember = {
  imports: {
    Handlebars: Handlebars,
    jQuery: $,
    console: window.console
  }
};
```

#### Errors within an `RSVP.Promise`

#### `RSVP.Promise`中的错误

There are times when dealing with promises that it seems like any errors
are being 'swallowed', and not properly raised. This makes is extremely
difficult to track down where a given issue is coming from. Thankfully,
`RSVP` has a solution for this problem built in.

有时候，在处理承诺时，错误信息并没有被正确的抛出，就好像被吞下了一样。这使得跟踪问题出在什么地方变得十分困难。不过要感谢`RSVP`，它内置了一种专用于处理这种情况的方法。

You can provide an `onerror` function that will be called with the error
details if any errors occur within your promise. This function can be anything
but a common practice is to call `console.assert` to dump the error to the
console.

只需要提供一个`onerror`函数，供在承诺发生错误的时候被调用，来查看错误的详细信息。这个函数根据需要来设计，不过通常的方法是在其中调用`console.assert`在控制台里面输出错误信息。

```javascript
Ember.RSVP.configure('onerror', function(error) {
  Ember.Logger.assert(false, error);
});
```

#### Errors within `Ember.run.later`([Backburner.js](https://github.com/ebryn/backburner.js))

#### `Ember.run.later`([Backburner.js](https://github.com/ebryn/backburner.js))中的错误

Backburner has support for stitching the stacktraces together so that you can
track down where an erroring `Ember.run.later` is being initiated from. Unfortunately,
this is quite slow and is not appropriate for production or even normal
development.

Backburner支持将堆栈记录汇合在一起，以便跟踪`Ember.run.later`中的错误实在什么地方发生的。不幸的是，这非常的缓慢，并不适用与生产环境，甚至是开发环境。

To enable this mode you can set:

启用该模式需要设置：

```javascript
Ember.run.backburner.DEBUG = true;
```
