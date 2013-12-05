英文原文：[http://emberjs.com/guides/templates/displaying-a-list-of-items/](http://emberjs.com/guides/templates/displaying-a-list-of-items/)

## 显示项目列表

如果你需要枚举一个对象列表，可以使用`Handlebar`的`{{#each}}`助手:

```handlebars
<ul>
  {{#each people}}
    <li>Hello, {{name}}!</li>
  {{/each}}
</ul>
```

对于数组中的每一个对象，`{{#each}}`块内的模板都会被执行一次，模板的内容将被对象的值所代替。

上面的例子将会输出如下所示的一个列表：

```html
<ul>
  <li>Hello, Yehuda!</li>
  <li>Hello, Tom!</li>
  <li>Hello, Trek!</li>
</ul>
```

与`Handlebars`的所有东西一样，`{{#each}}`助手也具有绑定机制。如果应用程序为数组增加一个对象，或删除一个对象，
`DOM`将自动更新而不需要写任何其他代码。

`{{#each}}`助手还有一个可选的语法形式，这种形式不会改变内部模板的作用域。如果你需要从循环内的外部空间访问一个属性，这个语法很有用。

```handlebars
{{name}}'s Friends

<ul>
  {{#each friend in friends}}
    <li>{{name}}'s friend {{friend.name}}</li>
  {{/each}}
</ul>
```

上面语句将输出这样一个列表：

```html
Trek's Friends

<ul>
  <li>Trek's friend Yehuda</li>
  <li>Trek's friend Tom!</li>
</ul>
```

`{{#each}}`助手也可以使用`{{else}}`助手。如果集合为空，这个块的内容就会被渲染。

```handlebars
{{#each people}}
  Hello, {{name}}!
{{else}}
  Sorry, nobody is here.
{{/each}}  
```
