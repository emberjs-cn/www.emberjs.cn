## `Handlebars`基础 (Handlebars Basics)

Ember.js uses the [Handlebars templating library](http://www.handlebarsjs.com)
to power your app's user interface. Handlebars templates are just like
regular HTML, but also give you the ability to embed expressions that
change what is displayed.

`Ember.js` 使用 [Handlebars模板库](http://www.handlebarsjs.com)
来增强你的应用程序的用户界面。`Handlebars`模板与普通的HTML类似，但是它还提供了嵌入
改变显示内容的表达式的功能。

We take Handlebars and extend it with many powerful features. It may
help to think of your Handlebars templates as an HTML-like DSL for
describing the user interface of your app. And, once you've told
Ember.js to render a given template on the screen, you don't need to
write any additional code to make sure it keeps up-to-date.

我们采用了`Handlebars`,并且还使用许多强大的功能对其进行了扩展。为了有助于理解，你可要认为`Handlebars`模板是一种用于描述你的应用程序界面的类HTML的DSL。而且，一旦使用`Ember.js`在屏幕上渲染一个
模板,开发人员就不需要编写额外的代码来确保其更新。

### 定义模板(Defining Templates)

If you're not using build tools, you can define your application's main
template inside your HTML by putting it inside a `<script>` tag, like so:

如果你没有在使用构建工具,你仍然可以在HTML文档中定义应用程序的主模板，只需要在HTML中加上`<script>`标签,如下所示：

```html
<html>
  <body>
    <script type="text/x-handlebars">
      Hello, <strong>{{firstName}} {{lastName}}</strong>!
    </script>
  </body>
</html>
```

This template will automatically be compiled and become your
_application template_, which will be displayed on the page by the
router when your app loads.

这个模板将会被自动编译成为你的应用程序的主模板,它将在应用程序加载时通过路由显示在页面上。

You can also define templates by name that can be used later. For
example, you may want to define a reusable control that is used in many
different places in your user interface. To tell Ember.js to save the
template for later, instead of displaying it immediately, you can add
the `data-template-name` attribute:

你也可以为模板定义一个名称,以便复用。例如,你可能想定义一个在多个不同的应用程序用户界面处都可以使用的可重用控件。
如果只是希望`Ember.js`先保存模板留做复用，而不是即时显示，那么可以使用`data-template-name`属性：

```html
<html>
  <head>
    <script type="text/x-handlebars" data-template-name="say-hello">
      <div class="my-cool-control">{{name}}</div>
    </script>
  </head>
</html>
```

If you are using build tools to manage your application's assets, most
will know how to precompile Handlebars templates and make them available
to Ember.js.

如果你正在使用构建工具管理应用程序，那么大多数工具可以对`Handlebars`模板进行预编译并使它们可以用于`Ember.js`

### Handlerbars表达式(Handlebars Expressions)

Each template has an associated _controller_: this is where the template 
finds the properties that it displays.

每一个模板都有其相关的控制器：模板从中获取要显示的属性。

You can display a property from your controller by wrapping the property
name in curly braces, like this:

使用花括号将属性名称括起来，就可以显示控制器中所定义的属性,如下所示：

```handlebars
Hello, <strong>{{firstName}} {{lastName}}</strong>!
```

This would look up the `firstName` and `lastName` properties from the
controller, insert them into the HTML described in the template, then
put them into the DOM.

上面的语句将会到控制器中查询`firstName`和`lastName`属性值,插入到模板所描述的HTML文档中,然后放到`DOM`中去。

By default, your top-most application template is bound to your `ApplicationController`:

默认情况下，最上层的应用程序模板与`ApplicationController`关联，即：

```javascript
App.ApplicationController = Ember.Controller.extend({
  firstName: "Trek",
  lastName: "Glowacki"
});
```

The above template and controller would combine to display the following
rendered HTML:

上面的模板和控制器将协作呈现出被渲染的HTML,如下所示：

```html
Hello, <strong>Trek Glowacki</strong>!
```

These expressions (and the other Handlebars features you will learn
about next) are _bindings aware_. That means that if the values used
by your templates ever change, your HTML will be updated automatically.

这些表达式 (以及接下来你将了解的其他`Handlerbars`功能)
都有绑定机制。这意味着HTML文档将随着模板使用的属性值的改变而自动更新。

As your application grows in size, it will have many templates, each
bound to different controllers.

随着一个应用程序规模的扩大，将会存在许多的模板，它们将与不同的控制器关联。
