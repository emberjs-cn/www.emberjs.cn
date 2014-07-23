英文原文：[http://emberjs.com/guides/testing/unit/](http://emberjs.com/guides/testing/unit/)

单元测试用于测试代码的一个小片段，确保其功能正常。与集成测试不同，单元测试被限定在一个范围内，并且不需要Ember应用运行。

### 全局 vs 模块

过去如果没有作为一个全局变量加载整个Ember应用，要对应用进行测试非常困难。通过使用模块（[CommonJS]，[AMD]等）来编写应用，可以只加载被测试的部分，而不用将其从全局的应用中抽出来测试。

### 单元测试助手

[Ember-QUnit]是Ember的缺省的*单元*测试助手套件。其可以作为其他测试框架助手的样板来使用。[Ember-QUnit]使用应用的`resolver`来查找并使用`moduleFor`和`test`助手自动创建被测主体。

测试主体是一个特定测试将围绕其进行断言的一个简单对象的实例。通常测试主体有测试者手动创建。

<!--
* [Ember-QUnit](https://github.com/rpflorence/ember-qunit) - Unit test helpers
  written for QUnit
* [Ember-Mocha](#) - Unit test helpers written for Mocha (to be written)
* [Ember-Jasmine](#) - Unit test helpers written for Jasmine (to be written)
-->

***本指南中的单元测试将采用`Ember-QUnit`来完成，不过其中的概念和例子可以非常容易的迁移至其他的框架。***

### 可用的助手

通过加入[Ember-QUnit]，可以获取一系列测试助手。

* `moduleFor(fullName [, description [, callbacks]])`
 - **fullName**: 单元测试全名。（例如：`controller:application`，`route:index`等。）
 - **description**: 模块描述。
 - **callbacks**: 完成附加需求的QUnit回调（`setup`和`teardown`），可以通过回调来指定测试需要的其他单元）。

* `moduleForComponent(name [, description [, callbacks]])`
 - **name**: 将被用于模板中得简短组件名。（例如：`x-foo`，`ic-tabs`等等。）
 - **description**: 模块描述。
 - **callbacks**: 完成附加需求的QUnit回调（`setup`和`teardown`），可以通过回调来指定测试需要的其他单元）。

* `moduleForModel(fullName [, description [, callbacks]])`
 - **name**: 在`store`操作中将使用的简短模型名。（例如：`user`，`assignmentGroup`等。）
 - **description**: 模块描述。
 - **callbacks**: 完成附加需求的QUnit回调（`setup`和`teardown`），可以通过回调来指定测试需要的其他单元）。

* `test`
 - 与QUnit的`test`期望一样，其包含了用来创建测试主体的`subject`函数。
   to create the test subject.

* `setResolver`
- 设置用来从应用容器中查找对象的`resolver`。

### 设置单元测试

为了对Ember应用进行单元测试，首先需要让Ember知道其在测试模式。为实现这个目的，需要调用`Ember.setupForTesting()`。

```javascript
Ember.setupForTesting();
```

`setupForTesting()`函数的调用通知Ember关闭了其自动运行循环的执行。这样使得可以能够自己一定程度上控制运行循环流程。缺省的履行所有承诺和完成所有异步行为的行为被暂停，使得可以在一个已知的状态来作出断言。换句话说，如果已知运行`visit`到一个特定的URL，就可以肯定URL被访问并且也是唯一发生的行为。如果并没有采用这种方式，那么断言很可能会在异步行为发生之前就被执行了，以至于断言结果并不是可预知。

在一个基于模块的应用里，可以通过请求模块的导出来访问单元测试助手。然而，如果在测试一个全局的Ember应用，一样可以使用单元测试助手。作为导入`ember-qunit`模块的替代方案，需要通过`emq.globalize()`来使得单元测试变成全局的。

```javascript
emq.globalize();
```

这就使得上述的助手变成了全局可用。

### 解析器

Ember解析器在对应用进行单元测试的时候扮演了一个非常重要的角色。其提供了一个基于名字查找的功能，例如`route:index`或者`model:post`。

如果没有一个自定义的解析器，或者测试一个全局的Ember应用，解析器应该进行如下的设置：

***确定使用应用的命名空间来替代下面一行代码中得`App`***

```javascript
setResolver(Ember.DefaultResolver.create({ namespace: App })
```

否则，需要获取自定义解析器，并将其传递给`setResolver`，就如_（ES6示例）_中一般：

```javascript
import Resolver from './path/to/resolver';
import { setResolver } from 'ember-qunit';
setResolver(Resolver.create());
```

[CommonJS]: http://wiki.commonjs.org/wiki/CommonJS  "CommonJS"
[AMD]: http://requirejs.org/docs/whyamd.html "AMD"
[Ember-QUnit]: https://github.com/rpflorence/ember-qunit "Ember QUnit"
