英文原文：[http://emberjs.com/guides/templates/actions/](http://emberjs.com/guides/templates/actions/)

中英对照：[http://emberjs.c/bilingual_guides/templates/actions/](http://emberjs.cn/bilingual_guides/templates/actions/)

## 操作（{{action}}助手方法）

应用常常需要一种让用户通过控件进行交互来修改应用状态的方式。例如，有一个用来显示一篇博客的模板，并且支持展开查看博客更多的信息。

那么可以使用`{{action}}`助手来使得一个HTML元素可以被点击。当用户点击这个元素时，一个命名事件将会被发送给应用。

```handlebars
{{! post.handlebars }}

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

  actions: {
    expand: function() {
      this.set('isExpanded', true);
    },

    contract: function() {
      this.set('isExpanded', false);
    }
  }
});
```

### 操作冒泡

缺省情况下，`{{action}}`助手触发模板控制器的一个方法（如上所述）。

如果控制器没有实现一个与操作的同名方法，那么这个操作将被发送至路由，这样当前处于激活状态的叶节点路由可以处理该操作。

路由和控制器处理操作**必须将操作处理函数定义在`actions`哈希中**。即便一个路由有一个与操作同名的的方法，如果不定义在`ations`哈希中也不会被触发。对于一个控制器，强烈推荐将操作处理函数定义在`actions`哈希中来保证向前兼容。

```js
App.PostRoute = Ember.Route.extend({
  actions: {
    expand: function() {
      this.controller.set('isExpanded', true);
    },

    contract: function() {
      this.controller.set('isExpanded', false);
    }
  }
});
```

正如在上例中所示，操作处理器在执行的时候被调用，`this`是路由的实例，而非`actions`这个哈希。

如果模板对应的控制器和关联的路由都没有实现操作处理器，这个操作将被冒泡到其父级的路由。如果应用定义了`ApplicationRoute`，这里是能处理该操作的最后地方。

当一个操作被触发时，如果在控制器中没有实现对应的操作处理器，当前路由或当前路由的任意一个父节点也没有实现时，将抛出一个错误。

![操作冒泡（Action Bubbling）](/images/template-guide/action-bubbling.png)

这样可以创建一个按钮，且该按钮根据当前应用所在位置有不同的行为。例如，有一个在侧栏中的按钮，当在`/posts`路由和`/about`路由时，分别有不同的行为。

### 操作参数

Ember.js支持传递参数给操作处理器。任何在操作名称之后传递给`{{action}}`助手的值，都会作为参数传递给操作处理器。

例如，如果需要将`post`作为参数：
 
 ```handlebars
 <p><button {{action "select" post}}>✓</button> {{post.title}}</p>
 ```
 
路由的`select`操作处理器被调用，并且将博客模型作为参数：

```js
App.PostController = Ember.ObjectController.extend({
  actions: {
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

默认情况下，`{{action}}`助手方法会忽略掉用户点击时同时按下的辅助键。你可以通过提供一个`allowedKeys`的选项来指定哪些键按下时不会被忽略掉。

```handlebars
<script type="text/x-handlebars" data-template-name='a-template'>
  <div {{action anActionName allowedKeys="alt"}}>
    click me
  </div>
</script>
```

这样，{{action}}助手方法会在用户按下alt键后点击时被触发。

### 阻止事件传递（译注：即不让冒泡）

{{action}}助手方法允许将由它处理的事件冒泡到父级DOM节点。如果你想禁掉这个行为，你完全可以做到。

比如，你有一个链接包含一个**✗**按钮，你想保证这个按钮点击时，链接却不会被点击。

```handlebars
{{#link-to 'post'}}
  Post
  <button {{action close bubbles=false}}>✗</button>
{{/link-to}}
```

没指定`bubbles=false`时，用户点击了按钮，Ember.js 就会触发操作，同时浏览器会将此点击事件传递到父级元素。

指定`bubbles=false`时，Ember.js 就会阻止浏览器将此点击事件传递到父级元素。

### 指定目标

在默认情况下，`{{action}}`助手将操作发送到视图的目标，通常是视图的控制器。（注意：Ember.Component默认的目标是组件自身。）

使用`target`选项可以指定其他的目标。经常使用这个选项将目标指向视图而非控制器。

```handlebars
<p>
  <button {{action "select" post target="view"}}>✓</button>
  {{post.title}}
</p>
```

这样应该在视图的`actions`哈希中处理。

```javascript
App.PostsIndexView = Ember.View.extend({
  actions: {
    select: function(post) {
      // do your business.
    }
  }
});
```
