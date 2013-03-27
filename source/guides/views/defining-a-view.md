英文原文：[http://emberjs.com/guides/views/defining-a-view/](http://emberjs.com/guides/views/defining-a-view/)

## 定义视图

你可以使用`Ember.View`来渲染一个`Handlebars`模板并将它插入到`DOM`中。

为了告诉视图要用哪个模板，可以设置它的`temaplateName`属性。例如，如果我有一个像这样的`<script>`标签:


```html
<html>
  <head>
    <script type="text/x-handlebars" data-template-name="say-hello">
      Hello, <b>{{view.name}}</b>
    </script>
  </head>
</html>
```

我会将`templateName`属性设置成`"say-hello"`。


```javascript
var view = Ember.View.create({
  templateName: 'say-hello',
  name: "Bob"
});
```

注意：本指南其余部分，大多数例子中的`templateName`属性将会被省略。你可以假定当我们展示包含`Ember.View`和`Handlebars`模板的代码例子时，视图已经通过配置`templateName`属性来显示指定的模板了。

你可以通过调用`appendTo`将视图追加到文档中：

```javascript
view.appendTo('#container');
```

做为简写，你可以通过调用`append`来将视图追加到文档中：

```javascript
view.append();
```

调用`remove`即可从文档中删除视图：

```javascript
view.remove();
```
