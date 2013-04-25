## Writing Custom Helpers

## 编写自定义助手方法

Sometimes, you may use the same HTML in your application multiple times. In those case, you can register a custom helper that can be invoked from any Handlebars template.

For example, imagine you are frequently wrapping certain values in a `<span>` tag with a custom class. You can register a helper from your JavaScript like this:

有时，你想在程序里多次使用同一段 HTML 代码。这种情况下，你就可以自定义一个任何 Handlebars 模板都能调用的助手方法。

比如，你频繁地用一个拥有 class（译注：这个class为css中的class，非JavaScript中的类） 的 `<span>`来包裹特定的值。你可以这样注册一个助手方法：

```javascript
Ember.Handlebars.registerBoundHelper('highlight', function(value, options) {
  var escaped = Handlebars.Utils.escapeExpression(value);
  return new Handlebars.SafeString('<span class="highlight">' + escaped + '</span>');
});
```

If you return HTML from a helper, and you don't want it to be escaped,
make sure to return a new `SafeString`. Make sure you first escape any
user data!

如果你想从助手方法返回 HTML，并且你不想转义，那你就要保证返回的结果是新的 `SafeString`。首先要确保已经转义了用户数据。

Anywhere in your Handlebars templates, you can now invoke this helper:

你可以从Handlebars模板的任何地方调用此助手方法：

```handlebars
{{highlight name}}
```

and it will output the following:

输出如下：

```html
<span class="highlight">Peter</span>
```

If the `name` property on the current context changes, Ember.js will
automatically execute the helper again and update the DOM with the new
value.

如果当前上下文中的 `name` 属性发生变化， Ember.js会自动重新执行此助手方法，并用新的值去更新 DOM。

### Dependencies

### 依赖

Imagine you want to render the full name of an `App.Person`. In this
case, you will want to update the output if the person itself changes,
or if the `firstName` or `lastName` properties change.

想象另一种情况，如果要渲染`App.Person`的全名，而希望在person本身变化或者其`firstName`和`lastName`属性值发生变化时，都能自动更新输出，那么，我们可以像下面这样做：

```js
Ember.Handlebars.registerBoundHelper('fullName', function(person) {
  return person.get('firstName') + ' ' + person.get('lastName');
}, 'firstName', 'lastName');
```

You would use the helper like this:

你可以这样用助手方法：

```handlebars
{{fullName person}}
```

Now, whenever the context's person changes, or when any of the
_dependent keys_ change, the output will automatically update.

现在，一旦上下文中的 person 变化了，或任何 _依赖的键值_ 发生变化，输出都会自动更新。

Both the path passed to the `fullName` helper and its dependent keys may
be full _property paths_ (e.g. `person.address.country`).

传递给 `fullName` 助手方法的路径以及它的依赖键值都可以是完整的 _属性路径_ （如`person.address.country`）