英文原文：[http://emberjs.com/guides/getting-started/obtaining-emberjs-and-dependencies](http://emberjs.com/guides/getting-started/obtaining-emberjs-and-dependencies)

## Obtaining Ember.js and Dependencies

## 获取EMBER.JS和相应依赖

TodoMVC has a few dependencies:

TodoMVC的依赖：
  
  * [jQuery](http://code.jquery.com/jquery-1.11.1.min.js)
  * [Handlebars](http://builds.handlebarsjs.com.s3.amazonaws.com/handlebars-v1.3.0.js)
  * [Ember.js](http://builds.emberjs.com/tags/v1.8.1/ember.js)
  * [Ember Data 1.0 beta](http://builds.emberjs.com/tags/v1.0.0-beta.11/ember-data.js)

For this example, all of these resources should be stored in the folder `js/libs` located in the same location as `index.html`. Update your `index.html` to load these files by placing `<script>` tags just before your closing `</body>` tag in the following order:

本示例中，所有的这些资源要放在与 `index.html` 相同目录的 `js/libs` 文件夹下。更新 `index.html` 代码，在 `</body>` 标签之前加入如下几个 `<script>` 标签，加载这些资源文件。

```html
<!-- ... additional lines truncated for brevity ... -->
<!-- ... 为确保简洁，略去头尾代码 ... -->
  <script src="js/libs/jquery-1.11.1.min.js"></script>
  <script src="js/libs/handlebars-v1.3.0.js"></script>
  <script src="js/libs/ember.js"></script>
  <script src="js/libs/ember-data.js"></script>
</body>
<!-- ... additional lines truncated for brevity ... -->
<!-- ... 为确保简洁，略去头尾代码 ... -->
```

Reload your web browser to ensure that all files have been referenced correctly and no errors occur.

重新加载浏览器页面，确保所有的文件被正确引用，且没有错误产生。

If you are using a package manager, such as [bower](http://bower.io),
make sure to checkout the [Getting Ember](/guides/getting-ember) guide
for info on other ways to get Ember.js.
If you are using a package manager, such as [bower](http://bower.io), make sure to checkout the [Getting Ember](/guides/getting-ember) guide for info on other ways to get Ember.js (this guide is dependant on ember-data v1.0 or greater so please be sure to use the latest beta).

如果使用包管理工具，例如[bower](http://bower.io)，请阅读[获取Ember](/guides/getting-ember)指南来获得其他获取Ember.js的方法（该指南依赖于 ember-data v1.0 或更新，请确保使用最新beta版）。

### Live Preview
### 在线演示
<a class="jsbin-embed" href="http://jsbin.com/ijefig/2/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>

### Additional Resources

  * [Changes in this step in `diff` format](https://github.com/emberjs/quickstart-code-sample/commit/0880d6e21b83d916a02fd17163f58686a37b5b2c)

### 附加资源

  * [采用`diff`格式显示这步骤所作的修改](https://github.com/emberjs/quickstart-code-sample/commit/0880d6e21b83d916a02fd17163f58686a37b5b2c)
