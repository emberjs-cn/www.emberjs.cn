英文原文：[http://emberjs.com/guides/components/customizing-a-components-element/](http://emberjs.com/guides/components/customizing-a-components-element/)

中英对照：[http://emberjs.cn/bilingual_guides/components/customizing-a-components-element/](http://emberjs.cn/bilingual_guides/components/customizing-a-components-element/)

默认情况下，每个组件是一个`<div>`元素。如果使用开发工具查看渲染后的组件，将看到一个如下所示的DOM表示：

```html
<div id="ember180" class="ember-view">
  <h1>My Component</h1>
</div>
```

通过使用Javascript创建一个`Ember.Component`子类，可以自定义Ember生成的组件使用的元素类型，包括其属性和类名。

### 自定义元素

为了不使用`div`，继承`Ember.Component`并为其添加一个`tagName`属性。这个属性可以是任何合法的HTML5标签。

```js
App.NavigationBarComponent = Ember.Component.extend({
  tagName: 'nav'
});
```

```handlebars
{{! templates/components/navigation-bar }}
<ul>
  <li>{{#linkTo 'home'}}Home{{/linkTo}}</li>
  <li>{{#linkTo 'about'}}About{{/about}}</li>
</ul>
```

### 自定义类名

通过设置`classNames`属性为一个字符串数组，可以指定组件元素的类名：

```javascript
App.NavigationBarComponent = Ember.Component.extend({
  classNames: ['primary']
});
```

如果需要通过组件的属性来决定使用的类名，可以使用类名绑定。如果绑定一个布尔型属性，类名将根据该属性的值来决定是添加还是移除类名：

```js
App.TodoItemComponent = Ember.Component.extend({
  classNameBindings: ['isUrgent'],
  isUrgent: true
});
```

组件将渲染为：

```html
<div class="ember-view is-urgent"></div>
```

如果`isUrgent`变为`false`，那么`is-urgent`类名将被移除。

默认情况下，布尔属性的名称会用'-'来连接。使用分号可以自定义类名：

```javascript
App.TodoItemComponent = Ember.Component.extend({
  classNameBindings: ['isUrgent:urgent'],
  isUrgent: true
});
```

组件将渲染为：

```html
<div class="ember-view urgent">
```

除了为值为`true`的添加自定义类名外，还可以在值为`false`的时候来指定类名：

```javascript
App.TodoItemComponent = Ember.Component.extend({
  classNameBindings: ['isEnabled:enabled:disabled'],
  isEnabled: false
});
```

组件将渲染为：

```html
<div class="ember-view disabled">
```

另外，还可以通过定义`classNameBindings`，实现只在属性为`false`的时候添加类名：

```javascript
App.TodoItemComponent = Ember.Component.extend({
  classNameBindings: ['isEnabled::disabled'],
  isEnabled: false
});
```

组件将渲染为：

```html
<div class="ember-view disabled">
```

如果`isEnabled`属性设置为`true`，则不会添加类名：

```html
<div class="ember-view">
```

如果绑定的值是一个字符串，那么该值将作为类名，且不加任何修改：

```javascript
App.TodoItemComponent = Ember.Component.extend({
  classNameBindings: ['priority'],
  priority: 'highestPriority'
});
```

组件将渲染为：

```html
<div class="ember-view highestPriority">
```

### 自定义属性

通过`attributeBindings`可以绑定属性到代表组件的DOM元素：

```javascript
App.LinkItemComponent = Ember.Component.extend({
  tagName: 'a',
  attributeBindings: ['href'],
  href: "http://emberjs.com"
});
```

也可以使用不同的命名属性来绑定这些属性：

```javascript
App.LinkItemComponent = Ember.Component.extend({
  tagName: 'a',
  attributeBindings: ['customHref:href'],
  customHref: "http://emberjs.com"
});
```

### 例子

下面是一个Todo应用的例子，展示了使用红色的背景来显示已完成的待办事项：

<a class="jsbin-embed" href="http://jsbin.com/utonef/1/embed?live">JS Bin</a><script src="http://static.jsbin.com/js/embed.js"></script>
