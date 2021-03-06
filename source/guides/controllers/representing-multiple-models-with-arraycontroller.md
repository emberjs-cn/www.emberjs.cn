英文原文：[http://emberjs.com/guides/controllers/representing-multiple-models-with-arraycontroller/](http://emberjs.com/guides/controllers/representing-multiple-models-with-arraycontroller/)

[Ember.ArrayController](/api/classes/Ember.ArrayController.html)用于代表一组模型。通过在路由的`setupController`方法中设置`ArrayController`的`model`属性，来指定其代表的模型。

可以将`ArrayController`作为一个数组来对待。例如，音乐播放器希望显示当前播放列表。在路由中，通过设置`SongsController`来代表播放列表中的歌曲。

```javascript
App.SongsRoute = Ember.Route.extend({
  setupController: function(controller, playlist) {
    controller.set('model', playlist.get('songs'));
  }
});
```

在`songs`模板中，可以使用`{{#each}}`助手来显示歌曲。

```handlebars
<h1>Playlist</h1>

<ul>
  {{#each}}
    <li>{{name}} by {{artist}}</li>
  {{/each}}
</ul>
```

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

现在便可以在模板中使用该属性。

```handlebars
<ul>
  {{#each}}
    <li>{{name}} by {{artist}}</li>
  {{/each}}
</ul>

{{longSongCount}} songs over 30 seconds.
```

### 排序

[Ember.ArrayController](/api/classes/Ember.ArrayController.html)使用`Ember.SortableMixin`来支持排序。为了支持排序，需要设置两个属性：

```javascript
App.SongsController = Ember.ArrayController.extend({
  sortProperties: ['name', 'artist'],
  sortAscending: true // false for descending
});
```

### 条目控制器

在遍历`ArrayController`的条目时，指定一个控制器来装饰单个条目非常有用。这可以在`ArrayController`中进行定义：

```javascript
App.SongsController = Ember.ArrayController.extend({
  itemController: 'song'
});
```

或者在模板中指定：

```handlebars
{{#each itemController="song"}}
  <li>{{name}} by {{artist}}</li>
{{/each}}
```
