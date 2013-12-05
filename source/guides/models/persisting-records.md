英文原文：[http://emberjs.com/guides/models/persisting-records/](http://emberjs.com/guides/models/persisting-records/)

Ember Data中的记录都基于实例来进行持久化。调用`DS.Model`实例的`save()`会触发一个网络请求，来进行记录的持久化。

下面是几个示例：

```javascript
var post = store.createRecord('post', {
  title: 'Rails is Omakase',
  body: 'Lorem ipsum'
});

post.save(); // => POST to '/posts'
```

```javascript
var post = store.find('post', 1);

post.get('title') // => "Rails is Omakase"

post.set('title', 'A new post');

post.save(); // => PUT to '/posts/1'
```

### 承诺

`save()`会返回一个承诺，这使得可以非常容易的来处理保存成功和失败的场景。下面是一个通用的模式：

```javascript
var post = store.createRecord('post', {
  title: 'Rails is Omakase',
  body: 'Lorem ipsum'
});

post.save().then(function(post) {
  this.transitionToRoute('posts/show', post);
});

// => POST to '/posts'
// => transitioning to posts.show route
```

对于失败的网络请求，承诺也可以方便的来处理：

```javascript
var post = store.createRecord('post', {
  title: 'Rails is Omakase',
  body: 'Lorem ipsum'
});

var onSuccess = function(post) {
  this.transitionToRoute('posts/show', post);
};

var onFail = function(post) {
  // deal with the failure here
};

post.save().then(onSuccess, onFail);

// => POST to '/posts'
// => transitioning to posts.show route
```

更多关于承诺的内容请参看[这里](https://github.com/tildeio/rsvp.js)，下面是一个示例展示了如何在重试失败的持久化操作：

```javascript
function retry(callback, nTimes) {
  // if the promise fails
  return callback().fail(function(reason) {
    // if we haven't hit the retry limit
    if (nTimes-- > 0) {
      // retry again with the result of calling the retry callback
      // and the new retry limit
      return retry(callback, nTimes);
    }
 
    // otherwise, if we hit the retry limit, rethrow the error
    throw reason;
  });
}
 
// try to save the post up to 5 times
retry(function() {
  return post.save();
}, 5);
```
