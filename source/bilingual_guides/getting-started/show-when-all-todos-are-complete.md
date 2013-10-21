英文原文：[http://emberjs.com/guides/getting-started/show-when-all-todos-are-complete/](http://emberjs.com/guides/getting-started/show-when-all-todos-are-complete/)

Next we'll update our template to indicate when all todos have been completed. In `index.html` replace the static checkbox `<input>` with `{{input}}`:

接下来我们将修改模板来提示所有待办事项都已经完成。在`index.html`中替换静态的复选框`<input>`为`{{input}}`：

```handlebars
<!--- ... additional lines truncated for brevity ... -->
<section id="main">
  {{outlet}}

  {{input type="checkbox" id="toggle-all" checked=allAreDone}}
</section>
<!--- ... additional lines truncated for brevity ... -->
```

This checkbox will be checked when the controller property `allAreDone` is `true` and unchecked when the property `allAreDone` is `false`.

这个复选框将在控制器的属性`allAreDone`为`true`的时候被自动选中，为`false`的时候不选中。

In `js/controllers/todos_controller.js` implement the matching `allAreDone` property:

在`js/controllers/todos_controller.js`中实现`allAreDone`属性：

```javascript
// ... additional lines truncated for brevity ...
allAreDone: function (key, value) {
  return !!this.get('length') && this.everyBy('isCompleted', true);
}.property('@each.isCompleted')
// ... additional lines truncated for brevity ...
```

This property will be `true` if the controller has any todos and every todo's `isCompleted` property is true. If the `isCompleted` property of any todo changes, this property will be recomputed. If the return value has changed, sections of the template that need to update will be automatically updated for us.

这一属性在控制器包含待办事项，且每项都已完成的时候为`true`。如果任意待办事项的`isCompleted`属性发生改变，这个属性的值将被重新计算。如果返回值发生改变，模板中需要更新的内容会自动为我们保持更新。

Reload your web browser to ensure that there are no errors and the behavior described above occurs. 

重载浏览器确保没有任何错误，并且以上描述的功能正常。

### Live Preview

### 在线演示

<a class="jsbin-embed" href="http://jsbin.com/IcItARE/1/embed?live">Ember.js • TodoMVC</a><script src="http://static.jsbin.com/js/embed.js"></script>
    
### Additional Resources

### 附加资源

  * [Changes in this step in `diff` format](https://github.com/emberjs/quickstart-code-sample/commit/9bf8a430bc4afb06f31be55f63f1d9806e6ab01c)
  * [Ember.Checkbox API documentation](/api/classes/Ember.Checkbox.html)

  * [用`diff`格式显示改动](https://github.com/emberjs/quickstart-code-sample/commit/9bf8a430bc4afb06f31be55f63f1d9806e6ab01c)
  * [Ember.Checkbox API文档](/api/classes/Ember.Checkbox.html)
