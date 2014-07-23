Testing with asynchronous calls and promises in Ember may seem tricky at first, but with a little explanation things should become clearer.

在Ember中测试异步调用和承诺，一开始可能觉得有点复杂，不过通过一些说明便能清晰起来。

### Promises, Ember and the Run Loop

### 承诺，Ember和运行循环

In order to fully explain testing promises & asynchronous code, it's important that you have a clear grasp of the Ember run loop. If you haven't yet done so, please read about them in the [Promises](/api/classes/Ember.RSVP.Promise.html) and [Understanding Ember run loop guide](/guides/understanding-ember/run-loop/).

为了能完整的解释测试承诺和异步代码，对Ember的运行循环有一个清晰的了解非常重要。如果还不了解，请看看[承诺](http://emberjs.com/api/classes/Ember.RSVP.Promise.html)和[理解Ember运行循环指南](/guides/understanding-ember/run-loop/)。

Now that you grasp the general concepts regarding the run loop, recall from reading about the basics of testing Ember applications that the run loop is suspended when in testing mode.  This helps ensure the procedure of your code and the tests you write around that code. Note that in testing promises and asynchronous code, you're effectively "stepping through" your application in chunks.

现在对运行循环有了基本的理解，回想之前阅读的测试Ember应用的基础知识，发现在测试模式下，运行循环是被暂停的。这有助于保证代码的步骤和围绕代码编写的测试。注意在测试承诺和异步代码中，是一块块有效的“逐句通过”应用的。

When a promise runs, it schedules fulfillment/rejection to be executed by the run loop, therefore in order for promises to work the run loop must be on. In short: no run loop, no promise fulfillment/rejection.

当一个承诺运行时，其计划了履行和违背承诺让运行循环执行，因此为了使承诺工作，运行循环必须启用。简而言之，没有运行循环就没有承诺的履行和违背。

Getting the results of a promise requires you to use the `then` method. Calling the `then` function on an existing promise:

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

In the case that `promise1` succeeds, then the `fulfillmentCallback` function will be called and passed the successful results of `promise1` as its argument. If the promise rejects (ie failure), then the `rejectionCallback` will be called with the failure reason as its argument.

在本例中，`promise1`成功时，那么`fulfillmentCallback`函数会被调用，并将`promise1`的成功结果作为其参数。如果承诺被否决了（例如失败了），那么`rejectionCallback`将被调用，失败的原因将作为其参数。

If you pass in a function to `then` it casts the function into a promise and returns the promise.  The results of that promise will be what's returned from the function.

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

If you pass a promise into `then` it will return the results of that promise.

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

***None of this will work if the run loop isn't running due to these callbacks and/or chained promises getting scheduled on the run loop.  ***

*** 如果运行循环没有运行，这些都不会工作。因为这些回调或者链式承诺都被计划在运行循环中执行。 ***

###Where the run loop and Promises intersect

### 运行循环和承诺的交点在哪

####Promise Resolution

#### 承诺处理

    var promise = new Ember.RSVP.Promise(function(resolve){
      // calling resolve will schedule an action to fulfill the promise 
      // and call observers/chained promises.
      resolve('hello world'); // Run loop needs to be on here
    });

####Chaining/Observing Promises

#### 链接/观察承诺

    // once the above promise has been resolved it will then notify 
    // the observers/chained promises to.
    promise.then(function(result){  // Run loop might* need to be on here
      alert(result);
    });

* Calling `then` (observing/chaining) only needs to be implicitely wrapped in a run call statement (eg `Ember.run(...)`) if there is a possibility you will chain/observe the promise after it's been fulfilled.  See the examples below which will help explain the different scenarios.

* 调用`then`（观察/链接）只需要将其隐性的包裹在一个运行调用语句中（例如`Ember.run(..)`），这样有可能能够在承诺履行后对其进行链接/观察。下面的示例解释了不同的场景。

#####Walk through example of observing/chaining before the promise has fulfilled

##### 承诺履行之前观察/链接示例

1. Run loop is off (testing mode)
2. Code: Create Promise1 (new Ember.RSVP.Promise....)
3. Code: Observe Promise1 (promise.then(....))
4. Code: Begin run loop (this will only finish once the run loop has cleared out all of the scheduled items)
5. Code: Resolve Promise1 (this will scheduled a task in the run loop to fulfill the promise)
6. Run loop: run "fulfill the promise" task (which includes notifying all chained promises/observers of fulfillment)
7. Run loop is off since there are no more tasks

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

 
#####Walk through example of observing/chaining after the promise has fulfilled

##### 承诺履行之后观察/链接示例

1. Run loop is off (testing mode)
2. Code: Create Promise1
4. Code: Begin run loop (this will finish once all scheduled tasks have been executed)
5. Code: Resolve Promise1 (this will add a scheduled task to fulfill the promise)
6. Run loop: run "fulfill the promise" task (which includes notifying all chained promises/observers of fulfillment)
7. Run loop is off since there are no more tasks
8. Code: Observe Promise1 (since the promise has already fulfilled, schedule an async task to notify this observer of fulfillment)
9. Uncaught Error: Assertion Failed: You have turned on testing mode, which disabled the run-loop's autorun. You will need to wrap any code with asynchronous side-effects in an Ember.run

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

###Testing promises and the run loop

### 测试承诺和运行循环

When you are using Ember normally (ie when not in testing mode), the run loop is actively running, so you don't need to worry about wrapping these events in calls to Ember.run(). In testing mode, the run loop is passive and must be triggered manually.  Testing asynchronous code not wrapped in calls to Ember.run will result in the error: `Uncaught Error: Assertion Failed: You have turned on testing mode, which disabled the run-loop's autorun. You will need to wrap any code with asynchronous side-effects in an Ember.run`.

当在通常情况下使用Ember时（例如不在测试模式），运行循环是处于活跃的执行状态的，也就是说不需要将异步代码包裹在`Ember.run()`中。在测试模式，运行循环是被动的，必须手动触发。测试没有包裹在`Ember.run`中的异步代码会导致出错：`Uncaught Error: Assertion Failed: You have turned on testing mode, which disabled the run-loop's autorun. You will need to wrap any code with asynchronous side-effects in an Ember.run`.

####General Example

#### 一般性示例

Here we are setting up a promise, and intentionally using `setTimeout` to mimic a delayed response from a fake server.  Once our fake server has responded we need to invoke the run loop manually, by wrapping the statement in a run call.

这里创建了一个承诺，并且使用`setTimeout`来模拟从一个假的服务器延时返回一个响应。当这个假服务器返回时，需要将代码包裹在`Ember.run`中，手动调用运行循环。

    var promise = new Ember.RSVP.Promise(function(resolve){
      setTimeout(function(){
        Ember.run(this, resolve, 'hello world');
      }, 20);
    });

If you were to pass the above promise around to multiple methods, and they choose to observe/chain to the promise, it is likely that at some point the promise may already be resolved.  In that case you will need to wrap the observer/chained promise in a run call.

如果将上面的承诺传递给多个方法，并且这些方法观察/链接这个承诺，在某一时刻这个承诺可能已经履行了。这种情况下，需要将观察器和链接的承诺包裹在一个运行调用中。

    Ember.run(function(){
      promise.then(function(result){
        alert(result);
      });
    });

####Synchronous Example using promises

#### 使用承诺的同步示例

If you're using a promise, but it resolves immediately then you can simply follow the pattern above of wrapping the resolve and observer/chained promises in a run call without harm.  In this example we wrap the resolve and the observer (due to the promise resolving immediately) in a run call.

如果使用承诺，但是其立即都履行了，那么可以简单的遵从上面的方法，将履行和观察器/链接的承诺包裹到一个运行调用中。本例中包裹了履行和观察器到一个运行调用中（因为承诺立即就被履行了）。

<script src="http://static.jsbin.com/js/embed.js"></script>
<a class="jsbin-embed" href="http://jsbin.com/qoyinucu/45/embed?js,output">Simple promise example</a>

<script src="http://static.jsbin.com/js/embed.js"></script>
<a class="jsbin-embed" href="http://jsbin.com/qoyinucu/45/embed?js,output">简单的承诺示例</a>

####Asynchronous Example using promises

#### 使用承诺的异步示例

If you're using a promise, but there's a chance it might resolves after the test would finish you'll need to use the `stop` and `start` global qunit methods.  These methods will give you the ability to tell qunit to stop the test run on the current test (makes qunit wait) and start again when ready.  In this example we delay execution and wrap the resolve in a run call.  Since the chained promise begins observing before the promise has been resolved you won't need to wrap  the chained promise in a run call.

如果使用承诺，如果承诺在测试完成的时候才履行，那么就需要使用`qunit`的全局方法`stop`和`start`。这些方法可以告诉`qunit`在当前测试中停止测试（让`qunit`等待）或者在准备好时重新启动测试。本例中将执行延时，并将履行包裹在一个运行调用中。因为链接的承诺在承诺履行之前开始观察，所以不需要将链接的承诺包裹在一个运行循环中。

<a class="jsbin-embed" href="http://jsbin.com/qoyinucu/46/embed?js,output">Async promise example</a>

<a class="jsbin-embed" href="http://jsbin.com/qoyinucu/46/embed?js,output">异步承诺示例</a>

## AJAX

## AJAX

AJAX requests are the most prevelant use case where you will be creating promises.  While testing it's likely you will want to mock your AJAX requests to the server.  Below we've included examples for [ic-ajax](https://github.com/instructure/ic-ajax). Feel free to use other mocking libraries such as [Mockjax](https://github.com/appendto/jquery-mockjax), but it's important to note, that Mockjax and other libraries are unaware of the run loop and won't wrap their resolve in a run call.  This may resolve in promises being run outside the realm of the run loop and will result in errors.

AJAX请求是最典型的会创建承诺的用例。在测试的时候，可能希望模拟发送到服务器端的AJAX请求。下面给出一些[ic-ajax](https://github.com/instructure/ic-ajax)的示例，不过有一点非常重要，就是Mockajax和其他的一些库并不知道运行循环，并不会将履行包裹在一个运行调用中。这可能导致承诺的履行不在一个运行循环中，从而发生错误。

###ic-ajax

[ic-ajax] is an Ember-friendly `jQuery-ajax` wrapper, which is very convenient for building up fixture data and mocking ajax calls for unit/integration testing. The most common use case for promises is when you're making an asynchronous call to a server, and ic-ajax can help alleviate having to worry about wrapping `resolve` in a run call.

[ic-ajax]是一个`Ember`友好的`jQuery-ajax`封装，可以非常方便的用来构造夹具数据和在单元测试和集成测试中模拟ajax请求。最常见的承诺用例就是发送一个异步请求给一个服务器，ic-ajax可以不需要担心是否将`resolve`包裹在一个运行调用中。

####Simple ic-ajax example:

#### ic-ajax简单示例

Imagine you wanted to request a list of colors from a server.  Using ic-ajax you would use the following syntax

假设希望从服务器请求一个颜色列表。使用ic-ajax将采用如下的语法：

    var promise = ic.ajax.request('/colors');

This is an asynchronous call which returns a promise. When the promise has resolved, it will contain the list of colors. The convenient thing about ic-ajax is that it wraps the resolve of your ajax call in a call to Ember.run so you don't need to worry about it. We're going to set up some fixture data that can be returned instead of making an ajax call to fake the server so we can test our code

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

####Simple ic-ajax example with Ember Data:

#### 使用Ember Data的ic-ajax简单示例

Ember Data can be dealt with just as easily, you will just need to define the fixtures in the same format that Ember Data is expecting it.

只需要将数据格式定义为Ember Data期望的格式，即可完成Ember Data的处理。

<a class="jsbin-embed" href="http://emberjs.jsbin.com/OxIDiVU/361/embed?js,output">Using ic-ajax</a>

####Integration test using ic-ajax and Ember Data

#### 使用ic-ajax和Ember Data的集成测试

Often while doing integration tests, you don't actually want to hit the server because its state won't be consistent. Using the previously established patterns you can set up fixture data which will be returned in place of real ajax call responses so you can isolate your code as being the only thing under test. Below we'e provided you with a simple example test using ic-ajax and Ember Data.

在进行集成测试时，通常不希望向服务器发送真实的请求，因为这样应用的状态会出现不一致的情况。采用之前的模式，可以这是真实的ajax调用响应返回的数据，以此来独立测试代码。下面给出了一个简单的使用ic-ajax和Ember Data的测试示例。

<a class="jsbin-embed" href="http://emberjs.jsbin.com/OxIDiVU/365/embed?js,output">Using ic-ajax</a>

###jquery-mockjax

### jquery-mockjax

[jquery-mockjax](https://github.com/appendto/jquery-mockjax) is a `jQuery` plugin that provides the ability to simulate ajax requests.

[jquery-mockjax](https://github.com/appendto/jquery-mockjax)是一个`jQuery`插件，用来模拟ajax请求。

####Simple jquery-mockjax example:

#### jquery-mockjax简单示例

Imagine you wanted to request a list of colors from a server.  Using vanilla `jQuery` you would use the following syntax

假设希望从服务器请求一个颜色列表。使用`jQuery`的方法如下所示：

    $.getJSON('/colors', function(response){ /* ... */ });

This is an asynchronous call which will pass the server's response to the callback provided. Unlike `ic-ajax`, with vanilla `jQuery` you need to wrap the callback syntax in a promise.

这个异步调用会将服务器的响应作为参数传给回调函数。与`ic-ajax`不同，这里需要将回调包裹到一个承诺中。

    var promise = new Ember.RSVP.Promise(function(resolve){
      $.getJSON('/colors', function(data){
        resolve(data.response);
      });
    });

We're going to set up some fixture data that can be returned instead of making an ajax call to fake the server so we can test our code

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

As you can see, there is a lot of flexibility in the `jquery-mockjax` api. You can specify not only the url and the response but the method, status code and data type. For the full jquery-mockax api check [their docs](https://github.com/appendto/jquery-mockjax).

由此可见，使用`jquery-mockjax` api可以非常的灵活。不仅可以设定url和响应，还可以设定方法、状态代码和数据类型。jquery-mockjax的完整api请查看[文档](https://github.com/appendto/jquery-mockjax)。

<a class="jsbin-embed" href="http://emberjs.jsbin.com/wotib/1/embed?js,output">Using jquery-mockjax</a>

####Simple jquery-mockjax example with Ember Data:

#### Ember Data的jquery-mockjax简单示例

Ember Data can be dealt with just as easily. You will just need to define the fixtures in the format that Ember Data is expecting.

只需要将数据格式定义为Ember Data期望的格式，即可完成Ember Data的处理。

<a class="jsbin-embed" href="http://emberjs.jsbin.com/vojas/5/embed?js,output">Using jquery-mockjax</a>

####Integration test using jquery-mockjax and Ember Data

#### 使用jquery-mockjax和Ember Data的集成测试

Often while writing integration tests, you don't actually want to hit the server because its state won't be consistent. Using the previously established patterns you can set up fixture data which will be returned in place of real ajax call responses so you can isolate your code as being the only thing under test. Below we've provided you with a simple example test using jquery-mockjax and Ember Data.

在进行集成测试时，通常不希望向服务器发送真实的请求，因为这样应用的状态会出现不一致的情况。采用之前的模式，可以这是真实的ajax调用响应返回的数据，以此来独立测试代码。下面给出了一个简单的使用jquery-mockjax和Ember Data的测试示例。

<a class="jsbin-embed" href="http://emberjs.jsbin.com/hoxub/5/embed?js,output">Using jquery-mockjax</a>
