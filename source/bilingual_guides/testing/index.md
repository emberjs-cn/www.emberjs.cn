Testing is a core part of the Ember framework and its development cycle.

测试是Ember框架及其开发周期中非常核心的部分。

Let's assume you are writing an Ember application which will serve as a blog. 
This application would likely include models such as `user` and `post`. It would 
also include interactions such as _login_ and _create post_. Let's finally 
assume that you would like to have [automated tests] in place for your application. 

假设需要编写一个提供博客服务的Ember应用。这个应用应该包括`user`和`post`模型，并包含_登录_和_创建博文_这样的交互。这里假定需要对应用进行[自动化测试]。

There are two different classifications of tests that you will need: 
**Integration** and **Unit**.

测试主要分为**集成测试**和**单元测试**两类：

### Integration Tests

### 集成测试

Integration tests are used to test user interaction and application flow. With 
the example scenario above, some integration tests you might write are:

集成测试用于测试用户交互和应用流程。如上所述的博客应用，应该需要如下的集成测试：

* A user is able to log in via the login form.
* A user is able to create a blog post.
* A visitor does not have access to the admin panel.

* 用户应该可以通过一个登录窗口进行登录。
* 用户可以创建一篇博文。
* 访客没有访问管理面板的权限。

### Unit Tests

### 单元测试

Unit tests are used to test isolated chunks of functionality, or "units" without 
worrying about their dependencies. Some examples of unit tests for the scenario 
above might be:

单元测试用来测试独立的功能，或者说不需要关心其依赖部分的“单元”。对于博客应用可能的单元测试如下：

* A user has a role
* A user has a username
* A user has a fullname attribute which is the aggregate of its first and last 
  names with a space between
* A post has a title
* A post's title must be no longer than 50 characters

* 用户有角色划分
* 用户有用户名
* 用户有由用空格分隔的姓和名组成的全名
* 博文有标题
* 博文的标题不能超过50个字符

### Testing Frameworks

### 测试框架

[QUnit] is the default testing framework for this guide, but others are 
supported through third-party adapters.

[QUnit]是本指南的缺省测试框架，不过其他的框架也可以通过第三方的适配器来支持。

### Contributing

### 贡献

The Ember testing guide provides best practices and examples on how to test your
Ember applications. If you find any errors or believe the documentation can be
improved, please feel free to [contribute].

Ember测试指南主要提供关于如何测试Ember应用的最佳实践和示例。如果发现任何错误或者文档可以得到更好的描述，请为此作出[贡献]。

[自动化测试]: http://en.wikipedia.org/wiki/Test_automation
[QUnit]: http://qunitjs.com/
[贡献]: https://github.com/emberjs/website
