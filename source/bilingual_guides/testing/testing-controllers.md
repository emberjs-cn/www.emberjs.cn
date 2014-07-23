_Unit testing methods and computed properties follows previous patterns shown 
in [Unit Testing Basics] because Ember.Controller extends Ember.Object._

_单元测试方案和计算属性与之前[单元测试基础]中说明的相同，因为`Ember.Controller`集成自`Ember.Object`。_

Unit testing controllers is very simple using the unit test helper 
[moduleFor](/guides/testing/unit) which is part of the ember-qunit framework.

针对控制器的单元测试使用ember-qunit框架的[moduleFor](/guides/testing/unit)来做使这一切变得非常简单。

### Testing Controller Actions

### 测试控制器操作

Here we have a controller `PostsController` with some computed properties and an 
action `setProps`.

下面给出一个`PostsController`控制器，控制器有一些计算属性和一个`setProps`操作。

```javascript
App.PostsController = Ember.ArrayController.extend({

  propA: 'You need to write tests',
  propB: 'And write one for me too',

  setPropB: function(str) {
    this.set('propB', str);
  },

  actions: {
    setProps: function(str) {
      this.set('propA', 'Testing is cool');
      this.setPropB(str);
    }
  }
});
```

`setProps` sets a property on the controller and also calls a method. To write a
test for this action, we would use the `moduleFor` helper to setup a test 
container:

`setProps`设置控制器的一个属性并调用一个方法。为这个操作编写测试，需要使用`moduleFor`助手来设置一个测试容器：

```javascript
moduleFor('controller:posts', 'Posts Controller');
```

Next we use `this.subject()` to get an instance of the `PostsController` and 
write a test to check the action. `this.subject()` is a helper method from the 
`ember-qunit` library that returns a singleton instance of the module set up 
using `moduleFor`.

接下来使用`this.subject()`来获取`PostsController`的一个实例，并编写一个测试来检测这个操作。`this.subject()`是ember-qunit库提供的一个助手方法，其返回`moduleFor`设置的模块的一个单例。

```javascript
test('calling the action setProps updates props A and B', function() {
  expect(4);
  
  // get the controller instance
  var ctrl = this.subject();

  // check the properties before the action is triggered
  equal(ctrl.get('propA'), 'You need to write tests');
  equal(ctrl.get('propB'), 'And write one for me too');

  // trigger the action on the controller by using the `send` method, 
  // passing in any params that our action may be expecting
  ctrl.send('setProps', 'Testing Rocks!');

  // finally we assert that our values have been updated 
  // by triggering our action.
  equal(ctrl.get('propA'), 'Testing is cool');
  equal(ctrl.get('propB'), 'Testing Rocks!');
});
```

#### Live Example

#### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/sanaf/embed?output">Unit Testing 
Controllers "Actions"</a>

<a class="jsbin-embed" href="http://jsbin.com/sanaf/embed?output">控制器“操作”单元测试</a>

### Testing Controller Needs

### 测试控制器依赖

Sometimes controllers have dependencies on other controllers. This is 
accomplished by using [needs]. For example, here are two simple controllers. The
`PostController` is a dependency of the `CommentsController`:

有时候控制器需要依赖其他控制器。这通过[needs]来实现。例如，下面有两个简单的控制器。`PostController`是`CommentsController`的一个依赖：

```javascript
App.PostController = Ember.ObjectController.extend({
  // ...
});

App.CommentsController = Ember.ArrayController.extend({
  needs: 'post',
  title: Ember.computed.alias('controllers.post.title'),
});
```

This time when we setup our `moduleFor` we need to pass an options object as
our third argument that has the controller's `needs`.

在设置`moduleFor`之时，需要将一个选项对象作为第三个参数，该参数是控制器的`needs`。

```javascript
moduleFor('controller:comments', 'Comments Controller', {
  needs: ['controller:post']
});
```

Now let's write a test that sets a property on our `post` model in the 
`PostController` that would be available on the `CommentsController`.

下面来写一个，测试中设置`PostController`中得`post`模型的一个属性，这个属性在`CommentsController`同样有效。

```javascript
test('modify the post', function() {
  expect(2);

  // grab an instance of `CommentsController` and `PostController`
  var ctrl = this.subject(),
      postCtrl = ctrl.get('controllers.post');

  // wrap the test in the run loop because we are dealing with async functions
  Ember.run(function() {

    // set a generic model on the post controller
    postCtrl.set('model', Ember.Object.create({ title: 'foo' }));

    // check the values before we modify the post
    equal(ctrl.get('title'), 'foo');

    // modify the title of the post
    postCtrl.get('model').set('title', 'bar');

    // assert that the controllers title has changed
    equal(ctrl.get('title'), 'bar');

  });
});
```

#### Live Example

#### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/busoz/embed?output">Unit Testing Controllers "Needs"</a>

<a class="jsbin-embed" href="http://jsbin.com/busoz/embed?output">控制器依赖单元测试</a>

<script src="http://static.jsbin.com/js/embed.js"></script>

[单元测试基础]: /guides/testing/unit-testing-basics
[needs]: /guides/controllers/dependencies-between-controllers
