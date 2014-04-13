英文原文：[http://emberjs.com/guides/models/the-fixture-adapter/](http://emberjs.com/guides/models/the-fixture-adapter/)

当开发客户端应用时，服务端可能还没有完成对应API的开发。使用`FixtureAdapter`可以先进行Ember应用开发，然后切换到其他的适配器来使用API，并且这个切换并不需要改变应用的代码。

### 开始学习

使用夹具适配器需要完成三步简单的配置：

1. 创建一个新的、使用夹具适配器的`store`并将其关联到应用。
2. 使用`DS.Model.extend`来定义模型。
3. 将夹具（样本数据）关联到对应的模型类。

#### 创建夹具适配器

只需将其定义为`Ember.Application`应用的`ApplicationAdapter`属性即可。

```JavaScript
var App = Ember.Application.create();
App.ApplicationAdapter = DS.FixtureAdapter;
```

#### 定义模型

查看[定义模型][1]一章可以获取更多详细的关于定义模型的介绍，作为简单的示例，这里定义一个编写Ember文档的人员的模型。

```JavaScript
App.Documenter = DS.Model.extend({
  firstName: DS.attr( 'string' ),
  lastName: DS.attr( 'string' )
});
```

#### 关联夹具到模型类

关联夹具非常之简单。只需要将一个Javascript对象集合赋值给模型的`FIXTURES`属性即可：

```JavaScript
App.Documenter.FIXTURES = [
  { id: 1, firstName: 'Trek', lastName: 'Glowacki' },
  { id: 2, firstName: 'Tom' , lastName: 'Dale'     }
];
```

这就是所有的配置过程了，现在便可以施工用[查找记录][2]一章中得方法了。例如：

```JavaScript
App.DocumenterRoute = Ember.Route.extend({
  model: function() {
    return this.store.find('documenter', 1); // returns a promise that will resolve
                                             // with the record representing Trek Glowacki
  }
});
```

#### 命名惯例

与[REST Adapter][3]不同，夹具适配器并不做任何命名惯例的猜测。如同上例中所示，如果在`DS.Model.extend`中定义了一个`firstName`属性，那么需要在夹具样本数据中使用`firstName`来表示该属性。

更重要地是，需要确保夹具样本数据中得每一条记录都有一个唯一的标识。缺省情况下，Ember
Data假定该标识为`id`。如果没有重定义主键标识名，又未在记录中提供一个`id`，那么夹具适配器会抛出一个错误。

[1]: /guides/models/defining-models
[2]: /guides/models/finding-records
[3]: /guides/models/the-rest-adapter
