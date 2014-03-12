Ember's internals and most of the code you will write in your applications takes place in a run loop. The run loop is used to batch, and order (or reorder) work in a way that is most effective and efficient.

Ember内部及大部分为应用编写的代码都在一个运行循环中执行。运行循环用来做批量处理，并将任务以一种最高效的方式来执行。

It does so by scheduling work on specific queues. These queues have a priority,
and are processed to completion in priority order.

运行循环通过将工作分配到特定的队列来完成任务。队列具有优先级，并严格按照优先级来执行。

## Why is this useful?

## 为什么这样有用？

Very often, batching similar work has benefits. Web browsers do something quite similar
by batching changes to the DOM.

通常批处理相似的工作都能得到好处。Web浏览器也实现了相似的批处理来完成对DOM的修改。

Consider the following HTML snippet:

考虑如下的HTML片段：

```html
<div id="foo"></div>
<div id="bar"></div>
<div id="baz"></div>
```

and executing the following code:

并执行如下代码：

```js
foo.style.height = "500px" // write
foo.offsetHeight // read (recalculate style, layout, expensive!)

bar.style.height = "400px" // write
bar.offsetHeight // read (recalculate style, layout, expensive!)

baz.style.height = "200px" // write
baz.offsetHeight // read (recalculate style, layout, expensive!)
```

In this example, the sequence of code forced the browser to recalculate style,
and relayout after each step. However, if we were able to batch similar jobs together,
the browser would have only needed to recalulate the style and layout once.

在本例中，一系列代码要求浏览器重新计算样式，并在每步之后重新进行布局。然而，如果能够将相似的工作放在一起，那么浏览器就有可能只需要执行一次重新计算样式和重新布局。

```js
foo.style.height = "500px" // write
bar.style.height = "400px" // write
baz.style.height = "200px" // write

foo.offsetHeight // read (recalculate style, layout, expensive!)
bar.offsetHeight // read (fast since style and layout is already known)
baz.offsetHeight // read (fast since style and layout is already known)
```

Interestingly, this pattern holds true for many other types of work. Essentially,
batching similar work allows for better pipelining, and further optimization.

有趣的是，这种模式对于其他类型的工作也适用。本来将相似的工作进行批量处理就能得到较好的流水作业，也有利于进行深入的优化。

Let's look at a similar example that is optimized in Ember, starting with a `User` object:

下面从一个`User`对象开始，来看Ember优化的一个类似的例子：

```js
var User = Ember.Object.extend({
  firstName: null,
  lastName: null,
  fullName: function() {
    return this.get('firstName') + ' ' + this.get('lastName');
  }.property('firstName', 'lastName')
});
```

and a template to display its attributes:

下面的模板用来显示其属性：

```handlebars
{{firstName}}
{{fullName}}
```

If we execute the following code without the run loop:

如果不在运行循环中执行下列代码：

```js
var user = User.create({firstName:'Tom', lastName:'Huda'});
user.set('firstName', 'Yehuda');
// {{firstName}} and {{fullName}} are updated

user.set('lastName', 'Katz');
// {{lastName}} and {{fullName}} are updated
```

We see that the browser will rerender the template twice.

浏览器将会渲染模板两次。

```js
var user = User.create({firstName:'Tom', lastName:'Huda'});
user.set('firstName', 'Yehuda');
user.set('lastName', 'Katz');

// {{firstName}}  {{lastName}} and {{fullName}} are updated
```

However, if we have the run loop in the above code, the browser will only rerender the template once the attributes have all been set.

然后，如果上述代码在运行循环中执行，浏览器将会在所有属性都被设置好后，只重新渲染一次模板。

```js
var user = User.create({firstName:'Tom', lastName:'Huda'});
user.set('firstName', 'Yehuda');
user.set('lastName', 'Katz');
user.set('firstName', 'Tom');
user.set('lastName', 'Huda');
```

In the above example with the run loop, since the user's attributes end up at the same values as before execution, the template will not even rerender!

如上例所示，由于用户属性值最后并没有发生改变，当这段代码在运行循环中执行时，模板并不会被重新渲染！

It is of course possible to optimize these scenarios on a case-by-case basis,
but getting them for free is much nicer. Using the run loop, we can apply these
classes of optimizations not only for each scenario, but holistically app-wide.

当然这些场景也可以一个个问题来进行优化，然而能保持开放性相对来说更好。使用运行循环，可以为此类优化问题实现应用范围内的全局优化，而不单单是一个个场景。

## How does the Run Loop work in Ember?

## Ember中运行循环是如何工作的？

As mentioned earlier, we schedule work (in the form of function invocations) on
queues, and these queues are processed to completion in priority order.

如之前所述，任务（函数调用）被分配到队列中，而队列会按照优先级来进行处理直到全部完成。

What are the queues, and what is their priority order?

那么都有些什么队列，它们的优先级又是怎么样排序的呢？

```js
Ember.run.queues
// => ["sync", "actions", "routerTransitions", "render", "afterRender", "destroy"]
```

Because the priority is first to last, the "sync" queue has higher priority than the "render" or "destroy" queue.

由于优先级是从前至后的，因此"sync"队列的优先级比"render"或者"destroy"队列的要高。

## What happens in these queues?

## 这些队列里面都发生了些什么？

* The `sync` queue contains binding synchronization jobs

* `sync`队列包含绑定同步的任务

* The `actions` queue is the general work queue and will typically contain scheduled tasks e.g. promises

* `actions`队列是最普通的工作队列，通常包含待执行的计划任务。例如：承诺

* The `routerTransitions` queue contains transition jobs in the router

* `routerTransitions`队列包含路由的转换任务

* The `render` queue contains jobs meant for rendering, these will typically update the DOM

* `render`队列包含将要进行渲染的任务，通常都是对DOM的更新操作

* The `afterRender` contains jobs meant to be run after all previously scheduled render tasks are complete. This is often good for 3rd-party DOM manipulation libraries, that should only be run after an entire tree of DOM has been updated

* `afterRender`包含之前计划进行渲染的任务完成后需要执行的任务。对于第三方修改DOM的库来说非常有用，因为这意味着任务会在DOM全部被更新后才执行

* The `destroy` queue contains jobs to finish the teardown of objects other jobs have scheduled to destroy

* `destroy`队列包含完成其他任务计划销毁额对象的清理任务

## In what order are jobs executed on the queues?

## 队列中的任务以什么顺序执行？

The algorithm works this way:

算法按照下面的方式工作：

1. Let the highest priority queue with pending jobs be: `CURRENT_QUEUE`, if there are no queues with pending jobs the run loop is complete
2. Let a new temporary queue be defined as `WORK_QUEUE`
3. Move jobs from `CURRENT_QUEUE` into `WORK_QUEUE`
4. Process all the jobs sequentially in `WORK_QUEUE`
5. Return to Step 1

1. 将包含等待任务的具有最高优先级的队列设置为`CURRENT_QUEUE`，如果没有任何队列中包含等待执行的任务，运行循环完成
2. 将一个新的临时队列定义为`WORK_QUEUE`
3. 将`CURRENT_QUEUE`中的任务移动到`WORK_QUEUE`中
4. 按顺序处理`WORK_QUEUE`中的所有任务
5. 返回第一步开始执行

## An example of the internals

## 内部示例

Rather than writing the higher level app code that internally invokes the various
run loop scheduling functions, we have stripped away the covers, and shown the raw run-loop interactions.

与编写高层的应用代码不同，Ember内部会调用各种运行循环来计划函数的执行，这里拨开所有的面纱，直接展示原始的运行循环交互。

Working with this API directly is not common in most Ember apps, but understanding this example will
help you to understand the run-loops algorithm, which will make you a better Ember developer.

大部分Ember应用并不需要直接操作这些API，但是理解本示例将能更好的理解运行循环算法，有助于成为更为优秀的Ember开发者。

<iframe src="http://emberjs.com.s3.amazonaws.com/run-loop-guide/index.html" width="678" height="410" style="border:1px solid rgb(170, 170, 170);margin-bottom:1.5em;"></iframe>

## FAQs

## 常见问题

#### What do I need to know to get started with Ember?

#### 对于Ember入门需要了解哪些内容？

For basic Ember app development scenarios, nothing. All common paths are paved nicely
for you and don't require working with the run loop directly.

对于基础的Ember应用开发场景，不需要了解任何关于运行循环的内容。所有道路已经铺设完毕，可以完全不需要与运行循环打交道。

#### What do I need to know to actually build an app?

#### 对于编写一个实际的应用需要了解哪些内容？

It is possible to build good apps without working with the run loop directly, so if
you don't feel the need to do so, don't.

不直接使用运行循环并不影响构建一个好的应用，因此能不用就不要用。

#### What scenarios will require me to understand the run loop?

#### 哪些场景需要理解运行循环？

The most common case you will run into is integrating with a non-Ember API
that includes some sort of asynchronous callback. For example:

最常见的问题是集成一个非Ember接口的异步回调。例如：

- AJAX callbacks
- DOM update and event callbacks
- Websocket callbacks
- `setTimeout` and `setInterval` callbacks
- `postMessage` and `messageChannel` event handlers

- AJAX回调
- DOM更新和事件回调
- Websocket回调
- `setTimeout`和`setInterval`回调
- `postMessage`和`messageChannel`事件处理器

You should begin a run loop when the callback fires.

在回调被出发时，应该开始一个运行循环。

#### How do I tell Ember to start a run loop? 

#### 如何通知Ember开始一个运行循环？

```js
$('a').click(function(){
  Ember.run(function(){  // begin loop
    // Code that results in jobs being scheduled goes here
  }); // end loop, jobs are flushed and executed
});
```

#### What happens if I forget to start a run loop in an async handler?

#### 如果忘记在一个异步处理器中启动一个运行循环会发生什么？

As mentioned above, you should wrap any non-Ember async callbacks in `Ember.run`.
If you don't, Ember will try to approximate a beginning and end for you. Here
is some pseudocode to describe what happens:

如上所述，任何非Ember的异步回调应该放到`Ember.run`中。如果没有，Ember会尝试自动添加一个。下面是一个大概会发生的情况的示例代码：

```js
$('a').click(function(){
  // Ember or runloop related code.
  Ember.run.start();
  
  // 1. we detect you need a run-loop
  // 2. we start one for you, but we don't really know when it ends, so we guess
  
  nextTick(function() { 
    Ember.run.end()
  }, 0);
});
```

This is suboptimal because the current JS frame is allowed to end before the run loop is
flushed, which sometimes means the browser will take the opportunity to do other things,
like garbage collection. GC running in between data changing and DOM rerendering can cause visual lag and should be minimized.

这样做并没有达到最佳效果，因为当前的JS依然允许在运行循环清空前结束，这样就意味着有时候浏览器会有机会去做一些其他的事情，例如垃圾回收。垃圾回收如果在数据变更和DOM重新渲染的过程中执行，会导致明显的延迟，应该竟可能避免。

#### When I am in testing mode, why are run-loop autoruns disabled?

#### 在测试模式下，为什么运行循环自动运行是被关闭的？

Some of Ember's test helpers are promises that wait for the run loop to empty before resolving. This leads to resolving too early if there is code that is outside the run loop and gives erroneous test failures. Disabling autoruns help you identify these scenarios and helps both your testing and your application!

一些Ember测试助手都是承诺，需要等待运行循环为空才能履行。如果有代码不在运行循环内，会导致其过早履行，并给出错误的测试失败。关闭自动运行可以帮助找到这些场景，能为测试和应用都带来帮助。
