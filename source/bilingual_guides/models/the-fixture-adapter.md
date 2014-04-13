When developing client-side applications, your server may not have an API ready
to develop against. The FixtureAdapter allows you to begin developing Ember.js
apps now, and switch to another adapter when your API is ready to consume
without any changes to your application code.

当开发客户端应用时，服务端可能还没有完成对应API的开发。使用`FixtureAdapter`可以先进行Ember应用开发，然后切换到其他的适配器来使用API，并且这个切换并不需要改变应用的代码。

### Getting Started

### 开始学习

Using the fixture adapter entails three very simple setup steps:

使用夹具适配器需要完成三步简单的配置：

1. Create a new store using the fixture adapter and attach it to your app.
2. Define your model using `DS.Model.extend`.
3. Attach fixtures(also known as sample data) to the model's class.

1. 创建一个新的、使用夹具适配器的`store`并将其关联到应用。
2. 使用`DS.Model.extend`来定义模型。
3. 将夹具（样本数据）关联到对应的模型类。

#### Creating a Fixture Adapter

#### 创建夹具适配器

Simply attach it as the `ApplicationAdapter` property on your instance
of `Ember.Application`:

只需将其定义为`Ember.Application`应用的`ApplicationAdapter`属性即可。

```JavaScript
var App = Ember.Application.create();
App.ApplicationAdapter = DS.FixtureAdapter;
```

#### Define Your Model

#### 定义模型

You should refer to [Defining a Model][1] for a more in-depth guide on using
Ember Data Models, but for the purposes of demonstration we'll use an example
modeling people who document Ember.js.

查看[定义模型][1]一章可以获取更多详细的关于定义模型的介绍，作为简单的示例，这里定义一个编写Ember文档的人员的模型。

```JavaScript
App.Documenter = DS.Model.extend({
  firstName: DS.attr( 'string' ),
  lastName: DS.attr( 'string' )
});
```

#### Attach Fixtures to the Model Class

#### 关联夹具到模型类

Attaching fixtures couldn't be simpler. Just attach a collection of plain
JavaScript objects to your Model's class under the `FIXTURES` property:

关联夹具非常之简单。只需要将一个Javascript对象集合赋值给模型的`FIXTURES`属性即可：

```JavaScript
App.Documenter.FIXTURES = [
  { id: 1, firstName: 'Trek', lastName: 'Glowacki' },
  { id: 2, firstName: 'Tom' , lastName: 'Dale'     }
];
```

That's it! You can now use all of methods for [Finding Records][2] in your
application. For example:

这就是所有的配置过程了，现在便可以施工用[查找记录][2]一章中得方法了。例如：

```JavaScript
App.DocumenterRoute = Ember.Route.extend({
  model: function() {
    return this.store.find('documenter', 1); // returns a promise that will resolve
                                             // with the record representing Trek Glowacki
  }
});
```

#### Naming Conventions

#### 命名惯例

Unlike the [REST Adapter][3], the Fixture Adapter does not make any assumptions
about the naming conventions of your model. As you saw in the example above,
if you declare the attribute as `firstName` during `DS.Model.extend`, you use
`firstName` to represent the same field in your fixture data.

与[REST Adapter][3]不同，夹具适配器并不做任何命名惯例的猜测。如同上例中所示，如果在`DS.Model.extend`中定义了一个`firstName`属性，那么需要在夹具样本数据中使用`firstName`来表示该属性。

Importantly, you should make sure that each record in your fixture data has
a uniquely identifiable field. By default, Ember Data assumes this key
is called `id`. Should you not provide an `id` field in your fixtures, or
not override the primary key, the Fixture Adapter will throw an error.

更重要地是，需要确保夹具样本数据中得每一条记录都有一个唯一的标识。缺省情况下，Ember
Data假定该标识为`id`。如果没有重定义主键标识名，又未在记录中提供一个`id`，那么夹具适配器会抛出一个错误。

[1]: /guides/models/defining-models
[2]: /guides/models/finding-records
[3]: /guides/models/the-rest-adapter
