英文原文：[http://emberjs.com/guides/understanding-ember/debugging/](http://emberjs.com/guides/understanding-ember/debugging/)

### 调试Ember和Ember Data

下面是一些调试Ember应用的小技巧。

另外，检出[ember-extension](https://github.com/tildeio/ember-extension)项目，ember-extension是一个Chrome开发工具，可以用来查看应用中的Ember对象。

## 路由

#### 在日志中输出路由转换信息

```javascript
window.App = Ember.Application.create({
  // 基础日志，例如：'Transitioned into 'post'"
  LOG_TRANSITIONS: true, 

  // 更为详尽的日志，记录切换到一个路由时所有的内部步骤，包括：
  // `beforeModel`，`model`和`afterModel`钩子，以及跳转和取消的切换的信息
  LOG_TRANSITIONS_INTERNAL: true
});
```

#### 查看所有注册的路由

```javascript
Ember.keys(App.Router.router.recognizer.names)
```

#### 获取当前路由名/路径

Ember在`ApplicationController`中以`currentRouteName`和`currentPath`属性来记录当前路由和路径。`currentRouteName`的值（例如："comments.edit"）可以用来作为`transitionTo`和`{{linkTo}}`Handlebars助手的目标参数，`currentPath`完整表述了路由进入的整个路径（如：`"admin.posts.show.comments.edit"`）。

## 视图/模板

#### 在日志中输出视图查询

```javascript
window.App = Ember.Application.create({
  LOG_VIEW_LOOKUPS: true
});
```

#### 通过DOM元素ID获取视图对象
 
```javascript
Ember.View.views['ember605']
```

#### 查看所有注册模板

```javascript
Ember.keys(Ember.TEMPLATES)
```

#### Handlebars调试助手

```handlebars
{{debugger}}
{{log record}}
```

## 控制器

#### 在日志中记录自动生成的控制器

```javascript
window.App = Ember.Application.create({
  LOG_ACTIVE_GENERATION: true
});
```

## Ember Data

#### 查看ember-data的标示符映射

```javascript
// all records in memory
App.__container__.lookup('store:main').recordCache 

// attributes
App.__container__.lookup('store:main').recordCache[2].get('data.attributes')

// loaded associations
App.__container__.lookup('store:main').recordCache[2].get('comments')
```

## 观察器/绑定

#### 查看一个对象、键值的所有观察器

```javascript
Ember.observersFor(comments, keyName);
```

#### 在日志中记录对象绑定

```javascript
Ember.LOG_BINDINGS = true
```

## 其他

#### 查看容器中的实例

```javascript
App.__container__.lookup("controller:posts")
App.__container__.lookup("route:application")
```

#### 处理废弃信息

```javascript
Ember.ENV.RAISE_ON_DEPRECATION = true
Ember.LOG_STACKTRACE_ON_DEPRECATION = true
```

#### 实现一个`Ember.oneerror`钩子来记录生产环境下的所有错误

```javascript
Ember.onerror = function(error) {
  Em.$.ajax('/error-notification', {
    type: 'POST',
    data: {
      stack: error.stack,
      otherInformation: 'exception message'
    }
  });
}
```

#### 引入控制台

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

#### `RSVP.Promise`中的错误

有时候，在处理承诺时，错误信息并没有被正确的抛出，就好像被吞下了一样。这使得跟踪问题出在什么地方变得十分困难。不过要感谢`RSVP`，它内置了一种专用于处理这种情况的方法。

只需要提供一个`onerror`函数，供在承诺发生错误的时候被调用，来查看错误的详细信息。这个函数根据需要来设计，不过通常的方法是在其中调用`console.assert`在控制台里面输出错误信息。

```javascript
Ember.RSVP.configure('onerror', function(error) {
  Ember.Logger.assert(false, error);
});
```

#### `Ember.run.later`([Backburner.js](https://github.com/ebryn/backburner.js))中的错误

Backburner支持将堆栈记录汇合在一起，以便跟踪`Ember.run.later`中的错误实在什么地方发生的。不幸的是，这非常的缓慢，并不适用与生产环境，甚至是开发环境。

启用该模式需要设置：

```javascript
Ember.run.backburner.DEBUG = true;
```
