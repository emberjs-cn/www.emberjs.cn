英文原文:[http://emberjs.com/guides/templates/changing-scope/](http://emberjs.com/guides/templates/changing-scope/)


## 改变作用域(Changing Scope)

Sometimes you may want to invoke a section of your template with a
different context.

有些时候，你可能希望在一个不同的上下文中调用模板。

For example, instead of repeating a long path, like in this example:

例如，为了不像下面例子这样写出重复代码：

```handlebars
Welcome back, <b>{{person.firstName}} {{person.lastName}}</b>!
```

We can use the `{{#with}}` helper to clean it up:

我们可以使用`{{#with}}`助手来简化它，如下所示：

```handlebars
{{#with person}}
  Welcome back, <b>{{firstName}} {{lastName}}</b>!
{{/with}}
```

`{{#with}}` changes the _context_ of the block you pass to it. The
context, by default, is the template's controller. By using the `{{#with}}`
helper, you can change the context of all of the Handlebars expressions
contained inside the block.

`{{#with}}`改变了区块内的属性的 _上下文。默认情况下，一个模板的上下文是其对应的控制器。
通过使用`{{#with}}`助手，你可以改变在这个区块内的所有`Handlebars`表达式的上下文环境。
