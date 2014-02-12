### Problem

### 问题

You want to add analytics to your Ember application.

希望可以分析Ember应用的使用情况。

### Solution

### 解决方案

Subscribe to the `didTransition` event inside your application router.

通过在应用的路由中订阅`didTransition`事件来实现。

In the following examples we're using Google Analytics but it could be any other analytics product.
Add google analytic's base code to the html file that renders your ember app.

系列中使用Google
Analytics来展示如何实现对应用的分析，当然也可以使用其他的分析产品。将Google
Analytics的基础代码添加到渲染Ember应用的HTML文件中。

```html
<html lang="en">
<head>
  <title>My Ember Site</title>
  <script type="text/javascript">

    var _gaq = _gaq || [];
    _gaq.push(['_setAccount', 'UA-XXXXX-Y']);

    (function() {
      var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
      ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
      var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
    })();

  </script>
</head>
<body>

</body>
</html>
```

Then reopen the application router and add this function. It will be called when
`didTransition` is fired by the router.

然后重新打开应用的路由并添加下面的函数。该函数在路由触发`didTransition`时会被调用。

```js
App.Router.reopen({
  notifyGoogleAnalytics: function() {
    return ga('send', 'pageview', {
        'page': this.get('url'),
        'title': this.get('url')
      });
  }.on('didTransition')
});
```

### Discussion

### 讨论

The `didTransition` event is responsible for notifying listeners of any URL
changes, in this example we are getting the path after the hash in the url so we
can notify Google Analytics about moving between areas of the site.

`didTransition`事件负责将URL改变的事件通知监听器，在本例中，通过获得URL`#`之后的路径，来将应用状态改变通知Google Analytics。

### Example

### 示例

<a class="jsbin-embed" href="http://jsbin.com/AjeDehO/2/embed?js,output">JS Bin</a><script src="http://static.jsbin.com/js/embed.js"></script>
