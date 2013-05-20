英文原文：[http://emberjs.com/guides/controllers/representing-multiple-models-with-arraycontroller/](http://emberjs.com/guides/controllers/representing-multiple-models-with-arraycontroller/)

## 代表多模型（Representing Multiple Models）

You can use `Ember.ArrayController` to represent an array of models. To tell an
`ArrayController` which model to represent, set its `model` property
in your route's `setupController` method.

`Ember.ArrayController`用于代表一组模型。通过在路由的`setupController`方法中设置`ArrayController`的`model`属性，来指定其代表的模型。

You can treat an `ArrayController` just like its underlying array. For
example, imagine we want to display the current playlist. In our router,
we setup our `SongsController` to represent the songs in the playlist:

可以将`ArrayController`作为一个数组来对待。例如，音乐播放器希望显示当前播放列表。在路由中，通过设置`SongsController`来代表播放列表中的歌曲。

```javascript
App.SongsRoute = Ember.Route.extend({
  setupController: function(controller, playlist) {
    controller.set('model', playlist.get('songs'));
  }
});
```

In the `songs` template, we can use the `{{#each}}` helper to display
each song:

在`songs`模板中，可以使用`{{#each}}`助手来显示歌曲。

```handlebars
<h1>Playlist</h1>

<ul>
  {{#each controller}}
    <li>{{name}} by {{artist}}</li>
  {{/each}}
</ul>
```

You can use the `ArrayController` to collect aggregate information about
the models it represents. For example, imagine we want to display the
number of songs that are over 30 seconds long. We can add a new computed
property called `longSongCount` to the controller:

另外，可以使用`ArrayController`来收集一些模型所代表的聚合类信息。例如，音乐播放器需要显示超过30秒长的歌曲的数量。那么只需要在控制器中添加一个名为`longSongCount`的计算属性。

```javascript
App.SongsController = Ember.ArrayController.extend({
  longSongCount: function() {
    var longSongs = this.filter(function(song) {
      return song.get('duration') > 30;
    });
    return longSongs.get('length');
  }.property('@each.duration')
});
```

Now we can use this property in our template:

现在便可以在模板中使用该属性。

```handlebars
<ul>
  {{#each controller}}
    <li>{{name}} by {{artist}}</li>
  {{/each}}
</ul>

{{longSongCount}} songs over 30 seconds.
```
