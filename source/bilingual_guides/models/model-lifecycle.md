## Model Lifecycle

## 模型生命周期

Since models must be loaded and saved asynchronously, there are several
possible states that a record may be in at a given time. Each instance
of `DS.Model` has a set of Boolean properties that you can use to
introspect the current state of the record.

既然模型必须是异步加载和保存的，那么在给定的时间内一条记录就会存在几个不同的可能状态。每一个`DS.Model`的实例都有一系列布尔类型的属性，用来检查记录的当前状态。

* **isLoaded** The adapter has finished retrieving the current state of
  the record from its backend.
* **isDirty** The record has local changes that have not yet been saved
  by the adapter. This includes records that have been created (but not
  yet saved) or deleted.
* **isSaving** The record has been sent to the adapter to have its
  changes saved to the backend, but the adapter has not yet confirmed
  that the changes were successful.
* **isDeleted** The record was marked for deletion. When `isDeleted`
  is true and `isDirty` is true, the record is deleted locally
  but the deletion was not yet persisted. When `isSaving` is
  true, the change is in-flight. When both `isDirty` and
  `isSaving` are false, the change has been saved.
* **isError** The adapter reported that it was unable to save
  local changes to the backend. This may also result in the
  record having its `isValid` property become false if the
  adapter reported that server-side validations failed.
* **isNew** The record was created locally and the adapter
  did not yet report that it was successfully saved.
* **isValid** No client-side validations have failed and the
  adapter did not report any server-side validation failures.

* **isLoaded** 适配器已完成从后端读取记录的当前状态
* **isDirty** 记录有本地修改且尚未被适配器保存到后端。包括记录被创建或删除（但尚未保存）
* **isSaving** 记录已被发给适配器，但适配器尚未确认修改已成功保存与否
* **isDeleted** 记录被标记将被删除。当`isDeleted`和`isDirty`同时为真时，记录只是在本地被删除，并没有持久化。`isSaving`为真时，修改正在保存当中。`isDirty`和`isSaving`同时为假时，修改已经保存成功。
* **isError** 适配器报告说无法保存修改到后端。如果服务器端的验证失败时，也会导致记录的`isValid`属性为假。
* **isNew** 记录只是在本地被创建，适配器尚未报告记录是否被成功保存。
* **isValid** 没有客户端验证失败，适配器也没有报告任何服务器端验证失败

Additionally, you can subscribe to events that are emitted when a record
changes state. For example, you can run some code when a record becomes
loaded:

另外，你可以订阅记录变更状态时释出的事件。比如，你可以在记录加载完之后运行一些代码：

```js
record.on('didLoad', function() {
  console.log("Loaded!");
});
```

Valid events are:

有效的事件包括：

* `didLoad`
* `didCreate`
* `didUpdate`
* `didDelete`
* `becameError`
* `becameInvalid`


### Record States

### 记录的状态

#### Loading

#### 加载中

A record typically starts off in the loading state. This means Ember
Data has not yet received information from the adapter about what values
its attributes and relationships should have. You can put the record
into templates and they will automatically update once the record
becomes loaded.

Attempting to modify a record in the loading state will raise an
exception.

记录一般都起始于加载中这个状态。这意味着 Ember Data尚未从适配器收到任何有关记录的属性值为多少，处于什么样的关系之类的信息。你可以将记录放进模板中，一旦记录加载完成，模板就会自动更新。

#### Loaded/Clean

#### 加载完成/干净

A record that is both loaded and clean means that is has received
information about its attributes and relationships from the server, and
no changes have been made locally on the client.

一条记录加载完成且干净意味着已经从服务器获得了它的属性以及关系的信息。而且本地对记录尚无修改。

#### Dirty

#### 脏

A dirty record has outstanding changes to either its attributes or
relationships that have not yet been synchronized with the adapter.

脏的状态意味着记录的属性或关系已经被更改，但尚未通过适配器同步到服务器端。

#### In-Flight

#### 进行中

A record that is in-flight is a dirty record that has been given to the
adapter to save the changes made locally. Once the server has
acknowledged that the changes have been saved successfully, the record
will become clean.

一条在进行中的记录是指记录被交给适配器，以保存在本地所做的修改。一旦服务器确认修改已成功保存，记录就变干净了。

#### Invalid

A record becomes invalid if the adapter is notified by the server that
it was not able to be saved because the backend deemed it invalid.

#### 无效

如果服务器端认为一条记录无效即无法保存，就会通知适配器记录为无效的。

#### Error

#### 错误

A record enters the error state when the adapter is unable to save it
for some reason other than invalidity.

如果一条记录因为除无效之外的其他原因无法保存时，它就进入了错误状态。
