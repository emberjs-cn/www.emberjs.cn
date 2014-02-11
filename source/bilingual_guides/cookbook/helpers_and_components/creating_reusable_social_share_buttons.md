### Problem

### 问题

You want to create a reusable [Tweet button](https://dev.twitter.com/docs/tweet-button)
for your application.

希望可以为应用创建一个可以重用的[Tweet按钮](https://dev.twitter.com/docs/tweet-button)。

### Solution

### 解决方案

Write a custom component that renders the Tweet button with specific attributes
passed in.

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

Include Twitter's widget code in your HTML:

在HTML代码中包含Twitter的控件：

```javascript
<script type="text/javascript" src="http://platform.twitter.com/widgets.js" id="twitter-wjs"></script>
```

### Discussion

### 讨论

Twitter's widget library expects to find an `<a>` tag on the page with specific `data-` attributes applied.
It takes the values of these attributes and, when the `<a>` tag is clicked, opens an iFrame for twitter sharing.

Twitter的控件库希望能在页面上找到一个设置了特定`data-`属性的`<a>`标签。当其被点击时，会采用这些属性的值来打开一个iFrame，用于提供Twitter的分享。

The `share-twitter` component takes four options that match the four attributes for the resulting `<a>` tag:
`data-url`, `data-text`, `data-size`, `data-hashtags`. These options and their values become properties on the
component object. 

`share-twitter`组件采用了四个选项来对应该`<a>`标签的四个属性：`data-url`，`data-text`，`data-size`，`data-hashtags`。这些选项及其值成为组件对象的属性。

The component defines certain attributes of its HTML representation as bound to properties of the object through
its `attributeBindings` property. When the values of these properties change, the component's HTML element's
attributes will be updated to match the new values.

组件通过`attributeBindings`属性，定义了一些作为对象绑定属性的HTML表示的属性。当这些属性的值发生改变时，组件的HTML元素属性也会发生相应的变化。


An appropriate tag and css class are applied through the `tagName` and `classNames` properties.

通过`tagName`和`classNames`属性设定了对应的标签和CSS类。

Note: Your component must have a matching template named `share-twitter`. Because there is no HTML inside our `<a>` tag, this template will be empty.

注意：组件必须有一个命名为`share-twitter`的模板。由于`<a>`中不需要任何HTML代码，所以该模板的内容为空。

#### Example

#### 示例

<a class="jsbin-embed" href="http://emberjs.jsbin.com/OpocEPu/1/edit?js,output">JS Bin</a>
