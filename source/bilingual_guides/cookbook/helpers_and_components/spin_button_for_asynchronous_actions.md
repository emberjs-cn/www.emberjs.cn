### Problem

### 问题

You want a button component that spins to show asynchronous action till completion. Eg- Save Button.

希望有一个按钮组件在异步操作完成之前一直保持旋转。例如保存按钮。

### Solution

### 解决方案

Write an Ember Component to change to loading state when action is taking place.

编写一个Ember组件，该组件在操作发生时变为加载中的状态。

For example a button to save data could be as 

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
    actions:{
        isLoading:false,
        showLoading:function(){
            if(!this.get('isLoading')){
                this.set('isLoading', true);
                this.sendAction('action');
            }
        }
    }
});

```


### Discussion

### 讨论

I have dumbed down the sample code to only change text within the button. One may add a loading image inside the button or change the button to a div styled like a button.

这里只是采用了基本的代码来改变按钮中的文本。这里也可以添加一个加载中的图片，当然也可以将按钮变成一个div样式的按钮。

The component is in charge of setting isLoading = true and the base controller performing asynchronous action decides when the 'isLoading' becomes false again.

组件负责设置`isLoading =
true`，而执行异步操作的控制器负责将`isLoading`设回`false`。

For safety and sanity of the component, one can add a settimeout of however much time and then set 'isLoading' back to false so that the components comes to initial state no matter the result of the asynchronous call. But I would prefer it was properly handled in the parent controller.

对于一个安全且明智的组件，可以添加一个定时器，在超时的时候可以将`isLoading`设置为`false`，这样可以让组件回归到初始状态，而不用管异步操作的结果是什么。当然宁愿其被父控制器正确的处理了。

Also note that the component does not let multiple clicks get in the way of loading status.

需要注意的是组件一旦进入加载中状态后，就不支持重复点击了。

#### Example

#### 示例

<a class="jsbin-embed" href="http://emberjs.jsbin.com/EXaxEfE/8">JS Bin</a><script src="http://static.jsbin.com/js/embed.js"></script>
