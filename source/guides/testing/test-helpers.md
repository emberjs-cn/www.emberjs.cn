英文原文：[http://emberjs.com/guides/testing/test-helpers/](http://emberjs.com/guides/testing/test-helpers/)

测试Web应用最大的问题是代码都是事件驱动的，因此很可能出现异步的情况（例如输出与输入不是按照顺序发送）。其衍生问题就是代码可能会以任何可能的顺序执行。

下面这个例子能很好的说明此问题：当一个用户点击了两个按钮，一个接着一个，分别从不同的服务器加载数据。这种情况响应的时间是不同的。

当编写测试时，应该敏锐地意识到，在发送了一个请求之后，并无法立即得到返回的响应，因此断言的代码（“测试者”）需要以同步的状态来等待被测试的事物（“被测对象”）。例如上面所举例子，应该等待两个服务器都返回数据，这时测试代码才执行其逻辑来检测数据的正确性（不论是模仿的数据，还是真实的）。

这就是为什么Ember的测试助手当其做断言的时候，都是被包裹爱确保在一个同步状态的代码中。这样做避免对所有这样的代码都去做这样的包裹，并且因为减少了模板代码，提高了测试代码的可读性。

Ember包含一些助手来辅助完成集成测试。主要有两类助手：**同步的**和**异步的**。

### 异步助手

异步助手能感知到应用中得异步行为，并会等待这些异步行为，这使得更加容易编写判定测试。

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

* `find(selector, context)` - 在应用的根元素中找到指定上下文（可选）的一个元素。限定到根元素可以有效的避免与测试框架的报告发生冲突，如果上下文没有指定，那么这将按照缺省的完成。
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

### 自定义测试助手

`Ember.Test.registerHelper`和`Ember.Test.registerAsyncHelper`都是用来在调用`App.injectTestHelpers`调用时，注册将被注入的测试助手的。两者的不同之处在于，`Ember.Test.registerAsyncHelper`只有所有之前的异步助手都完成了，并且后续的助手不需要等待其完成来运行的时候才会运行。

助手方法将总是作为当前应用的第一个参数来被调用。助手需要在调用`App.injectTestHelpers()`之前进行注册。

下例为一个同步助手：

```javascript
Ember.Test.registerHelper('shouldHaveElementWithCount',
  function(app, selector, n, context) {
    var el = findWithAssert(selector, context);
    var count = el.length;
    equal(n, count, 'found ' + count + ' times');
  }
);

// shouldHaveElementWithCount("ul li", 3);
```

下例是一个异步助手：

```javascript
Ember.Test.registerAsyncHelper('dblclick',
  function(app, selector, context) {
    var $el = findWithAssert(selector, context);
    Ember.run(function() {
      $el.dblclick();
    });
  }
);

// dblclick("#person-1")
```

异步助手也可以用来将一组操作合并为一个助手。例如：

```javascript
Ember.Test.registerAsyncHelper('addContact',
  function(app, name, context) {
    fillIn('#name', name);
    click('button.create');
  }
);

// addContact("Bob");
// addContact("Dan");
```

#### 示例

这里有一个使用`registerHelper`和`registerAsyncHelper`的例子。

<a class="jsbin-embed"
href="http://jsbin.com/bahas/embed?output">自定义测试助手</a>
