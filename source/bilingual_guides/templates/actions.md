英文原文：[http://emberjs.com/guides/templates/actions/](http://emberjs.com/guides/templates/actions/)

中英对照：[http://emberjs.c/bilingual_guides/templates/actions/](http://emberjs.cn/bilingual_guides/templates/actions/)

## Actions (The `{{action}}` Helper)

## 操作（{{action}}助手方法）

Your app will often need a way to let users interact with controls that
change application state. For example, imagine that you have a template
that shows a blog post, and supports expanding the post with additional
information.

应用常常需要一种让用户通过控件进行交互来修改应用状态的方式。例如，有一个用来显示一篇博客的模板，并且支持展开查看博客更多的信息。

You can use the `{{action}}` helper to make an HTML element clickable.
When a user clicks the element, the named event will be sent to your
application.

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

### Action Bubbling

By default, the `{{action}}` helper triggers a method on the template's
controller, as illustrated above.

缺省情况下，`{{action}}`助手触发模板控制器的一个方法（如上所述）。

If the controller does not implement a method with the same name as the
action in its actions object, the action will be sent to the router,
where the currently active leaf route will be given a chance to handle the
action.

如果控制器没有实现一个与操作的同名方法，那么这个操作将被发送至路由，这样当前处于激活状态的叶节点路由可以处理该操作。

Routes and controllers that handle actions **must place action handlers
inside an `actions` hash**. Even if a route has a method with the same
name as the actions, it will not be triggered unless it is inside an
`actions` hash. In the case of a controller, while there is deprecated support for
triggering a method directly on the controller, it is strongly recommended that
you put your action handling methods inside an `actions` hash for forward
compatibility.

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

As you can see in this example, the action handlers are called such
that when executed, `this` is the route, not the `actions` hash.

正如在上例中所示，操作处理器在执行的时候被调用，`this`是路由的实例，而非`actions`这个哈希。

To continue bubbling the action, you must return true from the handler:

为了记录将操作冒泡，需要在处理器中返回`true`：
 
```js
App.PostRoute = Ember.Route.extend({
 actions: {
   expand: function() {
     this.controller.set('isExpanded', true);
   },

   contract: function() {
     // ...
     if (actionShouldAlsoBeTriggeredOnParentRoute) {
       return true;
   }
 }
});
```

If neither the template's controller nor its associated route implements
a handler, the action will continue to bubble to any parent routes.
Ultimately, if an `ApplicationRoute` is defined, it will have an
opportunity to handle the action.

如果模板对应的控制器和关联的路由都没有实现操作处理器，这个操作将被冒泡到其父级的路由。如果应用定义了`ApplicationRoute`，这里是能处理该操作的最后地方。

When an action is triggered, but no matching action handler is
implemented on the controller, the current route, or any of the
current route's ancestors, an error will be thrown.

当一个操作被触发时，如果在控制器中没有实现对应的操作处理器，当前路由或当前路由的任意一个父节点也没有实现时，将抛出一个错误。

![操作冒泡（Action Bubbling）](/images/template-guide/action-bubbling.png)

This allows you to create a button that has different behavior based on
where you are in the application. For example, you might want to have a
button in a sidebar that does one thing if you are somewhere inside of
the `/posts` route, and another thing if you are inside of the `/about`
route.

这样可以创建一个按钮，且该按钮根据当前应用所在位置有不同的行为。例如，有一个在侧栏中的按钮，当在`/posts`路由和`/about`路由时，分别有不同的行为。

### Action Parameters

### 操作参数

You can optionally pass arguments to the action handler. Any values
passed to the `{{action}}` helper after the action name will be passed
to the handler as arguments.

Ember.js支持传递参数给操作处理器。任何在操作名称之后传递给`{{action}}`助手的值，都会作为参数传递给操作处理器。

For example, if the `post` argument was passed:

例如，如果需要将`post`作为参数：
 
 ```handlebars
 <p><button {{action "select" post}}>✓</button> {{post.title}}</p>
 ```
 
The route's `select` action handler would be called with a single
argument containing the post model:

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

### Specifying the Type of Event

### 指定事件的类型

By default, the `{{action}}` helper listens for click events and triggers
the action when the user clicks on the element.

默认情况下，`{{action}}`助手方法侦听事件，并且在用户点击到此元素时触发指定的操作。

You can specify an alternative event by using the `on` option.

你还可以通过`on`选项指定一个替代事件来侦听。

```handlebars
<p>
  <button {{action "select" post on="mouseUp"}}>✓</button>
  {{post.title}}
</p>
```

You should use the normalized event names [listed in the View guide][1].
In general, two-word event names (like `keypress`) become `keyPress`.

你应该使用标准化之后的事件名称[视图指南已详细列出][1].
通常，两个字的事件名（如`keypress`）,会变成（`keyPress`）。

[1]: /guides/understanding-ember/the-view-layer/#toc_adding-new-events

### Specifying Whitelisted Modifier Keys

### 指定在白名单中的辅助键

By default the `{{action}}` helper will ignore click events with
pressed modifier keys. You can supply an `allowedKeys` option
to specify which keys should not be ignored.

默认情况下，`{{action}}`助手方法会忽略掉用户点击时同时按下的辅助键。你可以通过提供一个`allowedKeys`的选项来指定哪些键按下时不会被忽略掉。

```handlebars
<script type="text/x-handlebars" data-template-name='a-template'>
  <div {{action anActionName allowedKeys="alt"}}>
    click me
  </div>
</script>
```

This way the `{{action}}` will fire when clicking with the alt key
pressed down.

这样，{{action}}助手方法会在用户按下alt键后点击时被触发。

### Stopping Event Propagation

### 阻止事件传递（译注：即不让冒泡）

By default, the `{{action}}` helper allows events it handles to bubble
up to parent DOM nodes. If you want to stop propagation, you can disable
propagation to the parent node.

{{action}}助手方法允许将由它处理的事件冒泡到父级DOM节点。如果你想禁掉这个行为，你完全可以做到。

For example, if you have a **✗** button inside of a link, you will want
to ensure that if the user clicks on the **✗**, that the link is not
clicked.

比如，你有一个链接包含一个**✗**按钮，你想保证这个按钮点击时，链接却不会被点击。

```handlebars
{{#link-to 'post'}}
  Post
  <button {{action close bubbles=false}}>✗</button>
{{/link-to}}
```

Without `bubbles=false`, if the user clicked on the button, Ember.js
will trigger the action, and then the browser will propagate the click
to the link.

没指定`bubbles=false`时，用户点击了按钮，Ember.js 就会触发操作，同时浏览器会将此点击事件传递到父级元素。

With `bubbles=false`, Ember.js will stop the browser from propagating
the event.

指定`bubbles=false`时，Ember.js 就会阻止浏览器将此点击事件传递到父级元素。

### Specifying a Target

### 指定目标

By default, the `{{action}}` helper will send the action to the view's
target, which is generally the view's controller. (Note: in the case of
an Ember.Component, the default target is the component itself.)

在默认情况下，`{{action}}`助手将操作发送到视图的目标，通常是视图的控制器。（注意：Ember.Component默认的目标是组件自身。）

You can specify an alternative target by using the `target` option.
This is most commonly used to send actions to a view instead of a
controller.

使用`target`选项可以指定其他的目标。经常使用这个选项将目标指向视图而非控制器。

```handlebars
<p>
  <button {{action "select" post target="view"}}>✓</button>
  {{post.title}}
</p>
```

You would handle this in an `actions` hash on your view.

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
