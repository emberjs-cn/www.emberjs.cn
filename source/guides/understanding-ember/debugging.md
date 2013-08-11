英文原文：[http://emberjs.com/guides/understanding-ember/debugging/](http://emberjs.com/guides/understanding-ember/debugging/)

中英对照：[http://emberjs.cn/bilingual_guides/understanding-ember/debugging/](http://emberjs.cn/bilingual_guides/understanding-ember/debugging/)

### 调试Ember和Ember Data

下面是一些调试Ember应用的小技巧。

#### 在日志中输出路由转换信息

```javascript
window.App = Ember.Application.create({
  LOG_TRANSITIONS: true
});
```
#### 在日志中输入视图查询

```javascript
window.App = Ember.Application.create({
  LOG_VIEW_LOOKUPS: true
});
```

#### 在日志中记录自动生成的控制器

```javascript
window.App = Ember.Application.create({
  LOG_ACTIVE_GENERATION: true
});
```

#### 在日志中输出对象绑定

```javascript
Ember.LOG_BINDINGS = true
```

#### 查看所有注册的路由

```javascript
 Ember.keys(App.Router.router.recognizer.names)
 ```

#### 查看所有注册的模板

 ```javascript
Ember.keys(Ember.TEMPLATES)
 ```

#### 获取Ember Data记录的状态历史

```javascript
record.stateManager.get('currentPath')
```

#### 通过生成的`div`的ID视图来获取视图对象

```javascript
Ember.View.views['ember605']
```

#### 在日志中输出状态转换

```javascript
record.set("stateManager.enableLogging", true)
```

#### 查看容器中的实例

```javascript
App.__container__.lookup("controller:posts")
App.__container__.lookup("route:application")
```

#### 查看ember-data的标示符映射

```javascript
// all records in memory
App.__container__.lookup('store:main').recordCache 

// attributes
App.__container__.lookup('store:main').recordCache[2].get('data.attributes')

// loaded associations
App.__container__.lookup('store:main').recordCache[2].get('comments')
```

#### 查看一个对象、键值的所有观察器

```javascript
Ember.observersFor(comments, keyName);
```

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

#### 实现一个`Ember.oneerror`钩子来记录生产环境下的所有错误

```javascript
Ember.onerror = function(error) {
  Em.$.ajax('/error-notification', 'POST', {
    stack: error.stack,
    otherInformation: 'exception message'
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
