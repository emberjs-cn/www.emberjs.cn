英文原文：[http://emberjs.com/guides/cookbook/helpers_and_components/creating_reusable_social_share_buttons](http://emberjs.com/guides/cookbook/helpers_and_components/creating_reusable_social_share_buttons)

### 问题

希望可以为应用创建一个可以重用的[Tweet按钮](https://dev.twitter.com/docs/tweet-button)。

### 解决方案


编写一个自定义组件，使用传入的特定属性渲染Tweet按钮。

```handlebars
{{share-twitter data-url="http://emberjs.com" 
                data-text="EmberJS Components are Amazing!" 
                data-size="large" 
                data-hashtags="emberjs"}}

```

```javascript
App.ShareTwitterComponent = Ember.Component.extend({
  tagName: 'a',
  classNames: 'twitter-share-button',
  attributeBindings: ['data-size', 'data-url', 'data-text', 'data-hashtags']
});
```

在HTML代码中包含Twitter的控件：

```javascript
<script type="text/javascript" src="http://platform.twitter.com/widgets.js" id="twitter-wjs"></script>
```

### 讨论

Twitter的控件库希望能在页面上找到一个设置了特定`data-`属性的`<a>`标签。当其被点击时，会采用这些属性的值来打开一个iFrame，用于提供Twitter的分享。

`share-twitter`组件采用了四个选项来对应该`<a>`标签的四个属性：`data-url`，`data-text`，`data-size`，`data-hashtags`。这些选项及其值成为组件对象的属性。

组件通过`attributeBindings`属性，定义了一些作为对象绑定属性的HTML表示的属性。当这些属性的值发生改变时，组件的HTML元素属性也会发生相应的变化。

通过`tagName`和`classNames`属性设定了对应的标签和CSS类。

注意：组件必须有一个命名为`share-twitter`的模板。由于`<a>`中不需要任何HTML代码，所以该模板的内容为空。

#### 示例

<a class="jsbin-embed" href="http://emberjs.jsbin.com/OpocEPu/1/edit?js,output">JS Bin</a>
