# -*- encoding: utf-8 -*-
xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title "EmberJS.CN Blog"
  xml.subtitle "Ember JS相关新闻与资源"
  xml.id "http://emberjs.cn/blog"
  xml.link "href" => "http://emberjs.cn/blog"
  xml.link "href" => "http://emberjs.cn/blog/feed.xml", "rel" => "self"
  xml.updated blog.articles.first.date.to_time.iso8601
  xml.author { xml.name "EmberJS.CN" }

  blog.articles[0..5].each do |article|
    xml.entry do
      entry_url = "http://emberjs.cn#{article.url}"

      xml.title article.title
      xml.link "rel" => "alternate", "href" => entry_url                                                                                                   
      xml.id entry_url
      xml.published article.date.to_time.iso8601
      xml.updated article.date.to_time.iso8601
      xml.author { xml.name "EmberJS.CN" }
      xml.summary article.summary, "type" => "html"
      xml.content article.body, "type" => "html"
    end
  end
end
