英文原文：[http://emberjs.com/guides/getting-started/planning-the-application](http://emberjs.com/guides/getting-started/planning-the-application)

尽管TodoMVC是一个小应用，但是它涵盖了现今典型单页面应用（single page applications）几乎所有的行为。在继续之前，先从用户视角了解一下TodoMVC是怎样工作的。

TodoMVC包含了以下几个主要功能：

<img src="/guides/getting-started/images/todo-mvc.png" width="680">

  1. 为用户提供一个todos的列表，并且会随着用户添加或移除todos进行增长与缩减。

  1. 从一个 `<input>` 框接收文本作为新建todos的入口，当点击 `<enter>` 时，创建一项，并在列表下方显示。

  1. 为每一个todo提供一个 `checkbox` 用于切换完成与未完成状态。新建的todo默认为未完成状态。

  1. 显示所有未完成的todos的数量，并在添加新todos和现有todos完成时，动态改变显示的值。

  1. 提供导航链接，使用户能切换显示全部（all）、未完成（incomplete）与完成（completed）的todos。

  1. 提供一个按钮用于提示用户当前已完成的todos数目，并在点击时移除所有已完成的todos。当无已完成todos时，此按钮不显示。

  1. 为每一个todo提供一个删除按钮，这个按钮显示为一个红色的X，并只在用户鼠标移动到这个todo上时显示。

  1. 提供一个 `checkbox` 用于切换列表中所有的todos的完成与未完成状态。而且，当所有的todos状态为完成时，它自动变为勾选状态。

  1. 允许用户双击某一个todo，显示一个 `textfield` 用于修改这个todo。点击 `<enter>` 或者当鼠标焦点从这个 `textfield` 移除时，持久化更改的内容。

  1. 使用 `本地存储(localstorage)` 机制保存用户的todos列表，在应用程序启动时重新加载。

你可以通过访问[the TodoMVC site](http://addyosmani.github.com/todomvc/)来体验一下完整的版本。
