## Problem

## 问题

You'd like to redraw your views every few seconds/minutes e.g. to update
relative timestamps (like on twitter.com).

有时视图需要每隔几秒或者几分钟重绘一次。例如更新相对时间（如同twitter.com那样）。

## Solution

## 解决方案

Have a clock object with a `pulse` attribute in your application which 
increments using a timed interval. You want to let view(s) bind values to be
refreshed when the `pulse` attribute increments.

应用中有一个时钟对象，该对象有一`pulse`属性定时递增。希望将视图与`pulse`绑定，并在其增加时得到刷新。

The clock object can be used to create new instances for binding to new views
generated within the application, like a list of comments.

时钟对象可以创建用于绑定到应用生成的新视图的对象，比如评论列表。

## Discussion

## 讨论

<a class="jsbin-embed" href="http://jsbin.com/iLETUTI/10/embed?output">Cookbook: Continuous Redrawing of Views</a><script src="http://static.jsbin.com/js/embed.js"></script>

<a class="jsbin-embed" href="http://jsbin.com/iLETUTI/10/embed?output">Cookbook: 持续重绘视图</a><script src="http://static.jsbin.com/js/embed.js"></script>

### ClockService object

### ClockService对象

This `ClockService` is an example of an object that may come from a library.
And, is injected into the application via an initializer.

这里`ClockService`只是用于作为一个例子，它可能来自于一个第三方库。并且通过初始化注入到应用中。

During initialization the `tick` method is called which uses `Ember.run.later`
with a time of 250 milliseconds as the interval. A property is set at the end
of the interval. Since the `tick` method observes the incremented property
another interval is triggered each time the property increases.

在初始化过程中，`tick`方法通过`Ember.run.later`每250毫秒被调用一次。当到时间时，会设置一个属性。由于`tick`方法观察了一个递增属性，并且每次属性增加时另外一个周期也同时被触发。

```javascript
var ClockService = Ember.Object.extend({
  pulse: Ember.computed.oneWay('_seconds').readOnly(),
  tick: function () {
    var clock = this;
    Ember.run.later(function () {
      var seconds = clock.get('_seconds');
      if (typeof seconds === 'number') {
        clock.set('_seconds', seconds + (1/4));
      }
    }, 250);
  }.observes('_seconds').on('init'),
  _seconds: 0,
});
```

### Binding to the `pulse` attribute

### 绑定至`pulse`属性

In this recipe, an application initializer is used to inject an instance of the
`ClockService` object, setting a controller's `clock` property to this instance.

在本技巧中，应用在初始化时注入了一个`ClockService`的实例，并且将一个控制器的`clock`属性设置为该实例。

```javascript
Ember.Application.initializer({
  name: 'clockServiceInitializer',
  initialize: function(container, application) {
    container.register('clock:service', ClockService);
    application.inject('controller:interval', 'clock', 'clock:service');
  }
});
```

The controller can set any computed properties based on the `pulse` property of
the injected `clock` instance.

该控制器可以基于注入的`clock`实例的`pulse`属性来设置任意属性。

In this case the `seconds` property is bound to the `pulse` property of the
controller's `clock`. The property `clock.pulse` was injected during
initialization.

本例中`seconds`属性绑定到`控制器的`clock`对象的`pulse`属性。属性`clock.pulse`在初始化时被注入。

The controller has (session) data to display `seconds` to visitors, as well as
a handful of properties used as conditions in the Handlebars template.

控制器有（会话）数据来显示`seconds`给访问者，而且少数用于Handlebars模板的条件属性。

```javascript
App.IntervalController = Ember.ObjectController.extend({
  secondsBinding: 'clock.pulse',
  fullSecond: function () {
    return (this.get('seconds') % 1 === 0);
  }.property('seconds'),
  quarterSecond: function () {
    return (this.get('seconds') % 1 === 1/4);
  }.property('seconds'),
  halfSecond: function () {
    return (this.get('seconds') % 1 === 1/2);
  }.property('seconds'),
  threeQuarterSecond: function () {
    return (this.get('seconds') % 1 === 3/4);
  }.property('seconds')
});
```

A controller for a list of comments, which creates a new clock instance
for each comment. Each comment in the list also has a controller. When a
comment is created the `init` method adds a clock instance to the comment.

一个评论列表的控制器，为每条评论创建一个时钟实例。列表中的每条评论都有一个控制器。当一条评论被创建时，`init`方法添加一个时钟实例到评论。

```javascript
App.CommentItemController = Ember.ObjectController.extend({
  init: function() {
    this.set('clock', ClockService.create());
  }
})

App.CommentsController = Ember.ArrayController.extend({
  needs: ['interval'],
  clockBinding: 'controllers.interval.clock',
  itemController: 'commentItem',
  actions: {
    add: function () {
      this.addObject(Em.Object.create({
        comment: $('#comment').val()
      }));
    }
  }
});
```

### Handlebars template which displays the `pulse`

### 显示`pulse`的Handlebars模板

The `seconds` value is computed from the `pulse` attribute. And the controller
has a few properties to select a component to render, `fullSecond`,
`quarterSecond`, `halfSecond`, `threeQuarterSecond`.

`seconds`的值是从`pulse`属性计算得来的。控制器有些属性是用来选择一个控件来渲染的，`fullSecond`、`quarterSecond`、`halfSecond`和`threeQuarterSecond`。

```handlebars
{{#if fullSecond}}
  {{nyan-start}}
{{/if}}
{{#if quarterSecond}}
  {{nyan-middle}}
{{/if}}
{{#if halfSecond}}
  {{nyan-end}}
{{/if}}
{{#if threeQuarterSecond}}
  {{nyan-middle}}
{{/if}}
<h3>You&apos;ve nyaned for {{digital_clock seconds}} (h:m:s)</h3>
{{render 'comments'}}
```

A template for a list of comments

评论列表的一个模板：

```handlebars
<input type="text" id="comment" />
<button {{action add}}>Add Comment</button>
<ul>
  {{#each}}
    <li>{{comment}} ({{digital_clock clock.pulse}})</li>
  {{/each}}
</ul>
```

### Handlebars helper to format the clock display (h:m:s)

### 格式化时钟显示（h:m:s）的Handlebars助手

This helper is used in the template like so `{{digital_clock seconds}}`,
`seconds` is the property of the controller that will be displayed (h:m:s).

本助手在模板中这样使用：`{{digital_clock seconds}}`，`seconds`是控制器要显示的一个属性（h:m:s）。

```javascript
Ember.Handlebars.registerBoundHelper('digital_clock', function(seconds) {
  var h = Math.floor(seconds / 3600);
  var m = Math.floor((seconds % 3600) / 60);
  var s = Math.floor(seconds % 60);
  var addZero = function (number) {
    return (number < 10) ? '0' + number : '' + number;
  };
  var formatHMS = function(h, m, s) {
    if (h > 0) {
      return '%@:%@:%@'.fmt(h, addZero(m), addZero(s));
    }
    return '%@:%@'.fmt(m, addZero(s));
  };
  return new Ember.Handlebars.SafeString(formatHMS(h, m, s));
});
```

### Note

### 注意

To explore the concept further, try adding a timestamp and updating the clock's
pulse by comparing the current time. This would be needed to update the pulse
property when a user puts his/her computer to sleep then reopens their browser
after waking.

为了深入探究这个概率，可以尝试添加一个时间戳，并通过与当前时间比较来更新时钟的`pulse`。在用户将计算机设置为睡眠后，再唤醒后重新打开浏览器时也应该更新`pulse`属性。

### Links

### 链接

The source code:

源代码：

* <http://jsbin.com/iLETUTI/8/>

Further reading:

更多相关内容：

* <http://emberjs.com/api/classes/Ember.Object.html>
* <http://emberjs.com/api/classes/Ember.Application.html>, See section on "Initializers"
* <http://emberjs.com/api/classes/Ember.Application.html>, 查看"Initializers"部分
* <http://emberjs.com/api/classes/Ember.Application.html#method_inject>
* <http://emberjs.com/guides/templates/conditionals/>
* <http://emberjs.com/guides/templates/writing-helpers/>
* <http://emberjs.com/guides/components/defining-a-component/>
* <http://emberjs.com/api/classes/Ember.ArrayController.html>
