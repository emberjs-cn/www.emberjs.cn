英文原文：[http://emberjs.com/guides/templates/conditionals/](http://emberjs.com/guides/templates/conditionals/)

有些时候，或许我们只希望在一个属性存在的时候显示一部分模板。

这时，我们就可以使用`{{#if}}`助手按条件渲染一个代码块,如下所示：

```handlebars
{{#if person}}
  Welcome back, <b>{{person.firstName}} {{person.lastName}}</b>!
{{/if}}
```

如果传入的参数的值是`false`,`undefined`,`null`或者`[]`(例如，任何"假"值),那么`Handlebars`将不会渲染这个代码块。

如果表达式的值为假,我们也可以使用{{else}}助手显示另外一个模板,如下所示：

```handlebars
{{#if person}}
  Welcome back, <b>{{person.firstName}} {{person.lastName}}</b>!
{{else}}
  Please log in.
{{/if}}
```

如果只希望在一个值为假的时候渲染一个区块，那么应该使用`{{#unless}}`助手:

```handlebars
{{#unless hasPaid}}
  You owe: ${{total}}
{{/unless}}
```

`{{#if}}`和`{{#unless}}`都是块表达式的例子。通过使用他们可以只执行模板的一部分。块表达式与普通的表达式类似，
不同的地方只在于：在助手名称前面需要有一个`#`，并且需要一个结束表达式。
