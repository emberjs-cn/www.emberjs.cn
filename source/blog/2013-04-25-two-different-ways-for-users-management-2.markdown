---
title: 两种方式实现用户管理(二)
tags: Recent Posts
author: pudgecon
---

本文通过两种常见的方式实现了一个简单的用户管理。

一种是采用跳转至一个新页面进行用户信息查看与修改；另一种是采用在同一个页面进行用户信息查看与修改。

[上一篇](http://emberjs.cn/blog/2013/04/25/two-different-ways-for-users-management-1.html)讲述使用第一种方案实现的过程。

### 这一篇讲述使用第二种方案实现的过程。

首先是相同的创建应用：

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

定义`Router`，这里与方案一中稍有不同：

```javascript
App.Router.map(function() {
    this.resource('users', function() {
        this.resource('user', { path: ':user_id' });
    });
});

App.IndexRoute = Ember.Route.extend({
    redirect: function() {
        this.transitionTo('users');
    }
});
```

定义`UsersRoute`:

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
    <div class="list">
        <ul>
            {{#each controller}}
            <li>{{#linkTo 'user' this}}{{name}}{{/linkTo}}</li>
            {{else}}
            <li>no users yet...</li>
            {{/each}}
        </ul>
    </div>
</script>
```

这样，就可以顺利地列出我们所有的`users`了，上面的`linkTo` helper就会为我们构造类似`#/users/2`这样的url。

开始`User`

同样的，[Ember](http://www.emberjs.com)自动为我们构造了`UserRoute`，并使用了默认的`model`方法，因此，这里并不需要显示地定义`UserRoute`。

定义`user`的`template`：

```html
<script type="text/x-handlebars" data-template-name="user">
    <p>name: {{name}}</p>
    <p>email: {{email}}</p>
</script>
```

但是此时，若我们点击user的链接，会发现页面并没有出现我们想要的user信息，这是因为Ember虽然render了我们user的模板，但是并不知道需要将它显示在页面的什么地方，因此，我们需要在我们的`users`模板添加一个`outlet`，Ember会自动将`user` `render`到此处。

```html
<script type="text/x-handlebars" data-template-name="users">
    <div class="list">
        <ul>
            {{#each controller}}
            <li>{{#linkTo 'user' this}}{{name}}{{/linkTo}}</li>
            {{else}}
            <li>no users yet...</li>
            {{/each}}
        </ul>
    </div>
    <div class="detail">{{outlet}}</div>
</script>
```
这段代码的第11行，就是我们新添加的一个outlet。

这样，其实我们就已经完成了在页面的另一区域显示我们点击的user的信息，后面我们可以给它添加一些常用的操作，比如说，修改操作。

```html
<script type="text/x-handlebars" data-template-name="user">
    {{#if view.isEditing}}
    <p>name: {{view Ember.TextField valueBinding="name" target="view"}}</p>
    <p>email: {{view Ember.TextField valueBinding="email" target="view"}}</p>
    <button type="button" {{action finishEdit}}>Save</button>
    {{else}}
    <button type="button" {{action edit}}>Edit</button>
    {{/if}}
    <p>name: {{name}}</p>
    <p>email: {{email}}</p>
</script>
```

这段是修改过的`template`，默认情况下，我们显示一个`Edit`按钮，当我们点击它时，切换到编辑模式，同时显示一个保存按钮。

同时，细心的你可以会发现，Ember自动为我们对应的user的链接添加了一个`.active`的样式。因此我们只需要额外提供一个`.active`样式就可以实现选中效果了。

这里我们通过`{{#if
isEditing}}`这个helper来判断当前是否处在编辑模式，并使用Ember提供的TextField，将它与对应的`attribute`绑定（`valueBinding`）。

我们将这个方法放在`UserView`内

```javascript
App.UserView = Ember.View.extend({
    isEditing: false,
    
    edit: function() {
        this.set('isEditing', true);
    },
    finishEdit: function() {
        this.set('isEditing', false);
        //this.get('controller.model.transaction').commit();
    }
});
```

这样，当`UserView`的`isEditing`变化时，Ember会自动为我们重新render页面。

这里将这个变量放在`UserView`而不是放在`UserController`内的原因主要是，放在`UserController`内，当我们在一个user下处于编辑状态时，当我们点击到另外一个user，需要手动地将controller的`isEditing`置为`false`，否则将会出现点击直接出现编辑界面的情况。而在`方案一`中，这种情况就不一样了，就可以放在`UserController`内了。

### 总结

方案一与方案二的区别在于方案二采用的是嵌套的路由与嵌套的视图，因此大家会发现方案一中的`App.Router`与方案二是不一样的。


自己来尝试一下吧！！！

方案二示例：[http://jsfiddle.net/pudgecon/gZeN2/5/](http://jsfiddle.net/pudgecon/gZeN2/5/)
