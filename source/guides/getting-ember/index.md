英文原文: [http://emberjs.com/guides/getting-ember/index/](http://emberjs.com/guides/getting-ember/index/)

## Ember构建

Ember的发布管理团队针对Ember和Ember Data维护了不同的发布方法。

### 频道

最新的Ember和Ember Data的[Release](/builds#/release)，[Beta](/builds#/beta)和[Canary](/builds#/canary)构建可以在[这里](/builds)找到。每一个频道都提供了一个开发版、最小化版和生产版。更多关于不同频道的信息可以查看博客[1.0后发布周期](http://emberjs.com/blog/2013/09/06/new-ember-release-process.html)。

### 标签发布

所有之前的Ember和Ember
Data的发布版本和beta版本构建都包含在[标签发布](/builds#/tagged)中。这些构建可以用来跟踪应用中的回归，不过还是建议在生产环境中使用最新的稳定版本的发布。

## Bower

Bower是Web的包管理器。Bower可以方便的管理应用的依赖，包括Ember和Ember
Data。希望了解更多关于Bower的信息，可以访问[http://bower.io](http://bower.io)。

在应用中通过bower来添加Ember非常容易，只需要运行`bower install ember
--save`即可。如果要添加Ember Data只需要执行`bower install ember-data
--save`。也可以手动将`ember`和`ember-data`添加到`bower.json`文件中，如下所示：

```json
{
	"name": "your-app",
	"dependencies": {
		"ember": "~1.5",
		"ember-data": "~1.0.0-beta.4"
	}
}

```

## RubyGems

如果应用采用了基于Ruby的构建系统，那么可以使用[ember-source](http://rubygems.org/gems/ember-source)和[ember-data-source](http://rubygems.org/gems/ember-data-source)RubyGems来从Ruby中访问Ember和Ember
Data。

如果应用在Rails中进行构建，那么[ember-rails](http://rubygems.org/gems/ember-rails)RubyGem将大大简化将Ember集成到Ruby on Rails应用的工作。
