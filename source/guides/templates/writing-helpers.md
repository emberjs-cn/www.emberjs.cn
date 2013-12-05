英文原文： [http://emberjs.com/guides/templates/writing-helpers/](http://emberjs.com/guides/templates/writing-helpers/)

有时，你想在程序里多次使用同一段 HTML 代码。这种情况下，你就可以自定义一个任何 Handlebars 模板都能调用的助手方法。

比如，你频繁地用一个拥有 class（译注：这个class为css中的class，非JavaScript中的类） 的 `<span>`来包裹特定的值。你可以这样注册一个助手方法：

```javascript
Ember.Handlebars.helper('highlight', function(value, options) {
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


想象另一种情况，如果要渲染`App.Person`的全名，而希望在person本身变化或者其`firstName`和`lastName`属性值发生变化时，都能自动更新输出，那么，我们可以像下面这样做：

```js
Ember.Handlebars.helper('fullName', function(person) {
  return person.get('firstName') + ' ' + person.get('lastName');
}, 'firstName', 'lastName');
```


你可以这样用助手方法：

```handlebars
{{fullName person}}
```


现在，一旦上下文中的 person 变化了，或任何 _依赖的键值_ 发生变化，输出都会自动更新。

传递给 `fullName` 助手方法的路径以及它的依赖键值都可以是完整的 _属性路径_ （如`person.address.country`）

### 自定义视图助手

有时需要经常在多个地方使用`{{view}}`来渲染视图类。其实在这样的情况下，可以通过注册一个自定义的视图助手来简化。

例如，假设有一个视图名为`App.CalendarView`，那么可以注册一个如下的助手：

```javascript
Ember.Handlebars.helper('calendar', App.CalendarView);
```

这样在模板中使用`App.CalendarView`就变成：

```handlebars
{{calendar}}
```

该助手提供了与视图助手相同的功能，并且可以接收相同的参数：

```handlebars
{{view App.CalendarView}}
```
