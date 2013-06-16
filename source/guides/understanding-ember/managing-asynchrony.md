英文原文：[http://emberjs.com/guides/understanding-ember/managing-asynchrony/](http://emberjs.com/guides/understanding-ember/managing-asynchrony/)

## Ember管理异步

许多Ember的概念都是用来管理异步行为的，比如绑定和计算属性。

### Ember之外

本文将从使用jQuery和其他基于事件的MVC框架入手，分析管理异步行为的方法。

下面采用一个Web应用中非常普遍的异步行为作为例子，就是发起一个Ajax请求。浏览器提供的用于发起Ajax请求的API是一个异步的接口，jQuery的封装也是如此：

```javascript
jQuery.getJSON('/posts/1', function(post) {
  $("#post").html("<h1>" + post.title + "</h1>" +
    "<div>" + post.body + "</div>");
});
```

在一个原生的jQuery应用中，需要通过回调函数来修改DOM中需要更新的内容。

当使用一个基于事件的MVC框架时，可以将更新的逻辑从回调中移入模型和视图对象中。这样做有了一定的改进，但是依然需要显式的在异步回调中处理。

```javascript
Post = Model.extend({
  author: function() {
    return [this.salutation, this.name].join(' ')
  },

  toJSON: function() {
    var json = Model.prototype.toJSON.call(this);
    json.author = this.author();
    return json;
  }
});

PostView = View.extend({
  init: function(model) {
    model.bind('change', this.render, this);
  },

  template: _.template("<h1><%= title %></h1><h2><%= author %></h2><div><%= body %></div>"),

  render: function() {
    jQuery(this.element).html(this.template(this.model.toJSON());
    return this;
  }
});

var post = Post.create();
var postView = PostView.create({ model: post });
jQuery('#posts').append(postView.render().el);

jQuery.getJSON('/posts/1', function(json) {
  // set all of the JSON properties on the model
  post.set(json);
});
```

上面的例子除了jQuery之外没有使用任何其他Javascript库，但是却是一个典型的事件驱动的MVC框架的处理方法。它很好的组织了异步事件，但是编程模型依然是异步行为。

### Ember方法

Ember把消除显式的异步行为作为根本性的目标。后面将会看到，这给Ember带来了能合并具有相同结果的事件的能力。

Ember同时还提供了一个更高层次的抽象，使得不再需要手动的注册和注销执行一些最常见的任务的事件监听器。

在这个例子中其实可以使用ember-data，但是下面的例子是在Ember中结合使用jQuery的Ajax
API来进行建模。

```javascript
App.Post = Ember.Object.extend({
  
});

App.PostController = Ember.ObjectController.extend({
  author: function() {
    return [this.get('salutation'), this.get('name')].join(' ');
  }.property('salutation', 'name')
});

App.PostView = Ember.View.extend({
  // the controller is the initial context for the template
  controller: null,
  template: Ember.Handlebars.compile("<h1>{{title}}</h1><h2>{{author}}</h2><div>{{body}}</div>")
});

var post = App.Post.create();
var postController = App.PostController.create({ model: post });

App.PostView.create({ controller: postController }).appendTo('body');

jQuery.getJSON("/posts/1", function(json) {
  post.setProperties(json);
});
```

与之前展示的例子做比较，本例中Ember不再需要显式的去注册一个观察器来监听`post`的属性的改变。

`{{title}}`、`{{author}}`和`{{body}}`这几个模板元素都与`PostController`对应的属性绑定。当`PostController`的模型改变时，这些改变将自动的传播到DOM中。

使用计算属性来表示`author`，在其依赖的属性发生改变的时候，可以避免在一个回调中显式的调用一个计算方法。

Ember的绑定系统会自动跟踪在`getJSON`的回调中设置的`salutation`和`name`到`PostController`的计算属性，一直到DOM中。

### 好处

由于Ember负责传播改变，这样就可以确保一个改变在每个用户事件中只传播一次。

接下来在回过头来看`author`这个计算属性

```javascript
App.PostController = Ember.ObjectController.extend({
  author: function() {
    return [this.get('salutation'), this.get('name')].join(' ');
  }.property('salutation', 'name')
});
```

因为这里指定了`author`的两个依赖属性`salutationt`和`name`，那么这两个属性的任意一个发生改变，都会触发DOM中的`{{author}}`属性的更新。

假设在一个用户事件中触发了下述的行为：

```javascript
post.set('salutation', "Mrs.");
post.set('name', "Katz");
```

这里的改变看上去似乎会触发计算属性失效两次，并导致DOM两次更新。在一个事件驱动的框架中确实是这样。

然而，在Ember中，计算属性只会被重新计算一次，DOM也只更新一次。

怎么做到的呢？

当在Ember中修改一个属性的时候，这个改变并不会被传播出去。相反，依赖该属性的属性全部会立即设为无效，而实际的改变会在之后执行。

同时改变`salutation`和`name`会使`author`失效两次，但是事件队列能智能的合并这两个改变。

只有当用户事件相关的所有事件处理器都完成后，Ember才刷新队列，并向下传播改变。在这种情形下，被设置为无效的`author`属性将使DOM中的`{{author}}`失效，这就会发起一个请求去重新计算，并更新一次。

**这个机制是Ember的基石**。在Ember中，应该总是假定一个改变的附带效应会在延迟发生。基于这个假设，Ember可以在一个调用中合并相同的附带效应。

总之，事件触发系统的目标是把修改数据，从监听器产生的附带效应中解耦出来。因此不应该假设同步附带效应，哪怕实在一个更为关注事件的系统中。事实上由于Ember中不立即传播附带效应，消除了投机的诱惑，并将可能被耦合的代码分离开来。

### 附带效应回调

由于有时候不能依靠同步附带效应，这样就需要知道如何确定某些操作是如何在一个正确的时间被执行。

例如，假设有一个视图包含一个按钮，且想用jQuery
UI来设计这个按钮。由于视图的`append`方法，与其他在Ember中的一切一样，会延迟它的附带效应，那么如何才能在正确的时间执行jQuery UI的代码呢？

答案就是通过生命周期的回调。

```javascript
App.Button = Ember.View.extend({
  tagName: 'button',
  template: Ember.Handlebars.compile("{{view.title}}"),

  didInsertElement: function() {
    this.$().button();
  }
});

var button = App.Button.create({
  title: "Hi jQuery UI!"
}).appendTo('#something');
```

在上述的情形下，当按钮一出现在DOM中时，Ember将会触发`didInsertElement`回调，这时就可以在其中完成想完成的一切。

生命周期回调的方法能带来很多好处，即使并非需要担心延迟添加。

首先，如果依赖同步插入，就意味着把触发需要在追加后需要立刻执行的操作交给了`appendTo`的调用者。当应用不断的膨胀，就会发现在很多地方使用了相同的视图，这时就需要很多地方担心同步的问题了。

生命周期回调将实例化视图和在视图被追加后的行为的代码解耦。一般来说，不依赖同步附带效应会导向更好的设计。

接着，由于所有关于视图的生命周期都在视图自身里面，这使得Ember可以在需要的是否非常容易重新渲染DOM的一部分。

例如，如果按钮在一个`{{#if}}`块中，且Ember需要从主分支切换到`else`，那么Ember可以更容易初始化视图并调用生命周期回调。

由于Ember要求必须定义一个完整的视图，这样就可以在恰当的情形下控制视图的创建和插入。

这同时也意味着所有围绕DOM工作的代码是应用中几个有约束力的部分之一，Ember可以在这些回调之外，渲染过程中有更大的自由度。

### 观察器

在一些罕见的情形下，可能需要再某个属性改变被传播后执行某一特定行为。如同前一部分中所述的一样，Ember提供了一个机制将属性改变的通知用钩子连接起来。

下面回到称呼的例子。

```javascript
App.PostController = Ember.ObjectController.extend({
  author: function() {
    return [this.get('salutation'), this.get('name')].join(' ');
  }.property('salutation', 'name')
});
```

如果需要在`author`改变的时候被通知，可以注册一个观察器。这里假设视图对象需要得到通知：

```javascript
App.PostView = Ember.View.extend({
  controller: null,
  template: Ember.Handlebars.compile("<h1>{{title}}</h1><h2>{{author}}</h2><div>{{body}}</div>"),

  authorDidChange: function() {
    alert("New author name: " + this.get('controller.author'));
  }.observes('controller.author')
});
```

Ember在成功传播了改变之后触发观察者。在这里，意味着在每个用户事件中，即使`salutation`和`name`都改变的时候，`authorDidChange`回调也只被调用一次。

这就带来了能在属性改变后执行代码的好处，而无须迫使所有属性改变都同步。这也基本上意味着如果需要在一个计算属性改变的时候执行一些手动的工作的话，可以获得如Ember绑定系统一样的合并好处。

最后，也可以在一个对象定义之外手动注册观察器：

```javascript
App.PostView = Ember.View.extend({
  controller: null,
  template: Ember.Handlebars.compile("<h1>{{title}}</h1><h2>{{author}}</h2><div>{{body}}</div>"),

  didInsertElement: function() {
    this.addObserver('controller.name', function() {
      alert("New author name: " + this.get('controller.author'));
    });
  }
});
```

然而，当采用对象定义的语法时，Ember将在对象被销毁的时候注销这些观察器。例如，如果一个`{{#if}}`语句从真值改变为假值，Ember所有定义在这个块中的视图。Ember同时也会在这个过程中断开所有的绑定和内联的观察器。

如果手动定义观察器，那么需要自己确定其是否被正确移除。总而言之，这时需要在创建观察器相反的回调中移除观察器。本例中，则需要在`willDestroyElement`中移除回调。

```javascript
App.PostView = Ember.View.extend({
  controller: null,
  template: Ember.Handlebars.compile("<h1>{{title}}</h1><h2>{{author}}</h2><div>{{body}}</div>"),

  didInsertElement: function() {
    this.addObserver('controller.name', function() {
      alert("New author name: " + this.get('controller.author'));
    });
  },

  willDestroyElement: function() {
    this.removeObserver('controller.name');
  }
});
```

如果观察器是在`init`方法中添加的，那么就要在`willDestroy`回调中移除。

一般情况下，几乎不需要像这样手动的注册观察器。由于为了确保有效的内存管理，如果可能的话，尽量采用对象定义的方法来定义观察器。
