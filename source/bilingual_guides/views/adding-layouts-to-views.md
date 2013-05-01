## Adding Layouts to Views

## 为视图添加布局

Views can have a secondary template that wraps their main template. Like templates,
layouts are Handlebars templates that will be inserted inside the
view's tag.

视图可以拥有一个次模板来包裹其主模板。如同模板一样，布局是可以插入到视图标签下的Handlebars模板。

To tell a view which layout template to use, set its `layoutName` property.

通过设置`layoutName`属性来配置视图的布局模板。

To tell the layout template where to insert the main template, use the Handlebars `{{yield}}` helper.
The HTML contents of a view's rendered `template` will be inserted where the `{{yield}}` helper is.

而布局模板通过`Handlebars`的`{{yield}}`助手来指定在哪里插入主模板。视图渲染后的`template`的HTML内容将被插入到`{{yield}}`助手所在的位置。

First, you define the following layout template:

首先，定义如下的布局：

```html
<script type="text/x-handlebars" data-template-name="my_layout">
  <div class="content-wrapper">
    {{yield}}
  </div>
</script>
```

And then the following main template:

接着定义如下的主模板：

```html
<script type="text/x-handlebars" data-template-name="my_content">
  Hello, <b>{{view.name}}</b>!
</script>
```

Finally, you define a view, and instruct it to wrap the template with the defined layout:

最后定义视图，并指定其使用定义的布局来包裹模板：

```javascript
AViewWithLayout = Ember.View.extend({
  name: 'Teddy',
  layoutName: 'my_layout',
  templateName: 'my_content'
});
```

This will result in view instances containing the following HTML

上面的例子中定义的视图将生成如下的HTML：

```html
<div class="content-wrapper">
  Hello, Teddy!
</div>
```

#### Applying Layouts in Practice

#### 在实际中应用布局

Layouts are extremely useful when you have a view with a common wrapper and behavior, but its main template might change.
One possible scenario is a Popup View.

布局在一个视图具有通用的结构和行为，而其主模板会发生变化时非常有用。一个非常典型应用场景就是弹出视图。

You can define your popup layout template:

可以预先定义弹出布局的模板：

```html
<script type="text/x-handlebars" data-template-name="popup">
  <div class="popup">
    <button class="popup-dismiss">x</button>
    <div class="popup-content">
    {{yield}}
    </div>
  </div>
</script>
```

Then define your popup view:

接着定义弹出视图：

```javascript
App.PopupView = Ember.View.extend({
  layoutName: 'popup'
});
```

Now you can re-use your popup with different templates:

现在可以使用不同的模板来复用弹出视图：

```html
{{#view App.PopupView}}
  <form>
    <label for="name">Name:</label>
    <input id="name" type="text" />
  </form>
{{/view}}

{{#view App.PopupView}}
  <p> Thank you for signing up! </p>
{{/view}}
```
