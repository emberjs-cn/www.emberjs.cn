英文原文： [http://emberjs.com/guides/templates/writing-helpers/](http://emberjs.com/guides/templates/writing-helpers/)

## 编写自定义助手方法

有时，你想在程序里多次使用同一段 HTML 代码。这种情况下，你就可以自定义一个任何 Handlebars 模板都能调用的助手方法。

比如，你频繁地用一个拥有 class（译注：这个class为css中的class，非JavaScript中的类） 的 `<span>`来包裹特定的值。你可以这样注册一个助手方法：

```javascript
Ember.Handlebars.registerBoundHelper('highlight', function(value, options) {
  var escaped = Handlebars.Utils.escapeExpression(value);
  return new Handlebars.SafeString('<span class="highlight">' + escaped + '</span>');
});
```

如果你想从助手方法返回 HTML，并且你不想转义，那你就要保证返回的结果是新的 `SafeString`。首先要确保已经转义了用户数据。


你可以从Handlebars模板的任何地方调用此助手方法：

```handlebars
{{highlight name}}
```

输出如下：

```html
<span class="highlight">Peter</span>
```

如果当前上下文中的 `name` 属性发生变化， Ember.js会自动重新执行此助手方法，并用新的值去更新 DOM。


### 依赖


想象一下，如果你想渲染`App.Person`的全名。这种情况下，如果 person 本身变化了或`firstName`, `lastName`属性变化了，你都会想要更新输出。

```js
Ember.Handlebars.registerBoundHelper('fullName', function(person) {
  return person.get('firstName') + ' ' + person.get('lastName');
}, 'firstName', 'lastName');
```


你可以这样用助手方法：

```handlebars
{{fullName person}}
```


现在，一旦上下文中的 person 变化了，或任何 _依赖的键值_ 发生变化，输出都会自动更新。

传递给 `fullName` 助手方法的 path 以及它的依赖键值都可以是完整的 _property paths_ （如`person.address.country`）
（译注：此处的path及property paths不知如何翻译）