Almost every test has a pattern of visiting a route, interacting with the page
(using the helpers), and checking for expected changes in the DOM.

几乎所有的测试都有访问路由的一种固有模式，就是与页面进行交互（通过助手），然后检测期待的改变是否在DOM中发生。

Examples:

例如：

```javascript
test('root lists first page of posts', function(){
  visit('/posts');
  andThen(function() {
    equal(find('ul.posts li').length, 3, 'The first page should have 3 posts');
  });
});
```

The helpers that perform actions use a global promise object and automatically
chain onto that promise object if it exists. This allows you to write your tests
without worrying about async behaviour your helper might trigger.

这些助手使用一个全局的承诺来执行操作，如果这个承诺对象存在，会自动的链上这个对象。这也就不需要单向测试中助手可能触发的异步行为了。

```javascript
module('Integration: Transitions', {
  setup: function() {
    App.reset();
  }
});

test('add new post', function() {
  visit('/posts/new');
  fillIn('input.title', 'My new post');
  click('button.submit');

  andThen(function() {
    equal(find('ul.posts li:last').text(), 'My new post');
  });
});
```

#### Live Example

#### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/gokor/embed?output">Testing User 
Interaction</a>

<a class="jsbin-embed" href="http://jsbin.com/gokor/embed?output">测试用户交互</a>

### Testing Transitions

### 测试过渡

Suppose we have an application which requires authentication. When a visitor
visits a certain URL as an unauthenticated user, we expect them to be transitioned
to a login page.

假定有一个应用需要身份认证。当一位访问者最为未登录用户访问某一URL时，希望他被过渡到一个登录的页面。

```javascript
App.ProfileRoute = Ember.Route.extend({
  beforeModel: function() {
    var user = this.modelFor('application');
    if (Em.isEmpty(user)) {
      this.transitionTo('login');
    }
  }
});
```

We could use the route helpers to ensure that the user would be redirected to the login page
when the restricted URL is visited.

当受限的URL被访问时，可以通过路由助手确保用户被重定向到登录页面。

```javascript
module('Integration: Transitions', {
  setup: function() {
    App.reset();
  }
});

test('redirect to login if not authenticated', function() {
  visit('/');
  click('.profile');

  andThen(function() {
    equal(currentRouteName(), 'login');
    equal(currentPath(), 'login');
    equal(currentURL(), '/login');
  });
});
```

#### Live Example

#### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/nulif/embed?output">Testing Transitions</a>

<a class="jsbin-embed" href="http://jsbin.com/nulif/embed?output">测试过渡</a>

<script src="http://static.jsbin.com/js/embed.js"></script>
