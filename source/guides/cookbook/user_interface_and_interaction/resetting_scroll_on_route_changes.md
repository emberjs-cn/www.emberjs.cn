英文原文：[http://emberjs.com/guides/cookbook/user_interface_and_interaction/resetting_scroll_on_route_changes](http://emberjs.com/guides/cookbook/user_interface_and_interaction/resetting_scroll_on_route_changes)

### 问题

当从一个页面跳转到另外一个页面时，页面滚动条总是停留在同样的位置。例如，如果访问了一个显示了很长列表的页面，并且滚动到页面的底部，这时又切换到另外一个具有长列表的页面，会发现页面的滚动条位置并没有被重置。

### 解决方案

添加下面的`Mixin`到受影响的路由：

```js
App.ResetScroll = Ember.Mixin.create({
  activate: function() {
    this._super();
    window.scrollTo(0,0);
  }
});
```

只要想在`activate`方法中做点什么，就需要在一开始的时候调用`this._super()`：

```js
App.IndexRoute = Ember.Route.extend(App.ResetScroll, {
  //I need to do other things with activate 
  activate: function() {
    this._super.apply(this, arguments); // Call super at the beginning
    // Your stuff
  }
});
```

#### 示例

<a class="jsbin-embed" href="http://emberjs.jsbin.com/kixowati/1/embed?html,js,output">Ember Starter Kit</a><script src="http://static.jsbin.com/js/embed.js"></script>
