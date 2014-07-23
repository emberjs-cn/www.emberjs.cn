英文原文：[http://emberjs.com/guides/testing/test-runners/](http://emberjs.com/guides/testing/test-runners/)

当运行测试时，可以在很多种不同的方案里选取最适合工作流的方案。找到一种摩擦最低的运行测试的方案非常重要，因为测试是一项经常要做的事情。

### <a name="browser"></a>浏览器

运行测试的最简单的方法是直接在浏览器中打开页面。下面将展示如何加入一个`qunit`的测试`harness`给应用，并可以针对其运行测试：

首先，从[这里][qunit]获取一份`qunit`（包括Javascript和CSS）。

然后，创建一个HTML文件来包含`qunit`，如下例所示：

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>QUnit Example</title>
  <link rel="stylesheet" href="qunit.css">
</head>
<body>
  <div id="qunit"></div>
  <div id="qunit-fixture"></div>
  <script src="qunit.js"></script>
  <script src="your_ember_code_here.js"></script>
  <script src="your_test_code_here.js"></script>
</body>
</html>
```

最后，使用选定的浏览器打开上面的文件。

这样就完成了所有的工作，并且运行了测试。不需要安装和配置其他任何工具，或者运行一个其他的进程。在添加或者修改了测试或者代码后，重载页面即可重新运行测试。

如果这已经满足了需求，那么不需要继续往下读了。但是，如果希望能有一种更加自动化的运行测试的方法，那么请继续往下读。

不停的手动的打开和刷新浏览器，很显然是一件非常乏味的工作。当知道代码可以在所有的浏览器中得到运行，这样能得到更多的利益，不过依然需要在修改代码后手动的启动和刷新来测试。消除重复的劳动本来就是使用计算机的原因之一，因此这里就是一个需要解决的问题。

幸运地是有工具能帮助我们完成这些工作。这些工具可以在实际的浏览器中运行测试（是浏览器 - 同一时间运行多个），并将测试结果通过一个综合的视图呈现。这些工具都是在命令行中执行的，并且也能在文件发送改变的时候自动重新运行测试。不过相比创建一个简单的HTML文件，这种方法需要进行一些额外的配置，不过从长远来说这也是能节约时间的。

### Testem运行期

[Testem][testem]是一个配置和使用都非常简单的工具。简单地说，其将收集所有应用代码、测试代码、选择的测试框架，并自动创建一个测试["harness"](#browser)。然后启动每个浏览器（指定的）来运行测试，并将结果返回。`Testem`有非常好的基于终端的用于显示每个浏览器测试结果的用户接口。`testem`内置了非常多的特性，目前还没有任何第三方的插件或者扩展。

为了使用`testem`，需要在node.js中安装`testem`模块。假设已经安装了[node][node]，那么只需要运行如下命令即可：

```bash
npm install -g --save-dev testem
```

现在完成一个简单的配置，就可以使用`Testem`来运行测试了。

```javascript
// testem.json
{
    "framework": "qunit",
    "src_files": [
      "your_ember_code_here.js",
      "your_test_code_here.js"
    ],
    "launch_in_dev": ["PhantomJS"],
    "launch_in_ci": ["PhantomJS"]
}
```

以上就是需要安装和配置的全部内容。现在再详细的回顾一下配置。

* `framework`
 - 表示将使用的测试框架是什么。这里使用的是`QUnit`。`Testem`会完成对`QUnit`库的加载，因此不需要担心`QUnit`的加载问题。
* `src_files`
 - 表示需要`testem`在运行测试是需要加载的源文件（包括产品代码和测试代码）。
* `launch_in_dev`
 - 这里可以配置需要启动用来测试的浏览器。合理可以设置一个或多个浏览器。当设置了多个浏览器时，测试时会并发启动这些浏览器来进行测试。
* `launch_in_ci`
 - 这里可以配置哪个浏览器将用来做持续集成的测试。这里特指`headless`的[持续集成][ci]环境。

除以上配置外，`testem`还提供了更多的参数，如果愿意的话可以进行更详细的配置。可以在[testem文档][testem]中找到所有可用的配置项的详细说明。

执行下述命令来运行`testem`。

```bash
testem
```
 这将启动`testem`，并且启动所有在`launch_in_dev`配置的所有浏览器。可以看到一个基于标签的视图，每个标签对应一个浏览器，通过箭头按键可以查看每个浏览器的执行结果。此外还有一些其他的命令，运行`testem -h`可以查看能在标签视图中使用的所有命令。当`src_files`指定的文件发生改变时，`Testem`将持续的运行或者重新运行测试。

`launch_in_ci`设置在采用如下命令执行`testem`时生效：

```bash
testem ci
```

与运行不带参数的`testem`非常相似，除了其会使用`launch_in_ci`取代`launch_in_dev`设置的浏览器列表外，`ci`选项会使用相同的配置。`ci`选项同样会采用`testem`运行一遍所有的测试，并将测试结果输出到终端。

### Karma测试运行器

[Karma][karma]是另一个易于配置和使用的工具。与`testem`相似，`karma`也会收集所有应用代码，测试代码，选用的测试框架，并自动的创建一个测试["harness"](#browser)。之后也会启动指定的每一个浏览器，运行测试，并生成测试结果报告。其终端用户接口不像`testem`那么好，不过其会为每一个浏览器生成有颜色的测试结果输出。Karma的插件拥有许多非常有用的特性。如果想了解更多关于编写`karma`插件的文档可以访问[这里][karma_plugins]。在[karma_runner][karma_github]可以获取一些可用的`karma`插件。

为了开始使用`karma`，需要安装一些`node`模块。下面是一个[package.json][package.json]示例文件，其包含了所有`karma`运行需要的模块。

```javascript
// package.json
{
  "name": "your_project_name",
  "version": "0.1.0",
  "devDependencies": {
    "karma-qunit": "0.1.1",
    "karma-phantomjs-launcher": "0.1.2",
    "karma": "0.12.1"
  }
}
```

这三个依赖都是`karma`自己，`karma-qunit`包含了需要运行`qunit`测试需要的一切，而`karma-phantomjs-launcher`是`karma`测试运行器用来启动一个无头的`PhantomJS`浏览器来运行测试的模块。还有许多不同的插件用来启动不同的浏览器，包括Google Chrome，Firefox，Safari，IE，甚至[Sauce Labs][sauce_labs]。在[Karma Github][karma_github]有一个完整的可用启动器的列表。

现在有了一个包含所有运行`karma`所需的一切的`package.json`文件，那么可以运行下面的命令（在`package.json`文件所在的目录下）来安装这些模块。

```bash
npm install
```

现在`karma`连同所有需要用来开始运行测试的东西都准备就绪了。不过还需要进行一点点额外的配置。如果只需要生成缺省的`karma`配置，可以执行`karma
init`，这将会在当前目录创建一个名为`karma.conf.js`的配置文件。配置有许多选项，这里给出一个精简版本的配置：`karma`需要用来运行测试的最小配置。

```javascript
// karma.conf.js
module.exports = function(config) {
  config.set({
    frameworks: ['qunit'],
    files: [
      "your_ember_code_here.js",
      "your_test_code_here.js"
    ],
    autoWatch: true,
    singleRun: true,
    browsers: ['PhantomJS']
  });
};
```

最后还有一样需要安装：`Karma`命令行接口。

```bash
npm install -g karma-cli
```

这就是所有需要安装和配置的全部内容。下面来仔细看看这些配置。

* `frameworks`
 - 这代表将要采用的测试框架。本例中使用`QUnit`。`karma`会自动加载`QUnit`库。
* `files`
 - 这代表哪些源文件（包括产品和测试代码）需要`karma`在运行测试时加载。
* `autoWatch`
 - 当`singleRun`的值为`false`时，如果`autoWatch`值为`true`表示`karma`将观察所有`files`的修改，并重新运行测试。
* `singleRun`
 - 如果值为`true`表示将只运行所有测试一次就关闭，如果值为`false`将运行所有测试一次，当有文件发生改变时，会再次运行所有测试。
* `browsers`
 - 本选项用来配置使用哪些浏览器来加载和运行测试。可以是一个或多个浏览器。当指定了多个浏览器时，测试讲并发的在所有的浏览器中运行。

除以上配置以外，还有大量的配置项可以用来配置`karma`。查看[karma文档][karma]可以看到所有的配置项，除了手动创建`karma.conf.js`外，还可以运行下面的命令来生成：

```bash
karma init
```

启动`karma`运行：

```bash
karma start
```

至于是运行完测试后退出，还是等待文件改变来重新运行测试，取决于配置。


### 构建集成

`testem`和`karma`都可以与大的构建过程进行集成。例如，项目中可能使用了[CoffeeScript][coffee]，[ES6][es6]或者其他需要转换源代码到`Javascript`的某些技术。如果使用了`grunt`，那么可以为`testem`使用`grunt-contrib-testem`，为`karma`选择`grunt-karma`来集成到构建过程里。`testem`和`karma`都有预处理配置选项。更多关于配置项的信息请查看[karma][karma]和[testem][testem]的文档。


### 生成报告

通常获取测试结果的不同格式的输出是非常有用的。例如，采用了[Jenkins][jenkins]作为[持续集成][ci]服务器，那么可能就希望获取到XM格式的测试结果，以便`Jenkins`能够为测试结构生成报表图。此外，也可能希望使用Jenkins一直跟踪[测试覆盖率][coverage]。使用这些测试运行器，可以根据测试结果生成不同格式的报告，对于测试覆盖率的信息也是一样。

#### Testem XML测试结果

为了使`testem`生成[junit
xml][junitxml]，只需在运行`testem`的时候添加一个标志，将输出定向到一个文件即可。

```bash
testem ci -R xunit > test-results.xml
```

现在就可以在其他的工具中使用`test-results.xml`了。


#### Karma XML测试结果

为了使`karma`生成[junit
xml][junitxml]，需要安装一个node.js模块。通过下面的命令可以完成模块的安装。

```bash
npm install --save-dev karma-junit-reporter
```

当安装上模块后，需要修改`karma`配置文件来包含下面的配置。

```javascript
module.exports = function(config) {
  config.set({
    /* snip */
    reporters: ['progress', 'junit'],
    /* snip */
  });
};
```

`reporters`选项决定了测试结果如何返回。`progress`报告将会显示如下信息。

```
PhantomJS 1.9.7 (Mac OS X): Executed 2 of 2 SUCCESS (0.008 secs / 0.002 secs)
```

`junit`报告会在当前目录下生成一个`test-results.xml`文件，文件中包含了可以用作其他工具的输入的junit
xml。文件可以重命名为其他任意的名字。更多的信息请查看[karma junit
reporter][karma_junit_reporter]文档。

#### Testem测试覆盖率

使用`testem`生成测试覆盖率报告，目前需要更多的关注，尽管可以实现。更多的信息请查看[testem文档][testem_coverage]。


#### Karma测试覆盖率

使用karma来生成[代码测试覆盖率][coverage]需要安装另外一个node.js模块，通过下面的命令可以完成模块的安装。

```bash
npm install --save-dev karma-coverage
```

安装完模块后，需要在karma的配置中添加下面的配置。

```javascript
module.exports = function(config) {
  config.set({
    /* snip */
    reporters: ['progress', 'coverage'],
    preprocessors: {
      "your_ember_code_here.js": "coverage",
      "your_test_code_here.js": "coverage"
    },
    coverageReporter: {
        type: "text",
    }
    /* snip */
  });
};
```

现在如同往常一样运行`karma`就能在终端中看到测试覆盖率信息的输出了。`coverageReporter.type`选项可以被设置为不同的值。示例中得值为`text`，将显示在控制台中。其他的值包括：`lcov`，`html`和`cobertura`，这些的输出可以用作其他工具的输入。`karma`更多关于测试覆盖率的配置项，可以查看[karma文档][karma_coverage_docs]。

[node]: http://nodejs.org/download/
[testem_coverage]: https://github.com/airportyh/testem/tree/master/examples/coverage_istanbul
[karma_coverage_docs]: http://karma-runner.github.io/0.8/config/coverage.html
[karma_junit_reporter]: https://github.com/karma-runner/karma-junit-reporter
[junitxml]: http://ant.apache.org/manual/Tasks/junitreport.html
[coverage]: http://en.wikipedia.org/wiki/Code_coverage
[qunit]: http://qunitjs.com/
[jenkins]: http://jenkins-ci.org/
[transpile]: http://en.wikipedia.org/wiki/Source-to-source_compiler
[es6]: http://square.github.io/es6-module-transpiler/
[ci]: http://en.wikipedia.org/wiki/Continuous_integration
[testem]: https://github.com/airportyh/testem
[coffee]: http://coffeescript.org/
[karma]: http://karma-runner.github.io/
[package.json]: https://www.npmjs.org/doc/json.html
[sauce_labs]: https://saucelabs.com/
[karma_github]: https://github.com/karma-runner?query=launcher
[karma_plugins]: http://karma-runner.github.io/0.10/config/plugins.html
[karma_runner]: https://github.com/karma-runner
