## 条件语句(Conditionals)

Sometimes you may only want to display part of your template if a property
exists.

有些时候，或许我们只希望在一个属性存在的时候显示一部分模板。

We can use the `{{#if}}` helper to conditionally render a block:

这时，我们就可以使用`{{#if}}`助手按条件渲染一个代码块,如下所示：

```handlebars
{{#if person}}
  Welcome back, <b>{{person.firstName}} {{person.lastName}}</b>!
{{/if}}
```

Handlebars will not render the block if the argument passed evaluates to
`false`, `undefined`, `null` or `[]` (i.e., any "falsy" value).

如果传入的参数的值是`false`,`undefined`,`null`或者`[]`(例如，任何"假"值),那么`Handlebars`将不会渲染这个代码块。

If the expression evaluates to falsy, we can also display an alternate template
using `{{else}}`:

如果表达式的值为假,我们也可以使用{{else}}助手显示一个可选的模板,如下所示：

```handlebars
{{#if person}}
  Welcome back, <b>{{person.firstName}} {{person.lastName}}</b>!
{{else}}
  Please log in.
{{/if}}
```

To only render a block if a value is falsy, use `{{#unless}}`:

如果只希望在一个值为假的时候渲染一个模块，那么应该使用`{{#unless}}`助手:

```handlebars
{{#unless hasPaid}}
  You owe: ${{total}}
{{/unless}}
```

`{{#if}}` and `{{#unless}}` are examples of block expressions. These allow you
to invoke a helper with a portion of your template. Block expressions look like
normal expressions except that they contain a hash (#) before the helper name,
and require a closing expression.

`{{#if}}`和`{{#unless}}`都是块表达式的例子。通过使用他们可以只执行模板的一部分。块表达式与普通的表达式类似，
不同的地方只在于：在助手名称前面需要有一个`#`，并且需要一个结束表达式。
