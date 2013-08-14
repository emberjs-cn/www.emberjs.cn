英文原文：[http://emberjs.com/guides/getting-started/obtaining-emberjs-and-dependencies](http://emberjs.com/guides/getting-started/obtaining-emberjs-and-dependencies)

## Obtaining Ember.js and Dependencies

## 获取EMBER.JS和相应依赖

The version of Ember.js used in this guide (RC 3.1) can be downloaded directly from [the Ember.js build site](http://builds.emberjs.com.s3.amazonaws.com/ember-1.0.0-rc.3.1.js). Ember.js has two dependencies: jQuery and Handlebars. jQuery can be downloaded from [http://jquery.com/](http://jquery.com/) and Handlebars can be downloaded at [http://handlebarsjs.com/](http://handlebarsjs.com/). This guide uses `ember-data` for managing model data. The latest development builds of Ember data can be downloaded at [http://builds.emberjs.com/](http://builds.emberjs.com/). The build compatible [with RC3 has the SHA `e324f0e`](http://builds.emberjs.com.s3.amazonaws.com/ember-data-e324f0e582fe180bb577f648b1b7247958db21d9.js).

本指南中使用的Ember.js版本为(RC 3.1)可以直接从[Ember.js官方网站](http://builds.emberjs.com.s3.amazonaws.com/ember-1.0.0-rc.3.1.js)下载。Ember.js需要两个依赖库：jQuery和Handlebars。jQuery可以从[http://jquery.com/](http://jquery.com/)下载，Handlebars可以从[http://handlebarsjs.com/](http://handlebarsjs.com/)下载。本指南使用 `ember-data` 来进行数据模型映射。最新的Ember data开发版本可以从[http://builds.emberjs.com/](http://builds.emberjs.com/)下载。与[RC3兼容的版本](http://builds.emberjs.com.s3.amazonaws.com/ember-data-e324f0e582fe180bb577f648b1b7247958db21d9.js)SHA值为 `e324f0e` 。

For this example, all of these resources should be stored in the folder `js/libs` located in the same location as `index.html`. Update your `index.html` to load these files by placing `<script>` tags just before your closing `</body>` tag in the following order:

本示例中，所有的这些资源要放在与 `index.html` 相同目录的 `js/libs` 文件夹下。更新 `index.html` 代码，在 `</body>` 标签之前加入如下几个 `<script>` 标签，加载这些资源文件。

```html
<!-- ... additional lines truncated for brevity ... -->
<!-- ... 为确保简洁，略去头尾代码 ... -->
  <script src="js/libs/jquery.min.js"></script>
  <script src="js/libs/handlebars.js"></script>
  <script src="js/libs/ember.js"></script>
  <script src="js/libs/ember-data.js"></script>
</body>
<!-- ... additional lines truncated for brevity ... -->
<!-- ... 为确保简洁，略去头尾代码 ... -->
```

Reload your web browser to ensure that all files have been referenced correctly and no errors occur.

重新加载浏览器页面，确保所有的文件被正确引用，且没有错误产生。

### Live Preview
### 在线演示
<a class="jsbin-embed" href="http://jsbin.com/ijefig/2/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>
 
### Additional Resources

  * [Changes in this step in `diff` format](https://github.com/emberjs/quickstart-code-sample/commit/0880d6e21b83d916a02fd17163f58686a37b5b2c)

### 附加资源

  * [采用`diff`格式显示这步骤所作的修改](https://github.com/emberjs/quickstart-code-sample/commit/0880d6e21b83d916a02fd17163f58686a37b5b2c)
