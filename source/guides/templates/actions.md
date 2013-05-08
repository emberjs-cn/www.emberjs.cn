英文原文：[http://emberjs.com/guides/templates/actions/](http://emberjs.com/guides/templates/actions/)

## 操作（{{action}}助手方法）

你可能希望通过触发一个高层的事件来响应一个简单的用户操作（比如一次点击）。
通常，这些事件将修改控制器的某些属性，并且将通过绑定来改变当前的模板。
比如，你有一个显示一条博文的模板，博文可以展开以显示更多的信息。

```handlebars
<!-- post.handlebars -->

<div class='intro'>
  {{intro}}
</div>

{{#if isExpanded}}
  <div class='body'>{{body}}</div>
  <button {{action contract}}>Contract</button>
{{else}}
  <button {{action expand}}>Show More...</button>
{{/if}}
```

这种情况下，`post`控制器就是`Ember.ObjectController`，它的`content` 是`App.Post`的一个实例。

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

默认情况下， `{{action}}`助手方法在当前的控制器上触发一个方法。你还可以传递参数路径到这个方法。下面代码中的按钮在被点击时会调用`controller.select( context.post )`。

```handlebars
<p><button {{action "select" post}}>✓</button> {{post.title}}</p>
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
