---
title: 两种方式实现用户管理(一)
tags: Recent Posts
author: pudgecon
---

本文共两篇文章，通过两种常见的方式实现了一个简单的用户管理。

一种是采用跳转至一个新页面进行用户信息查看与修改；另一种是采用在同一个页面进行用户信息查看与修改。

### 第一篇讲述使用第一种方案实现的过程。

首先是创建应用：

```javascript
App = Ember.Application.create();


App.Store = DS.Store.extend({
    revision: 12,
    adapter: 'DS.FixtureAdapter'
});

App.User = DS.Model.extend({
    name: DS.attr('string'),
    email: DS.attr('string')
});

App.User.FIXTURES = [
    { id: 1, name: 'user1', email: 'user1@example.com' },
    { id: 2, name: 'user2', email: 'user2@example.com' },
    { id: 3, name: 'user3', email: 'user3@example.com' },
    { id: 4, name: 'user4', email: 'user4@example.com' },
    { id: 5, name: 'user5', email: 'user5@example.com' }
];
```

定义App的`template`：

```html
<script type="text/x-handlebars">    
    <h2>Users' example</h2>
    {{outlet}}
</script>
```

定义`Router`：

```javascript
App.Router.map(function() {
    this.resource('users');
    this.resource('user', { path: 'users/:user_id'});
});

//默认跳转至`users`
App.IndexRoute = Ember.Route.extend({
    redirect: function() {
        this.transitionTo('users');
    }
});
```

这样，我们内容将会render到上面的`outlet`内。

之后，定义我们的`UsersRoute`：

```javascript
App.UsersRoute = Ember.Route.extend({
    model: function() {
        return App.User.find();
    }
});
```

`users`模板：

```html
<script type="text/x-handlebars" data-template-name="users">
    <h3>Users</h3>
    <ul>
        {{#each controller}}
        <li>{{#linkTo 'user' this}}{{name}}{{/linkTo}}</li>
        {{/each}}
    </ul>
</script>
```

这样，就可以顺利地列出我们所有的`users`了，上面的`linkTo` helper就会为我们构造类似`#/users/2`这样的url。

开始`User`

因为[Ember](http://www.emberjs.com)自动为我们构造了`UserRoute`，并使用了默认的`model`方法，因此，这里并不需要显示地定义`UserRoute`。

我们直接写我们的`template`：

```html
<script type="text/x-handlebars" data-template-name="user">
    <h3>User</h3>
    <p>name: {{name}}</p>
    <p>email: {{email}}</p>
    {{#linkTo 'users'}}back{{/linkTo}}
</script>
```

这样，我们就实现了在新页面打开具体user的方案。具体代码参见[http://jsfiddle.net/pudgecon/gbZBQ/3/](http://jsfiddle.net/pudgecon/gbZBQ/3/)。

[方案二](http://emberjs.cn/blog/2013/04/25/two-different-ways-for-users-management-2.html)
