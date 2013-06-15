英文原文：[http://emberjs.com/guides/object-model/computed-properties-and-aggregate-data/](http://emberjs.com/guides/object-model/computed-properties-and-aggregate-data/)

## 计算属性和带@each的集合数据

计算属性时常依赖一个数组中的全部元素来计算其值。例如，要知道有多少已经完成的待办事项，那么需要计算控制器中所有的待办事项才能得出结果。

下面是一个计算属性的示例：

```javascript
App.TodosController = Ember.Object.extend({
  todos: [
    Ember.Object.create({ isDone: false })
  ],

  remaining: function() {
    var todos = this.get('todos');
    return todos.filterProperty('isDone', false).get('length');
  }.property('todos.@each.isDone')
});
```

这里需要注意的是依赖（`todos.@each.isDone`）中包含一个特殊的关键字`@each`。使用了`@each`意味着Ember.js在下述的四种情况下，将更新计算属性的绑定和触发其观察器：

1. `todos`数组中任意一个元素的`isDone`属性发生改变；
2. `todos`数组中添加了一个新成员；
3. `todos`数组中有一个成员被移除了；
4. 控制器的`todos`数组变为了另外一个不同的数组。

在上面的示例中，`remaining`为`1`：

```javascript
App.todosController = App.TodosController.create();
App.todosController.get('remaining');
// 1
```

如果改变待办事项的`isDone`属性，`remaining`属性会被自动更新：

```javascript
var todos = App.todosController.get('todos');
var todo = todos.objectAt(0);
todo.set('isDone', true);

App.todosController.get('remaining');
// 0

todo = Ember.Object.create({ isDone: false });
todos.pushObject(todo);

App.todosController.get('remaining');
// 1
```
