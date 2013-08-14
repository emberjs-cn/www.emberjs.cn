---
title: Windows下Ember应用开发环境搭建
tags: Recent Posts
author: Jun Yang
---

环境：windows 7

### 安装nodejs

### 安装grunt

#### 安装grunt命令行工具grunt-cli

执行全局安装

```bash
  # grunt 必须依赖
  npm install -g grunt-cli
  # 生成项目脚手架 grunt-init --help
  npm install -g grunt-init
```

### 安装Yeoman

Yeoman 是 yo + bower + grunt

* yo:   生成 项目脚手架
* bower: 包管理工具

```bash
  npm install -g yo
```

自动安装grunt 和 bower

```bash
  # 生成项目脚手架
  npm install -g generator-webapp
```

### 准备项目文件夹

#### 创建项目文件夹
#### 安装grunt及插件，安装在项目根目录

进入项目根目录

```bash
  npm install grunt --save-dev
  npm install grunt-contrib-qunit --save-dev
```

验证版本 `grunt -version`

```
  grunt-cli v0.1.9
  grunt v0.4.1
```

#### 创建一个项目脚手架代码

```bash
  yo wabapp
```

查看目录下的文件，自动生成 package.json 和 Gruntfile

#### 安装依赖的模块 

```bash
  npm install
```

### 运行

```bash
  grunt server --force
```

http://localhost:9000 出现欢迎页面

### 与ember集成

#### 下载ember相关包

```bash
  bower install ember
```

app 目录下自动生成 bower_components

#### 安装模版编译插件

```bash
  npm install grunt-ember-templates --save-dev
```

建立模版文件夹 templates

```bash
  mkdir app/templates
```

#### 修改Gruntfile.js 自动编译模版

在Gruntfile.js文件添加

```javascript
  grunt.loadNpmTasks('grunt-ember-templates');
```

在grunt.initConfig内添加

```javascript
emberTemplates: {
  compile: {
    options: {
      templateName: function(sourceFile) {
        return sourceFile.replace(/app\/templates\//, '');
      }
    },
    files: {
      "<%= yeoman.app %>/scripts/templates.js": ["<%= yeoman.app%>/templates/**/*.handlebars"]
    }
  }
},
```

在 watch处添加如下内容：

```javascript
emberTemplates: {
    files: '<%= yeoman.app %>/templates/**/*.handlebars',
    tasks: ['emberTemplates']
},
```

最后添加emberTemplates到server任务

```javascript
grunt.registerTask('server', function (target) {
    ...
    grunt.task.run([
        ...
        'compass:server',
        ' emberTemplates', // Add this line.
        'livereload-start',
        ...
    ]);
});
```

### 开发一个简单应用

#### 在app/scripts/main.js 中 添加如下代码

```javascript
App = Em.Application.create({
  rootElement: $('#app'),
});

App.Router.map(function(){
  this.route('about');
});
```

#### 在 index.html 

```html
 <div id="app" class="container">   
 </div>
```

添加js文件

```html
  <script src="bower_components/jquery/jquery.js"></script>       
  <script src="bower_components/handlebars/handlebars.js"></script>
  <script src="bower_components/ember/ember.js"></script>
 
  <script src="scripts/main.js"></script>
  <script src="scripts/templates.js"></script>
```

#### 建立模版

在 app/templates目录下建立模版文件

* application.handlebars

```handlebars
  <h1>My App</h1>
  {{outlet}}
```

* index.handlebars

```handlebars
  <h1>My App</h1>
  <h1>index</h1>
  {{#linkTo "about"}}About{{/linkTo}}
```

* about.handlebars

```handlebars
  <h1>About</h1>
  {{#linkTo "index"}}index{{/linkTo}}
```

#### 运行

```bash
  grunt server --force
```

http://localhost:9000 出现欢迎页面，内容如下：

  My App
  index
  About

### 下一步，修改 grunt Gruntfile.js

对components、controllers、models、routes、views等js文件进行合并和压缩。
