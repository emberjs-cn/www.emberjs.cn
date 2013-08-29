英文原文：[http://emberjs.com/guides/components/handling-user-interaction-with-actions/](http://emberjs.com/guides/components/ndling-user-interaction-with-actions/)

中英对照：[http://emberjs.cn/bilingual_guides/components/handling-user-interaction-with-actions/](http://emberjs.cn/bilingual_guides/components/handling-user-interaction-with-actions/)

Components allow you to define controls that you can reuse throughout
your application. If they're generic enough, they can also be shared
with others and used in multiple applications.

组件可以定义能在整个应用中使用的控件。如果组件非常通用，组件可以在很多应用中共享。

To make a reusable control useful, however, you first need to allow
users of your application to interact with it.

为了使得可重用控件有用，那么首先需要应用的用户可以与其交互。

You can make elements in your component interactive by using the
`{{action}}` helper. This is the [same `{{action}}` helper you use in
application templates](/guides/templates/actions), but it has an
important difference when used inside a component.

使用`{{action}}`助手可以让组件支持交互。这与[在应用模板中使用的`{{action}}`助手是相同的](/guides/templates/actions)，不过在组件中使用时有一点重要的不同。

Instead of sending an action to the template's controller, then bubbling
up the route hierarchy, actions sent from inside a component are sent
directly to the component's `Ember.Component` instance, and do not
bubble.

组件中的操作将被直接发送到组件的`Ember.Component`实例，不会冒泡。更不会发送到模板的控制器，也不会在路由中冒泡。

For example, imagine the following component that shows a post's title.
When the title is clicked, the entire post body is shown:

例如，假设下面的组件显示一篇博客的标题。当标题被点击时，完整的博客将被显示：

```handlebars
<script type="text/x-handlebars" id="components/post-summary">
  <h3 {{action "toggleBody"}}>{{title}}</h3>
  {{#if isShowingBody}}
    <p>{{{body}}}</p>
  {{/if}}
</script>
```

```js
App.PostSummaryComponent = Ember.Component.extend({
  actions: {
    toggleBody: function() {
      this.toggleProperty('isShowingBody');
    }
  }
});
```
<a class="jsbin-embed" href="http://jsbin.com/EWEQeKO/1/embed?live">JS Bin</a><script src="http://static.jsbin.com/js/embed.js"></script>

The `{{action}}` helper can accept arguments, listen for different event
types, control how action bubbling occurs, and more.

`{{action}}`助手可以接收参数，监听不同的事件类型，控制操作冒泡等等。

For details about using the `{{action}}` helper, see the [Actions section](/guides/templates/actions) of the Templates chapter.

更多关于使用`{{action}}`助手的内容，请参看模板一章中的[操作部分](/guides/templates/actions)。
