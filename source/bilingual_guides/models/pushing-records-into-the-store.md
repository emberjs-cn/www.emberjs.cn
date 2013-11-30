One way to think about the store is as a cache of all of the records
that have been loaded by your application. If a route or a controller in
your app asks for a record, the store can return it immediately if it is
in the cache. Otherwise, the store must ask the adapter to load it,
which usually means a trip over the network to retrieve it from the
server.

仓库可以认为是所有应用加载的记录的一个缓存池。如果应用中的控制器或者路由请求一个记录，当记录已经被缓存时，仓库会立即将其返回。否则仓库必须请求适配器去加载这个记录，这通常就意味着需要通过网络去服务器端去获取该记录。

Instead of waiting for the app to request a record, however, you can
push records into the store's cache ahead of time.

为了避免一直等待着应用获取记录，可以事先将记录推送到仓库中进行缓存。

This is useful if you have a good sense of what records the user
will need next. When they click on a link, instead of waiting for a
network request to finish, Ember.js can render the new template
immediately. It feels instantaneous.

这对于事先能预知用户需要获取什么数据的场景尤为有用。当用户点击一个连接，避免等待网络请求完成，Ember.js可以立即渲染新的模板。这能提高应用的实时性。

Another use case for pushing in records is if your application has a
streaming connection to a backend. If a record is created or modified,
you want to update the UI immediately.

另外一种情况是在应用保持一个与后端的流式连接的情形。如果一个记录被创建或者修改，可以立即自动更新UI。

### Pushing Records

### 推送记录

To push a record into the store, call the store's `push()` method.

为了将记录推入仓库，需要调用仓库的`push()`方法。

For example, imagine we want to preload some data into the store when
the application boots for the first time.

例如，假设在应用初次启动时，需要预先加载一些数据到仓库。

We can use the `ApplicationRoute` to do so. The `ApplicationRoute` is
the top-most route in the route hierarchy, and its `model` hook gets
called once when the app starts up.

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
