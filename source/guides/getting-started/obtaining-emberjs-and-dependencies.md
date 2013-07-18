英文原文：[http://emberjs.com/guides/getting-started/obtaining-emberjs-and-dependencies](http://emberjs.com/guides/getting-started/obtaining-emberjs-and-dependencies)

## 获取EMBER.JS和相应依赖

最新的Ember.js RC6 可以直接从[Ember.js官方网站](http://emberjs.com/)下载。Ember.js需要两个依赖库：jQuery和Handlebars。jQuery可以从[http://jquery.com/](http://jquery.com/)下载，Handlebars可以从[http://handlebarsjs.com/](http://handlebarsjs.com/)下载。本指南使用 `ember-data` 来进行数据模型映射（managing model data）。最新的Ember data开发版本可以从[http://builds.emberjs.com/](http://builds.emberjs.com/)下载。与[RC3兼容的版本](http://builds.emberjs.com.s3.amazonaws.com/ember-data-e324f0e582fe180bb577f648b1b7247958db21d9.js)SHA值为 `e324f0e` 。

本示例中，所有的这些资源要放在与 `index.html` 相同目录的 `js/libs` 文件夹下。更新 `index.html` 代码，在 `</body>` 标签之前加入如下几个 `<script>` 标签，加载这些资源文件。

```html
<!-- ... 为确保简洁，略去头尾代码 ... -->
  <script src="js/libs/jquery.min.js"></script>
  <script src="js/libs/handlebars.js"></script>
  <script src="js/libs/ember.js"></script>
  <script src="js/libs/ember-data.js"></script>
</body>
<!-- ... 为确保简洁，略去头尾代码 ... -->
```

重新加载浏览器页面，确保所有的文件被正确引用，且没有错误产生。

### 在线演示
<a class="jsbin-embed" href="http://jsbin.com/ijefig/2/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>
 
### 附加资源

  * [采用`diff`格式显示这步骤所作的修改](https://github.com/emberjs/quickstart-code-sample/commit/0880d6e21b83d916a02fd17163f58686a37b5b2c)
