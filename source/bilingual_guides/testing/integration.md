Ember includes several helpers to facilitate integration testing. These helpers are "aware" of (and wait for) asynchronous behavior within your application, making it much easier to write deterministic tests.

Ember包含了需要用来帮助完成集成测试的助手。这些助手能自动识别（等待）应用中的异步行为，这使得编写确定性测试更加容易。

[QUnit](http://qunitjs.com/) is the default testing framework for this package, but others are supported through third-party adapters.

[QUnit](http://qunitjs.com/)是Ember默认使用的测试框架，其他的框架也可以通过第三方的适配器来得到支持。

### Setup

### 设置

In order to integration test the Ember application, you need to run the app within your test framework. Set the root element of the application to an arbitrary element you know will exist. It is useful, as an aid to test-driven development, if the root element is visible while the tests run. You can potentially use #qunit-fixture, typically used to contain fixture html for use in tests, but you will need to override css to make it visible.

为了对Ember应用进行集成测试，需要在测试框架中运行应用。首先需要将根元素（root element）设置为任意一个已知将存在的元素。如果根元素在测试运行时可见的话，这对测试驱动开发非常有用，带来的帮助非常明显。这里可以使用`#qunit-fixture`，这个元素通常用来包含在测试中需要使用的html，不过需要重写CSS样式，以便其在测试过程中可见。

```javascript
App.rootElement = '#arbitrary-element-to-contain-ember-application';
```

This hook defers the readiness of the application, so that you can start the app when your tests are ready to run. It also sets the router's location to 'none', so that the window's location will not be modified (preventing both accidental leaking of state between tests and interference with your testing framework).

下面的钩子会延迟准备应用，以便当测试准备好运行的时候才启动应用。钩子还负责将路由的地址（location）设置为`none`，这样浏览器窗口的地址就不会被修改（这样避免了测试和测试框架之间的状态冲突）。

```javascript
App.setupForTesting();
```

This injects the test helpers into the window's scope.

下面的代码完成将测试助手注入到`window`作用域。

```javascript
App.injectTestHelpers();
```

With QUnit, `setup` and `teardown` functions are defined in each test module's configuration. These functions are called for each test in the module. If you are using a framework other than QUnit, use the hook that is called before each individual test.

QUnit中，`setup`和`teardown`函数在每个测试模块的配置中被定义。上面两个函数在模块中每个测试进行时被调用。如果使用了QUnit之外的其他测试框架，那么需要在每个测试运行之前的钩子中调用上面两个函数来完成设置。

Before each test, reset the application: `App.reset()` completely resets the state of the application.

每个测试开始前，还需要通过`App.reset()`重置整个应用，这样可以恢复应用的所有状态。

```javascript
module("Integration Tests", {
  setup: function() {
    App.reset();
  }
});
```

### Helpers

### 助手

* `visit(url)` - Visits the given route and returns a promise that fulfills when all resulting async behavior is complete.

* `visit(url)` - 访问指定的路由并返回一个将在所有异步行为完成后得到履行的承诺。

* `find(selector, context)` - Finds an element within the app's root element and within the context (optional). Scoping to the root element is especially useful to avoid conflicts with the test framework's reporter.

* `find(selector, context)` - 在应用的根元素中找到指定上下文（可选）的一个元素。限定到根元素可以有效的避免与测试框架的报告发生冲突。

* `fillIn(input_selector, text)` - Fills in the selected input with the given text and returns a promise that fulfills when all resulting async behavior is complete.

* `fillIn(input_selector, text)` - 在选定的输入出填入给定的文本，并返回一个在所有异步行为完成后会履行的承诺。

* `click(selector)` - Clicks an element and triggers any actions triggered by the element's `click` event and returns a promise that fulfills when all resulting async behavior is complete.

* `click(selector)` -
  点击选定的元素，触发元素`click`事件会触发的所有操作，并返回一个在所有异步行为完成后会履行的承诺。

* `keyEvent(selector, type, keyCode)` - Simulates a key event type, e.g. `keypress`, `keydown`, `keyup` with the desired keyCode on element found by the selector.

* `keyEvent(selector, type, keyCode)` -
  模拟一个键盘事件，例如：在选定元素上的带有`keyCode`的`keypress`，`keydown`，`keyup`事件。

* `wait()` - Returns a promise that fulfills when all async behavior is complete.

* `wait()` - 返回一个在所有异步行为完成后会履行的承诺。

### Writing tests

### 编写测试

Almost every test has a pattern of visiting a route, interacting with the page (using the helpers), and checking for expected changes in the DOM.

几乎每个测试都遵循一个固定的模式，访问一个路由，与打开的页面进行交互（通过测试助手），最后检验期望的DOM改变是否发生。

Examples:

例子：

```javascript
test("root lists first page of posts", function(){
  visit("/").then(function() {
    equal(find(".post").length, 5, "The first page should have 5 posts");
    // Assuming we know that 5 posts display per page and that there are more than 5 posts
  });
});
```

The helpers that perform actions return a promise that fulfills when all asynchronous behavior has completed.

执行操作的测试助手都会返回在所有异步行为完成后会履行的承诺。

```javascript
test("creating a post displays the new post", function(){
  visit("/posts/new").then(function() {
    return fillIn(".post-title", "A new post");
  }).then(function() {
    return fillIn(".post-author", "John Doe");
  }).then(function() {
    return click("button.create");
  }).then(function() {
    ok(find("h1:contains('A new post')").length, "The post's title should display");
    ok(find("a[rel=author]:contains('John Doe')").length, "A link to the author should display");
  });
});
```

For convenience, helpers can be chained:

为了方便，测试助手还可以进行链式调用：

```javascript
test("creating a post displays the new post", function() {
  visit("/posts/new")
  .fillIn(".post-title", "A new post")
  .fillIn(".post-author", "John Doe")
  .click("button.create")
  .then(function() {
    ok(find("h1:contains('A new post')").length, "The post's title should display");
    ok(find("a[rel=author]:contains('John Doe')").length, "A link to the author should display");
  });
});
```

### Creating your own test helpers

### 创建自己的测试助手

`Ember.Test.registerHelper` is used to register a test helper that will be injected when `App.injectTestHelpers` is called.

`Ember.Test.registerHelper`用于注册测试助手，这些助手会在`App.injectTestHelpers`被调用时被注入。

The helper method will always be called with the current Application as the first parameter. Helpers that cause asynchronous behavior should return `wait()` to return a promise that will resolve when that asynchronous behavior is complete.

测试助手总是作为当前应用的第一个参数来调用。如果一个测试助手会触发异步行为，那么它需要返回`wait()`，从而实现返回一个在异步行为完成后会履行的承诺。

For example:

```javascript
Ember.Test.registerHelper('dblclick', function(app, selector, context) {
  var $el = findWithAssert(selector, context);
  Ember.run(function() {
    $el.dblclick();
  });
  return wait();
});
```

### Test adapters for other libraries

### 其他测试库的适配器

If you use a library other than QUnit, your test adapter will need to
provide methods for `asyncStart` and `asyncEnd`. To facilitate
asynchronous testing, the default test adapter for QUnit uses methods
that QUnit provides: (globals) `stop()` and `start()`.

如果使用QUnit之外的一个测试库，那么测试适配器需要提供`asyncStart`和`asyncEnd`两个方法。为了方便进行异步测试，QUnit的适配器使用QUnit提供的全局方法：`stop()`和`start()`。

**(Please note: Only development builds of Ember include the testing
package. The ember-testing package is not included in the production
build of Ember. The package can be loaded in your dev or qa builds to
facilitate testing your application. By not including the ember-testing
package in production, your tests will not be executable in a production
environment.)**

**（请注意：只有开发版本的Ember构建才包含测试包。ember-testing并不包含在生产环境版本的构建中。为了方便测试应用，可以将测试包包含在开发和质量保障的构建中。测试不应该能在一个生产环境中执行，因此不要生产环境中包含ember-testing包。）**
