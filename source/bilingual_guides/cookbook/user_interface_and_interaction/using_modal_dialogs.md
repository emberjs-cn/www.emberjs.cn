### Problem

### 问题

You want to show part of your UI in a modal dialog.

希望用模态窗口来显示一部分UI。

### Solution

### 解决方案

Render a specific controller into a named `modal` outlet in your application
template.

渲染一个指定的控制器到应用模板中一个名为`modal`的插口（outlet）。

### Discussion

### 讨论

You can use a route's `render` method to render a specific controller and
template into a named outlet. In this case we can setup our application template
to handle the main outlet and a modal outlet:

可以使用路由的`render`方法来渲染一个指定的控制器和模板到一个命名插口（outlet）。这样的情况下，可以设置应用模板来出来主插口（outlet）和一个模态插口（outlet）。

```handlebars
{{outlet}}
{{outlet modal}}
```

Then you can render a controller and template into the `modal` outlet.  Sending
an action in a template will propagate to the application route's actions.

这样就可以渲染一个控制器和模板到`modal`插口（outlet）。在模板中触发一个操作，该操作会被传播到应用路由的操作哈希。

In a template:

模板如下：

```handlebars
<button {{action 'openModal' 'myModal'}}>Open modal</button>
```

In your application route:

应用路由如下：

```javascript
App.ApplicationRoute = Ember.Route.extend({
  actions: {
    openModal: function(modalName) {
      return this.render(modalName, {
        into: 'application',
        outlet: 'modal'
      });
    }
  }
});
```

When closing a modal, you can use the route's `disconnectOutlet` method to remove
the modal from the DOM.

当关闭模态对话框时，可以使用路由的`disconnectOutlet`方法来将模态对话框从DOM中删除。

```javascript
  closeModal: function() {
    return this.disconnectOutlet({
      outlet: 'modal',
      parentView: 'application'
    });
  }
```

It may also be helpful to use a `modal-dialog` component to handle common markup
and interactions such as rendering an overlay and handling clicks outside of the
modal.

使用一个`modal-dialog`组件来处理通用标记和交互也是非常有用的。例如渲染一个叠加层，并处理在模态对话框外的点击事件。

#### Example

#### 例子

This example shows:

本例中包含：

  1. Rendering a pop-up modal in a named outlet.
  1. Sending a specific model to the modal controller.
  1. Wrapping the common modal markup and actions in a component.
  1. Handling events to close the modal when the overlay is clicked.

  1. 渲染一个弹出模态对话框到一个命名插口（outlet）。
  1. 发送一个特定的模型到模态控制器。
  1. 将通用模态对话框标记和操作包裹到一个组件中。
  1. 处理叠加层被点击的事件，来关闭模态对话框 。

<a class="jsbin-embed" href="http://emberjs.jsbin.com/lokozegi/4/embed?output">JS Bin</a>
