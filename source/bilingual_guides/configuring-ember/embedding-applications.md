英文原文：[http://emberjs.com/guides/configuring-ember/embedding-applications/](http://emberjs.com/guides/configuring-ember/embedding-applications/)

中英对照：[/bilingual_guides/configuring-ember/embedding-applications/](/bilingual_guides/configuring-ember/embedding-applications/)

## Embedding Applications

## 嵌入式应用

In most cases, your application's entire UI will be created by templates
that are managed by the router.

大多数情况下，应用所有的UI都将通过路由器管理的模板来创建。

But what if you have an Ember.js app that you need to embed into an
existing page, or run alongside other JavaScript frameworks?

但是如果需要将一个Ember.js应用嵌入一个现有的网页，与其他的Javascript框架共存应该怎么做呢？

### Changing the Root Element

### 改变根元素

By default, your application will render the [application
template](/guides/templates/the-application-template) and attach it to
the document's `body` element.

缺省情况下，应用将渲染[应用模板](/guides/templates/the-appliation-template)到网页的`body`元素中。

You can tell the application to append the application template to a
different element by specifying its `rootElement` property:

通过指定`rootElement`属性可以将应用模板渲染到其他的元素中：

```js
App = Ember.Application.create({
  rootElement: '#app'
});
```

This property can be specified as either an element or a
[jQuery-compatible selector
string](http://api.jquery.com/category/selectors/).

`rootElement`可以通过一个元素来指定，也可以通过[jQuery兼容的选择字符串](http://api.jquery.com/category/selectors)来指定。

### Disabling URL Management

### 禁用URL管理

You can prevent Ember from making changes to the URL by [changing the
router's `location`](/guides/routing/specifying-the-location-api) to
`none`:

通过将[路由的`location`](/guides/routing/specifying-the-location-api)设置为`none`来禁止Ember改变URL：

```js
App.Router = Ember.Router.extend({
  location: 'none'
});
```
