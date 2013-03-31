---
title: Ember入门实践
tags: 最近文章
author: TiffanyZhou
---

本文翻译自：[Ember: Baby Steps](http://wekeroad.com/2013/03/20/ember-baby-steps)

首先让我们用`Ember`[官方网站](http://emberjs.com/)上的一句话来介绍`Ember`:

    A framework for creating ambitious web applications

### 基本配置

由于`Ember`的官方指南主要关注概念性的东西，而没有太注重实用性，所以，要亲自动手配置`Ember`可能不那么容易。在开始编写我们的代码之前，我们就先从头开始配置一下环境：(本文所有操作都基于linux)

首先创建项目文件：

```shell
mkdir hello-ember
cd hello-ember
```

接下来我们创建项目的文件结构，这里，我们需要一个文件夹以及一个HTML文档

```shell
mkdir js
touch index.html
```

接下来，我们得在项目中加入`Ember`必需的3个库：

* jQuery
* Handlerbars
* Ember

对于`jQuery`，我们可以使用Google提供的CDN jQuery库，而对于其他两项，分别可以在[Ember](https://raw.github.com/emberjs/ember.js/release-builds/ember-1.0.0-rc.1.js)和[Handlebars](https://raw.github.com/wycats/handlebars.js/1.0.0-rc.3/dist/handlebars.js)下载.

以上三者都应该放在上面创建的`js`文件夹里。

上面准备好了之后，我们还需要创建一个入口程序：

```shell
touch js/app.js
```

然后，把下面的代码加入到`index.html`文件中去(要注意你的`Handlebars`及`Ember`的命名是否与下面代码的链接名一致)：

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Hello Ember</title>
  </head>
  <body>
    <div>
      <h1>Hello Ember</h1>
    </div>
  </body>
  <script
src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
  <script type="text/javascript" src="js/handlebars.js"></script>
  <script type="text/javascript" src="js/ember.js"></script>
  <script type="text/javascript" src="js/app.js"></script>
</html>
```

现在我们就可以来看一下执行效果了，利用`python`架设简单的服务器：

```python
python -m SimpleHTTPServer
```

现在访问本机的[8000端口](http://localhost:8000)即可看到效果。


### Step 1: 应用程序视图

首先，我们得先创建一个`Ember`应用，在`js/app.js`中添加以下代码：

```javascript
var HelloEmber = Ember.Application.create();
```

接下来，对于一个完整正确的`Ember`应用来说，我们还需要添加：

* 视图
* 控制器

最简单的视图就是全局的应用程序视图，在`index.html`中加入以下代码：

```html
<body>
  <div>
    <script type="text/x-handlebars" data-template-name="application">

    </script>
  </div>
</body>
```

`script`标签指定了`Handlebars`模板，用`data-template-name`标识视图的名称。关于`Handlebars`的知识可以参见[http://handlebarsjs.com/](http://handlebarsjs.com/)

视图创建完毕，接下来开始创建控制器：

### Step 2: 控制器

在`Ember`中，控制器的作用主要是：将数据传递给模板用于灵活显示。
下面，我们创建一个控制器，在`app.js`中添加如下代码：

```javascript
var HelloEmber = Ember.Application.create();
HelloEmber.ApplicationController = Ember.Controller.extend({
  greeting : "Good Morning Starshine!",
  happyThought : "The Earth Says Hello!"
});
```

这里这样写可能有点不妥，但是仍然可以执行，我们不妨先这样写，后面再做修改。
接下来，为了可以显示我们的数据，我们还需更新`index.html`文件：

```handlebars
<body>
  <div>
    <script type="text/x-handlebars" data-template-name="application">
      <h1>{{greeting}}</h1>
      <h3>
        {{happyThought}}
      </h3>
    </script>
  </div>
</body>
```

好了，现在可以刷新页面去见证奇迹了！

### Step 3: 命名惯例

在`Ember`中：命名即是一切。有关命名惯例的内容可以参加：[英文链接](http://emberjs.com/guides/concepts/naming-conventions/) [中文链接](http://emberjs.cn/guides/concepts/naming-conventions/) 

下面，我们来看看`Ember`中的命名，先来改进一下上面的`ApplicationController`。我们删除`ApplicationController`，创建一个新的`IndexController`,现在`app.js`中的内容如下所示：

```javascript
var HelloEmber = Ember.Application.create();
HelloEmber.IndexController = Ember.Controller.extend({
  greeting : "Good Morning Starshine!",
  happyThought : "The Earth Says Hello!"
});
```

再修改视图`index.html`，如下所示：

```handlebars
<body>
  <div>
    <script type="text/x-handlebars" data-template-name="application">
      {{outlet}}
    </script>
    <script type="text/x-handlebars" data-template-name="index">
      <h1>{{greeting}}</h1>
      <h3>
        {{happyThought}}
      </h3>
    </script>
  </div>
</body>
```

现在刷新页面，效果应该跟修改之前一样，但是，这与前面有什么不同呢？

再一次申明：命名惯例。虽然，我们的代码中没有显示定义`ApplicationController`，但是`Ember`会自动创建它。其实这类似与`C++`的构造函数，在以前的例子中，我们只是`重载`了构造函数(这里指`ApplicationController`)罢了。

`IndexController`也是一样的道理。你定义，或者不定义它，它都存在，不离，不弃。只是，在这个例子中，我们重载了它。

### 模型和路由

接下来，我们在讨论一下`Ember`的其他部分.

在`app.js`中，定义一个模型，如下所示：

```javascript
HelloEmber.Greeting = Ember.Object.extend({
  greeting : "Good Morning Starshine!",
  happyThought : "The Earth Says Hello!"
});
```

然后，再定义一个路由，在`Ember`中，路由的作用是使控制器可以找到某个模型，现在，`app.js`的文件内容如下所示：

```javascript
//our app
var HelloEmber = Ember.Application.create({});

//our model
HelloEmber.Greeting = Ember.Object.extend({
  greeting : "Good Morning Starshine!",
  happyThought : "The Earth Says Hello!"
});

//our route
HelloEmber.IndexRoute = Ember.Route.extend({
  model : function(){
    return HelloEmber.Greeting.create();
  }
});
```

这些代码就够了，不信？刷新一下页面试试？

或许你会感觉到奇怪，我们甚至没有控制器啊！！？？仔细想想，对了：命名惯例。`Ember`会为我们自动创建一个控制器`IndexController`。只要我们按照命名惯例来编写代码，`IndexController`就会自动与`IndexRoute`关联。控制器会接收路由中所指定模型的数据，并将其提供给视图，以供显示。

这就是上面代码起作用的原因，最后一遍：都是命名惯例惹得祸。

### 后记

对于我来说，`Ember`是全新的东西，甚至可以说整个`web`领域对我一点都不熟悉。在过去的两三个周内，我开始编写一些简单的`web`代码，同时学习`Ember`。可以说，在昨天下午，我感觉自己对`Ember`有点感觉了，特别是对`命名惯例`有感觉了，其实，这种感觉源自我犯的一些错误，当把这些错误解决了，所有的东西好像一下子就清楚了。所以说，失败是成功之母，这话没有假。我想，对于所有东西，其实，前期的一些错误或失败可以让我们更快的达到我们的最终目标。

说了一些废话，这篇文章可能距离真正的在项目中使用`Ember`还有一定差距，但是对于理解`Ember`以及其中的`MVC`架构应该是很有益的，如果英语好的话，建议直接阅读英文文章。

另外，希望大家能多关注 [Ember中文网站](http://emberjs.cn),并希望能有更多的人参与进来，共同建设一个积极向上的社区。
