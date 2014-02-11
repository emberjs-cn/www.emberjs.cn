英文原文：[http://emberjs.com/guides/getting-started/obtaining-emberjs-and-dependencies](http://emberjs.com/guides/getting-started/obtaining-emberjs-and-dependencies)

TodoMVC的依赖：
  
* [jQuery](http://code.jquery.com/jquery-1.10.2.min.js)
* [Handlebars](http://builds.handlebarsjs.com.s3.amazonaws.com/handlebars-1.0.0.js)
* [Ember.js 1.3](http://builds.emberjs.com/tags/v1.3.0/ember.js)
* [Ember Data 1.0 beta](http://builds.emberjs.com/tags/v1.0.0-beta.5/ember-data.js)
  
本示例中，所有的这些资源要放在与 `index.html` 相同目录的 `js/libs` 文件夹下。更新 `index.html` 代码，在 `</body>` 标签之前加入如下几个 `<script>` 标签，加载这些资源文件。

```html
<!-- ... 为确保简洁，略去头尾代码 ... -->
  <script src="js/libs/jquery-1.10.2.min.js"></script>
  <script src="js/libs/handlebars-1.0.0.js"></script> 
  <script src="js/libs/ember.js"></script>
  <script src="js/libs/ember-data.js"></script>
</body>
<!-- ... 为确保简洁，略去头尾代码 ... -->
```

重新加载浏览器页面，确保所有的文件被正确引用，且没有错误产生。

如果使用包管理工具，例如[bower](http://bower.io)，请阅读[获取Ember](/guides/getting-ember)指南来获取更多关于获取Ember.js的方法。

### 在线演示
<a class="jsbin-embed" href="http://jsbin.com/ijefig/2/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>
 
### 附加资源

  * [采用`diff`格式显示这步骤所作的修改](https://github.com/emberjs/quickstart-code-sample/commit/0880d6e21b83d916a02fd17163f58686a37b5b2c)
