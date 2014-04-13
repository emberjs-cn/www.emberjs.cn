英文原文：[http://emberjs.com/guides/testing/integration/](http://emberjs.com/guides/testing/integration/)

Ember包含了需要用来帮助完成集成测试的助手。这些助手能自动识别（等待）应用中的异步行为，这使得编写确定性测试更加容易。

[QUnit](http://qunitjs.com/)是Ember默认使用的测试框架，其他的框架也可以通过第三方的适配器来得到支持。

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

### 异步助手

异步助手将等待之前的其他异步助手被触发并完成才开始执行。

* `visit(url)` - 访问指定的路由并返回一个将在所有异步行为完成后得到履行的承诺。
* `fillIn(input_selector, text)` - 在选定的输入出填入给定的文本，并返回一个在所有异步行为完成后会履行的承诺。
* `click(selector)` -
  点击选定的元素，触发元素`click`事件会触发的所有操作，并返回一个在所有异步行为完成后会履行的承诺。
* `keyEvent(selector, type, keyCode)` -
  模拟一个键盘事件，例如：在选定元素上的带有`keyCode`的`keypress`，`keydown`，`keyup`事件。
* `triggerEvent(selector, type, options)` -
  触发指定事件，如指定选择器的元素上的`blur`，`dblclick`事件。

### 同步助手

同步助手在触发时立即执行。

* `find(selector, context)` - 在应用的根元素中找到指定上下文（可选）的一个元素。限定到根元素可以有效的避免与测试框架的报告发生冲突。
* `currentPath()` - 返回当前路径。
* `currentRouteName()` - 返回当前活动路由名。
* `currentURL()` - 返回当前URL。

### 等待助手

`andThen`助手将等待之前所有异步助手完成才开始执行。下面通过一个示例来说明：

```javascript
test("simple test", function(){
  expect(1); // Ensure that we will perform one assertion

  visit("/posts/new");
  fillIn("input.title", "My new post");
  click("button.submit");

  // Wait for asynchronous helpers above to complete
  andThen(function() {
    equal(find("ul.posts li:last").text(), "My new post");
  });
});
```

注意上例中使用了`andThen`助手。也就是说会等待之前所有的异步测试助手完成处理后，才会执行传给`andThen`的函数中得代码。

### 编写测试

几乎每个测试都遵循一个固定的模式，访问一个路由，与打开的页面进行交互（通过测试助手），最后检验期望的DOM改变是否发生。

例子：

```javascript
test("root lists first page of posts", function(){
  visit("/");
  andThen(function() {
    equal(find(".post").length, 5, "The first page should have 5 posts");
    // Assuming we know that 5 posts display per page and that there are more than 5 posts
  });
});
```

执行操作的测试助手使用一个全局的承诺对象，如果这个对象存在，会自动的链接到这个承诺对象上。这样在编写测试代码的时候就不需要关心助手可能触发的异步行为。

```javascript
test("creating a post displays the new post", function(){
  visit("/posts/new");
  fillIn(".post-title", "A new post");
  fillIn(".post-author", "John Doe");
  click("button.create");
  andThen(function() {
    ok(find("h1:contains('A new post')").length, "The post's title should display");
    ok(find("a[rel=author]:contains('John Doe')").length, "A link to the author should display");
  });
});
```

### 创建自己的测试助手

`Ember.Test.registerHelper`和`Ember.Test.registerAsyncHelper`都是用来在调用`App.injectTestHelpers`调用时，注册将被注入的测试助手的。两者的不同之处在于，`Ember.Test.registerAsyncHelper`只有所有之前的异步助手都完成了，并且后续的助手不需要等待其完成来运行的时候才会运行。

助手方法将总是作为当前应用的第一个参数来被调用。助手需要在调用`App.injectTestHelpers()`之前进行注册。

例如：

```javascript
Ember.Test.registerAsyncHelper('dblclick', function(app, selector, context) {
  var $el = findWithAssert(selector, context);
  Ember.run(function() {
    $el.dblclick();
  });
});
```

### 其他测试库的适配器

如果使用QUnit之外的一个测试库，那么测试适配器需要提供`asyncStart`和`asyncEnd`两个方法。为了方便进行异步测试，QUnit的适配器使用QUnit提供的全局方法：`stop()`和`start()`。

**（请注意：只有开发版本的Ember构建才包含测试包。ember-testing并不包含在生产环境版本的构建中。为了方便测试应用，可以将测试包包含在开发和质量保障的构建中。测试不应该能在一个生产环境中执行，因此不要生产环境中包含ember-testing包。）**
