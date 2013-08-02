英文原文：[http://emberjs.com/guides/components/](http://emberjs.com/guides/components/)

中英对照：[http://emberjs.cn/bilingual_guides/components/](http://emberjs.cn/bilingual_guides/components/)

HTML was designed in a time when the browser was a simple document
viewer. Developers building great web apps need something more.

HTML设计之初浏览器还只是一个简单的文档阅读器。而今开发者需要更多东西来构建精彩的Web应用。

Instead of trying to replace HTML, however, Ember.js embraces it, then adds
powerful new features that modernize it for building web apps.

Ember.js没有选择去尝试替换掉HTML，而是通过增强HTML，来添加一些非常有用的新特性给HTML，使其能跟上时代的脚步，可以用来构建Web应用。

Currently, you are limited to the tags that are created for you by the
W3C. Wouldn't it be great if you could define your own,
application-specific HTML tags, then implement their behavior using
JavaScript?

目前，能使用的标签仅限于W3C定义的。如果可以进行自定义应用相关的HTML标签，并能够通过Javascript来实现其行为，将带来非常大的帮助。

That's exactly what components let you do. In fact, it's such a good
idea that the W3C is currently working on the [Custom
Elements](https://dvcs.w3.org/hg/webcomponents/raw-file/tip/spec/custom/index.html)
spec.

这正是组件提供的功能。实际上，这也是W3C正在定义的一个非常好的想法[自定义元素规范](https://dvcs.w3.org/hg/webcomponents/raw-file/tip/spec/custom/index.html)

Ember's implementation of components hews as closely to the Web
Components specification as possible. Once Custom Elements are widely
available in browsers, you should be able to easily migrate your Ember
components to the W3C standard and have them be usable by other
frameworks.

Ember中组件的实现与Web组件规范非常接近。一旦自定义元素被浏览器广泛的支持后，能非常容易的将Ember组件迁移为W3C标准实现，使其能在其他的框架中得到使用。

This is so important to us that we are working closely with the
standards bodies to ensure our implementation of components matches the
roadmap of the web platform.

紧紧跟随标准，确保组件的实现与Web平台的发展路线图一致，这一点非常重要。

To highlight the power of components, here is a short example of turning a blog post into a reusable
`blog-post` custom element that you could use again and again in your
application. Keep reading this section for more details on building
components.

为了展示组件超凡的作用，这里给出了一个简单的例子，本例使用一个自定义的`blog-post`元素来表示一篇博客，该标签可以不停的在应用中重复使用。可以通过继续阅读本章其他部分来进一步了解如何创建组件。

<a class="jsbin-embed" href="http://jsbin.com/ifuxey/2/embed?live">JS Bin</a><script src="http://static.jsbin.com/js/embed.js"></script>
