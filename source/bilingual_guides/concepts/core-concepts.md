英文原文：[http://emberjs.com/guides/concepts/core-concepts/](http://emberjs.com/guides/concepts/core-concepts)

## 核心概念(Core Concepts)

To get started with Ember.js, there are a few core concepts you
should understand. 

要开始学习Ember.js,首先要了解一些核心概念。

Ember.js is designed to help developers build ambitiously large web
applications that are competitive with native apps. Doing so requires
both new tools and a new vocabulary of concepts. We've spent a lot of
time borrowing ideas pioneered by native application frameworks like
Cocoa and Smalltalk.

Ember.js的设计目标是能帮助广大开发者构建能与本地应用相颦美的大型Web应用。要实现这个目标需要新的工具和新的概念。我们花了很大的功夫从Cocoa、Smalltalk等本地应用框架引入了其优秀的理念。

However, it's important to remember what makes the web special. Many
people think that something is a web application because it uses
technologies like HTML, CSS and JavaScript. In reality, these are just
implementation details.

然而，记住Web的特殊性非常重要。很多人认为一个应用是Web应用是因为其使用了像HTML、CSS和Javascript这些技术。实际上，这只是实现的细节问题。

Instead, **the web derives its power from the ability to bookmark and
share URLs.** URLs are the key feature that give web applications
superior shareability and collaboration. Today, most JavaScript
frameworks treat the URL as an afterthought, instead of the primary
reason for the web's success.

相反，**Web应用是通过能收藏和分析链接来凸显它的作用的**。URL是Web应用的一个最核心的特性，正是URL使得Web应用有了卓越的可共享性和可协作性。现今，很多Javascript框架都是时候才考虑URL，没有考虑这个让Web成功的主要因素。

Ember.js, therefore, marries the tools and concepts of native
GUI frameworks with support for the feature that makes the web so
powerful: the URL.

Ember.js将本地GUI框架中的工具和概念与使得Web应用如此强大的URL嫁接在一起。

### 概念（Concepts）

#### 模板（Templates)

A **template**, written in the Handlebars templating language, describes
the user interface of your application. Each template is backed by a
model, and the template automatically updates itself if the model
changes.

In addition to plain HTML, templates can contain:

**模板**，用Handlebars模板语言来编写，它描述了一个应用程序的用户接口。每个模板背后都有一个模型，当模型发生改变时，模板将自动进行更新。

此外，相对于纯HTML，模板还提供了：

* **Expressions**, like `{{firstName}}`, which take information from the template's model and put it into HTML.

* **表达式**, 例如 `{{firstName}}` ,
  它从模板对应的模型获取信息并将信息添加到HTML中。

* **Outlets**, which are placeholders for other templates. As users
  move around your app, different templates can be plugged into the
  outlet by the router. You can put outlets into your template using the
  `{{outlet}}` helper.

* **出口（Outlets）**, 它是其他模板的占位符。当用户使用应用时，不
  同的模板会通过路由插入到出口中。你可以使用 `{{outlet}}` 助手将出口放到
  模板中去。

* **Components**, custom HTML elements that you can use to clean up repetitive templates or create reusable controls.

* **组件**，自定义的HTML元素，可以用来清理重复的模板或创建可重用的控件。

#### 路由器（Router）

The **router** translates a URL into a series of nested templates, each
backed by a model. As the templates or models being shown to the user
change, Ember automatically keeps the URL in the browser's address bar
up-to-date.

**路由器**将URL转换为一系列内嵌的有模型数据支撑的模板。当显示给用户的模板和模型发生改变时，Ember自动更新浏览器地址栏中的URL。

This means that, at any point, users are able to share the URL of your
app. When someone clicks the link, they reliably see the same content
as the original user.

这意味着用户可以在任意点分享应用的URL。当某个用户点击了这个链接时，将看到与分享链接的用户看到的相同内容。

#### 组件（Components）

A **component** is a custom HTML tag whose behavior you implement using
JavaScript and whose appearance you describe using Handlebars templates.
They allow you to create reusable controls that can simplify your
application's templates.

**组件**是一个自定义的HTML标签，其行为用Javascript来实现，而显示使用Handlebars模板来描述。组件可以用来定义可重用的控件来简化应用的模板。

#### 模型（Models）

A **model** is an object that stores _persistent state_. This is the
data that your application operates on and what gives it value to your
users.  These objects are usually loaded from your server, then saved
back when changes are made on the client.

**模型**是一个存储 _持久化状态_
的对象。它是应用将操作的数据，也是用来返回值给用户的数据。这些对象通常从服务器端加载，并当其在客户端发生改变后又保存到服务器端。

#### 路由(Route)

The **route** is the object responsible for _managing application state_.

**路由**是 _负责管理应用程序状态_ 的对象。

#### 控制器(Controllers)

**controller** is an object that stores _application state_. A
template can optionally have a controller in addition to a model, and
can retrieve properties from both.

**控制器**是存放_应用状态_的对象。模板除模型之外还可以有一个控制器与之对应，使其可以从这两者获取属性。

---

These are the core concepts you'll need to understand as you develop
your Ember.js app. They are designed to scale up in complexity, so that
adding new functionality doesn't force you to go back and refactor
major parts of your app.

以上这些是在开发`Ember.js`应用时需要了解的核心概念。Ember.js设计为可以弹性的处理复杂的问题，因此需要为应用增加新功能、新特性时只需要改变很小的部分。

Now that you understand the roles of these objects, you're equipped to
dive deep into Ember.js and learn the details of how each of these
individual pieces work.

现在你已经理解了这些对象各自的角色，可以开始深入到Ember.js
的世界中，进一步了解这些部分如何工作的细节。
