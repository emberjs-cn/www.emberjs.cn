英文原文：[http://emberjs.com/guides/understanding-ember/debugging/](http://emberjs.com/guides/understanding-ember/debugging/)

### Debugging Ember and Ember Data

### 调试Ember和Ember Data

Here are some tips you can use to help debug your Ember application.

下面是一些调试Ember应用的小技巧。

#### Log router transitions

#### 在日志中输出路由转换信息

```javascript
window.App = Ember.Application.create({
  LOG_TRANSITIONS: true,
});
```

#### Log object bindings

#### 在日志中输出对象绑定

```javascript
Ember.LOG_BINDING = true
```

#### View all registered routes

#### 查看所有注册的路由

```javascript
 Ember.keys(App.Router.router.recognizer.names)
 ```

#### View all registered templates

#### 查看所有注册的模板

 ```javascript
Ember.keys(Ember.TEMPLATES)
 ```

#### Get the state history of an ember-data record

#### 获取Ember Data记录的状态历史

```javascript
record.stateManager.get('currentPath')
```

#### Get the View object for a generated ember `div` by its div id

#### 通过生成的`div`的ID视图来获取视图对象

```javascript
Ember.View.views['ember605']
```

#### Log state transitions

#### 在日志中输出状态转换

```javascript
record.set("stateManager.enableLogging", true)
```

#### View an instance of something from the container

#### 查看容器中的实例

```javascript
App.__container__.lookup("controller:posts")
App.__container__.lookup("route:application")
```

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

#### See all observers for a object, key

#### 查看一个对象、键值的所有观察器

```javascript
Ember.observersFor(comments, keyName);
```

#### Dealing with deprecations

#### 处理废弃信息

```javascript
Ember.ENV.RAISE_ON_DEPRECATION = true
Ember.LOG_STACKTRACE_ON_DEPRECATION = true
```

#### Handlebars

```handlebars
{{debugger}}
{{log record}}
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
