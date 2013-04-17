英文原文：[http://emberjs.com/guides/controllers/](http://emberjs.com/guides/controllers/)

## 控制器（Controllers）

In Ember.js, controllers allow you to decorate your models with 
display logic. In general, your models will have properties that
are saved to the server, while controllers will have properties
that your app does not need to save to the server.

在`Ember.js`中，控制器用于将显示逻辑与模型绑定在一起。通常模型包含需要保存到服务器端的属性，而控制器的属性可以不需要保存至服务器端。

For example, if you were building a blog, you would have a
`BlogPost` model that you would present in a `blog_post` template.

例如，构建博客系统时，`blog_post`模板用于呈现`BlogPost`模型。

Your `BlogPost` model would have properties like:

`BlogPost`模型可能包含如下属性：

* `title`
* `intro`
* `body`
* `author`

Your template would bind to these properties in the `blog_post` 
template:

`blog_post`模板可能会绑定这些属性到模板中去。

```javascript
<h1>{{title}}</h1>
<h2>by {{author}}</h2>

<div class='intro'>
  {{intro}}
</div>
<hr>
<div class='body'>
  {{body}}
</div>
```

In this simple example, we don't have any display-specific properties
or actions just yet. For now, our controller just acts as a
pass-through (or "proxy") for the model properties. (Remember that
a controller gets the model it represents from its route handler.)

在这个简单的例子中，没有涉及任何显示相关的属性或操作。目前控制器只是作为模型的一个透明代理。（控制器其路由处理器获取到其表示的模型）。

Let's say we wanted to add a feature that would allow the user to 
toggle the display of the body section. To implement this, we would
first modify our template to show the body only if the value of a 
new `isExpanded` property is true.

假设现在要添加一个允许用户打开或关闭`body`部分的新功能。为了实现这个功能，首先需要编辑模板使其在`isExpanded`属性为`true`的时候才显示`body`。

```javascript
<h1>{{title}}</h1>
<h2>by {{author}}</h2>

<div class='intro'>
  {{intro}}
</div>
<hr>

{{#if isExpanded}}
  <button {{action toggleProperty 'isExpanded'}}>Hide Body</button>
  <div class='body'>
    {{body}}
  </div>
{{else}}
  <button {{action toggleProperty 'isExpanded'}}>Show Body</button>
{{/if}}
```

You might think you should put this property on the model, but 
whether the  body is expanded or not is strictly a display concern.

`body`是否展开是一个明显的显示相关的逻辑，因此将其放入到模型中并不合适。

Putting this property on the controller cleanly separates logic
related to your data model from logic related to what you display
on the screen. This makes it easy to unit-test your model without
having to worry about logic related to your display creeping into
your test setup.

将这个属性放置到控制器中则可以将数据模型与显示相关逻辑的属性清晰的分离开。这使得可以方便的对模型进行单元测试，而完全不需要担心在测试时去考虑相关的显示逻辑。

## 相关性说明（A Note on Coupling）

In Ember.js, templates get their properties from controllers, which
decorate a model.

在`Ember.js`中，模板从装饰了模型的控制器中获取属性。

This means that templates _know about_ controllers and controllers
_know about_ models, but the reverse is not true. A model knows
nothing about which (if any) controllers are decorating it, and
controller does not know which views are presenting its properties.


这就意味着模板_知道_控制器，而控制器_知道_模型，反之却不然。模型并不知道被那些控制器装饰，控制器也不知道那些视图呈现了控制器的属性。

<figure>
<img src="/images/controller-guide/objects.png">
</figure>

This also means that as far as a template is concerned, all of its
properties come from its controller, and it doesn't need to know
about the model directly.

这也意味着涉及至某个模板时，其使用的属性全部来自控制器，模板并不需要直接了解模型。

In practice, Ember.js will create a template's controller once for
the entire application, but the controller's model may change
throughout the lifetime of the application without requiring that
the view knows anything about those mechanics.

实际情况下，`Ember.js`在这个应用中只创建一次模板的控制器，而控制器的模型可以在应用的生命周期中随意变换，不需要视图知道模型的改变。

<aside>
For example, if the user navigates from `/posts/1` to `/posts/2`,
the `PostController` will change its model from `Post.find(1)` to
`Post.find(2)`. The template will update its representations of any
properties on the model, as well as any computed properties on the
controller that depend on the model.

例如，如果用户从`/posts/1`跳转至`/posts/2`，`PostController`将其模型从`Post.find(1)`变为`Post.find(2)`。模板会更新呈现的模型的属性，以及控制器中依赖于模型的计算属性。
</aside>

This makes it easy to test a template in isolation by rendering it 
with a controller object that contains the properties the template
expects. From the template's perspective, a **controller** is simply
an object that provides its data.

这样可以通过使用一个包含模板期望属性的控制器对象来独立的对模板进行测试。从模板的角度来看，**控制器**只是一个为其提供数据的不同对象。

### 代表模型（Representing Models）

Templates are always connected to controllers, not models. This 
makes it easy to separate display-specific properties from model 
specific properties, and to swap out the controller's model as the
user navigates around the page.

模板总是连接着控制器，而非模型。这样可以很容易的将显示相关属性与模型属性分离开。当用户在不同的页面游弋的时候，也可以很方便的置换控制器的模型。

For convenience, Ember.js provides controllers that _proxy_ 
properties from their models so that you can say `{{name}}` in your
template rather than `{{model.name}}`. An `Ember.ArrayController` 
proxies properties from an Array, and an `Ember.ObjectController` 
proxies properties from an obect.

为了方便起见，`Ember.js`的控制器代理了其模型的属性，因此可以在模板中使用`{{name}}`而非`{{model.name}}`来访问模型的属性。`Ember.ArrayController`代理了`Array`的属性，`Ember.ObjectController`则代理了一个对象的属性。

If your controller is an `ArrayController`, you can iterate directly
over the controller using `{{#each controller}}`. This keeps the
template from having to know about how the controller is implemented
and makes isolation testing and refactoring easier.

如果控制器是一个`ArrayController`，那么可以使用`{{#each
controller}}`来直接遍历控制器。这样模板不需要知道控制器是如何实现的，从而使独立测试和重构变得更加简单。

### 保存应用属性（Storing Application Properties）

Not all properties in your application need to be saved to the 
server. Any time you need to store information only for the lifetime
of this application run, you should store it on a controller.

不是所有在应用中的属性都需要保存到服务器端。当需要只为本次运行的应用保存一些信息的时候，可以将其保存到控制器中。

For example, imagine your application has a search field that is 
always present. You could store a `query` property on your
`ApplicationController`, and bind the `search` field in the `
application` template to that property.

例如，应用中有一个一直存在的搜索框，那么就可以在`ApplicationController`中存储一个`query`属性，并将在`application`模板中的搜索框绑定到该属性。

```handlebars
<!-- application.handlebars -->
<header>
  {{view Ember.TextField valueBinding="search" action="query"}}
</header>

{{outlet}}
```

```javascript
App.ApplicationController = Ember.Controller.extend({
  // the initial value of the `search` property
  search: '',

  query: function() {
    // the current value of the text field
    var query = this.get('search');
    this.transitionToRoute('search', { query: query });
  }
});
```

The `application` template stores its properties and sends its 
actions to the `ApplicationController`. In this case, when the user
hits enter, the application will transition to the `search` route,
passing the query as a parameter.

`application`模板保存搜索框的属性，并将其操作发送给`ApplicationController`。在此情形下，当用户敲回车时，应用将转换至`search`路由，并将`query`作为参数传递。
