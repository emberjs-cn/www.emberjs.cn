英文原文：[http://emberjs.com/guides/templates/development-helpers/](http://emberjs.com/guides/templates/development-helpers/)

## 开发助手

Handlebars和Ember中定义了一些可以简化开发模板的助手。这些助手可以方便的将变量输出到浏览器的控制台中，或者在模板中激活调试。

### 日志

`{{log}}`助手可以方便的将当前渲染上下文中的变量、表达式输出到浏览器的控制台中：

```handlebars
{{log 'Name is:', name}}
```

`{{log}}`助手还支持原生类型，例如字符串和数字。

### 添加断点

`{{debugger}}`助手为Handlebars提供了与Javascript中`debugger`关键字一样的功能。它将在`{{debugger}}`助手里面暂停应用的执行，从而可以能够查看当前渲染的上下文：

```handlebars
{{debugger}}
```

在该助手被调用之前，定义了两个非常有用的变量：

* `templateContext`：获取到的变量的当前上下文。比如一个控制器。
* `typeOfTemplateContext`：一个字符串表明`templateContext`的类型。

例如，如果想知道为什么一个变量没有在模板中显示，就可以使用`{{debugger}}`助手。当执行到断点处，就可以在控制台中使用`templateContext`来查看属性：

```
> templateContext.get('name')
"Bruce Lee"
```
