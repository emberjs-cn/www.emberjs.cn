英文原文：[http://emberjs.com/guides/models/pushing-records-into-the-store/](http://emberjs.com/guides/models/pushing-records-into-the-store/)

仓库可以认为是所有应用加载的记录的一个缓存池。如果应用中的控制器或者路由请求一个记录，当记录已经被缓存时，仓库会立即将其返回。否则仓库必须请求适配器去加载这个记录，这通常就意味着需要通过网络去服务器端去获取该记录。

为了避免一直等待着应用获取记录，可以事先将记录推送到仓库中进行缓存。

这对于事先能预知用户需要获取什么数据的场景尤为有用。当用户点击一个连接，避免等待网络请求完成，Ember.js可以立即渲染新的模板。这能提高应用的实时性。

另外一种情况是在应用保持一个与后端的流式连接的情形。如果一个记录被创建或者修改，可以立即自动更新UI。

### 推送记录

为了将记录推入仓库，需要调用仓库的`push()`方法。

例如，假设在应用初次启动时，需要预先加载一些数据到仓库。

可以使用`ApplicationRoute`来完成这些操作。`ApplicationRoute`是路由层级中最顶层的路由，其`model`钩子在应用启动的时候被调用。

```js
var attr = DS.attr;

App.Album = DS.Model.extend({
  title: attr(),
  artist: attr(),
  songCount: attr()
});

App.ApplicationRoute = Ember.Route.extend({
  model: function() {
    var store = this.get('store'); 

    store.push('album', {
      id: 1,
      title: "Fewer Moving Parts",
      artist: "David Bazan",
      songCount: 10
    });

    store.push('album', {
      id: 2,
      title: "Calgary b/w I Can't Make You Love Me/Nick Of Time",
      artist: "Bon Iver",
      songCount: 2
    });
  }
});
```
