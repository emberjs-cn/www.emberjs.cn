---
title: 如何使用ember-dev来开发Ember包
authors: Tower He
tags: Recent Posts
---

### Ember Dev是什么？

Ember Dev是由Ember核心团队开发的一个用来辅助开发Ember包的工具。目前还处于“社会主义初级阶段”，可谓是“万里长征”迈出了好几步。目前Ember Dev已经包含了一些基本的工具，可以帮助我们提高Ember包开发的速度。其为我们搭建了开发、测试、发布等基本操作环境。用官方的语言来表达一下Ember Dev现在的状态：

  “目前Ember Dev还不推荐公众使用，因为还缺少一些重要的特性，比如缺少生成器。”

尽管如此，我们还是可以放心的使用Ember Dev来搭建Ember包项目的构建环境的。

### 基本目录结构

```
├── Assetfile
├── Gemfile
├── README.md
├── Rakefile
├── VERSION
├── config.ru
├── ember-dev.yml
├── generators
│   └── license.js
├── packages
│   └── ember-pkg-example
│       ├── lib
│       │   ├── core.js
│       │   └── main.js
│       ├── package.json
│       └── tests
├── project.json
└── tests
    └── ember_configuration.js
```

#### 目录与文件用途

1. `Assetfile`：
2. `Gemfile`：定义项目依赖的RubyGems。
3. `README.md`：项目说明文件，通常包括项目的简介、使用说明、开发指南等等。
4. `Rakefile`：项目开发过程中常使用的构建任务，通过`rake -T`可以查看任务清单。
5. `VERSION`：项目版本申明文件。
6. `config.ru`：Rack配置文件。
7. `ember-dev`：ember-dev配置文件。
8. `generators/license.js`：版权声明文件，该文件中的内容会被自动添加到生成的js文件的头部，用作版权声明。
9. `packages`：项目源代码目录，代码就是从这里开始的走向成功的。
10. `project.json`：bpm配置文件。
11. `tests/ember_configuration.js`：测试环境配置文件。

#### 实例代码

如果需要一个感性、直面的认识，那么赶紧去签出[ember-pkg-example](https://github.com/emberjs-cn/ember-pkg-example)的源代码，然后按照[README](https://github.com/emberjs-cn/ember-pkg-example/blob/master/README.md)一步步迈进吧。
