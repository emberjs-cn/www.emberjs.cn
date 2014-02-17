---
title: Ember 1.4.0和1.5 Beta发布
author: Robert Jackson
tags: Releases, Recent Posts
---

### 1.4中的新特性

#### 属性大括号扩展

在之前的Ember版本中，如果需要观察`baz`的`foo`和`bar`属性，需要在同时设置`baz.foo`和`baz.bar`两个依赖键。

```javascript
var obj = Ember.Object.extend({
  baz: {foo: 'BLAMMO', bar: 'BLAZORZ'},

  something: function(){
    return this.get('baz.foo') + ' ' + this.get('baz.bar');
  }.property('baz.foo', 'baz.bar')
});
```

使用最新的属性大括号扩展，可以这样来简化依赖设置：

```javascript
  something: function(){
    return this.get('baz.foo') + ' ' + this.get('baz.bar');
  }.property('baz.{foo,bar}')
```

这样大大的简化了重复和冗余的相似依赖键的设置。

详细的内容可以查看[PR #3538](https://github.com/emberjs/ember.js/pull/3538)

#### Ember.run.bind

`Ember.run.bind`是一个非常有用的工具，可以用来集成提供异步回调的非Ember库。

Ember使用运行循环来批处理和合并更新。这是通过标记Ember相关代码的开始和结束执行来实现的。

当使用事件时，如视图点击处理器，Ember把该处理器包裹在一个运行循环中。如果与非Ember库集成，那么就会变得非常让人厌烦。

例如，下面的代码就非常的啰嗦，不过确实正确的处理第三方库事件的Ember代码：

```javascript
var that = this;
jQuery(window).on('resize', function(){
  Ember.run(function(){
    that.handleResize();
  });
});
```

为了减少这种套式代码，下面的代码可以完成将回调包裹到一个运行循环中。

```javascript
jQuery(window).on('resize', Ember.run.bind(this, this.handleResize));
```

更多的关于运行循环的内容，请查看[运行循环指南](/guides/understanding-ember/run-loop/)。（非常感谢[Brendan Briggs](https://github.com/bfbriggs)）。

#### 支持控制器的`{{with}}`

`{{with}}`助手现在可以接收一个`controller`选项。添加`controller='something'`表示`{{with}}`助手将创建和使用一个指定的控制器来作为其内容的新上下文。

这与`{{each}}`助手中使用`itemController`选项非常类似。

```handlebars
{{#with users.posts controller='userBlogPosts'}}
  {{!- The current context is wrapped in our controller instance }}
{{/with}}
```

在上例中，提供给`{{with}}`块的模板被包裹到`userBlogPost`控制器中，这提供了一个非常简单的方法，来讲当前上下文中添加自定义的函数和属性。

#### 延迟绑定属性

之前，所有绑定的属性都有一定程度的开销（大部分是维护绑定和观察器之间的关联关系）。这导致需要限制自动绑定到`Ember.TextField`，`Ember.TextArea`等控件上的属性。对于越来越多的人希望绑定HTML5属性来说，这是一个问题的根源。为了多绑定属性，不得不重新打开`Ember.TextField`类，然后添加可以绑定的属性。

例如：

```javascript
Ember.TextField.reopen({
  attributeBindings: ['autofocus']
});
```

然后在模板中就可以：

```handlebars
{{input autofocus=omgAutofocusMe}}
```

这当然不理想，对于那些认为`Ember.TextField`理所当然支持的人来说，会遇到非常多问题。

随着Ember 1.4的发布，这个问题得到了很好的处理。在1.4中，任何属性绑定在试图被渲染的时候如果不存在，那么不会为他设置观察器（因此避免了原本的性能开销问题）。当试图在之后又设置了该属性的时候（在初次渲染之后），一个属性观察器会在这时被添加。

这意味着只会为存在的谁能够添加观察器，这样就可以在`attributeBindings`中添加所有有效的HTML属性，今后就可以直接使用，而不需要在重新打开类来添加。

在Ember 1.4中`{{input type="text"}}`，`{{textarea}}`和`{{checkbox}}`助手可以使用任何HTML5的属性。

#### 其他改进

一如既往，本次发布还修改了许多之前版本存在的Bugs，对一部分功能也作出了一些改进。详细的内容可以查看CHANGELOG：

* [Ember.js 1.4.0 CHANGELOG](https://github.com/emberjs/ember.js/blob/v1.4.0/CHANGELOG.md)
* [Ember.js 1.5.0-beta.1 CHANGELOG](https://github.com/emberjs/ember.js/blob/v1.5.0-beta.1/CHANGELOG.md)
