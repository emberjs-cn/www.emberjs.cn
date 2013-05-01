## Manually Managed Views with Ember.ContainerView

## 采用Ember.ContainerView手动管理视图

As you probably know by now, views usually create their child views
by using the `{{view}}` helper. However, it is sometimes useful to
_manually_ manage a view's child views.
[`Ember.ContainerView`](/api/classes/Ember.MutableArray.html)
is the way to do just that.

视图通常采用`{{view}}`助手来创建其子视图。然而有时手动管理视图的子视图非常有用。[`Ember.ContainerView`](http://emberjs.com/api/classes/Ember.ContainerView.html) 便是用来完成该功能的。

As you programmatically add or remove views to a `ContainerView`,
those views' rendered HTML are added or removed from the DOM to
match.

当在代码中添加和删除一个`ContainerView`的视图时，这些渲染的视图的HTML将被添加，或从匹配的DOM中删除。

```javascript
var container = Ember.ContainerView.create();
container.append();

var firstView = App.FirstView.create(),
    secondView = App.SecondView.create();

container.pushObject(firstView);
container.pushObject(secondView);

// When the rendering completes, the DOM
// will contain a `div` for the ContainerView
// and nested inside of it, a `div` for each of
// firstView and secondView.
```

### Defining the Initial Views of a Container View

### 定义容器视图的初始视图

There are a few ways to specify what initial child views a
`ContainerView` should render. The most straight-forward way is to
add them in `init`:

有几种不同的方法可以用来指定`ContainerView`需要渲染的初始子视图。最直接的方法是在`init`方法中指定：

```javascript
var container = Ember.ContainerView.create({
  init: function() {
    this._super();
    this.pushObject(App.FirstView.create());
    this.pushObject(App.SecondView.create());
  }
};

container.objectAt(0).toString(); //=> '<App.FirstView:ember123>'
container.objectAt(1).toString(); //=> '<App.SecondView:ember124>'
```

As a shorthand, you can specify a `childViews` property that will be
consulted on instantiation of the `ContainerView` also. This example is
equivalent to the one above:

作为一种便捷的方式，也可以指定在初始化时会被使用的`childViews`属性。下面的例子与上面的完成相同的功能：

```javascript
var container = Ember.ContainerView.extend({
  childViews: [App.FirstView, App.SecondView]
};

container.objectAt(0).toString(); //=> '<App.FirstView:ember123>'
container.objectAt(1).toString(); //=> '<App.SecondView:ember124>'
```

Another bit of syntactic sugar is available as an option as well:
specifying string names in the childViews property that correspond
to properties on the `ContainerView`. This style is less intuitive
at first but has the added bonus that each named property will
be updated to reference its instantiated child view:

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

### It Feels Like an Array Because it _is_ an Array

### `ContainerView`是一个数组

You may have noticed that some of these examples use `pushObject` to add
a child view, just like you would interact with an Ember array.
[`Ember.ContainerView`](/api/classes/Ember.ContainerView.html)
gains its collection-like behavior by mixing in
[`Ember.MutableArray`](/api/classes/Ember.MutableArray.html). That means
that you can manipulate the collection of views very expressively, using
methods like `pushObject`, `popObject`, `shiftObject`, `unshiftObject`, `insertAt`,
`removeAt`, or any other method you would use to interact with an Ember array.

上面的例子中采用了`pushObject`来添加子视图，如同使用Ember的数组一样。[`Ember.ContainerView`](http://emberjs.com/api/classes/Ember.ContainerView.html)
通过织入[`Ember.MutableArray`](http://emberjs.com/api/classes/Ember.MutableArray.html) 来获取类似集合的行为。这也表示可以采用`pushObject`、`popObject`、`shiftObject`、`unshiftObject`、`insertAt`、`removeAt`这类方法，或其他可以应用在Ember数组上的方法来操作视图集合。
