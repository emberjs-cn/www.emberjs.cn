英文原文：[http://emberjs.com/guides/components/customizing-a-components-element/](http://emberjs.com/guides/components/customizing-a-components-element/)

中英对照：[http://emberjs.cn/bilingual_guides/components/customizing-a-components-element/](http://emberjs.cn/bilingual_guides/components/customizing-a-components-element/)

By default, each component is backed by a `<div>` element. If you were
to look at a rendered component in your developer tools, you would see
a DOM representation that looked something like:

默认情况下，每个组件是一个`<div>`元素。如果使用开发工具查看渲染后的组件，将看到一个如下所示的DOM表示：

```html
<div id="ember180" class="ember-view">
  <h1>My Component</h1>
</div>
```

You can customize what type of element Ember generates for your
component, including its attributes and class names, by creating a
subclass of `Ember.Component` in your JavaScript.

通过使用Javascript创建一个`Ember.Component`子类，可以自定义Ember生成的组件使用的元素类型，包括其属性和类名。

### Customizing the Element

### 自定义元素

To use a tag other than `div`, subclass `Ember.Component` and assign it
a `tagName` property. This property can be any valid HTML5 tag name as a
string.

为了不使用`div`，继承`Ember.Component`并为其添加一个`tagName`属性。这个属性可以是任何合法的HTML5标签。

```js
App.NavigationBarComponent = Ember.Component.extend({
  tagName: 'nav'
});
```

```handlebars
{{! templates/components/navigation-bar }}
<ul>
  <li>{{#link-to 'home'}}Home{{/link-to}}</li>
  <li>{{#link-to 'about'}}About{{/link-to}}</li>
</ul>
```

### Customizing Class Names

### 自定义类名

You can also specify which class names are applied to the component's
element by setting its `classNames` property to an array of strings:

通过设置`classNames`属性为一个字符串数组，可以指定组件元素的类名：

```javascript
App.NavigationBarComponent = Ember.Component.extend({
  classNames: ['primary']
});
```

If you want class names to be determined by properties of the component,
you can use class name bindings. If you bind to a Boolean property, the
class name will be added or removed depending on the value:

如果需要通过组件的属性来决定使用的类名，可以使用类名绑定。如果绑定一个布尔型属性，类名将根据该属性的值来决定是添加还是移除类名：

```js
App.TodoItemComponent = Ember.Component.extend({
  classNameBindings: ['isUrgent'],
  isUrgent: true
});
```

This component would render the following:

组件将渲染为：

```html
<div class="ember-view is-urgent"></div>
```

If `isUrgent` is changed to `false`, then the `is-urgent` class name will be removed.

如果`isUrgent`变为`false`，那么`is-urgent`类名将被移除。

By default, the name of the Boolean property is dasherized. You can customize the class name
applied by delimiting it with a colon:

默认情况下，布尔属性的名称会用'-'来连接。使用分号可以自定义类名：

```javascript
App.TodoItemComponent = Ember.Component.extend({
  classNameBindings: ['isUrgent:urgent'],
  isUrgent: true
});
```

This would render this HTML:

组件将渲染为：

```html
<div class="ember-view urgent">
```

Besides the custom class name for the value being `true`, you can also specify a class name which is used when the value is `false`:

除了为值为`true`的添加自定义类名外，还可以在值为`false`的时候来指定类名：

```javascript
App.TodoItemComponent = Ember.Component.extend({
  classNameBindings: ['isEnabled:enabled:disabled'],
  isEnabled: false
});
```

This would render this HTML:

组件将渲染为：

```html
<div class="ember-view disabled">
```

You can also specify a class should only be added when the property is
`false` by declaring `classNameBindings` like this:

另外，还可以通过定义`classNameBindings`，实现只在属性为`false`的时候添加类名：

```javascript
App.TodoItemComponent = Ember.Component.extend({
  classNameBindings: ['isEnabled::disabled'],
  isEnabled: false
});
```

This would render this HTML:

组件将渲染为：

```html
<div class="ember-view disabled">
```

If the `isEnabled` property is set to `true`, no class name is added:

如果`isEnabled`属性设置为`true`，则不会添加类名：

```html
<div class="ember-view">
```

If the bound value is a string, that value will be added as a class name without
modification:

如果绑定的值是一个字符串，那么该值将作为类名，且不加任何修改：

```javascript
App.TodoItemComponent = Ember.Component.extend({
  classNameBindings: ['priority'],
  priority: 'highestPriority'
});
```

This would render this HTML:

组件将渲染为：

```html
<div class="ember-view highestPriority">
```

### Customizing Attributes

### 自定义属性

You can bind attributes to the DOM element that represents a component
by using `attributeBindings`:

通过`attributeBindings`可以绑定属性到代表组件的DOM元素：

```javascript
App.LinkItemComponent = Ember.Component.extend({
  tagName: 'a',
  attributeBindings: ['href'],
  href: "http://emberjs.com"
});
```

You can also bind these attributes to differently named properties:

也可以使用不同的命名属性来绑定这些属性：

```javascript
App.LinkItemComponent = Ember.Component.extend({
  tagName: 'a',
  attributeBindings: ['customHref:href'],
  customHref: "http://emberjs.com"
});
```

### Example

### 例子

Here is an example todo application that shows completed todos with a
red background:

下面是一个Todo应用的例子，展示了使用红色的背景来显示已完成的待办事项：

<a class="jsbin-embed" href="http://jsbin.com/utonef/1/embed?live">JS Bin</a><script src="http://static.jsbin.com/js/embed.js"></script>
