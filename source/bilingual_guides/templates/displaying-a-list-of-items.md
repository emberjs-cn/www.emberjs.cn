英文原文：[http://emberjs.com/guides/templates/displaying-a-list-of-items/](http://emberjs.com/guides/templates/displaying-a-list-of-items/)

## 显示项目列表(Displaying a List of Items)

If you need to enumerate over a list of objects, use Handlebars' `{{#each}}` helper:

如果你需要枚举一个对象列表，可以使用`Handlebar`的`{{#each}}`助手:

```handlebars
<ul>
  {{#each people}}
    <li>Hello, {{name}}!</li>
  {{/each}}
</ul>
```

The template inside of the `{{#each}}` block will be repeated once for
each item in the array, with the context of the template set to the
current item.

对于数组中的每一个对象，`{{#each}}`块内的模板都会被执行一次，模板的内容将被对象的值所代替。

The above example will print a list like this:

上面的例子将会输出如下所示的一个列表：

```html
<ul>
  <li>Hello, Yehuda!</li>
  <li>Hello, Tom!</li>
  <li>Hello, Trek!</li>
</ul>
```

Like everything in Handlebars, the `{{#each}}` helper is bindings-aware.
If your application adds a new item to the array, or removes an item,
the DOM will be updated without having to write any code.

与`Handlebars`的所有东西一样，`{{#each}}`助手也具有绑定机制。如果应用程序为数组增加一个对象，或删除一个对象，
`DOM`将自动更新而不需要写任何其他代码。

There is an alternative form of `{{#each}}` that does not change the
scope of its inner template. This is useful for cases where you need to
access a property from the outer scope within the loop.

`{{#each}}`助手还有一个可选的语法形式，这种形式不会改变内部模板的作用域。如果你需要从循环内的外部空间访问一个属性，这个语法很有用。

```handlebars
{{name}}'s Friends

<ul>
  {{#each friend in friends}}
    <li>{{name}}'s friend {{friend.name}}</li>
  {{/each}}
</ul>
```

This would print a list like this:

上面语句将输出这样一个列表：

```html
Trek's Friends

<ul>
  <li>Trek's friend Yehuda</li>
  <li>Trek's friend Tom!</li>
</ul>
```

The `{{#each}}` helper can have a matching `{{else}}`.
The contents of this block will render if the collection is empty:

`{{#each}}`助手也可以使用`{{else}}`助手。如果集合为空，这个块的内容就会被渲染。

```handlebars
{{#each people}}
  Hello, {{name}}!
{{else}}
  Sorry, nobody is here.
{{/each}}  
```
