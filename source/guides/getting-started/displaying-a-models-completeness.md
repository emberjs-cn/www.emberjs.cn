## 显示模型的完成状态

TodoMVC通过在`<li>`元素上应用了一个名为`completed`的CSS类来标识已完成的待办事项。因此需要在一个待办事项的`isCompleted`属性为真的时候，更新`index.html`，为这个待办事项的元素添加一个CSS类：

```handlebars
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
<li {{bindAttr class="isCompleted:completed"}}>
  <input type="checkbox" class="toggle">
  <label>{{title}}</label><button class="destroy"></button>
</li>
<!--- ... 为保持代码简洁，在此省略了其他代码 ... -->
```

以上代码将在待办事项的`isCompleted`属性为真的时候设置`completed`这个CSS类，当`isCompleted`为假的时候移除该CSS类。

为我们应用构造的第一条待办事项的`isCompleted`属性是`true`，因此重载应用将会看到第一个待办事项有一条中划线，这表面其已经完成。

### 在线演示
<a class="jsbin-embed" href="http://jsbin.com/iqofac/2/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script> 
  
### 附加资源

  * [用`diff`格式呈现本次修改](https://github.com/emberjs/quickstart-code-sample/commit/72b1ccde5e157b20fcfe5da9bd52496e73533d47)
  * [bindAttr API文档](/api/classes/Ember.Handlebars.helpers.html#method_bindAttr)
  * [Peter Wagenet写的关于bind和bindAttr的文章](http://www.emberist.com/2012/04/06/bind-and-bindattr.html)
