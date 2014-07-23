_Unit testing methods and computed properties follows previous patterns shown 
in [Unit Testing Basics] because DS.Model extends Ember.Object._

_单元测试方案和计算属性与之前[单元测试基础]中说明的相同，因为`DS.Model`集成自`Ember.Object`。_

[Ember Data] Models can be tested using the `moduleForModel` helper.

[Ember Data[模型可以使用`moduleForModel`助手来测试。

Let's assume we have a `Player` model that has `level` and `levelName` 
attributes. We want to call `levelUp()` to increment the `level` and assign a 
new `levelName` when the player reaches level 5.

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

Now let's create a test which will call `levelUp` on the player when they are
level 4 to assert that the `levelName` changes. We will use `moduleForModel`:

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

#### Live Example

#### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/naqif/embed?output">Unit Testing 
Ember Data Models</a>

<a class="jsbin-embed" href="http://jsbin.com/naqif/embed?output">Ember Data模型单元测试</a>

## Testing Relationships

## 测试关联关系

For relationships you probably only want to test that the relationship
declarations are setup properly.

对于关联关系，可能只希望测试是否正确声明了关联关系。

Assume that a `User` can own a `Profile`.

例如一个`User`可以拥有一份`Profile`。

```javascript
App.Profile = DS.Model.extend({});

App.User = DS.Model.extend({
  profile: DS.belongsTo(App.Profile)
});
```

Then you could test that the relationship is wired up correctly
with this test.

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

#### Live Example

#### 在线示例

<a class="jsbin-embed" href="http://jsbin.com/ziboq/embed?output">Unit Testing Models (Relationships : One-to-One)</a>

<a class="jsbin-embed" href="http://jsbin.com/ziboq/embed?output">模型单元测试（关联关系：One-to-One）</a>

<script src="http://static.jsbin.com/js/embed.js"></script>

_Ember Data contains extensive tests around the functionality of
relationships, so you probably don't need to duplicate those tests.  You could
look at the [Ember Data tests] for examples of deeper relationship testing if you
feel the need to do it._

_Ember
Data还包含了针对关联关系功能性测试，因此可能不需要对这些来进行重复的测试。可以查看[Ember
Data测试]，来了解更多关于深层次的关联关系的测试。_

[Ember Data]: https://github.com/emberjs/data
[Unit Testing Basics]: /guides/testing/unit-testing-basics
[单元测试基础]: /guides/testing/unit-testing-basics
[Ember Data tests]: https://github.com/emberjs/data/tree/master/packages/ember-data/tests
[Ember Data测试]: https://github.com/emberjs/data/tree/master/packages/ember-data/tests
