英文原文：[http://emberjs.com/guides/controllers/representing-a-single-model-with-objectcontroller/](http://emberjs.com/guides/controllers/representing-a-single-model-with-objectcontroller/)

## 代表单一模型

`Ember.ObjectController`用于代表单一模型。通过在路由的`setupController`方法中设置`ObjectController`的`model`属性，来指定其代表的模型。

当模板向`ObjectController`请求属性时，控制器将首先检查是否定义有该属性，如果有，则返回其当前值。

然而，当控制器没有定义该属性时，就将返回其代表的模型的该属性的值。

例如，在编写一个音乐播放器时，可以定义一个`SongController`来代表当前播放的歌曲。

```javascript
App.SongController = Ember.ObjectController.extend({
  soundVolume: 1
});
```

在路由中，设置控制器的`model`属性为当前播放的歌曲。

```javascript
App.SongRoute = Ember.Route.extend({
  setupController: function(controller, song) {
    controller.set('model', song);
  }
});
```

在模板中，可以显示当前播放的歌曲的名称，以及播放的音量。

```handlebars
<p>
  <strong>Song</strong>: {{name}} by {{artist}}
</p>
<p>
  <strong>Current Volume</strong>: {{soundVolume}}
</p>
```

因为`name`和`artist`都是在模型中被持久化的信息，控制器从模型中获取这些信息，并提供给模板。

然而`soundVolume`则是与当前用户回话相关的，并存储在控制器中，因此控制器可以直接返回其值。

这样的架构的优点是可以很容易的通过对象控制器来访问模型的属性。另外，如果需要为模板转换模型的属性，控制器是一个非常合适的地方来完成这样的工作，避免了将视图的逻辑放入到模型中去。

例如，音乐播放器需要显示歌曲的时长。

```handlebars
<p>
  <strong>Song</strong>: {{name}} by {{artist}}
</p>
<p>
  <strong>Duration</strong>: {{duration}}
</p>
```

由于时长在服务器端被保存为一个以秒为单位的整数，这时模板的输出为：

```html
<p>
  <strong>Song</strong>: 4 Minute Warning by Radiohead
</p>
<p>
  <strong>Duration</strong>: 257
</p>
```

由于音乐播放器的用户是人类而非机器，因此应该将歌曲时长显示为可读的格式。

可以在控制器中定义一个计算属性来转换模型的值为一个对于模板来说更加具有可读性的属性。

```javascript
App.SongController = Ember.ObjectController.extend({
  duration: function() {
    var duration = this.get('model.duration'),
         minutes = Math.floor(duration / 60),
         seconds = duration % 60;

    return [minutes, seconds].join(':');
  }.property('model.duration')
});
```

现在，模板的输出变得更加友好。

```html
<p>
  <strong>Song</strong>: 4 Minute Warning by Radiohead
</p>
<p>
  <strong>Duration</strong>: 4:17
</p>
```
