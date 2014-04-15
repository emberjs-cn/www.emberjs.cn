---
title: Ember 1.5.0和1.6 Beta发布
author: Robert Jackson
tags: Releases, Recent Posts
---

### 1.5中得新特性

#### Handlebars记录原生值

本特性允许在模板中`log`原生数据类型的值（字符串、数字等）

```javascript
{{log "**LOOKEY HERE**"}}
```

#### 新测试助手

##### 路由助手

添加了一些新的测试助手，以便可以方便的断言应用的路由所处的状态（例如点击一个链接后重定向到一个指定的路由）。

新测试助手包括：`currentRouteName`，`currentPath`和`currentURL`。

##### 触发事件助手

`triggerEvent`助手可以用于在一个元素上触发任意的事件。

```javascript
triggerEvent('#some-element-id', 'dblclick');
```

#### Ember.computed.readOnly

通常当使用`Ember.computed.oneWay`时，需要使用`readOnly`来确保数据存在备份。

```javascript
// prior to Ember.computed.readOnly you would have to do the following:
Ember.computed.oneWay('foo').readOnly()

// in 1.5 you can use the following for the same result:
Ember.computed.readOnly('foo')
```

#### Ember.isBlank

用于检查一个特定的对象为空，或者为一个空的字符串：

```javascript
Ember.isBlank();                // true
Ember.isBlank(null);            // true
Ember.isBlank(undefined);       // true
Ember.isBlank('');              // true
Ember.isBlank([]);              // true
Ember.isBlank('\n\t');          // true
Ember.isBlank('  ');            // true
Ember.isBlank({});              // false
Ember.isBlank('\n\t Hello');    // false
Ember.isBlank('Hello world');   // false
Ember.isBlank([1,2,3]);         // false
```

#### 渴望型更新URL

之前，地址栏中的URL只会在过渡的最后才会被更新。目前只要过渡没有在同一个运行循环中被取消/重定向，那么URL会被立即更新，这样99%的用户体验问题得到改善。

#### 自动定位

为应用的`Router`的`location`属性添加一个`auto`选项。

```javascript
App.Router.reopen({
  location: 'auto'
});
```

如果使用了改选项，那么Ember会更具浏览器的支持按照：history，hash和none的顺序来选择最合适的定位方法。

对于被只支持hash改变的浏览器的清理`pushState`路径，会被重定向到与hash等价的方式，反之亦然。因此过渡保持了一致性。

#### 绑定操作查找

`{{action}}`助手可以使用无引号的参数，并在事件被触发时，在对应的操作目标对象的属性中区找这个参数绑定的属性。这样可以使用动态的操作名（通过属性获取操作的名称）。

#### Routes继承模型

Ember路由及叶子节点资源（没有嵌套的路由）将继承父路由的模型。

如下下例所示：

```javascript
App.Router.map(function(){
  this.resource('post', function(){
    this.route('edit');
  });
});

App.PostRoute = Ember.Route.extend({
  model: function(){
    return {title: 'ZOMG', text: 'AWESOME'};
  }
});

App.PostEditRoute = Ember.Route.extend({
  model: function(){
    return this.modelFor('post');
  }
});
```

在1.5版本中，不在需要为`PostEditRoute`定义`model`钩子，默认会使用父路由的`model`。

### 其他值得注意的更新

#### 当下的\_super（破坏性Bug修复）

之前版本的Ember.js使用了对于织入不是那么安全的`super`机制。如果一个指定函数名被多次调用`_super`，并且没有终止函数，那么就会遇到死循环。[#3523](https://github.com/emberjs/ember.js/issues/3523)有深入的讨论。

1.5中得解决方案修复了这个问题（[#3683](https://github.com/emberjs/ember.js/pull/3683)），这也破坏了使用`_super`不一致。例如：

```JavaScript
  doIt: function(){
    Ember.run.once(this, this._super);
  }
```

不在支持使用`_super`，查看实例[jsbin](http://emberjs.jsbin.com/xuroy/1/edit?html,js,output)。
如果个造成了影响，那么可以去[#4632](https://github.com/emberjs/ember.js/pull/4301)参与讨论。

#### Handlebars {{each}} 助手检查标签

有些情况，浏览器会添加固定的标签，可能改变`Metamorph`标签的递属关系。这个问题将成在开发人员忘记在一个表格中添加`TBODY`的情况。这使得框架无法更新和清理底层DOM元素。

非生产环境构建中添加了一个断言，用于指出`Metamorph`的开始和结尾标签父元素不同的情况。这通常是在`<table>`中使用`{{each}}`时没有指定`<tbody>`导致的。

[JSBin](http://emberjs.jsbin.com/fotin/3/edit)展示了这个断言：

```handlebars
<table>
  {{#each}}
    <tr></tr>
  {{/each}}
</table>
```

解决办法就是添加`<tbody>`（[JSBin](http://emberjs.jsbin.com/fotin/2/edit)）

```handlebars
<table>
  <tbody>
    {{#each}}
      <tr></tr>
    {{/each}}
  </tbody>
</table>
```

### 其他改进

一如既往，本次发布还修改了许多之前版本存在的Bugs，对一部分功能也作出了一些改进。详细的内容可以查看CHANGELOG：

* [Ember.js 1.5.0 CHANGELOG](https://github.com/emberjs/ember.js/blob/v1.5.0/CHANGELOG.md)
* [Ember.js 1.6.0-beta.1 CHANGELOG](https://github.com/emberjs/ember.js/blob/v1.6.0-beta.1/CHANGELOG.md)
