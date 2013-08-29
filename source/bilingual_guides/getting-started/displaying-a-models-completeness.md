## Displaying a Model's Complete State

## 显示模型的完成状态

TodoMVC strikes through completed todos by applying a CSS class `completed` to the `<li>` element. Update `index.html` to apply a CSS class to this element when a todo's `isCompleted` property is true:

TodoMVC通过在`<li>`元素上应用了一个名为`completed`的CSS类来标识已完成的待办事项。因此需要在一个待办事项的`isCompleted`属性为真的时候，更新`index.html`，为这个待办事项的元素添加一个CSS类：
```handlebars
<!--- ... additional lines truncated for brevity ... -->
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
<li {{bind-attr class="isCompleted:completed"}}>
  <input type="checkbox" class="toggle">
  <label>{{title}}</label><button class="destroy"></button>
</li>
<!--- ... additional lines truncated for brevity ... -->
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
```

This code will apply the CSS class `completed` when the todo's `isCompleted` property is `true` and remove it when the property becomes `false`.

以上代码将在待办事项的`isCompleted`属性为真的时候设置`completed`这个CSS类，当`isCompleted`为假的时候移除该CSS类。

The first fixture todo in our application has an `isCompleted` property of `true`. Reload the application to see the first todo is now decorated with a strike-through to visually indicate it has been completed.

为我们应用构造的第一条待办事项的`isCompleted`属性是`true`，因此重载应用将会看到第一个待办事项有一条中划线，这表面其已经完成。

### Live Preview
### 在线演示
<a class="jsbin-embed" href="http://jsbin.com/iqofac/2/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script> 
  
### Additional Resources
### 附加资源

  * [Changes in this step in `diff` format](https://github.com/emberjs/quickstart-code-sample/commit/19d08dd3b294187fadbe57860cf68fc0dc629ad8)
  * [bind-attr API documentation](/api/classes/Ember.Handlebars.helpers.html#method_bind-attr)
  * [bind and bind-attr article by Peter Wagenet](http://www.emberist.com/2012/04/06/bind-and-bindattr.html)

  * [用`diff`格式呈现本次修改](https://github.com/emberjs/quickstart-code-sample/commit/72b1ccde5e157b20fcfe5da9bd52496e73533d47)
  * [bind-attr API文档](/api/classes/Ember.Handlebars.helpers.html#method_bind-attr)
  * [Peter Wagenet写的关于bind和bind-attr的文章](http://www.emberist.com/2012/04/06/bind-and-bindattr.html)
