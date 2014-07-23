英文原文：[http://emberjs.com/guides/testing/testing-models/](http://emberjs.com/guides/testing/testing-models/)

_单元测试方案和计算属性与之前[单元测试基础]中说明的相同，因为`DS.Model`集成自`Ember.Object`。_

[Ember Data[模型可以使用`moduleForModel`助手来测试。

假定有一个`Player`模型，模型定义了`level`和`levelName`属性。通过调用`levelUp`可以增加`level`，并当玩家升级到5级时，为`levelName`设置一个新的值。

```javascript
App.Player = DS.Model.extend({
  level:     DS.attr('number', { defaultValue: 0 }),
  levelName: DS.attr('string', { defaultValue: 'Noob' }),
  
  levelUp: function() {
    var newLevel = this.incrementProperty('level');
    if (newLevel === 5) {
      this.set('levelName', 'Professional');      
    }
  }
});
```

下面创建一个测试，测试将在玩家等级为4时，调用`levelUp`方法来判断`levelName`是否正确改变。这里将使用`moduleForModel`来获取玩家的实例：

```javascript
moduleForModel('player', 'Player Model');

test('levelUp', function() {
  // this.subject aliases the createRecord method on the model
  var player = this.subject({ level: 4 });

  // wrap asynchronous call in run loop
  Ember.run(function() {
    player.levelUp();
  });

  equal(player.get('level'), 5);
  equal(player.get('levelName'), 'Professional');
});
```

#### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/naqif/embed?output">Ember Data模型单元测试</a>

## 测试关联关系

对于关联关系，可能只希望测试是否正确声明了关联关系。

例如一个`User`可以拥有一份`Profile`。

```javascript
App.Profile = DS.Model.extend({});

App.User = DS.Model.extend({
  profile: DS.belongsTo(App.Profile)
});
```

这里可以对关联关系是否正确关联进行正确性测试。

```javascript
moduleForModel('user', 'User Model', {
  needs: ['model:profile']
});

test('profile relationship', function() {
  var relationships = Ember.get(App.User, 'relationships');
  deepEqual(relationships.get(App.Profile), [
    { name: 'profile', kind: 'belongsTo' }
  ]);
});
```

#### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/ziboq/embed?output">模型单元测试（关联关系：One-to-One）</a>

<script src="http://static.jsbin.com/js/embed.js"></script>

_Ember
Data还包含了针对关联关系功能性测试，因此可能不需要对这些来进行重复的测试。可以查看[Ember
Data测试]，来了解更多关于深层次的关联关系的测试。_

[Ember Data]: https://github.com/emberjs/data
[单元测试基础]: /guides/testing/unit-testing-basics
[Ember Data测试]: https://github.com/emberjs/data/tree/master/packages/ember-data/tests
