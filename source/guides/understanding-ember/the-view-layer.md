英文原文：[http://emberjs.com/guides/understanding-ember/the-view-layer/](http://emberjs.com/guides/understanding-ember/the-view-layer/)

## Ember.js视图层

本文内容是针对有经验的Ember开发者而写，将深入讲解Ember.js的视图层，其中包括了一些非入门级的细节。

Ember.js拥有一个精心设计的用于创建、管理和渲染与浏览器的DOM连接在一起的具有层级的视图的系统。视图负责对用户输入做出响应，例如点击、拖动和滚动，还包括在视图底层数据发生改变时自动更新DOM的内容。

视图层级通常通过评估Handlebars模板来创建。子视图在评估模板的时候被添加。当这些子视图的模板被评估的时候，它们的子视图又被添加进来，如此反复，直到整个层级被创建出来。

即使没有显式的在Handlebars模板中创建子视图，Ember.js内部也会使用视图系统来更新绑定的值。例如，每个Handlebars表达式`{{value}}`会创建一个知道如何在其值改变的时候进行更新的视图。

使用`Ember.ContainerView`，可以在应用的运行期动态的改变视图的层级。与模板驱动不同，一个容器视图暴露了一组可以手动管理的子视图实例。

视图和模板联合提供了一个健壮的，可以创建任意梦寐以求的用户界面的系统。终端用户应该与诸如渲染和事件传播此类的复杂性隔离开来。应用开发者应该能一次性描述他们的UI，例如一串Handlebars标签，然后继续其应用而无需关心UI是否保持更新。

### 解决了什么问题？

#### 子视图

在一个典型的客户端应用中，视图可以表示DOM中互相嵌套的元素。本问题的一个最简单解决方案是分离表示每个DOM元素的视图对象，特定的引用可以帮助视图对象跟踪那些概念上嵌套在其中的视图。

下面是一个简单的示例，代表了一个应用的主视图，一个集合嵌套在其中，并且在集合中嵌套了各自独立的元素。

<figure>
  <img src="/images/view-guide/view-hierarchy-simple.png">
</figure>

乍一看，这个系统似乎工作的非常好，但想像一下如果希望打开乔上午8点的Lamprey Shack取代9点的会发生什么。在这样的情况下，应用的视图需要重新新渲染，因为开发者需要构建基于一个特定基础的指向子视图的引用，而这个重新渲染的过程有许多问题。

为了重新渲染应用视图，应用视图必须手动的重新渲染子视图，并将子视图插入应用视图元素中去。如果实现的非常完美的话，重现渲染能工作的非常好，但是这个基于一个完美的、特定的视图层级的实现。如果任何一个视图没有实现的那么好，整个重现渲染将失败。

为了避免这些问题，Ember的视图层次一开始就烙下了子视图的概率。

<figure>
  <img src="/images/view-guide/view-hierarchy-ember.png">
</figure>

当应用视图重新渲染的时候，Ember复杂重新渲染和插入子视图，而非应用代码。这意味着Ember可以执行内存管理，比如清除观察器和绑定。

这不仅消除了很多样板代码，而且也消除了没有实现的那么完美的视图层次在重新渲染时出现意想不到的错误的情况。

#### 事件委派

以前Web开发者为了知道用户与每个元素的交互，会在元素上添加事件监听器。例如，在一个`<div>`元素上注册一个函数，这个函数可以在用户点击`<div>`元素的时候被调用。

然而，当处理大量的交互元素的时候，这种方案往往不能扩展。例如，假设有一个`<ul>`元素，其包含了100个`<li>`在其中，每个元素都有一个删除按钮。由于对于这些元素来说都具有相同的行为，为每个删除按钮添加一个事件监听器这显然效率很低。

<figure>
  <img src="/images/view-guide/undelegated.png">
</figure>

为了解决这个问题，开发者发现了一个被称为“事件委派”的技术。这种技术只在容器元素上注册一个监听器，然后使用`event.target`来判断是哪一个具体的元素被用户点击了，而不用为每一个元素添加一个监听器。

<figure>
  <img src="/images/view-guide/delegated.png">
</figure>

这样实现依然存在一些问题，因为有些事件（例如`focus`、`blur`和`change`）并不会冒泡。幸远的是，jQuery完全地解决了这个问题，jQuery的`on`方法支持所有的本地浏览器事件。

其他的Javascript框架处理该问题通常有两种方法。第一种，需要自己实现一个简单的解决方案，即为每个元素创建一个独立的视图。当创建视图时，会给每个视图元素添加一个事件监听器。如果一个列表包含500个元素，那么需要创建500个视图，并且每个视图将在其元素上绑定一个监听器。

而第二种方法是，框架在视图层内置了事件委派机制。当创建一个视图时，可以提供一个需要委派的事件列表，及一个在事件发生时会被调用的方法。这样只需要识别接收到点击事件方法的上下文（例如列表中哪个元素被点击）。

现在面临一个让人感觉不爽的选择：是放弃事件委派的好处，为每一个元素创建一个视图，还是为所有元素创建一个视图，但保存一堆DOM中的Javascript对象呢？

为了解决这个问题，Ember使用jQuery将所有事件委派给应用的根元素（通常是文档的`body`）。当一个事件发生时，Ember识别出能够处理该事件的最近的视图，并调用其事件处理方法。这就意味着可以创建视图来保持Javascript上下文，并能享受使用事件委派的好处。

另外，因为Ember在整个Ember应用中只注册了一个事件，这样创建新视图时不需要设置事件监听器，这样不仅使重新渲染高效，而且不易出错。当一个视图有子视图时，也不需要手动解除重新渲染过程替换的视图的委托。

#### 渲染管道

大部分Web应用使用一种特定的模板语言标记来指定其用户界面。对于Ember.js，采用Handlebars模板语言来编写模板，当模板中使用的值发生改变的时候可以自动更新。

虽然显示模板的过程对于开发者来说是自动的，但是实际上这个过程包含了从原始模板到最终的、用户见到的DOM表示一系列必备的步骤。

下面是一个Ember视图近似的生命周期：

<figure>
  <img src="/images/view-guide/view-lifecycle-ember.png">
</figure>

##### 1. 模板编译

应用的模板通常是以字符串形式通过网络加载，或者随着应用加载的过程一同加载。当应用加载时，应用将模板字符串发送给Handlebars，将其编译成一个函数。一旦编译完成，这个模板函数就被保存起来，并且可以被多个视图每次需要重新渲染的时候重复使用。

如果模板在服务端进行预编译，那么这个步骤也可以在应用中省略。在这样的情况下，模板不在作为初始的、可读的模板字符串被传输，而是编译后的代码。

因为Ember负责了模板编译，因此不需要为确保编译后的模板可重用而做一些附加的工作。

##### 2. 字符串连接

当应用调用视图的`append`或者`appendTo`方法时，启动了视图的渲染过程。调用`append`或者`appendTo`相当于将视图渲染和插入操作排入了计划中。这样允许在渲染前处理其他的应用中的延迟逻辑（如绑定同步）。

在开始渲染过程时，Ember创建了一个`RenderBuffer`，视图可以将其内容追加到其中。在渲染的过程中，一个视图可以创建和渲染子视图。这时父视图创建一个`RenderBuffer`并赋给子视图，这个新创建的`RenderBuffer`与父的`RenderBuffer`相连。

Ember在渲染每个视图前进行绑定同步。通过在渲染视图前同步绑定，Ember确保不会渲染那些已经过期需要立刻替换的数据。

当主视图完成渲染时，整个渲染过程创建了一个与缓存树关联的视图树（视图层级）。通过遍历缓存树，将其转换为字符串，就得到了可以插入到DOM中的字符串。

下面是一个简单的示例：

<figure>
  <img src="/images/view-guide/render-buffer.png">
</figure>

除了子视图之外（字符串或其他`RenderBuffer`），一个`RenderBuffer`还封装了元素的标签名、id、类、样式和其他属性。这使得渲染过程中可以修改这些属性（比如样式），哪怕在其子字符串被渲染后。由于这些属性都通过绑定来控制（例如使用`bind-attr`），因此整个过程非常稳定且透明。

##### 3. 元素创建与插入

在渲染过程的最后阶段，根视图向`RenderBuffer`请求它的元素。这时`RenderBuffer`将完整的字符串使用jQuery转换成一个元素。根视图将这个元素赋给它的`element`属性，将其放置到DOM中正确的位置（`appendTo`指定的位置，如果应用使用`append`则是应用的根元素）。

虽然父视图直接为元素赋值，但是子视图则是延迟查找其元素的。子视图通过查找`id`与其`elementId`属性匹配的元素来完成对元素的赋值。除非显示的提供了`elementId`，否则渲染过程会生成`elementId`属性，并将该值赋给视图的`RenderBuffer`，这样视图就可以通过该属性来查找其元素。

##### 4. 重新渲染

在视图加入到DOM中之后，Ember和应用本身都可能想要重新渲染视图。这可以通过调用视图的`rerender`方法来触发重新渲染。

重新渲染将重复上述的第二和第三两个步骤，但存在两处不同：

* 与将元素插入到一个显式声明的特定地方不同，`rerender`将用一个新的元素替换已经存在的元素。
* 在渲染一个新的元素之外，将移除老的元素，并销毁其所有的子元素。这样Ember就可以在重新渲染视图时，自动的处理注销适当的绑定和观察器。因为注册和注销所有嵌套的观察器的过程都是自动的，这也使得观察器观察一个路径更为可行。

最常见的导致视图重新渲染的情况是绑定到Handlebars表达式（`{{foo}}`）的值发生改变。在内部，Ember为每个表达式创建了一个简单的视图，并在路径上注册了一个观察器。当路径发生改变时，Ember就会用新的值去更新DOM对应的部分。

另外一个常见的情形是`{{#if}}`或`{{#with}}`块。当渲染一个模板时，Ember为这些块助手创建了一个虚拟的视图。这些虚拟的视图并不会在公共的可见的视图层级部分出现（当从一个视图中获取`parentView`和`childViews`时），但是它们的存在可以保证重新渲染的一致性。

当被传递到`{{#if}}`和`{{#with}}`的路径发生改变时，Ember自动的重新渲染虚拟视图，这将替换其内容，更为重要的是，这将销毁所有子视图来释放内存。

在这些情形之外，应用有时也需要显式的重新渲染视图（通常是`ContainerView`，如下所示）。本例中，应用可以直接调用`rerender`，Ember会以相同的语义将重新渲染加入队列。

这个过程如下所示：

<figure>
  <img src="/images/view-guide/re-render.png">
</figure>

### 视图层级

#### 父视图与子视图

当Ember渲染一个模板化的视图时，将生成一个视图层级。假设有一个`form`模板。

```handlebars
{{view App.Search placeholder="Search"}}
{{#view Ember.Button}}Go!{{/view}}
```

并以如下方式加入到DOM中：

```javascript
var view = Ember.View.create({
  templateName: 'form'
}).append();
```

这将创建一个很小的视图层级，如下所示：

<figure>
  <img src="/images/view-guide/simple-view-hierarchy.png">
</figure>

通过`parentView`和`childViews`属性可以游弋在这个视图层级中。

```javascript
var children = view.get('childViews') // [ <App.Search>, <Ember.Button> ]
children.objectAt(0).get('parentView') // view
```

`parentView`的一个常见的使用场景就是在一个子视图的实例中。

```javascript
App.Search = Ember.View.extend({
  didInsertElement: function() {
    // this.get('parentView') in here references `view`
  }
})
```

#### 生命周期钩子

为了在视图的生命周期中的不同点更加容易的执行操作，Ember提供了许多有用的钩子。

* `willInsertElement`：本钩子在视图被渲染后，但还未插入到DOM中时被调用。它不访问视图的`element`。
* `didInsertElement`：本钩子在视图一插入DOM后立即被调用。它可以访问视图的`element`，这在集成外部的库的时候尤为有用。任何显式的设置DOM代码都应该被限定在本钩子内。
* `willDestroyElement`：本钩子在元素从DOM中移除之前调用。在此有机会来清理关联到DOM节点的一些外部状态。就像`didInsertElement`有助于集成外部库一般。
* `willClearRender`：本钩子在视图被重新渲染之前调用。它可以在视图重新渲染之前做一些清理工作。
* `becameVisible`：本钩子在视图的`isVisible`属性或者其某个父视图的`isVisible`属性变为真，且关联的元素变为可见之后调用。注意本钩子只适用于所有可见性都通过`isVisible`属性来控制的情况。

* `becameHidden`：本钩子在视图的`isVisible`属性或者其某个父视图的`isVisible`属性变为假，且关联的元素变为不可见之后调用。注意本钩子只适用于所有可见性都通过`isVisible`属性来控制的情况。

应用可以通过在视图中定义一个与钩子名称相同的方法来实现钩子。另外，也可以在视图上注册一个钩子的监听器：

```javascript
view.on('willClearRender', function() {
  // do something with view
});
```

#### 虚拟视图

如上所述，Handlebars通过创建视图在视图层级中表示绑定的值。每次使用Handlebars表达式时，无论是一个简单的值，还是一个如同`{{#with}}`或`{{#if}}`这样的块助手，Handlebars都会创建一个新视图。

由于在Ember中这些视图只用于内部记录，它们对于视图公开的`parentView`和`childViews`API都是不可见的。公开的视图层级只反映使用`{{view}}`助手或通过`ContainerView`（见下）创建的视图。

例如，考虑如下的Handlebars模板：

```handlebars
<h1>Joe's Lamprey Shack</h1>
{{controller.restaurantHours}}

{{#view App.FDAContactForm}}
  If you are experiencing discomfort from eating at Joe's Lamprey Shack,
please use the form below to submit a complaint to the FDA.

  {{#if controller.allowComplaints}}
    {{view Ember.TextArea valueBinding="controller.complaint"}}
    <button {{action submitComplaint}}>Submit</button>
  {{/if}}
{{/view}}
```

渲染这个模板将创建一个如下所示的层级：

<figure>
  <img src="/images/view-guide/public-view-hierarchy.png">
</figure>

在本场景的背后，Ember跟踪Handlebars表达式附加的虚拟视图：

<figure>
  <img src="/images/view-guide/virtual-view-hierarchy.png">
</figure>

从`TextArea`内部，`parentView`应该指向`FDAContactForm`，而`FDAContactForm`的`childViews`应该包含一个只有这个`TextArea`视图的数组。

通过询问包含虚拟视图的`_parentView`或`_childViews`可以查看视图层级的内部结构：

```javascript
var _childViews = view.get('_childViews');
console.log(_childViews.objectAt(0).toString());
//> <Ember._HandlebarsBoundView:ember1234>
```

**警告！**
不要在应用代码中依赖这些内部的API。这些API可能在不公开知会的情形下发生改变。返回的值也可以观察和绑定，也可以不是一个Ember对象。如果确实需要使用这些API，可以联系Ember.js开发团队，以便提供一个更加友好的针对这些应用场景的公共API。

概要：这些API就如同XML。如果需要使用，那么可能没有正确的理解问题本身。请重新考虑一遍。

#### 事件冒泡

视图的一个重要责任是负责将用户的原生事件转换成在应用中代表特定语义的事件。

例如，一个删除按钮讲一个原生的`click`事件转换为应用级的特性“从数组中删除这个元素”。

为了响应用户事件，可以创建一个视图的子类，来将事件实现为一个方法：

```javascript
App.DeleteButton = Ember.View.create({
  click: function(event) {
    var item = this.get('model');
    this.get('controller').send('deleteItem', item);
  }
});
```

当创建一个新的`Ember.Application`实例时，使用jQuery事件委派接口，为每个本地浏览器事件注册了一个事件处理器。当用户触发一个事件时，应用的事件分发器将找寻离事件的目标最近的，处理了该事件的视图。

视图实现一个事件通过定义一个与事件名对应的方法。如果事件的名称由多个词组成（如`mouseup`），那么实现的方法应该采用事件名称的驼峰命名格式（`mouseUp`）。

事件将在视图层级中一直向上冒泡，知道到达根视图。一个事件处理器可以如同使用jQuery事件处理一样的技术来停止传播事件：

* 在方法中`返回假`
* 调用`event.stopPropagation`

例如，假定定义了如下的视图类：

```javascript
App.GrandparentView = Ember.View.extend({
  click: function() {
    console.log('Grandparent!');
  }
});

App.ParentView = Ember.View.extend({
  click: function() {
    console.log('Parent!');
    return false;
  }
});

App.ChildView = Ember.View.extend({
  click: function() {
    console.log('Child!');
  }
});
```

下面是使用这些视图类的Handlebars模板：

```handlebars
{{#view App.GrandparentView}}
  {{#view App.ParentView}}
    {{#view App.ChildView}}
      <h1>Click me!</h1>
    {{/view}}
  {{/view}}
{{/view}}
```

如果点击了`<h1>`，那么在浏览器的控制台应该看到如下的输出：

```
Child!
Parent!
```

可见Ember调用了最近的接收到事件的子视图的处理器。事件继续冒泡到`ParentView`，但是没有到达`GrandparentView`，因为`ParentView`在其事件处理器中返回了假。

同样，也可以使用事件冒泡技术来实现类似的模式。例如，可以实现一个定义了`submit`方法的`FormView`。因为浏览器会在用户在一个文本输入框中敲回车的时候触发`submit`事件，因此在表单视图上定义一个`submit`方法是可以正常工作的。

```javascript
App.FormView = Ember.View.extend({
  tagName: "form",

  submit: function(event) {
    // will be invoked whenever the user triggers
    // the browser's `submit` method
  }
});
```

```handlebars
{{#view App.FormView}}
  {{view Ember.TextField valueBinding="controller.firstName"}}
  {{view Ember.TextField valueBinding="controller.lastName"}}
  <button type="submit">Done</button>
{{/view}}
```

#### 添加新事件

Ember内置支持下列本地的浏览器事件：

<table class="figure">
  <thead>
    <tr><th>事件名</th><th>方法名</th></tr>
  </thead>
  <tbody>
    <tr><td>touchstart</td><td>touchStart</td></tr>
    <tr><td>touchmove</td><td>touchMove</td></tr>
    <tr><td>touchend</td><td>touchEnd</td></tr>
    <tr><td>touchcancel</td><td>touchCancel</td></tr>
    <tr><td>keydown</td><td>keyDown</td></tr>
    <tr><td>keyup</td><td>keyUp</td></tr>
    <tr><td>keypress</td><td>keyPress</td></tr>
    <tr><td>mousedown</td><td>mouseDown</td></tr>
    <tr><td>mouseup</td><td>mouseUp</td></tr>
    <tr><td>contextmenu</td><td>contextMenu</td></tr>
    <tr><td>click</td><td>click</td></tr>
    <tr><td>dblclick</td><td>doubleClick</td></tr>
    <tr><td>mousemove</td><td>mouseMove</td></tr>
    <tr><td>focusin</td><td>focusIn</td></tr>
    <tr><td>focusout</td><td>focusOut</td></tr>
    <tr><td>mouseenter</td><td>mouseEnter</td></tr>
    <tr><td>mouseleave</td><td>mouseLeave</td></tr>
    <tr><td>submit</td><td>submit</td></tr>
    <tr><td>change</td><td>change</td></tr>
    <tr><td>dragstart</td><td>dragStart</td></tr>
    <tr><td>drag</td><td>drag</td></tr>
    <tr><td>dragenter</td><td>dragEnter</td></tr>
    <tr><td>dragleave</td><td>dragLeave</td></tr>
    <tr><td>dragover</td><td>dragOver</td></tr>
    <tr><td>drop</td><td>drop</td></tr>
    <tr><td>dragend</td><td>dragEnd</td></tr>
  </tbody>
</table>

在创建新的应用时，可以给事件分发器添加更多的事件：

```javascript
App = Ember.Application.create({
  customEvents: {
    // add support for the loadedmetadata media
    // player event
    'loadedmetadata': "loadedMetadata"
  }
});
```

为了使自定义事件可以正常工作，HTML5规范必须定义事件为“冒泡”，或者jQuery必须提供了针对该事件的一个事件委派。

### 模板化视图

截止目前，在本指南中所见的，应用中使用的主要视图都是基于模板的。当使用模板时，不需要通过编程来创建视图层级，因为模板会创建它。

当渲染时，视图模板可以追加视图到它的子视图数组。在内部，模板的`{{view}}`助手将调用视图的`appendChild`方法。

调用`appendChild`完成如下两件事情：

1. 将子视图添加到`childViews`数组。
2. 立即渲染子视图，并将其添加到父视图的渲染缓冲中去。

<figure>
  <img src="/images/view-guide/template-appendChild-interaction.png">
</figure>

在一个视图不在渲染中这个状态之后，不能调用其`appendChild`方法。一个模板渲染“混合的内容”（包括视图和纯文本），因此父视图在完成了渲染过程之后不知道在什么地方添加新的子视图。

在上例中，假定尝试在父视图的`childViews`数组中添加一个新的视图。是否应该将其添加到`App.MyView`的`</div>`之后呢？或者是添加到整个视图的`</div>`之后呢？这里通常都无法得到一个正确的答案。

由于存在不明确的地方，所以创建视图层级的唯一方法便是使用模板的`{{view}}`助手，它将永远可以将视图插入到与任何纯文本关联的正确位置。

虽然模板可以处理大部分情形，但是偶尔也会需要直接通过编程来控制视图的子。在这种情况下，可以使用`Ember.ContainerView`，它显式的暴露了一个公有API来完成这项任务。

### 容器视图

容器视图不包含纯文本，完全由其子视图构成（子视图可以基于模板）。

`ContainerView`暴露了两个公有API来改变其内容：

1. 一个可写的`childViews`数组，可以在其中插入`Ember.View`的实例。
2. 一个`currentView`属性，当其被设置时，将新的值添加到子视图数组中。如果`currentView`之前有值，那么这个值将被从`childViews`数组中移除。

下面是一个使用`childViews`API来创建视图的例子。有一个假设的`DescriptionView`开始，并可以通过调用`addButton`方法在任何时刻添加一个按钮：

```javascript
App.ToolbarView = Ember.ContainerView.create({
  init: function() {
    var childViews = this.get('childViews');
    var descriptionView = App.DescriptionView.create();

    childViews.pushObject(descriptionView);
    this.addButton();

    return this._super();
  },

  addButton: function() {
    var childViews = this.get('childViews');
    var button = Ember.ButtonView.create();

    childViews.pushObject(button);
  }
});
```

如上例中所述，使用了两个视图来对`ContainerView`进行初始化，而且还可以在运行期添加附加的视图。按照惯例，与通过重写`init`方法不同，还有另外一种更为简便的初始化方法：

```javascript
App.ToolbarView = Ember.ContainerView.create({
  childViews: ['descriptionView', 'buttonView'],

  descriptionView: App.DescriptionView,
  buttonView: Ember.ButtonView,

  addButton: function() {
    var childViews = this.get('childViews');
    var button = Ember.ButtonView.create();

    childViews.pushObject(button);
  }
});
```

如上所述，当使用这种便捷的方法时，`childViews`通过一个字符串数组来指定。在初始化的时候，每一个字符串都用作查找视图实例或者类的关键字。对应的视图如果需要的话，会自动初始化，并被添加到`childViews`数组中去。

<figure>
  <img src="/images/view-guide/container-view-shorthand.png">
</figure>

### 模板作用域

标准的Handlebars模板巨涌上下文的概念，即表达式将从哪个对象中查找。

一些如同`{{#with}}`一样的助手，可以改变其块内的上下文。其他的如同`{{#if}}`之类的，则保留了上下文，它们被称为“保留上下文助手”。

当Ember应用中的Handlebars模板使用了表达式时（`{{#if
foo.bar}}`），Ember在当前的上下文中自动针对路径设置一个观察器。

如果被路径引用的对象发生改变，那么Ember将自动使用适当的上下文重新渲染该块。在一个保留上下文的助手情况下，Ember在重新渲染块的时候使用初始的上下文。否则，Ember将使用路径对应的新值作为上下文。

```handlebars
{{#if controller.isAuthenticated}}
  <h1>Welcome {{controller.name}}</h1>
{{/if}}

{{#with controller.user}}
  <p>You have {{notificationCount}} notifications.</p>
{{/with}}
```

在上述的模板中，当`isAuthenticated`属性由假变真时，Ember将使用初始的外部作用域作为它的上下文来渲染块。

而`{{#with}}`助手则将其块的上下文变为当前控制器的`user`属性。当`user`属性改变时，Ember使用`controller.user`的新值作为其上下文来重新渲染该块。

#### 视图作用域

在Handlebars上下文之外，Ember中的模板还有当前视图的概念。无论当前的上下文是什么，`view`属性总是引用了最近的视图。

注意`view`属性从来都不会引用为像`{{#if}}`这样的块表达式创建的内部视图。这就可以用来区分Handlebars上下文了，它永远如工作在Vanilla Handlebars和视图层级中一般。

因为`view`指向一个`Ember.View`实例，所以可以使用如同`view.propertyName`这样的表达式来访问任何属性。也可以通过`view.parentView`来访问父视图。

例如，假定有一个视图包含如下的属性：

```javascript
App.MenuItemView = Ember.View.create({
  templateName: 'menu_item_view',
  bulletText: '*'
});
```

及如下的模板：

```handlebars
{{#with controller}}
  {{view.bulletText}} {{name}}
{{/with}}
```

即使Handlebars上下文改变为当前的控制器，依然可以通过引用`view.bulletText`来访问视图的`bulletText`。

### 模板变量

本指南到目前为止，在Handlebars模板中都在围绕着使用`controller`属性捣鼓。那么它是从何而来的呢？

Ember中Handlebars上下文可以从其父上下文中继承变量。在Ember在当前上下文中查找变量之前，首先在模板变量中进行查找。由于一个模板创建新的Handlebars作用域，这将自动从其父作用域中继承变量。

Ember定义这些`view`和`controller`变量，因此当一个表达式使用`view`或`controller`名称时，都是最先被找到的。

如上所述，Ember在Handlebars上下文中设置`view`变量，无论模板中什么时候使用`{{#view}}`助手。一开始，Ember将`view`变量设置为渲染模板的视图。

Ember在Handlebars上下文中设置`controller`变量，无论一个被渲染的视图什么时候有`controller`属性。如果一个视图没有`controller`属性，它将从最近的拥有`controller`变量的视图中继承过来。

#### 其他变量

Ember中的Handlebars助手可以指定变量。例如，`{{#with controller.person as tom}}`指定了一个能在派生的作用域中访问的变量`tom`。即使子上下文也有一个`tom`属性，这个`tom`变量也将替代它。

这种形式能获得的一个主要好处是：在能访问父作用域的同时，缩短路径的长度。

这在提供`{{#each person in people}}`形式的`{{#each}}`助手中尤为重要。这种形式派生的上下文能够访问`person`变量，且同时保持了模板中调用`each`处相同的作用域。

```handlebars
{{#with controller.preferences}}
  <h1>Title</h1>
  <ul>
  {{#each person in controller.people}}
    {{! prefix here is controller.preferences.prefix }}
    <li>{{prefix}}: {{person.fullName}}</li>
  {{/each}}
  <ul>
{{/with}}
```

注意这些变量继承自`ContainerView`，即使它不属于Handlebars上下文层级。

#### 在视图中访问模板变量

在大多数情况下，需要在模板内部访问模板变量。而在一些特殊的情况下，可能希望在视图的Javascript代码中访问在作用域中的模板变量。

通过访问视图的`templateVariables`属性可以实现。这个属性返回在视图被渲染时的一个包含了在作用域中的变量的Javascript对象。`ContainerView`同样可以访问该属性，这个属性引用了最近的一个基于模板的视图的模板变量。


目前，还不可以观察或者绑定一个包含`templateVariables`的路径。
