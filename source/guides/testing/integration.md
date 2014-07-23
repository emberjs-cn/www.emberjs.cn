英文原文：[http://emberjs.com/guides/testing/integration/](http://emberjs.com/guides/testing/integration/)

集成测试通常用来测试应用中得重要工作流。集成测试用来模拟用户交互和确认交互结果。

### 设置

为了对Ember应用进行集成测试，需要在测试框架中运行应用。首先需要将根元素（root element）设置为任意一个已知将存在的元素。如果根元素在测试运行时可见的话，这对测试驱动开发非常有用，带来的帮助非常明显。这里可以使用`#qunit-fixture`，这个元素通常用来包含在测试中需要使用的html，不过需要重写CSS样式，以便其在测试过程中可见。

```javascript
App.rootElement = '#arbitrary-element-to-contain-ember-application';
```

下面的钩子会延迟准备应用，以便当测试准备好运行的时候才启动应用。钩子还负责将路由的地址（location）设置为`none`，这样浏览器窗口的地址就不会被修改（这样避免了测试和测试框架之间的状态冲突）。

```javascript
App.setupForTesting();
```

下面的代码完成将测试助手注入到`window`作用域。

```javascript
App.injectTestHelpers();
```

QUnit中，`setup`和`teardown`函数在每个测试模块的配置中被定义。上面两个函数在模块中每个测试进行时被调用。如果使用了QUnit之外的其他测试框架，那么需要在每个测试运行之前的钩子中调用上面两个函数来完成设置。

每个测试开始前，还需要通过`App.reset()`重置整个应用，这样可以恢复应用的所有状态。

```javascript
module("Integration Tests", {
  setup: function() {
    App.reset();
  }
});
```

### 其他测试库的适配器

如果使用QUnit之外的一个测试库，那么测试适配器需要提供`asyncStart`和`asyncEnd`两个方法。为了方便进行异步测试，QUnit的适配器使用QUnit提供的全局方法：`stop()`和`start()`。

**请注意：**

`ember-testing`并不包含在生产环境版本的构建中，只有开发版本的Ember构建才包含测试包。为了方便测试应用，可以将测试包包含在开发和质量保障的构建中。测试不应该能在一个生产环境中执行，因此不要生产环境中包含ember-testing包。
