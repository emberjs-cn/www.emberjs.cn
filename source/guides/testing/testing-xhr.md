英文原文：[http://emberjs.com/guides/testing/testing-xhr/](http://emberjs.com/guides/testing/testing-xhr/)

在Ember中测试异步调用和承诺，一开始可能觉得有点复杂，不过通过一些说明便能清晰起来。

### 承诺，Ember和运行循环

为了能完整的解释测试承诺和异步代码，对Ember的运行循环有一个清晰的了解非常重要。如果还不了解，请看看[承诺](http://emberjs.com/api/classes/Ember.RSVP.Promise.html)和[理解Ember运行循环指南](/guides/understanding-ember/run-loop/)。

现在对运行循环有了基本的理解，回想之前阅读的测试Ember应用的基础知识，发现在测试模式下，运行循环是被暂停的。这有助于保证代码的步骤和围绕代码编写的测试。注意在测试承诺和异步代码中，是一块块有效的“逐句通过”应用的。

当一个承诺运行时，其计划了履行和违背承诺让运行循环执行，因此为了使承诺工作，运行循环必须启用。简而言之，没有运行循环就没有承诺的履行和违背。

要获取承诺的结果需要使用`then`方法。在一个已知的承诺上调用`then`函数。

``` javascript
// let's call the existing promise promise1, so you'd write:
promise1.then(fulfillmentCallback, rejectionCallback);

function fulfillmentCallback(successfulResults) {
  // do something wonderful with the results
}

function rejectionCallback(failureResults) {
  // tell someone important about the failure
}
```

在本例中，`promise1`成功时，那么`fulfillmentCallback`函数会被调用，并将`promise1`的成功结果作为其参数。如果承诺被否决了（例如失败了），那么`rejectionCallback`将被调用，失败的原因将作为其参数。

如果将一个函数传给`then`，则会将该函数转换为一个承诺，并返回这个承诺。这个承诺的结果将是这个函数的返回值。

``` javascript
// let's call the existing promise promise1 and will have the result `3`, so you'd write:
var promise2 = promise1.then(function(results){
  return results + 2;
});

// the results of this promise would be 10
var promise3a = promise2.then(function(results){
  return results + 5;
});

// the results of this promise would be 6
var promise3b = promise2.then(function(results){
 return results + 1;
});

// or we can chain without the intermediary variables like so,
var promise4 = promise1.then(function(results){
  return results + 2;
}).then(function(results){
  return results + 5;
}).then(function(results){
  return results + 90;
}).then(function(results){
  alert(results); // this will alert `100`
});
```

如果将一个承诺传递给`then`，其将返回这个承诺的结果。

``` javascript
// let's call the existing promises promise1 and promise2, so you'd write:
var promise3 = promise1.then(promise2);

promise3.then(function(result){
  // this will be the results from promise2
  // this callback won't be called until promise1 and promise2 have fulfilled
  alert(result);
});
```

*** 如果运行循环没有运行，这些都不会工作。因为这些回调或者链式承诺都被计划在运行循环中执行。 ***

### 运行循环和承诺的交点在哪

#### 承诺处理

    var promise = new Ember.RSVP.Promise(function(resolve){
      // calling resolve will schedule an action to fulfill the promise 
      // and call observers/chained promises.
      resolve('hello world'); // Run loop needs to be on here
    });

#### 链接/观察承诺

    // once the above promise has been resolved it will then notify 
    // the observers/chained promises to.
    promise.then(function(result){  // Run loop might* need to be on here
      alert(result);
    });

* 调用`then`（观察/链接）只需要将其隐性的包裹在一个运行调用语句中（例如`Ember.run(..)`），这样有可能能够在承诺履行后对其进行链接/观察。下面的示例解释了不同的场景。

##### 承诺履行之前观察/链接示例

1. 运行循环是关闭的（测试模式）
2. 代码：创建`Promise1`（new Ember.RSVP.Promise....）
3. 代码：观察`Promise1`（promise.then(...)）
4. 代码：启动运行循环（将在运行循环完成所有的计划项目后停止）
5. 代码：履行`Promise1`（将计划一个任务到运行循环来履行承诺）
6. 运行循环：运行“履行承诺”任务（包括将履行通知所有链接的承诺/观察器）
7. 运行循环停止，因为所有任务已经完成

``` javascript
new Ember.RSVP.Promise(function(resolve){
  // resolve will run ~10 ms after the then has been called and is observing
  Ember.run.later(this, resolve, 'hello', 10);
}).then(function(result){
  alert(result);
});
```

##### 承诺履行之后观察/链接示例

1. 运行循环是关闭的（测试模式）
2. 代码：创建`Promise1`
4. 代码：启动运行循环（将在运行循环完成所有的计划项目后停止）
5. 代码：履行`Promise1`（将计划一个任务到运行循环来履行承诺）
6. 运行循环：运行“履行承诺”任务（包括将履行通知所有链接的承诺/观察器）
7. 运行循环停止，因为所有任务已经完成
8. 代码：观察`Promise1`（因为承诺已经履行，计划一个异步任务来通知观察器）
9. 未捕获的错误：断言失败：开启了测试模式，这将禁止运行循环自动运行。需要将所有异步的代码包裹在`Ember.run()`中。

``` javascript
var promise = new Ember.RSVP.Promise(function(resolve){
  // this will run before the then has happened below
  // and finish the triggered run loop
  Ember.run(this, resolve, 'hello');
});

// incorrect the run loop isn't on any more
promise.then(function(result){
  alert(result);
});
  
// correct, start the run loop again
Ember.run(function(){
  promise.then(function(result){
    alert(result);
  });
});
```

### 测试承诺和运行循环

当在通常情况下使用Ember时（例如不在测试模式），运行循环是处于活跃的执行状态的，也就是说不需要将异步代码包裹在`Ember.run()`中。在测试模式，运行循环是被动的，必须手动触发。测试没有包裹在`Ember.run`中的异步代码会导致出错：`Uncaught Error: Assertion Failed: You have turned on testing mode, which disabled the run-loop's autorun. You will need to wrap any code with asynchronous side-effects in an Ember.run`.

#### 一般性示例

这里创建了一个承诺，并且使用`setTimeout`来模拟从一个假的服务器延时返回一个响应。当这个假服务器返回时，需要将代码包裹在`Ember.run`中，手动调用运行循环。

    var promise = new Ember.RSVP.Promise(function(resolve){
      setTimeout(function(){
        Ember.run(this, resolve, 'hello world');
      }, 20);
    });

如果将上面的承诺传递给多个方法，并且这些方法观察/链接这个承诺，在某一时刻这个承诺可能已经履行了。这种情况下，需要将观察器和链接的承诺包裹在一个运行调用中。

    Ember.run(function(){
      promise.then(function(result){
        alert(result);
      });
    });

#### 使用承诺的同步示例

如果使用承诺，但是其立即都履行了，那么可以简单的遵从上面的方法，将履行和观察器/链接的承诺包裹到一个运行调用中。本例中包裹了履行和观察器到一个运行调用中（因为承诺立即就被履行了）。

<script src="http://static.jsbin.com/js/embed.js"></script>
<a class="jsbin-embed" href="http://jsbin.com/qoyinucu/45/embed?js,output">简单的承诺示例</a>

#### 使用承诺的异步示例

如果使用承诺，如果承诺在测试完成的时候才履行，那么就需要使用`qunit`的全局方法`stop`和`start`。这些方法可以告诉`qunit`在当前测试中停止测试（让`qunit`等待）或者在准备好时重新启动测试。本例中将执行延时，并将履行包裹在一个运行调用中。因为链接的承诺在承诺履行之前开始观察，所以不需要将链接的承诺包裹在一个运行循环中。

<a class="jsbin-embed" href="http://jsbin.com/qoyinucu/46/embed?js,output">异步承诺示例</a>

## AJAX

AJAX请求是最典型的会创建承诺的用例。在测试的时候，可能希望模拟发送到服务器端的AJAX请求。下面给出一些[ic-ajax](https://github.com/instructure/ic-ajax)的示例，不过有一点非常重要，就是Mockajax和其他的一些库并不知道运行循环，并不会将履行包裹在一个运行调用中。这可能导致承诺的履行不在一个运行循环中，从而发生错误。

###ic-ajax

[ic-ajax]是一个`Ember`友好的`jQuery-ajax`封装，可以非常方便的用来构造夹具数据和在单元测试和集成测试中模拟ajax请求。最常见的承诺用例就是发送一个异步请求给一个服务器，ic-ajax可以不需要担心是否将`resolve`包裹在一个运行调用中。

#### ic-ajax简单示例

假设希望从服务器请求一个颜色列表。使用ic-ajax将采用如下的语法：

    var promise = ic.ajax.request('/colors');

这个异步调用将返回一个承诺。当承诺被履行时，其将包含颜色列表。ic-ajax的一个惯例是会将ajax调用的完成包裹到Ember.run中，这样就不需要担心这个异步行为。因此可以通过构造夹具数据来取代向一个模拟服务器发送请求来测试代码。

    ic.ajax.defineFixture('/colors', {
      response: [
        {
          id: 1,
          color: "red"
        },
        {
          id: 2,
          color: "green"
        },
        {
          id: 3,
          color: "blue"
        }
      ],
      jqXHR: {},
      textStatus: 'success'
    });


<a class="jsbin-embed" href="http://jsbin.com/OxIDiVU/366/embed?js,output">Using ic-ajax</a>

#### 使用Ember Data的ic-ajax简单示例

只需要将数据格式定义为Ember Data期望的格式，即可完成Ember Data的处理。

<a class="jsbin-embed" href="http://emberjs.jsbin.com/OxIDiVU/361/embed?js,output">Using ic-ajax</a>

#### 使用ic-ajax和Ember Data的集成测试

在进行集成测试时，通常不希望向服务器发送真实的请求，因为这样应用的状态会出现不一致的情况。采用之前的模式，可以这是真实的ajax调用响应返回的数据，以此来独立测试代码。下面给出了一个简单的使用ic-ajax和Ember Data的测试示例。

<a class="jsbin-embed" href="http://emberjs.jsbin.com/OxIDiVU/365/embed?js,output">Using ic-ajax</a>

### jquery-mockjax

[jquery-mockjax](https://github.com/appendto/jquery-mockjax)是一个`jQuery`插件，用来模拟ajax请求。

#### jquery-mockjax简单示例

假设希望从服务器请求一个颜色列表。使用`jQuery`的方法如下所示：

    $.getJSON('/colors', function(response){ /* ... */ });

这个异步调用会将服务器的响应作为参数传给回调函数。与`ic-ajax`不同，这里需要将回调包裹到一个承诺中。

    var promise = new Ember.RSVP.Promise(function(resolve){
      $.getJSON('/colors', function(data){
        resolve(data.response);
      });
    });

下面将设置一些夹具数据，以便可以取代向一个模拟服务器发送ajax请求来获取数据，从而进行代码测试。

    $.mockjax({
      type: 'GET',
      url: '/colors',
      status: '200',
      dataType: 'json',
      responseText: {
        response: [
          {
            id: 1,
            color: "red"
          },
          {
            id: 2,
            color: "green"
          },
          {
            id: 3,
            color: "blue"
          }
         ]
      }
    });

由此可见，使用`jquery-mockjax` api可以非常的灵活。不仅可以设定url和响应，还可以设定方法、状态代码和数据类型。jquery-mockjax的完整api请查看[文档](https://github.com/appendto/jquery-mockjax)。

<a class="jsbin-embed" href="http://emberjs.jsbin.com/wotib/1/embed?js,output">Using jquery-mockjax</a>

#### Ember Data的jquery-mockjax简单示例

只需要将数据格式定义为Ember Data期望的格式，即可完成Ember Data的处理。

<a class="jsbin-embed" href="http://emberjs.jsbin.com/vojas/5/embed?js,output">Using jquery-mockjax</a>

#### 使用jquery-mockjax和Ember Data的集成测试

在进行集成测试时，通常不希望向服务器发送真实的请求，因为这样应用的状态会出现不一致的情况。采用之前的模式，可以这是真实的ajax调用响应返回的数据，以此来独立测试代码。下面给出了一个简单的使用jquery-mockjax和Ember Data的测试示例。

<a class="jsbin-embed" href="http://emberjs.jsbin.com/hoxub/5/embed?js,output">Using jquery-mockjax</a>
