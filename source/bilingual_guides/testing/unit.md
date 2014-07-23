Unit tests are generally used to test a small piece of code and ensure that it
is doing what was intended. Unlike integration tests, they are narrow in scope
and do not require the Ember application to be running.

单元测试用于测试代码的一个小片段，确保其功能正常。与集成测试不同，单元测试被限定在一个范围内，并且不需要Ember应用运行。

### Globals vs Modules

### 全局 vs 模块

In the past, it has been difficult to test portions of your Ember application
without loading the entire app as a global. By having your application written
using modules ([CommonJS], [AMD], etc), you are able to require just code that 
is to be tested without having to pluck the pieces out of your global 
application.

过去如果没有作为一个全局变量加载整个Ember应用，要对应用进行测试非常困难。通过使用模块（[CommonJS]，[AMD]等）来编写应用，可以只加载被测试的部分，而不用将其从全局的应用中抽出来测试。

### Unit Testing Helpers

### 单元测试助手

[Ember-QUnit] is the default *unit* testing helper suite for Ember. It can and
should be used as a template for other test framework helpers. It uses your
application's resolver to find and automatically create test subjects for you
using the `moduleFor` and `test` helpers.

[Ember-QUnit]是Ember的缺省的*单元*测试助手套件。其可以作为其他测试框架助手的样板来使用。[Ember-QUnit]使用应用的`resolver`来查找并使用`moduleFor`和`test`助手自动创建被测主体。

A test subject is simply an instance of the object that a particular test is 
making assertions about. Usually test subjects are manually created by the 
writer of the test.

测试主体是一个特定测试将围绕其进行断言的一个简单对象的实例。通常测试主体有测试者手动创建。

<!--
* [Ember-QUnit](https://github.com/rpflorence/ember-qunit) - Unit test helpers
  written for QUnit
* [Ember-Mocha](#) - Unit test helpers written for Mocha (to be written)
* [Ember-Jasmine](#) - Unit test helpers written for Jasmine (to be written)
-->

***The unit testing section of this guide will use the Ember-QUnit library, but
the concepts and examples should translate easily to other frameworks.***

***本指南中的单元测试将采用`Ember-QUnit`来完成，不过其中的概念和例子可以非常容易的迁移至其他的框架。***

### Available Helpers

### 可用的助手

By including [Ember-QUnit], you will have access to a number of test helpers.

通过加入[Ember-QUnit]，可以获取一系列测试助手。

* `moduleFor(fullName [, description [, callbacks]])`
 - **fullName**: The full name of the unit, (ie. `controller:application`,
    `route:index`, etc.)
 - **description**: the description of the module
 - **callbacks**: normal QUnit callbacks (setup and teardown), with addition to
    needs, which allows you specify the other units the tests will need.

 - **fullName**: 单元测试全名。（例如：`controller:application`，`route:index`等。）
 - **description**: 模块描述。
 - **callbacks**: 完成附加需求的QUnit回调（`setup`和`teardown`），可以通过回调来指定测试需要的其他单元）。

* `moduleForComponent(name [, description [, callbacks]])`
 - **name**: the short name of the component that you'd use in a template, (ie.
    `x-foo`, `ic-tabs`, etc.)
 - **description**: the description of the module
 - **callbacks**: normal QUnit callbacks (setup and teardown), with addition to
    needs, which allows you specify the other units the tests will need.

 - **name**: 将被用于模板中得简短组件名。（例如：`x-foo`，`ic-tabs`等等。）
 - **description**: 模块描述。
 - **callbacks**: 完成附加需求的QUnit回调（`setup`和`teardown`），可以通过回调来指定测试需要的其他单元）。

* `moduleForModel(fullName [, description [, callbacks]])`
 - **name**: the short name of the model you'd use in store
    operations (ie. `user`, `assignmentGroup`, etc.)
 - **description**: the description of the module
 - **callbacks**: normal QUnit callbacks (setup and teardown), with addition to
    needs, which allows you specify the other units the tests will need.

 - **name**: 在`store`操作中将使用的简短模型名。（例如：`user`，`assignmentGroup`等。）
 - **description**: 模块描述。
 - **callbacks**: 完成附加需求的QUnit回调（`setup`和`teardown`），可以通过回调来指定测试需要的其他单元）。

* `test`
 - Same as QUnit `test` except it includes the `subject` function which is used
   to create the test subject.

 - 与QUnit的`test`期望一样，其包含了用来创建测试主体的`subject`函数。
   to create the test subject.

* `setResolver`
 - Sets the resolver which will be used to lookup objects from the application
   container.

- 设置用来从应用容器中查找对象的`resolver`。

### Unit Testing Setup

### 设置单元测试

In order to unit test your Ember application, you need to let Ember know it is in
test mode. To do so, you must call `Ember.setupForTesting()`.

为了对Ember应用进行单元测试，首先需要让Ember知道其在测试模式。为实现这个目的，需要调用`Ember.setupForTesting()`。

```javascript
Ember.setupForTesting();
```

The `setupForTesting()` function call makes ember turn off its automatic run
loop execution. This gives us an ability to control the flow of the run loop
ourselves, to a degree. Its default behaviour of resolving all promises and
completing all async behaviour are suspended to give you a chance to set up
state and make assertions in a known state. In other words, you know that if you
run "visit" to get to a particular URL, you can be sure the URL has been visited
and that's the only behaviour that has transpired. If we didn't use this mode,
our assertions would most likely be executed before the async behaviour had taken place, so
our assertion results would be unpredictable.

`setupForTesting()`函数的调用通知Ember关闭了其自动运行循环的执行。这样使得可以能够自己一定程度上控制运行循环流程。缺省的履行所有承诺和完成所有异步行为的行为被暂停，使得可以在一个已知的状态来作出断言。换句话说，如果已知运行`visit`到一个特定的URL，就可以肯定URL被访问并且也是唯一发生的行为。如果并没有采用这种方式，那么断言很可能会在异步行为发生之前就被执行了，以至于断言结果并不是可预知。

With a module-based application, you have access to the unit test helpers simply
by requiring the exports of the module. However, if you are testing a global
Ember application, you are still able to use the unit test helpers. Instead of
importing the `ember-qunit` module, you need to make the unit test helpers
global with `emq.globalize()`:

在一个基于模块的应用里，可以通过请求模块的导出来访问单元测试助手。然而，如果在测试一个全局的Ember应用，一样可以使用单元测试助手。作为导入`ember-qunit`模块的替代方案，需要通过`emq.globalize()`来使得单元测试变成全局的。

```javascript
emq.globalize();
```

This will make the above helpers available globally.

这就使得上述的助手变成了全局可用。

### The Resolver

### 解析器

The Ember resolver plays a huge role when unit testing your application. It
provides the lookup functionality based on name, such as `route:index` or
`model:post`.

Ember解析器在对应用进行单元测试的时候扮演了一个非常重要的角色。其提供了一个基于名字查找的功能，例如`route:index`或者`model:post`。

If you do not have a custom resolver or are testing a global Ember application,
the resolver should be set like this:

如果没有一个自定义的解析器，或者测试一个全局的Ember应用，解析器应该进行如下的设置：

***Make sure to replace "App" with your application's namespace in the following line***

***确定使用应用的命名空间来替代下面一行代码中得`App`***

```javascript
setResolver(Ember.DefaultResolver.create({ namespace: App })
```

Otherwise, you would require the custom resolver and pass it to `setResolver`
like this _(ES6 example)_:

否则，需要获取自定义解析器，并将其传递给`setResolver`，就如_（ES6示例）_中一般：

```javascript
import Resolver from './path/to/resolver';
import { setResolver } from 'ember-qunit';
setResolver(Resolver.create());
```

[CommonJS]: http://wiki.commonjs.org/wiki/CommonJS  "CommonJS"
[AMD]: http://requirejs.org/docs/whyamd.html "AMD"
[Ember-QUnit]: https://github.com/rpflorence/ember-qunit "Ember QUnit"
