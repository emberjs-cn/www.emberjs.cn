英文原文:[http://emberjs.com/guides/templates/changing-scope/](http://emberjs.com/guides/templates/changing-scope/)


## 切换作用域(Changing Scope)

Sometimes you may want to invoke a section of your template with a
different context.

有些时候，你可能希望在模版中的一个特定部分使用不同的上下文：

For example, instead of repeating a long path, like in this example:

例如，通过切换上下文，我们可以不需重复的指定属性的上下文路径，如下所示：

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

`{{#with}}`切换了区块内的属性的 _上下文_。默认情况下，一个模板的上下文是其对应的控制器。
通过使用`{{#with}}`助手，你可以切换在这个区块内的所有`Handlebars`表达式的上下文。

注意：可以使用"as"关键字，将上下文保存至一个变量供嵌套使用：

```handlebars
{{#with person as user}}
  {{#each book in books}}
    {{user.firstName}} has read {{book.name}}!
  {{/each}}
{{/with}}
```
