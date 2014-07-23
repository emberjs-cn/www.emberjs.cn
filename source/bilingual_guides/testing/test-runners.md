When it comes to running your tests there are multiple approaches that you can take depending on what best suits your workflow. Finding a low friction method of running your tests is important because it is something that you will be doing quite often.

当运行测试时，可以在很多种不同的方案里选取最适合工作流的方案。找到一种摩擦最低的运行测试的方案非常重要，因为测试是一项经常要做的事情。

### <a name="browser"></a>The Browser

### <a name="browser"></a>浏览器

The simplest way of running your tests is just opening a page in the browser. The following is how to put a test "harness" around your app with qunit so you can run tests against it:

运行测试的最简单的方法是直接在浏览器中打开页面。下面将展示如何加入一个`qunit`的测试`harness`给应用，并可以针对其运行测试：

First, get a copy of `qunit` (both the JavaScript and the css) from [here][qunit].

首先，从[这里][qunit]获取一份`qunit`（包括Javascript和CSS）。

Next, create an HTML file that includes qunit and it's css that looks like the following example.

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

Finally, launch your browser of choice and open the above html file.

最后，使用选定的浏览器打开上面的文件。

That's it. You're done and your tests are running. No need to install and configure any other tools or have any other processes running. After adding or updating tests and/or code just reload the page and you're off to the races running your tests.

这样就完成了所有的工作，并且运行了测试。不需要安装和配置其他任何工具，或者运行一个其他的进程。在添加或者修改了测试或者代码后，重载页面即可重新运行测试。

If that meets your needs, read no further. However, if you would like a more automated way of running your tests, read on.

如果这已经满足了需求，那么不需要继续往下读了。但是，如果希望能有一种更加自动化的运行测试的方法，那么请继续往下读。

Manually opening and refreshing a browser may prove to be a bit of a tedious workflow for you. While you get the benefit of knowing that your code (and your tests) work in every browser that you are able to launch, it's still up to you to do the launching (and then refreshing) each time you make a change. Getting rid of repetition is why we use computers, so this can be a problem.

不停的手动的打开和刷新浏览器，很显然是一件非常乏味的工作。当知道代码可以在所有的浏览器中得到运行，这样能得到更多的利益，不过依然需要在修改代码后手动的启动和刷新来测试。消除重复的劳动本来就是使用计算机的原因之一，因此这里就是一个需要解决的问题。

Luckily there are tools to help with this. These tools allow you to run your tests in actual browsers (yes browsers - as in more than one at the same time) and then report the results back to you in a consolidated view. These tools are run from the command line and they are also capable of automatically re-running tests when changes are made to files. They require a bit more setup than creating a simple html file but they will likely save time in the long run.

幸运地是有工具能帮助我们完成这些工作。这些工具可以在实际的浏览器中运行测试（是浏览器 - 同一时间运行多个），并将测试结果通过一个综合的视图呈现。这些工具都是在命令行中执行的，并且也能在文件发送改变的时候自动重新运行测试。不过相比创建一个简单的HTML文件，这种方法需要进行一些额外的配置，不过从长远来说这也是能节约时间的。

### The Testem Runner

### Testem运行期

[Testem][testem] is a simple tool to setup and use. In a nutshell it will collect all of your application code, your test code, your testing framework of choice and build a test ["harness"](#browser) automatically.  It will then launch each browser (that you specify), run the tests and report the results back to you. It has a nice terminal-based user interface that will display test results for each browser. There are many features built into testem, but it does not seem to have any 3rd party plugins or extensions available.

[Testem][testem]是一个配置和使用都非常简单的工具。简单地说，其将收集所有应用代码、测试代码、选择的测试框架，并自动创建一个测试["harness"](#browser)。然后启动每个浏览器（指定的）来运行测试，并将结果返回。`Testem`有非常好的基于终端的用于显示每个浏览器测试结果的用户接口。`testem`内置了非常多的特性，目前还没有任何第三方的插件或者扩展。

To get started using `testem`, you'll need to install the `testem` node.js module. Assuming you have [node][node] installed, run the following command:

为了使用`testem`，需要在node.js中安装`testem`模块。假设已经安装了[node][node]，那么只需要运行如下命令即可：

```bash
npm install -g --save-dev testem
```

`Testem` is now available to run your tests. There is just a little bit of configuration that needs to be done first.

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

That's it. Everything you need is installed and configured. Let's go over the configuration in more detail.

以上就是需要安装和配置的全部内容。现在再详细的回顾一下配置。

* `framework`
 - This represents the testing framework that you are going to be using. Qunit is what we are using in this example. `Testem` takes care of getting the qunit library loaded up so you don't have to worry about it.
 - 表示将使用的测试框架是什么。这里使用的是`QUnit`。`Testem`会完成对`QUnit`库的加载，因此不需要担心`QUnit`的加载问题。
* `src_files`
 - This represents which of your source files (including both production and test code) that you want `testem` to load when running tests.
 - 表示需要`testem`在运行测试是需要加载的源文件（包括产品代码和测试代码）。
* `launch_in_dev`
 - This allows you to configure which browsers to launch and run the tests. This can be one or more browsers. When multiple are specified your tests will run in all browsers concurrently.
 - 这里可以配置需要启动用来测试的浏览器。合理可以设置一个或多个浏览器。当设置了多个浏览器时，测试时会并发启动这些浏览器来进行测试。
* `launch_in_ci`
 - This allows you to configure which browsers to launch and run the tests in 'ci' mode. This is specifically geared towards [continuous integration][ci] environments that may be headless.
 - 这里可以配置哪个浏览器将用来做持续集成的测试。这里特指`headless`的[持续集成][ci]环境。


There are plenty of other options that you can configure as well if you would like. To see a list of available options you can check out the [testem documentation][testem].

除以上配置外，`testem`还提供了更多的参数，如果愿意的话可以进行更详细的配置。可以在[testem文档][testem]中找到所有可用的配置项的详细说明。

To start `testem` run the following command.

执行下述命令来运行`testem`。

```bash
testem
```

This will start testem and launch all of your browsers listed in the `launch_in_dev` setting. A tabbed view, one tab for each browser listed, will appear that you can cycle through using the arrow keys to see the test results in each browser. There are other commands that you can use as well, run `testem -h` to see the list of all available commands in the tabbed view. `Testem` will continually run and re-run your tests when changes are made to your files listed in the `src_files` setting.
 这将启动`testem`，并且启动所有在`launch_in_dev`配置的所有浏览器。可以看到一个基于标签的视图，每个标签对应一个浏览器，通过箭头按键可以查看每个浏览器的执行结果。此外还有一些其他的命令，运行`testem -h`可以查看能在标签视图中使用的所有命令。当`src_files`指定的文件发生改变时，`Testem`将持续的运行或者重新运行测试。

The `launch_in_ci` setting comes into play when you run `testem` with the following command.

`launch_in_ci`设置在采用如下命令执行`testem`时生效：

```bash
testem ci
```

Much like running `testem` with no arguments, the `ci` option will use your same configuration except it will use the `launch_in_ci` rather than the `launch_in_dev` list of browsers. This `ci` option will also cause `testem` to run all of the tests once and exit printing the results to the terminal.

与运行不带参数的`testem`非常相似，除了其会使用`launch_in_ci`取代`launch_in_dev`设置的浏览器列表外，`ci`选项会使用相同的配置。`ci`选项同样会采用`testem`运行一遍所有的测试，并将测试结果输出到终端。

### The Karma Test Runner

### Karma测试运行器

[Karma][karma] is another simple tool to setup and use. It is similar to testem in that it will collect all of your application code, your test code, your testing framework of choice and build a test ["harness"](#browser) automatically. It will then launch each browser (that you specify), run the tests and report the results back to you. The terminal user interface is not as fancy as testem, but there is a colored display of test results for each browser. Karma has many features as well as many plugins. For information about writing karma plugins checkout [the docs][karma_plugins]. To find some available karma plugins start with [karma_runner][karma_github] on github.

[Karma][karma]是另一个易于配置和使用的工具。与`testem`相似，`karma`也会收集所有应用代码，测试代码，选用的测试框架，并自动的创建一个测试["harness"](#browser)。之后也会启动指定的每一个浏览器，运行测试，并生成测试结果报告。其终端用户接口不像`testem`那么好，不过其会为每一个浏览器生成有颜色的测试结果输出。Karma的插件拥有许多非常有用的特性。如果想了解更多关于编写`karma`插件的文档可以访问[这里][karma_plugins]。在[karma_runner][karma_github]可以获取一些可用的`karma`插件。

To get started using `karma` you will need to install a few node modules. Here is an example of a [package.json][package.json] file which includes everything that you will need to get started.

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

The three dependencies are `karma` itself, `karma-qunit` which includes everything that you will need to run qunit tests and `karma-phantomjs-launcher` which is what `karma` will use to fire up an instance of the headless PhantomJS browser to run your tests in. There are a number of different launchers that you can plug into the `karma` test runner including but not limited to Google Chrome, FireFox, Safari, IE, and even [Sauce Labs][sauce_labs]. To see a complete list of all of the available launchers check out [Karma's Github][karma_github].

这三个依赖都是`karma`自己，`karma-qunit`包含了需要运行`qunit`测试需要的一切，而`karma-phantomjs-launcher`是`karma`测试运行器用来启动一个无头的`PhantomJS`浏览器来运行测试的模块。还有许多不同的插件用来启动不同的浏览器，包括Google Chrome，Firefox，Safari，IE，甚至[Sauce Labs][sauce_labs]。在[Karma Github][karma_github]有一个完整的可用启动器的列表。

Now that you've got a `package.json` containing everything that you will need to get started with `karma` run the following command (in the same directory as your `package.json` file) to download and install everything.

现在有了一个包含所有运行`karma`所需的一切的`package.json`文件，那么可以运行下面的命令（在`package.json`文件所在的目录下）来安装这些模块。

```bash
npm install
```

`Karma` along with everything else that you need to start running your tests is now available. There is a little bit of configuration that needs to be done first. If you want to generate the default `karma` configuration you can run `karma init` and that will create a `karma.conf.js` file in your current directory. There are many configuration options available, so here's a pared down version: ie, the minimum configuration that Karma requires to run your tests.

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
There is one last thing that you need to install: Karma's command line interface.

最后还有一样需要安装：`Karma`命令行接口。

```bash
npm install -g karma-cli
```

That's it. Everything you need is installed and configured. Let's go over the configuration in more detail.

这就是所有需要安装和配置的全部内容。下面来仔细看看这些配置。

* `frameworks`
 - This represents the testing frameworks that you're going to use. We're using QUnit in this example. Karma takes care of loading up the QUnit library for you.
 - 这代表将要采用的测试框架。本例中使用`QUnit`。`karma`会自动加载`QUnit`库。
* `files`
 - This represents which of your source files (including both production and test code) that you want `karma` to load when running tests.
 - 这代表哪些源文件（包括产品和测试代码）需要`karma`在运行测试时加载。
* `autoWatch`
 - A value of `true` will mean that `karma` will watch all of the `files` for changes and rerun the tests only when `singleRun` is `false`.
 - 当`singleRun`的值为`false`时，如果`autoWatch`值为`true`表示`karma`将观察所有`files`的修改，并重新运行测试。
* `singleRun`
 - A value of `true` will run all of the tests one time and shut down, whereas a value of `false` will run all of your tests once, then wait for any files to change which will trigger re-running all your tests.
 - 如果值为`true`表示将只运行所有测试一次就关闭，如果值为`false`将运行所有测试一次，当有文件发生改变时，会再次运行所有测试。
* `browsers`
 - This allows you to configure which browsers to launch and run the tests. This can be one or more browsers. When multiple are specified your tests will run in all browsers concurrently.
 - 本选项用来配置使用哪些浏览器来加载和运行测试。可以是一个或多个浏览器。当指定了多个浏览器时，测试讲并发的在所有的浏览器中运行。

There are plenty of other options that you can configure as well if you would like. To see a list of available options you can check out the [Karma documentation][karma] or instead of manually creating `karma.conf.js` you can run the following command.

除以上配置以外，还有大量的配置项可以用来配置`karma`。查看[karma文档][karma]可以看到所有的配置项，除了手动创建`karma.conf.js`外，还可以运行下面的命令来生成：

```bash
karma init
```

To start `karma` run

启动`karma`运行：

```bash
karma start
```

Depending on your configuration it will either run the tests and exit or run the tests and wait for file changes to run the tests again.

至于是运行完测试后退出，还是等待文件改变来重新运行测试，取决于配置。


### Build Integration

### 构建集成

Both `testem` and `karma` are capable of being integrated into larger build processes. For example, you may be using [CoffeeScript][coffee], [ES6][es6] or something else and need to [transpile][transpile] your source into `JavaScript`. If you happen to be using `grunt` you can use `grunt-contrib-testem` for `testem` or `grunt-karma` for `karma` integration into your existing build process. Both `testem` and `karma` have preprocessing configuration options available as well. For more information on other available configuration options see the docs for [karma][karma] or [testem][testem].

`testem`和`karma`都可以与大的构建过程进行集成。例如，项目中可能使用了[CoffeeScript][coffee]，[ES6][es6]或者其他需要转换源代码到`Javascript`的某些技术。如果使用了`grunt`，那么可以为`testem`使用`grunt-contrib-testem`，为`karma`选择`grunt-karma`来集成到构建过程里。`testem`和`karma`都有预处理配置选项。更多关于配置项的信息请查看[karma][karma]和[testem][testem]的文档。


### Generating Reports

### 生成报告

Oftentimes it's useful to get the results of your tests in different formats. For example, if you happen to use [Jenkins][jenkins] as a [ci][ci] server, you may want to get your test results in XML format so Jenkins can build some graphs of your test results over time. Also, you may want to measure your [code coverage][coverage] and have Jenkins track that over time as well. With these test runners, it's possible to generate reports from the results in various formats, as well as record other information such as code-test coverage, etc.

通常获取测试结果的不同格式的输出是非常有用的。例如，采用了[Jenkins][jenkins]作为[持续集成][ci]服务器，那么可能就希望获取到XM格式的测试结果，以便`Jenkins`能够为测试结构生成报表图。此外，也可能希望使用Jenkins一直跟踪[测试覆盖率][coverage]。使用这些测试运行器，可以根据测试结果生成不同格式的报告，对于测试覆盖率的信息也是一样。

#### XML Test Results from Testem

#### Testem XML测试结果

To get [junit xml][junitxml] from the `testem` test runner you can simply add a flag to the command when you run `testem` and pipe the output to a file like the following command.

为了使`testem`生成[junit
xml][junitxml]，只需在运行`testem`的时候添加一个标志，将输出定向到一个文件即可。

```bash
testem ci -R xunit > test-results.xml
```

That's it! Now you can use `test-results.xml` to feed into another tool.

现在就可以在其他的工具中使用`test-results.xml`了。


#### XML Test Results from Karma

#### Karma XML测试结果

To get [junit xml][junitxml] from the `karma` test runner you will need to install a new node.js module. You can do so with the following command.

为了使`karma`生成[junit
xml][junitxml]，需要安装一个node.js模块。通过下面的命令可以完成模块的安装。

```bash
npm install --save-dev karma-junit-reporter
```

Once that is done you will need to update your karma configuration to include the following.

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

The reporters option determines how your test results are communicated back to you. The `progress` reporter will display a line that says something like this.

`reporters`选项决定了测试结果如何返回。`progress`报告将会显示如下信息。

```
PhantomJS 1.9.7 (Mac OS X): Executed 2 of 2 SUCCESS (0.008 secs / 0.002 secs)
```

The `junit` reporter will create an xml file called `test-results.xml` in the current directory that contains junit xml which can be used as input to other tools. This file can be renamed to whatever you would like. For more information see the docs for [karma junit reporter][karma_junit_reporter].

`junit`报告会在当前目录下生成一个`test-results.xml`文件，文件中包含了可以用作其他工具的输入的junit
xml。文件可以重命名为其他任意的名字。更多的信息请查看[karma junit
reporter][karma_junit_reporter]文档。

#### Code Coverage from Testem

#### Testem测试覆盖率

Getting coverage from `testem` is a bit more involved at the moment, though there **is** a way to do it. Check the [testem docs][testem_coverage] for more information.

使用`testem`生成测试覆盖率报告，目前需要更多的关注，尽管可以实现。更多的信息请查看[testem文档][testem_coverage]。


#### Code Coverage from Karma

#### Karma测试覆盖率

To measure your [code coverage][coverage] from the `karma` test runner you will need to install a new node.js module. You can do so with the following command.

使用karma来生成[代码测试覆盖率][coverage]需要安装另外一个node.js模块，通过下面的命令可以完成模块的安装。

```bash
npm install --save-dev karma-coverage
```

Once that's done you will need to update your karma configuration to include the following.

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

That's it. Now, running `karma` normally will display code coverage information in the terminal. The `coverageReporter.type` option can be set to a number of different values. The value in the example, `text`, will only display to the console. Some other options are `lcov`, `html` and `cobertura` which can be used as input to other tools. For additional configuration options on coverage reporting from `karma` check out their [docs][karma_coverage_docs].

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
