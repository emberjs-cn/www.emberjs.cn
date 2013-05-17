英文原文：[http://emberjs.com/guides/views/adding-layouts-to-views/](http://emberjs.com/guides/views/adding-layouts-to-views/)

## 为视图添加布局

视图可以拥有一个次模板来包裹其主模板。如同模板一样，布局是可以插入到视图标签下的Handlebars模板。

通过设置`layoutName`属性来配置视图的布局模板。

而布局模板通过`Handlebars`的`{{yield}}`助手来指定在哪里插入主模板。视图渲染后的`template`的HTML内容将被插入到`{{yield}}`助手所在的位置。

首先，定义如下的布局：

```html
<script type="text/x-handlebars" data-template-name="my_layout">
  <div class="content-wrapper">
    {{yield}}
  </div>
</script>
```

接着定义如下的主模板：

```html
<script type="text/x-handlebars" data-template-name="my_content">
  Hello, <b>{{view.name}}</b>!
</script>
```

最后定义视图，并指定其使用定义的布局来包裹模板：

```javascript
AViewWithLayout = Ember.View.extend({
  name: 'Teddy',
  layoutName: 'my_layout',
  templateName: 'my_content'
});
```

上面的例子中定义的视图将生成如下的HTML：

```html
<div class="content-wrapper">
  Hello, <b>Teddy</b>!
</div>
```

#### 在实际中应用布局

布局在一个视图具有通用的结构和行为，而其主模板会发生变化时非常有用。一个非常典型应用场景就是弹出视图。

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

接着定义弹出视图：

```javascript
App.PopupView = Ember.View.extend({
  layoutName: 'popup'
});
```

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
