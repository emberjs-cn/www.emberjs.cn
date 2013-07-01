英文原文：[http://emberjs.com/guides/configuring-ember/embedding-applications/](http://emberjs.com/guides/configuring-ember/embedding-applications/)

中英对照：[/bilingual_guides/configuring-ember/embedding-applications/](/bilingual_guides/configuring-ember/embedding-applications/)

## 嵌入式应用

大多数情况下，应用所有的UI都将通过路由器管理的模板来创建。

但是如果需要将一个Ember.js应用嵌入一个现有的网页，与其他的Javascript框架共存应该怎么做呢？

### 改变根元素

缺省情况下，应用将渲染[应用模板](/guides/application/the-appliation-template)到网页的`body`元素中。

通过指定`rootElement`属性可以将应用模板渲染到其他的元素中：

```js
App = Ember.Application.create({
  rootElement: '#app'
});
```

`rootElement`可以通过一个元素来指定，也可以通过[jQuery兼容的选择字符串](http://api.jquery.com/category/selectors)来指定。

### 禁用URL管理

通过将[路由的`location`](/guides/routing/specifying-the-location-api)设置为`none`来禁止Ember改变URL：

```js
App.Router = Ember.Router.extend({
  location: 'none'
});
```
