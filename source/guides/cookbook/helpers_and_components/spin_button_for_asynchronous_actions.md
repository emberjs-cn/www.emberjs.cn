### 问题

希望有一个按钮组件在异步操作完成之前一直保持旋转。例如保存按钮。

### 解决方案

编写一个Ember组件，该组件在操作发生时变为加载中的状态。

例如一个用于保存数据的按钮可以是：

```handlebars
<script type='text/x-handlebars' id='application'>
    {{spin-button id="forapplication" isLoading = isLoading buttonText=buttonText action='saveData'}}
</script>

<script type='text/x-handlebars' id='components/spin-button'>
    <button {{bind-attr id=id}} {{action 'showLoading'}}>
        {{#if isLoading}}
            <img src="http://i639.photobucket.com/albums/uu116/pksjce/spiffygif_18x18.gif">
        {{else}}
            {{buttonText}}
        {{/if}}
    </button>
</script>
```

```javascript
var App = Ember.Application.create({});

App.ApplicationController = Ember.Controller.extend({
    isLoading:false,
    buttonText:"Submit",
    actions:{
        saveData:function(){
            var self = this;

           //Do Asynchronous action here. Set "isLoading = false" after a timeout.
            Ember.run.later(function(){
                self.set('isLoading', false);
            }, 1000);
        }
    }
});

App.SpinButtonComponent = Ember.Component.extend({
	classNames: ['button'],
    buttonText:"Save",
    isLoading:false,
    actions:{
        showLoading:function(){
            if(!this.get('isLoading')){
                this.set('isLoading', true);
                this.sendAction('action');
            }
        }
    }
});

```

### 讨论

这里只是采用了基本的代码来改变按钮中的文本。这里也可以添加一个加载中的图片，当然也可以将按钮变成一个div样式的按钮。

组件负责设置`isLoading =
true`，而执行异步操作的控制器负责将`isLoading`设回`false`。

对于一个安全且明智的组件，可以添加一个定时器，在超时的时候可以将`isLoading`设置为`false`，这样可以让组件回归到初始状态，而不用管异步操作的结果是什么。当然宁愿其被父控制器正确的处理了。

需要注意的是组件一旦进入加载中状态后，就不支持重复点击了。

#### 示例

<a class="jsbin-embed" href="http://emberjs.jsbin.com/EXaxEfE/14">JS Bin</a><script src="http://static.jsbin.com/js/embed.js"></script>
