英文原文：[http://emberjs.com/guides/understanding-ember/run-loop/](http://emberjs.com/guides/understanding-ember/run-loop/)

Ember内部及大部分为应用编写的代码都在一个运行循环中执行。运行循环用来做批量处理，并将任务以一种最高效的方式来执行。

运行循环通过将工作分配到特定的队列来完成任务。队列具有优先级，并严格按照优先级来执行。

## 为什么这样有用？

通常批处理相似的工作都能得到好处。Web浏览器也实现了相似的批处理来完成对DOM的修改。

考虑如下的HTML片段：

```html
<div id="foo"></div>
<div id="bar"></div>
<div id="baz"></div>
```

并执行如下代码：

```js
foo.style.height = "500px" // write
foo.offsetHeight // read (recalculate style, layout, expensive!)

bar.style.height = "400px" // write
bar.offsetHeight // read (recalculate style, layout, expensive!)

baz.style.height = "200px" // write
baz.offsetHeight // read (recalculate style, layout, expensive!)
```

在本例中，一系列代码要求浏览器重新计算样式，并在每步之后重新进行布局。然而，如果能够将相似的工作放在一起，那么浏览器就有可能只需要执行一次重新计算样式和重新布局。

```js
foo.style.height = "500px" // write
bar.style.height = "400px" // write
baz.style.height = "200px" // write

foo.offsetHeight // read (recalculate style, layout, expensive!)
bar.offsetHeight // read (fast since style and layout is already known)
baz.offsetHeight // read (fast since style and layout is already known)
```

有趣的是，这种模式对于其他类型的工作也适用。本来将相似的工作进行批量处理就能得到较好的流水作业，也有利于进行深入的优化。

下面从一个`User`对象开始，来看Ember优化的一个类似的例子：

```js
var User = Ember.Object.extend({
  firstName: null,
  lastName: null,
  fullName: function() {
    return this.get('firstName') + ' ' + this.get('lastName');
  }.property('firstName', 'lastName')
})
```

下面的模板用来显示其属性：

```handlebars
{{firstName}}
{{fullName}}
```

如果不在运行循环中执行下列代码：

```js
var user = User.create({firstName:'Tom', lastName:'Huda'});
user.set('firstName', 'Yehuda');
// {{firstName}} and {{fullName}} are updated

user.set('lastName', 'Katz');
// {{lastName}} and {{fullName}} are updated
```

浏览器将会渲染模板两次。

```js
var user = User.create({firstName:'Tom', lastName:'Huda'});
user.set('firstName', 'Yehuda');
user.set('lastName', 'Katz');

// {{firstName}}  {{lastName}} and {{fullName}} are updated
```

然后，如果上述代码在运行循环中执行，浏览器将会在所有属性都被设置好后，只重新渲染一次模板。

```js
var user = User.create({firstName:'Tom', lastName:'Huda'});
user.set('firstName', 'Yehuda');
user.set('lastName', 'Katz');
user.set('firstName', 'Tom');
user.set('lastName', 'Huda');
```

如上例所示，由于用户属性值最后并没有发生改变，当这段代码在运行循环中执行时，模板并不会被重新渲染！

当然这些场景也可以一个个问题来进行优化，然而能保持开放性相对来说更好。使用运行循环，可以为此类优化问题实现应用范围内的全局优化，而不单单是一个个场景。

## Ember中运行循环是如何工作的？

如之前所述，任务（函数调用）被分配到队列中，而队列会按照优先级来进行处理直到全部完成。

那么都有些什么队列，它们的优先级又是怎么样排序的呢？

```js
Ember.run.queues
// => ["sync", "actions", "routerTransitions", "render", "afterRender", "destroy"]
```

由于优先级是从前至后的，因此"sync"队列的优先级比"render"或者"destroy"队列的要高。

## 这些队列里面都发生了些什么？

* `sync`队列包含绑定同步的任务
* `actions`队列是最普通的工作队列，通常包含待执行的计划任务。例如：承诺
* `routerTransitions`队列包含路由的转换任务
* `render`队列包含将要进行渲染的任务，通常都是对DOM的更新操作
* `afterRender`包含之前计划进行渲染的任务完成后需要执行的任务。对于第三方修改DOM的库来说非常有用，因为这意味着任务会在DOM全部被更新后才执行
* `destroy`队列包含完成其他任务计划销毁额对象的清理任务

## 队列中的任务以什么顺序执行？

算法按照下面的方式工作：

1. 将包含等待任务的具有最高优先级的队列设置为`CURRENT_QUEUE`，如果没有任何队列中包含等待执行的任务，运行循环完成
2. 将一个新的临时队列定义为`WORK_QUEUE`
3. 将`CURRENT_QUEUE`中的任务移动到`WORK_QUEUE`中
4. 按顺序处理`WORK_QUEUE`中的所有任务
5. 返回第一步开始执行

## 内部示例

与编写高层的应用代码不同，Ember内部会调用各种运行循环来计划函数的执行，这里拨开所有的面纱，直接展示原始的运行循环交互。

大部分Ember应用并不需要直接操作这些API，但是理解本示例将能更好的理解运行循环算法，有助于成为更为优秀的Ember开发者。

<iframe src="http://emberjs.com.s3.amazonaws.com/run-loop-guide/index.html" width="678" height="410" style="border:1px solid rgb(170, 170, 170);margin-bottom:1.5em;"></iframe>

## 常见问题

#### 对于Ember入门需要了解哪些内容？

对于基础的Ember应用开发场景，不需要了解任何关于运行循环的内容。所有道路已经铺设完毕，可以完全不需要与运行循环打交道。

#### 对于编写一个实际的应用需要了解哪些内容？

不直接使用运行循环并不影响构建一个好的应用，因此能不用就不要用。

#### 哪些场景需要理解运行循环？

最常见的问题是集成一个非Ember接口的异步回调。例如：

- AJAX回调
- DOM更新和事件回调
- Websocket回调
- `setTimeout`和`setInterval`回调
- `postMessage`和`messageChannel`事件处理器

在回调被出发时，应该开始一个运行循环。

#### 如何通知Ember开始一个运行循环？

```js
$('a').click(function(){
  Ember.run(function(){  // begin loop
    // Code that results in jobs being scheduled goes here
  }); // end loop, jobs are flushed and executed
})
```

#### 如果忘记在一个异步处理器中启动一个运行循环会发生什么？

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
})
```

这样做并没有达到最佳效果，因为当前的JS依然允许在运行循环清空前结束，这样就意味着有时候浏览器会有机会去做一些其他的事情，例如垃圾回收。垃圾回收如果在数据变更和DOM重新渲染的过程中执行，会导致明显的延迟，应该竟可能避免。

#### 在测试模式下，为什么运行循环自动运行是被关闭的？

一些Ember测试助手都是承诺，需要等待运行循环为空才能履行。如果有代码不在运行循环内，会导致其过早履行，并给出错误的测试失败。关闭自动运行可以帮助找到这些场景，能为测试和应用都带来帮助。
