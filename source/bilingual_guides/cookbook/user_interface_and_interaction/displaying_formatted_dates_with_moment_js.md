### Problem

### 问题

Display JavaScript Date objects in human readable format.

将Javascript Date对象显示为易读的格式。

### Solution

### 解决方案

There are two ways of formatting the value:

有两种方法可以实现对日期对象的格式化：

1. Create a Handlebars helper `{{format-date}}` and use it in your template
2. Create a computed property `formattedDate` that will return a transformed date

1. 创建一个Handlebars助手`{{format-date}}`，并在模板中使用该助手
2. 创建一个计算属性`formattedDate`来返回一个格式化的日期

We will use [MomentJs](http://momentjs.com) for formatting dates.

这里将使用[Moment.js](http://momentjs.com)来做日期格式化。

Let's look at a simple example. You're working on a website for your
client, and one of the requirements is to have the current date on the index page in human readble format. This is a perfect place to use a
Handlebars helper that "pretty prints" the current date:

下面来看一个简单的例子。假设正在给客户开发一个网站，其中的一个需求是在首页显示一个易读的当前时间。这是一个非常适合使用Handlebars助手来实现的应用场景：

```javascript
Ember.Handlebars.registerBoundHelper('currentDate', function() {
  return moment().format('LL');
});
```

Your template will look like:

模板如下：

```html
Today's date: {{currentDate}}  // Today's date: August 30 2013
```

You can even enhance your code and pass in the date format to the helper:

此外还可以增强助手，使其支持指定日期格式：

```javascript
Ember.Handlebars.registerBoundHelper('currentDate', function(format) {
  return moment().format(format);
});
```

Now you would need to pass an additional parameter to the helper:

现在需要传入一个额外的参数，来表示需要的日期格式：

```html
Today's date: {{currentDate 'LL'}}  // Today's date: August 30 2013
```

Let's look at another example. Say you need
to create a simple control that allows you to type in a date and
a date format. The date will be formatted accordingly.

下面再看另外一个例子。假设需要创建一个简单的控件，允许输入一个日期和日期格式。日期更具输入的日期格式来进行格式化。

Define `formattedDate` computed property that depends on
`date` and `format`. Computed property in this example does
the same thing as Handlebars helpers defined above.

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

### Discussion

### 讨论

Both helper and computed property can format your date value. 
Which one do I use and when?

助手和计算属性都可以用于格式化日期。那么应该如何来选择呢？

Handlebars helpers are shorthand for cases where you want to format
a value specifically for presentation. That value may be used 
across different models and controllers.

Handlebars助手用于需要在表现层对值进行特定格式化的情况。而值本身可能被用在不同的模型和控制器。

You can use `{{currentDate}}` across your application to format dates
without making any changes to controllers.

`{{currentDate}}`可以在整个应用中用来格式化日期，而不需要对控制器做任何改变。

Computed property in the example above does the same thing as the
Handlebars helper with one big difference:
`formattedDate` can be consumed later without applying
date format on the date property again.

上例中的计算属性与Handlebars助手完成相同的功能，但是也由一个重要的区别：`formattedDate`不需要在之后的使用中再次指定日期需要使用的格式。

#### Example

#### 例子

<a class="jsbin-embed" href="http://emberjs.jsbin.com/iCaGUne/4/edit?output">JS Bin</a>
