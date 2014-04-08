## About Features

## 关于特性

When a new feature is added to Ember they will be written in such a way that the
feature can be conditionally included in the generated build output and enabled
(or completely removed) based on whether a particular flag is present. This
allows newly developed features to be selectively released when they are
considered ready for production use.

在Ember.js中，当添加一个新特性时，会为这个特性添加一个标识。这个标识用来标记该特性是在构建Ember.js的时候被启用并包含在构建中，还是完全被移除。这样新开发的特性可以在满足生产环境需求之前，有选择的进行发布。

## Feature Life-Cycle

## 特性生命周期

When a new feature is flagged it is only available in canary builds (if enabled
at runtime). When it is time for the next beta cycle to be started (generally
6-12 week cycles) each feature will be evaluated and those features that are
ready will be enabled in the next `beta` (and subsequently automatically enabled
in all future canary builds).

当一个新特性被标记，这表明其将被包含在`canary`构建中（如果在运行期被启用）。当开始下一个`beta`周期的时候（通常是6-12周），会对每一个特性进行评估，那些通过评估的特性会在下一个`beta`周期中启用（也会在之后的每个`canary`构建中被启用）

If a given feature is deemed unstable it will be disabled in the next beta point
release, and not be included in the next stable release. It may still be included
in the next beta cycle if the issues/concerns have been resolved.

如果一个特性还不够稳定，那么它将在下一个`beta`发布点被禁用。也不会被包含在接下来的`stable`发布中。如果相关的问题都被解决了，它将依然被包含在下一个`beta`周期中

Once the beta cycle has completed the final release will include any features that
were enabled during that cycle. At this point the feature flags will be removed from
the canary and future beta branches, and the feature flag will no longer be used.

一旦`beta`周期完成了最后的发布，那么发布中将包含所有在该周期中被启用的特性。此时特性标识将从`canary`和之后的`beta`分支中删除，且特性标识不在起作用。

## Flagging Details

## 标识详解

The flag status in the generated build output is controlled by the `features.json`
file in the root of the project. This file lists all features and their current
status.

在生成的构建中，标识状态通过项目根目录的`features.json`文件进行控制。这个文件中列出了所有的特性以及状态。

A feature can have one of a few different statuses:

一个特性可以有如下的状态：

* `true` - The feature is **enabled**: the code behind the flag is always enabled in
  the generated build.
* `false` - The feature is **disabled**: the code behind the flag is not present in
  the generated build at all.
* `null` - The feature is **present** in the build output, but must be enabled at
  runtime (it is still behind feature flags).

* `true` - 特性被**启用**：标识背后的代码将在之后的构建中被启用。
* `false` - 特性被**禁用**：标识背后的代码完全不会被包含在构建中。
* `null` - 特性会**包含**在构建中，但是必须在运行期启用才生效（依然处于标识之后）。

The process of removing the feature flags from the resulting build output is
handled by `defeatureify`.

处理从生成的构建输出中删除特性标识是通过`defeatureify`来实现的。

## Feature Listing ([`FEATURES.md`](https://github.com/emberjs/ember.js/blob/master/FEATURES.md))

## 特性列表 ([`FEATURES.md`](https://github.com/emberjs/ember.js/blob/master/FEATURES.md))

When a new feature is added to the `canary` channel (aka `master` branch), an
entry is added to [`FEATURES.md`](https://github.com/emberjs/ember.js/blob/master/FEATURES.md)
explaining what the feature does (and linking the originating pull request).
This listing is kept current, and reflects what is available in each branch
(`stable`,`beta`, and `master`).

当一个特性被添加到`canary`分支（或者`master`分支），会在[`FEATURES.md`](https://github.com/emberjs/ember.js/blob/master/FEATURES.md)中添加一条记录，用来描述这个特性提供了什么功能（并链接到原始的PR）。这个列表是当前保存的，用来记录分支中（`stable`，`beta`和`master`）包含了些什么特性。

## Enabling At Runtime

## 运行期启用

The only time a feature can be enabled at runtime is if the
`features.json` for that build contains `null` (technically, anything other
than `true` or `false` will do, but `null` is the chosen value).

只有当`features.json`文件中指定一个特性的状态为`null`时，该特性才能在运行期被启用。（从技术上说，任何`true`或`false`之外的值都可以，不过这里使用`null`来表示）。

A global `EmberENV` object will be used to initialize the `Ember.ENV`
object, and any feature flags that are enabled/disabled under
`EmberENV.FEATURES` will be migrated to `Ember.FEATURES`, those features
will be enabled based on the flag value. **Ember only reads** the
`EmberENV` value upon initial load so setting this value after Ember has
been loaded will have no affect.

Ember使用一个全局变量`EmberENV`对象来初始化`Ember.ENV`，所有`EmberENV.FEATURES`中的特性标识都会被移植到`Ember.FEATURES`中，这些特性将根据标识的值来启用。Ember紧在初始加载时读取`EmberENV`的值，因此在Ember加载后再设置这些标识不会起任何作用。

Example:

例子：

```javascript
EmberENV = {FEATURES: {'link-to': true}};
```

Additionally you can define `EmberENV.ENABLE_ALL_FEATURES` to force all
features to be enabled.

此外，也可以通过定义`EmberENV.ENABLE_ALL_FEATURES`来启用所有的特性。
