## 定义视图 (Defining a View)

You can use `Ember.View` to render a Handlebars template and insert it into the DOM.

你可以使用`Ember.View`来渲染一个`Handlebars`模板并将它插入到`DOM`中。

To tell the view which template to use, set its `templateName` property. For example, if I had a `<script>` tag like this:

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

I would set the `templateName` property to `"say-hello"`.

我会将`templateName`属性设置成`"say-hello"`。


```javascript
var view = Ember.View.create({
  templateName: 'say-hello',
  name: "Bob"
});
```

Note: For the remainder of the guide, the `templateName` property will be omitted from most examples. You can assume that if we show a code sample that includes an Ember.View and a Handlebars template, the view has been configured to display that template via the `templateName` property.

注意：本指南其余部分，大多数例子中的`templateName`属性将会被省略。你可以假定当我们展示包含`Ember.View`和`Handlebars`模板的代码例子时，视图已经通过配置`templateName`属性来显示指定的模板了。

You can append views to the document by calling `appendTo`:

你可以通过调用`appendTo`将视图追加到文档中：

```javascript
view.appendTo('#container');
```

As a shorthand, you can append a view to the document body by calling `append`:

做为简写，你可以通过调用`append`来将视图追加到文档中：

```javascript
view.append();
```

To remove a view from the document, call `remove`:

调用`remove`即可从文档中删除视图：

```javascript
view.remove();
```
