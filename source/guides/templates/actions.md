英文原文：[http://emberjs.com/guides/templates/actions/](http://emberjs.com/guides/templates/actions/)
中英对照：[http://emberjs.c/bilingual_guides/templates/actions/](http://emberjs.cn/bilingual_guides/templates/actions/)

## 操作（{{action}}助手方法）

应用常常需要一种让用户通过控件进行交互来修改应用状态的方式。例如，有一个用来显示一篇博客的模板，并且支持展开查看博客更多的信息。

那么可以使用`{{action}}`助手来使得一个HTML元素可以被点击。当用户点击这个元素时，一个命名事件将会被发送给应用。

```handlebars
<!-- post.handlebars -->

<div class='intro'>
  {{intro}}
</div>

{{#if isExpanded}}
  <div class='body'>{{body}}</div>
  <button {{action 'contract'}}>Contract</button>
{{else}}
  <button {{action 'expand'}}>Show More...</button>
{{/if}}
```

```js
App.PostController = Ember.ObjectController.extend({
  // initial value
  isExpanded: false,

  expand: function() {
    this.set('isExpanded', true);
  },

  contract: function() {
    this.set('isExpanded', false);
  }
});
```

### 事件冒泡

缺省情况下，`{{action}}`助手触发模板控制器的一个方法（如上所述）。

如果控制器没有实现一个与事件的同名方法，那么这个事件将被发送至模板对应的路由。

注意路由处理事件**必须将事件处理器放置在`events`哈希中。尽管路由具有与事件相同名称的方法，这个方法也不会被触发。

```js
App.PostRoute = Ember.Route.extend({
  events: {
    expand: function() {
      this.controllerFor('post').set('isExpanded', true);
    },

    contract: function() {
      this.controllerFor('post').set('isExpanded', false);
    }
  }
});
```

如果模板对应的控制器和关联的路由都没有实现事件处理器，这个事件将被冒泡到其父级的路由。如果应用定义了`ApplicationRoute`，这里是能处理该事件的最后地方。

如果一个事件处理器在控制器、路由、任何父路由和`ApplicationRoute`中实现，那么应用会抛出一个异常。

![事件冒泡](/images/template-guide/event-bubbling.png)

### 事件参数

Ember.js支持传递参数给事件处理器。任何在事件名称之后传递给`{{action}}`助手的值，都会作为参数传递给事件处理器。

例如，如果需要将`post`作为参数：
 
 ```handlebars
 <p><button {{action "select" post}}>✓</button> {{post.title}}</p>
 ```
 
路由的`select`事件处理器被调用，并且将博客模型作为参数：

```js
App.PostController = Ember.ObjectController.extend({
  events: {
    select: function(post) {
      console.log(post.get('title'));
    }
  }
});
```

### 指定事件的类型

默认情况下，`{{action}}`助手方法侦听事件，并且在用户点击到此元素时触发指定的操作。

你还可以通过`on`选项指定一个替代事件来侦听。

```handlebars
<p>
  <button {{action "select" post on="mouseUp"}}>✓</button>
  {{post.title}}
</p>
```

你应该使用标准化之后的事件名称[视图指南已详细列出][1].
通常，两个字的事件名（如`keypress`）,会变成（`keyPress`）。

[1]: /guides/understanding-ember/the-view-layer/#toc_adding-new-events

### 指定在白名单中的辅助键

默认情况下，`{{action}}`助手方法会忽略掉用户点击时同时按下的辅助键。你可以通过提供一个`allowed-keys`的选项来指定哪些键按下时不会被忽略掉。

```handlebars
<script type="text/x-handlebars" data-template-name='a-template'>
  <div {{action anActionName allowed-keys="alt"}}>
    click me
  </div>
</script>
```

这样，{{action}}助手方法会在用户按下alt键后点击时被触发。

### 阻止事件传递（译注：即不让冒泡）

{{action}}助手方法允许将由它处理的事件冒泡到父级DOM节点。如果你想禁掉这个行为，你完全可以做到。

比如，你有一个链接包含一个**✗**按钮，你想保证这个按钮点击时，链接却不会被点击。

```handlebars
{{#linkTo 'post'}}
  Post
  <button {{action close bubbles=false}}>✗</button>
{{/linkTo}}
```

没指定`bubbles=false`时，用户点击了按钮，Ember.js 就会触发操作，同时浏览器会将此点击事件传递到父级元素。

指定`bubbles=false`时，Ember.js 就会阻止浏览器将此点击事件传递到父级元素。

### 向目标冒泡

如果在当前控制器没有找到指定的操作，当前路由就会接管来处理。经由路由，再冒泡到父级路由处理，最终到达应用程序路由。

在路由的`events`属性里定义操作。

```javascript
App.PostsIndexRoute = Ember.Route.extend({
  events: {
    myCoolAction: function() {
      // do your business.
    }
  }
});
```

上面的代码允许你根据你目前在应用程序中的位置来创建具有不同行为的按钮。比如，如果你在 `/posts`路由中，你想在侧边栏创建一个按钮来完成某种操作，而在`/about`路由中时，此按钮却是做另外一件不同的事。
