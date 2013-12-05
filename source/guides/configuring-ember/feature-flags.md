英文原文：[http://emberjs.com/guides/configuring-ember/feature-flags/](http://emberjs.com/guides/configuring-ember/feature-flags/)

在Ember.js中，当添加一个新特性时，会为这个特性添加一个标识。这个标识用来标记该特性是在构建Ember.js的时候被启用并包含在构建中，还是完全被移除。这样新开发的特性可以在满足生产环境需求之前，有选择的进行发布。

## 特性生命周期

当一个新特性被标记，这表明其将被包含在`canary`构建中（如果在运行期被启用）。当开始下一个`beta`周期的时候（通常是6-12周），会对每一个特性进行评估，那些通过评估的特性会在下一个`beta`周期中启用（也会在之后的每个`canary`构建中被启用）

如果一个特性还不够稳定，那么它将在下一个`beta`发布点被禁用。也不会被包含在接下来的`stable`发布中。如果相关的问题都被解决了，它将依然被包含在下一个`beta`周期中

一旦`beta`周期完成了最后的发布，那么发布中将包含所有在该周期中被启用的特性。此时特性标识将从`canary`和之后的`beta`分支中删除，且特性标识不在起作用。

## 标识详解

在生成的构建中，标识状态通过项目根目录的`features.json`文件进行控制。这个文件中列出了所有的特性以及状态。

一个特性可以有如下的状态：

* `true` - 特性被启用：标识背后的代码将在之后的构建中被启用。
* `false` - 特性被启用：标识背后的代码完全不会被包含在构建中。
* `null` - 特性会包含在构建中，但是必须在运行期启用才生效（依然处于标识之后）。

处理从生成的构建输出中删除特性标识是通过`defeatureify`来实现的。

## 特性列表 ([`FEATURES.md`](https://github.com/emberjs/ember.js/blob/master/FEATURES.md))

当一个特性被添加到`canary`分支（或者`master`分支），会在[`FEATURES.md`](https://github.com/emberjs/ember.js/blob/master/FEATURES.md)中添加一条记录，用来描述这个特性提供了什么功能（并链接到原始的PR）。这个列表是当前保存的，用来记录分支中（`stable`，`beta`和`master`）包含了些什么特性。

## 运行期启用

只有当`features.json`文件中指定一个特性的状态为`null`时，该特性才能在运行期被启用。（从技术上说，任何`true`或`false`之外的值都可以，不过这里使用`null`来表示）。

Ember使用一个全局变量`ENV`对象来初始化`Ember.ENV`，所有`ENV.FEATURES`中的特性标识都会被移植到`Ember.FEATURES`中，这些特性将根据标识的值来启用。Ember紧在初始加载时读取`ENV`的值，因此在Ember加载后再设置这些标识不会起任何作用。

例子：

```javascript
ENV = {FEATURES: {'link-to': true}};
```

此外，也可以通过定义`ENV.ENABLE_ALL_FEATURES`来启用所有的特性。
