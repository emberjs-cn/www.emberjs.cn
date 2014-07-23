英文原文：[http://emberjs.com/guides/testing/testing-components/](http://emberjs.com/guides/testing/testing-components/)

_单元测试方案和计算属性与之前[单元测试基础]中说明的相同，因为`Ember.Component`集成自`Ember.Object`。_

#### 设置

在测试组件之前，需要确定测试应用的`div`已经加到测试的html文件中：

```html
<!-- as of time writing, ID attribute needs to be named exactly ember-testing -->
<div id="ember-testing"></div>
```

此外还需要通知`Ember`使用这个元素来重新渲染应用。

```javascript
App.rootElement = '#ember-testing'
```

组件可以使用`moduleForComponent`助手来进行测试。下面是一个简单的`Ember`控件：

```javascript
App.PrettyColorComponent = Ember.Component.extend({
  classNames: ['pretty-color'],
  attributeBindings: ['style'],
  style: function() {
    return 'color: ' + this.get('name') + ';';
  }.property('name')
});
```

其对应的`Handlebars`模板：

```handlebars
Pretty Color: {{name}}
```

对这个控件进行单元测试可以使用`moduleForComponent`助手。助手将通过名称来查找这个组件（pretty-color）和其模板（如果存在）。

```javascript
moduleForComponent('pretty-color');
```

现在每个测试有了一个`subject()`函数，该函数是组件工厂的`create`方法的一个别名。

下面是测试改变组件的颜色后，看看HTML是否重新渲染了。

```javascript
test('changing colors', function(){

  // this.subject() is available because we used moduleForComponent
  var component = this.subject();

  // we wrap this with Ember.run because it is an async function
  Ember.run(function(){
    component.set('name','red');
  });

  // first call to $() renders the component.
  equal(this.$().attr('style'), 'color: red;');

  // another async function, so we need to wrap it with Ember.run
  Ember.run(function(){
    component.set('name', 'green');
  });

  equal(this.$().attr('style'), 'color: green;');
});
```

另外一个可能的测试是检查组件的模板是否被正确地渲染了。

```javascript
test('template is rendered with the color name', function(){
  
  // this.subject() is available because we used moduleForComponent
  var component = this.subject();

  // first call to $() renders the component.
  equal($.trim(this.$().text()), 'Pretty Color:');

  // we wrap this with Ember.run because it is an async function
  Ember.run(function(){
    component.set('name', 'green');
  });

  equal($.trim(this.$().text()), 'Pretty Color: green');
});
```

#### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/hihef/embed?output">组件单元测试</a>

### 与DOM中的组件交互

Ember组件可以方便的用来创建有力的、交互的、自包含的自定义HTML元素。正因为此，不仅测试组件自身的方法很重要，测试用户与组件的交互也一样的重要。

下面看一个非常简单的组件，该组件只是在被点击时设置自己的标题：

```javascript
App.MyFooComponent = Em.Component.extend({
  title:'Hello World',
  
  actions:{
    updateTitle: function(){
      this.set('title', 'Hello Ember World');
    }
  }
});
```

下面将使用[集成测试助手]来与渲染的组件进行交互。

```javascript
moduleForComponent('my-foo', 'MyFooComponent');

test('clicking link updates the title', function() {
  var component = this.subject();
  
  // append the component to the DOM
  this.append();
  
  // assert default state
  equal(find('h2').text(), 'Hello World');
  
  // perform click action
  click('button');
  
  andThen(function() { // wait for async helpers to complete
    equal(find('h2').text(), 'Hello Ember World');
  });
});
```

#### 在线示例

<a class="jsbin-embed"
href="http://jsbin.com/liqog/embed?output">组件单元测试</a>

### 具有内置布局的组件

一些组件并不适用一个分离的模板。模板可以通过[布局]属性嵌入在组件代码中。例如：

```javascript
App.MyFooComponent = Ember.Component.extend({

  // layout supercedes template when rendered
  layout: Ember.Handlebars.compile(
    "<h2>I'm a little {{noun}}</h2><br/>" +
    "<button {{action 'clickFoo'}}>Click Me</button>"
  ),

  noun: 'teapot',

  actions:{
    changeName: function(){
      this.set('noun', 'embereño');
    }
  }
});
```

在本例中，也将对于组件的交互进行测试。

```javascript
moduleForComponent('my-foo', 'MyFooComponent');

test('clicking link updates the title', function() {
  var component = this.subject();
  
  // append the component to the DOM
  this.append();
  
  // assert default state
  equal(find('h2').text(), "I'm a little teapot");
  
  // perform click action
  click('button');
  
  andThen(function() { // wait for async helpers to complete
    equal(find('h2').text(), "I'm a little embereño");
  });
});
```

#### 在线示例

<a class="jsbin-embed"
href="http://jsbin.com/mazef/embed?output">测试带内置布局的组件</a>

### 程序化组件交互

另外一种测试组件的方法是通过直接调用组件函数来取代与DOM进行交互。这里采用与之前相同的例子作为测试的对象，不同的是通过编码直接进行测试：

```javascript
moduleForComponent('my-foo', 'MyFooComponent');

test('clicking link updates the title', function() {
  var component = this.subject();
  
  // append the component to the DOM, returns DOM instance
  var $component = this.append();
  
  // assert default state
  equal($component.find('h2').text(), "I'm a little teapot");
  
  // send action programmatically
  Em.run(function(){
    component.send('changeName');
  });
  
  equal($component.find('h2').text(), "I'm a little embereño");
});
```

#### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/davuf/embed?output">程序化组件测试</a>

### 组件中`sendAction`验证

组件经常使用`sendAction`，这是与Ember应用交互的一种方式。下面是一个简单的组件，当一个按钮被点击时，发送`internalAction`操作：

```javascript
App.MyFooComponent = Ember.Component.extend({
  layout:Ember.Handlebars.compile("<button {{action 'doSomething'}}></button>"),

  actions:{
    doSomething: function(){
      this.sendAction('internalAction');
    }
  }
});
```

在测试中，将创建一个僵尸对象，用来接收组件发送的操作。

```javascript
moduleForComponent('my-foo', 'MyFooComponent');

test('trigger external action when button is clicked', function() {
  // tell our test to expect 1 assertion
  expect(1);
  
  // component instance
  var component = this.subject();
  
  // component dom instance
  var $component = this.append();
  
  var targetObject = {
    externalAction: function(){
      // we have the assertion here which will be
      // called when the action is triggered
      ok(true, 'external Action was called!');
    }
  }; 
  
  // setup a fake external action to be called when 
  // button is clicked
  component.set('internalAction', 'externalAction');
  
  // set the targetObject to our dummy object (this
  // is where sendAction will send it's action to)
  component.set('targetObject', targetObject);
  
  // click the button
  click('button');
});
```

#### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/siwil/embed?output">组件中`sendAction`验证</a>

### 使用其他组件的组件

有时候将组件拆分为父子组件更容易维护，下面是一个简单的例子：

```javascript
App.MyAlbumComponent = Ember.Component.extend({
  tagName: 'section',
  layout: Ember.Handlebars.compile(
      "<section>" +
      "  <h3>{{title}}</h3>" +
      "  {{yield}}" +
      "</section>"
  ),
  titleBinding: ['title']
});

App.MyKittenComponent = Ember.Component.extend({
  tagName: 'img',
  attributeBindings: ['width', 'height', 'src'],
  src: function() {
    return 'http://placekitten.com/' + this.get('width') + '/' + this.get('height');
  }.property('width', 'height')
});
```

使用这个组件可能如下面代码所示：

```handlebars
{{#my-album title="Cats"}}
  {{my-kitten width="200" height="300"}}
  {{my-kitten width="100" height="100"}}
  {{my-kitten width="50" height="50"}}
{{/my-album}}
```

通过`needs`回调来测试这些包含子组件的组件非常容易。

```javascript
moduleForComponent('my-album', 'MyAlbumComponent', {
  needs: ['component:my-kitten']
});

test('renders kittens', function() {
  expect(2);
  
  // component instance
  var component = this.subject({
    template: Ember.Handlebars.compile(
      '{{#my-album title="Cats"}}' +
      '  {{my-kitten width="200" height="300"}}' +
      '  {{my-kitten width="100" height="100"}}' +
      '  {{my-kitten width="50" height="50"}}' +
      '{{/my-album}}'
    )
  });
  
  // append component to the dom
  var $component = this.append();
  
  // perform assertions
  equal($component.find('h3:contains("Cats")').length, 1);
  equal($component.find('img').length, 3);
});
```

#### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/xebih/embed?output">带嵌套组件的组件</a>

<script src="http://static.jsbin.com/js/embed.js"></script>

[单元测试基础]: /guides/testing/unit-testing-basics
[集成测试助手]: /guides/testing/test-helpers
[布局]: http://emberjs.com/api/classes/Ember.Component.html#property_layout
