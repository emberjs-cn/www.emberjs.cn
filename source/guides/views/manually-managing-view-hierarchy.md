英文原文：[http://emberjs.com/guides/views/manually-managing-view-hierarchy/](http://emberjs.com/guides/views/manually-managing-view-hierarchy/)

视图通常采用`{{view}}`助手来创建其子视图。然而有时手动管理视图的子视图非常有用。[`Ember.ContainerView`](http://emberjs.com/api/classes/Ember.ContainerView.html) 便是用来完成该功能的。

当在代码中添加和删除一个`ContainerView`的视图时，这些渲染的视图的HTML将被添加，或从匹配的DOM中删除。

```javascript
var container = Ember.ContainerView.create();
container.append();

var firstView = App.FirstView.create(),
    secondView = App.SecondView.create();

container.pushObject(firstView);
container.pushObject(secondView);

// 当渲染完成时，DOM 会在 ContainerView 的 `div` 内
// 嵌入 firstView 和 secondView 两个 `div`。
```

### 定义容器视图的初始视图

有几种不同的方法可以用来指定`ContainerView`需要渲染的初始子视图。最直接的方法是在`init`方法中指定：

```javascript
var container = Ember.ContainerView.create({
  init: function() {
    this._super();
    this.pushObject(App.FirstView.create());
    this.pushObject(App.SecondView.create());
  }
});

container.objectAt(0).toString(); //=> '<App.FirstView:ember123>'
container.objectAt(1).toString(); //=> '<App.SecondView:ember124>'
```

作为一种便捷的方式，也可以指定在初始化时会被使用的`childViews`属性。下面的例子与上面的完成相同的功能：

```javascript
var container = Ember.ContainerView.extend({
  childViews: [App.FirstView, App.SecondView]
});

container.objectAt(0).toString(); //=> '<App.FirstView:ember123>'
container.objectAt(1).toString(); //=> '<App.SecondView:ember124>'
```

另外一种可选的方法是：在`childViews`属性中指定与`ContainerView`属性一致的字符串。这种方式开始显得并不那么直观，但是其有一个好处，就是可以将命名的属性更新为被初始化后的子视图的引用：

```javascript
var container = Ember.ContainerView.create({
  childViews: ['firstView', 'secondView'],
  firstView: App.FirstView,
  secondView: App.SecondView
});

container.objectAt(0).toString(); //=> '<App.FirstView:ember123>'
container.objectAt(1).toString(); //=> '<App.SecondView:ember124>'

container.get('firstView').toString(); //=> '<App.FirstView:ember123>'
container.get('secondView').toString(); //=> '<App.SecondView:ember124>'
```

### `ContainerView`是一个数组

上面的例子中采用了`pushObject`来添加子视图，如同使用Ember的数组一样。[`Ember.ContainerView`](http://emberjs.com/api/classes/Ember.ContainerView.html)
通过织入[`Ember.MutableArray`](http://emberjs.com/api/classes/Ember.MutableArray.html) 来获取类似集合的行为。这也表示可以采用`pushObject`、`popObject`、`shiftObject`、`unshiftObject`、`insertAt`、`removeAt`这类方法，或其他可以应用在Ember数组上的方法来操作视图集合。
