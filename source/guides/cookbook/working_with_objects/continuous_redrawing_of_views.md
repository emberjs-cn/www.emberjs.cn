英文原文：[http://emberjs.com/guides/cookbook/working_with_objects/continuous_redrawing_of_views](http://emberjs.com/guides/cookbook/working_with_objects/continuous_redrawing_of_views)

## 问题

有时视图需要每隔几秒或者几分钟重绘一次。例如更新相对时间（如同twitter.com那样）。

## 解决方案

应用中有一个时钟对象，该对象有一`pulse`属性定时递增。希望将视图与`pulse`绑定，并在其增加时得到刷新。

时钟对象可以创建用于绑定到应用生成的新视图的对象，比如评论列表。

## 讨论

<a class="jsbin-embed" href="http://jsbin.com/iLETUTI/17/embed?output">Cookbook: 持续重绘视图</a><script src="http://static.jsbin.com/js/embed.js"></script>

### ClockService对象

这里`ClockService`只是用于作为一个例子，它可能来自于一个第三方库。并且通过初始化注入到应用中。

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

### 绑定至`pulse`属性

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

该控制器可以基于注入的`clock`实例的`pulse`属性来设置任意属性。

本例中`seconds`属性绑定到`控制器的`clock`对象的`pulse`属性。属性`clock.pulse`在初始化时被注入。

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

一个评论列表的控制器，每条评论在被添加到列表时，会得到一个新的时钟实例。评论条目控制器设置`seconds`绑定，用于在模板中显示评论创建了多长时间。

```javascript
App.CommentItemController = Ember.ObjectController.extend({
  seconds: Ember.computed.oneWay('clock.pulse').readOnly()
})

App.CommentsController = Ember.ArrayController.extend({
  needs: ['interval'],
  itemController: 'commentItem',
  actions: {
    add: function () {
      this.addObject(Em.Object.create({
        comment: $('#comment').val(),
        clock: ClockService.create()
      }));
    }
  }
});
```

### 显示`pulse`的Handlebars模板

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

### 格式化时钟显示（h:m:s）的Handlebars助手

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

### 注意

为了深入探究这个概率，可以尝试添加一个时间戳，并通过与当前时间比较来更新时钟的`pulse`。在用户将计算机设置为睡眠后，再唤醒后重新打开浏览器时也应该更新`pulse`属性。

### 链接

源代码：

* <http://jsbin.com/iLETUTI/17/edit?html,js,output>

更多相关内容：

* [Ember对象](http://emberjs.com/api/classes/Ember.Object.html)
* [Ember应用初始化](http://emberjs.com/api/classes/Ember.Application.html#toc_initializers)
* [方法注入](http://emberjs.com/api/classes/Ember.Application.html#method_inject)
* [条件表达式](http://emberjs.com/guides/templates/conditionals/)
* [编写助手](http://emberjs.com/guides/templates/writing-helpers/)
* [定义组件](http://emberjs.com/guides/components/defining-a-component/)
* [Ember数组控制器](http://emberjs.com/api/classes/Ember.ArrayController.html)
