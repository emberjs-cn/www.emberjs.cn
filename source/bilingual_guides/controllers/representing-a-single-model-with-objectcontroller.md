英文原文：[http://emberjs.com/guides/controllers/representing-a-single-model-with-objectcontroller/](http://emberjs.com/guides/controllers/representing-a-single-model-with-objectcontroller/)

## 代表单一模型（Representing a Single Model）

Use `Ember.ObjectController` to represent a single model. To tell an
`ObjectController` which model to represent, set its `content`
property in your route's `setupController` method.

`Ember.ObjectController`用于代表单一模型。通过在路由的`setupController`方法中设置`ObjectController`的`content`属性，来指定其代表的模型。

When a template asks an `ObjectController` for a property, it will first
check to see if it has its own property with that name defined. If so, it will
return its current value.

当模板向`ObjectController`请求属性时，控制器将首先检查是否定义有该属性，如果有，则返回其当前值。

However, if the controller does not have a property with that name defined, it
will return the value of the property on the model.

然而，当控制器没有定义该属性时，就将返回其代表的模型的该属性的值。

For example, imagine you are writing a music player. You have defined
your `SongController` to represent the currently playing song.

例如，在编写一个音乐播放器时，可以定义一个`SongController`来代表当前播放的歌曲。

```javascript
App.SongController = Ember.ObjectController.extend({
  soundVolume: 1
});
```

In your router, you set the `content` of the controller to the
currently playing song:

在路由中，设置控制器的`content`属性为当前播放的歌曲。

```javascript
App.SongRoute = Ember.Route.extend({
  setupController: function(controller, song) {
    controller.set('content', song);
  }
});
```

In your template, you want to display the name of the currently playing
song, as well as the volume at which it is playing.

在模板中，可以显示当前播放的歌曲的名称，以及播放的音量。

```handlebars
<p>
  <strong>Song</strong>: {{name}} by {{artist}}
</p>
<p>
  <strong>Current Volume</strong>: {{soundVolume}}
</p>
```

Because `name` and `artist` are persisted information, and thus stored
on the model, the controller looks them up there and provides them to
the template.

因为`name`和`artist`都是在模型中被持久化的信息，控制器从模型中获取这些信息，并提供给模板。

`soundVolume`, however, is specific to the current user's session, and
thus stored on the controller. The controller can return its own value
without consulting the model.

然而`soundVolume`则是与当前用户回话相关的，并存储在控制器中，因此控制器可以直接返回其值。

The advantage of this architecture is that it is easy to get started
by accessing the properties of the model via the object controller. If,
however, you need to transform a model property for a template, there is
a well-defined place to do so without adding view-specific concerns to
the model.

这样的架构的优点是可以很容易的通过对象控制器来访问模型的属性。另外，如果需要为模板转换模型的属性，控制器是一个非常合适的地方来完成这样的工作，避免了将视图的逻辑放入到模型中去。

For example, imagine we want to display the duration of the song:

例如，音乐播放器需要显示歌曲的时长。

```handlebars
<p>
  <strong>Song</strong>: {{name}} by {{artist}}
</p>
<p>
  <strong>Duration</strong>: {{duration}}
</p>
```

This is saved on the server as an integer representing the number of
seconds, so our first attempt looks like this:

由于时长在服务器端被保存为一个以秒为单位的整数，所以生成的html如下所示：

```html
<p>
  <strong>Song</strong>: 4 Minute Warning by Radiohead
</p>
<p>
  <strong>Duration</strong>: 257
</p>
```

Since our users are humans and not robots, however, we'd like to display
the duration as a formatted string.

由于音乐播放器的用户是人类而非机器，因此应该将歌曲时长显示为可读的格式。

This is very easy to do by defining a computed property on the
controller which transforms the model's value into a human-readable
format for the template:

可以在控制器中定义一个计算属性来转换模型的值为一个对于模板来说更加具有可读性的属性。

```javascript
App.SongController = Ember.ObjectController.extend({
  duration: function() {
    var duration = this.get('content.duration'),
         minutes = Math.floor(duration / 60),
         seconds = duration % 60;

    return [minutes, seconds].join(':');
  }.property('content.duration')
});
```

Now, the output of our template is a lot friendlier:

现在，模板的输出变得更加友好。

```html
<p>
  <strong>Song</strong>: 4 Minute Warning by Radiohead
</p>
<p>
  <strong>Duration</strong>: 4:17
</p>
```
