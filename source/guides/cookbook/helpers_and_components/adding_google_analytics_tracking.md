英文原文：[http://emberjs.com/guides/cookbook/helpers\_and\_components/adding\_google\_analytics\_tracking](http://emberjs.com/guides/cookbook/helpers_and_components/adding_google_analytics_tracking)

### 问题

希望可以分析Ember应用的使用情况。

### 解决方案

通过在应用的路由中订阅`didTransition`事件来实现。

系列中使用Google Analytics来展示如何实现对应用的分析，当然也可以使用其他的分析产品。将Google
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

### 讨论

`didTransition`事件负责将URL改变的事件通知监听器，在本例中，通过获得URL`#`之后的路径，来将应用状态改变通知Google Analytics。

### 示例

<a class="jsbin-embed" href="http://jsbin.com/AjeDehO/2/embed?js,output">JS Bin</a><script src="http://static.jsbin.com/js/embed.js"></script>
