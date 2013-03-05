英文原文：[http://emberjs.com/guides/getting-started/core-concepts/](http://emberjs.com/guides/getting-started/core-concepts)


## 核心概念(Core Concepts)

To get started with Ember.js, there are a few core concepts you
should understand. 

要开始学习Ember.js,首先要了解一些核心概念。

We want developers to be able to build ambitiously large web
applications that are competitive with native apps. To do that, they
need both sophisticated tools *and* the right vocabulary of concepts to
help them communicate and collaborate.

我们希望开发者能够创建能与本地应用媲美的优秀的大型的web应用。要达到这种效果,
他们需要强大的工具*和*准确的词汇概念以帮助他们沟通与合作。

We've spent a lot of time borrowing liberally from ideas introduced
by native application frameworks, like Cocoa. When we felt those
concepts were more hindrance than help–or didn't fit within the unique
constraints of the web–we turned to other popular open source projects
like Ruby on Rails and Backbone.js for inspiration.

我们曾经花费了大量的时间借鉴一些本地应用开发框架的思想，例如Cocoa。但是当
我们发现那些概念的羁绊多于约束，或者不适用于web开发的唯一性约束后，我们
把目光转向了其他流行的开源项目，例如，Ruby on Rails以及Backbone.js。

Ember.js, therefore, is a synthesis of the powerful tools of our native
forebearers with the lightweight sensibilities of the modern web. 

因此,Ember.js是结合了本地应用与现代web的轻量特性的一个强有力的工具。 

### 概念（Concepts）

#### 模板（Templates)

A **template**, written in the Handlebars templating language, describes
the user interface of your application. In addition to plain HTML,
templates can contain:

**模板**， 是由Handlebars模板语言写成，它描述了一个应用程序的用户接口。
此外，为了简单的HTML,模板还需要包含：

* **Expressions**, like `{{firstName}}`, which take information from
  controllers and models, place them into HTML, and automatically keep them
  updated.
* **表达式**, 例如 `{{firstName}}` , 它从控制器和模型接收数据，然后放
  到HTML文件中，并且保持他们自动更新。
* **Outlets**, which are placeholders for other templates. As your user
  moves around your app, different templates can be plugged into the
  outlet by the router. You can put outlets into your template using the
  `{{outlet}}` helper.
* 占位符(**Outlets**), 它是其他模板的占位符。当用户搬迁你的应用时，不
  同的模板会通过路由插入到outlet中。你可以使用 `{{outlet}}` 帮助将outlets放到
  模板中去。
* **Views**, which are responsible for handling user events. You can put
  views into your templates using the `{{view}}` helper.
* **视图**, 它负责处理用户事件。你可以使用`{{view}}`帮助将视图放到模板中。

#### 视图(Views)

A **view** is embedded inside a template and is responsible for
translating _primitive events_ (like clicks, taps, and swipes) into
_semantic events_ that have meaning to your application and are sent to
the controller.

一个**视图**被嵌入在一个模板中,它负责把 _原始事件_ (如点击,轻拍,猛击)翻译
成对你的应用程序有意义的 _语义事件_ ,然后将他们传输到控制器。

For example, a view might translate a `click` event into the more
meaningful `deleteItem` event, which would be sent to the controller.
If the controller does not implement the `deleteItem` event, the event
will be sent to the current route.

例如，一个视图可能将一个`click`事件翻译成更有意义的`deleteItem`事件，
然后将其发送给控制器。如果控制器没有实现`deleteItem`事件,事件将被发送给
当前的路由。

#### 控制器(Controllers)

A **controller** is an object that stores _application state_. Templates
are connected to controllers and translate the current state of the
controller into HTML.

**控制器**是存放 _应用程序状态_ 的对象。模板会与控制器进行连接并将控制器
的状态转变为HTML。

Controllers often act as representations of **models** for templates. In
these cases, the controller passes the properties of the model to the
template, and can transform or augment the model to present it in a way
the template is expecting.

控制器往往扮演为模板呈现**模型**的表现的角色。在这些情况下，控制器将模型的属性
传递给模板，并且可以改变或增加模型来以一种模板期待的方式来表现模型。


#### 模型（Models）

A **model** is an object that stores _persistent state_. This is the
data that your application operates on and what gives it value to your
users.  These objects are usually loaded from your server, then saved
back when changes are made on the client.

**模型**是一个存储 _持久化状态_ 的对象。它是你的应用程序操作的数据，也是
你返回给用户的值。这些对象通常从你的服务器进行加载，然后当它们在客户端被
改变后会保存回服务器中。

Usually, you'll use Ember Data to translate the _raw JSON payloads_
delivered by your API server into full-blown Ember.js objects with
associations, computed properties, and more.

通常情况下，你应该使用Ember数据去将你的API服务器传递的原始JSON负载文件转换成
更成熟的Ember.js对象，它们有更好的关联性，计算属性及其他优点。

#### 路由(Router)

The **router** is the object responsible for _managing application state_.

**路由**是 _负责管理应用程序状态_ 的对象。

When your user starts your application, it will look at the URL and make
sure that the right set of templates is displayed, as well as pairing
those templates with the right model objects.

当用户启动你的应用程序时，路由将查看URL并且确保显示正确的模板集，以及将
那些模板与正确的模型对象配对。

As you move around the different states of your application, the
router automatically keeps the URL up-to-date. Users can save the URL
and re-enter the application at this state later, or share the app in
its current state with others.

当你在不同的状态切换应用程序时，路由将自动保持URL为最新。用户可以保存URL
并且可以以后重新进入这个状态，或者与他人分享应用程序的当前状态。

---

These are the core concepts you'll need to understand as you develop
your Ember.js app. If you stick to these basics, we've designed the
system to scale up in complexity, so that adding new functionality
doesn't require you to go back and change the entire system.

以上这些所在开发Ember.js应用时需要了解的核心概念。如果你信守这些概念，我们
已经设计了能成比例增加复杂性的系统，以至于当你要增加新功能时就不需要重新改变
整个系统

We think it's important that multiple developers can look at a problem
and, using the patterns of the framework, arrive at the same solution.
Now that you understand the roles of these objects, you're equipped to
dive deep into Ember.js and learn the details of how each of these
individual pieces work.

在我们看来一个很重要的方面是，当大多数开发人员遇到问题时,可以根据这个框架
的某些模式解决问题。既然你已经理解了这些对象各自的角色，现在就已经可以深入到Ember.js
的世界中，进一步了解这些部分如何工作的细节。
