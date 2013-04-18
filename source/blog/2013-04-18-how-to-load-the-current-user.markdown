---
title: 如何获取应用当前登录的用户信息
tags: 最近文章
author: TowerHe
---

[论坛](http://discuss.emberjs.cn/t/topic/19)中发起了一个关于如何获取应用当前登录用户信息的最佳实践的讨论。在这里尝试采用讨论中给出的方案二来实现获取登录用户。其他的方案请查看http://discuss.emberjs.cn/t/topic/19。

在写应用的时候，几乎所有应用都有一个不变的需求，就是获取当前登录的用户的相关信息。比如用户的ID、用户名、头像、角色等等。那么在.js中应该如何解决这个需求呢？下面将尝试找出一个比较通用的方法，来获取应用当前登录的用户信息。

首先，假设我们需要获取的用户信息的数据结构如下所示：

```javascript
{
  id: ...,
  username: ...,
  avatar: ...,
  roles: ... 
}
```

一般情况下，应用都会有一个拥有独立`layout`的登录页面，用户在成功登录后进入应用主界面。那么我们就可以在服务器端渲染应用主界面时，将登录成功的用户信息通过服务器端脚本定义到页面中。

```erb
<!-- 以Rails的erb模板为例 -->
<html>
  <head>
    <script type="text/javascript">
      window.CURRENT_USER = <%=raw current_user.to_json %>;
    </script>
  </head>
  <body>
    ...
  </body>
</html>
```

现在我们就可以在Ember.js应用初始化的时候，将当前登录的用户设置到应用的一个session对象中：

```javascript
App.initializer({
  name: 'session',
  initialize: function(container, application) {
    App.set('session', Ember.Object.create())

    // 获取store实例
    store = container.lookup('store:main')
    // 将当前用户加载到store中
    store.adapterForType(App.User).load(store, App.User, window.CURRENT_USER)
    // 设置当前用户到session中
    App.set('session.currentUser', App.User.find(window.CURRENT_USER.id))
  }
});
```

至此，我们在之后的应用中就可以通过`App.get('session.currentUser')`来获取当前登录用户的信息了。

回过头来，我们看看为什么我们需要在`initializer`中来加载当前用户到store中去。如果我们不先将当前用户实现加载到store中去的话，会出现什么情况呢？

ember-data会自动发送一个ajax请求到服务器端，去获取当前登录的用户信息。由于ajax是采用异步通信的，这时并没有真正获取到当前用户信息，返回的只是ember-data创建的一个本地对象，所有的属性还是空，并没有被赋值，直到ajax成功返回（这里是Ember.js一个非常优秀的特性）。

或许你会觉得这样没有什么问题，但是如果我们在用户信息还没有加载成功的时候就要去完成一些判断，这时候问题就出现了，因为我们的当前用户并没有完成初始化。所以为了避免信息同步的问题，我们事先将当前用户信息手动的加载到store中去。
