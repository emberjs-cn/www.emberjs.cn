英文原文：[http://emberjs.com/guides/cookbook/user\_interface\_and\_interaction/displaying\_formatted\_dates\_with\_moment\_js](http://emberjs.com/guides/cookbook/user_interface_and_interaction/displaying_formatted_dates_with_moment_js)

### 问题

将Javascript Date对象显示为易读的格式。

### 解决方案

有两种方法可以实现对日期对象的格式化：

1. 创建一个Handlebars助手`{{format-date}}`，并在模板中使用该助手
2. 创建一个计算属性`formattedDate`来返回一个格式化的日期

这里将使用[Moment.js](http://momentjs.com)来做日期格式化。

下面来看一个简单的例子。假设正在给客户开发一个网站，其中的一个需求是在首页显示一个易读的当前时间。这是一个非常适合使用Handlebars助手来实现的应用场景：

```javascript
Ember.Handlebars.registerBoundHelper('currentDate', function() {
  return moment().format('LL');
});
```

模板如下：

```html
Today's date: {{currentDate}}  // Today's date: August 30 2013
```

此外还可以增强助手，使其支持指定日期格式：

```javascript
Ember.Handlebars.registerBoundHelper('currentDate', function(format) {
  return moment().format(format);
});
```

现在需要传入一个额外的参数，来表示需要的日期格式：

```html
Today's date: {{currentDate 'LL'}}  // Today's date: August 30 2013
```

下面再看另外一个例子。假设需要创建一个简单的控件，允许输入一个日期和日期格式。日期更具输入的日期格式来进行格式化。

定义一个`formattedDate`计算属性，依赖于`date`和`format`。这个计算属性与上面写的Handlebars助手实现了相同的功能。

```javascript
App.ApplicationController = Ember.Controller.extend({
  format: "YYYYMMDD",
  date: null,
  formattedDate: function() {
    var date = this.get('date'),
        format = this.get('format');
    return moment(date).format(format);
  }.property('date', 'format')
});
```

```html
{{input value=date}}
{{input value=format}}
<div>{{formattedDate}}</div>
```

### 讨论

助手和计算属性都可以用于格式化日期。那么应该如何来选择呢？

Handlebars助手用于需要在表现层对值进行特定格式化的情况。而值本身可能被用在不同的模型和控制器。

`{{currentDate}}`可以在整个应用中用来格式化日期，而不需要对控制器做任何改变。

上例中的计算属性与Handlebars助手完成相同的功能，但是也由一个重要的区别：`formattedDate`不需要在之后的使用中再次指定日期需要使用的格式。

#### 例子

<a class="jsbin-embed" href="http://emberjs.jsbin.com/iCaGUne/4/edit?output">JS Bin</a>
