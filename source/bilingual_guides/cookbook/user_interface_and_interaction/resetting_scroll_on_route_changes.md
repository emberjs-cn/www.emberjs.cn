### Problem

### 问题

The page scroller keeps in the same position when you go from one page to another. For instance, if you scroll down a long list of displayed elements on a page and then you navigate to another page with another long list of elements, you should be able to notice that scroll position is not being reset.

当从一个页面跳转到另外一个页面时，页面滚动条总是停留在同样的位置。例如，如果访问了一个显示了很长列表的页面，并且滚动到页面的底部，这时又切换到另外一个具有长列表的页面，会发现页面的滚动条位置并没有被重置。

### Solution

### 解决方案

Add the following mixin to the affected Routes:

添加下面的`Mixin`到受影响的路由：

```js
App.ResetScroll = Ember.Mixin.create({
  enter: function() {
    this._super();
    window.scrollTo(0,0);
  }
});
```

Only if you need do something on the `enter` method you must call `this._super()` at the beginning:

只要想在`enter`方法中做点什么，就需要在一开始的时候调用`this._super()`：

```js
App.IndexRoute = Ember.Route.extend(App.ResetScroll, {
  //I need to do other things with enter
  enter: function() {
    this._super.apply(this, arguments); // Call super at the beginning
    // Your stuff
  }
});
```

#### Example

#### 示例

<a class="jsbin-embed" href="http://emberjs.jsbin.com/IxERoxoy/4/embed?html,css,js,output">Ember Starter Kit</a><script src="http://static.jsbin.com/js/embed.js"></script>
