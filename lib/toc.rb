require 'redcarpet'
# -*- encoding: utf-8 -*-

module TOC
  class << self
    def registered(app)
      app.helpers Helpers
    end
    alias :included :registered
  end

  module TableOfContents
    extend self

    def anchorify(text)
      text.gsub(/&#?\w+;/, '-').gsub(/\W+/, '-').gsub(/^-|-$/, '').downcase
    end
  end

  module Helpers
    def index_for(data, scope = :guides)
      result = '<ol id="toc-list">'

      data.each_entry do |section, entries|
        next if entries.any? do |entry|
          entry[:skip_sidebar]
        end

        request_path_splits = request.path.split('/')

        current_url = request_path_splits[1]
        sub_url     = request_path_splits[2]
        intro_page  = request_path_splits.length == 3
        sub_url     = nil if intro_page
        chapter     = entries[0].url.split("/")[0]

        current = (chapter == current_url)

        result << %Q{
          <li class="level-1#{current ? ' selected' : ''}">
            <a href="/#{scope}/#{entries[0].url}">#{section}</a>
            <ol#{current ? " class='selected'" : ''}>
        }

        entries.each do |entry|
          next if entry[:skip_sidebar_item]

          current_segment = entry.url.split("/")[1]

          sub_current = if current_segment and current_segment == sub_url
            true
          elsif intro_page and current_url == entry.url
            true
          else
            false
          end

          result << %Q{
            <li class="level-3#{sub_current ? ' sub-selected' : ''}">
              <a href="/#{scope}/#{entry.url}">#{entry.title}</a>
            </li>
          }
        end

        result << '</ol></li>'
      end

      result << '</ol>'

      result
    end

    def chapter_name
      current_guide ? current_guide.title : ''
    end

    def section_name
      current_section[0] if current_section
    end

    def chapter_heading
      name = chapter_name.strip
      return if name.blank?

      %Q{
        <h1>#{name} 
          <a href="#{chapter_github_source_url}" target="_blank" class="edit-page">
            编辑页面</a>
        </h1>
      }
    end

    def section_slug
      request.path.split('/')[1]
    end

    def guide_slug
      request.path.split('/')[1..-2].join('/')
    end

    def chapter_github_source_url
      base_guide_url = "https://github.com/emberjs-cn/www.emberjs.cn/tree/master/source/guides"
      if section_slug == guide_slug
        return "#{base_guide_url}/#{current_guide['url']}/index.md"
      else
        return "#{base_guide_url}/#{current_guide['url'].gsub(/.html/, '')}.md"
      end
    end

    def current_section
      section_prefix = section_slug + "/"
      data.guides.find do |section, entries|
        entries.find do |entry|
          url = entry.url
          url.starts_with?(section_prefix) || url == section_slug
        end
      end
    end

    def current_guide
      return unless current_section

      if guide_slug == '' && section_slug == 'index.html'
        current_section[1][0]
      else
        current_section[1].find do |guide|
          guide.url == guide_slug
        end
      end
    end

    def chapter_links(scope = :guides)
      %Q{
      <footer>
        #{previous_chapter_link(scope)} #{next_chapter_link(scope)}
      </footer>
      }
    end

    def previous_chapter_link(scope = :guides)
      if previous_chapter
        %Q{
          <a class="previous-guide" href="/#{scope}/#{previous_chapter.url}">
            \u2190 #{previous_chapter.title}
          </a>
        }
      elsif whats_before = previous_guide
        previous_chapter = whats_before[1][-1]
        %Q{
          <a class="previous-guide" href="/#{scope}/#{previous_chapter.url}">
             \u2190 #{whats_before[0]}: #{previous_chapter.title}
          </a>
        }
      else
        ''
      end
    end

    def next_chapter_link(scope = :guides)
      if next_chapter
      %Q{
        <a class="next-guide" href="/#{scope}/#{next_chapter.url}">
          #{next_chapter.title} \u2192
        </a>
      }
      elsif whats_next = next_guide
        next_chapter = whats_next[1][0]
        if section_slug == 'index.html'
          %Q{
            <a class="next-guide" href="/guides/#{next_chapter.url}">
              #{next_chapter.title} \u2192
            </a>
          }
        else
          %Q{
            <a class="next-guide" href="/guides/#{next_chapter.url}">
              本章#{current_section[0]}完毕。下一章： #{whats_next[0]} - #{next_chapter.title} \u2192
            </a>
          }
        end
      else
        ''
      end
    end

    def previous_chapter
      return if not current_section

      guides = current_section[1]
      current_index = guides.find_index(current_guide)

      return unless current_index

      if current_index != 0
        guides[current_index-1]
      else
        nil
      end
    end

    def next_chapter
      return if not current_section

      guides = current_section[1]
      current_index = guides.find_index(current_guide)
      return unless current_index

      next_guide_index = current_index + 1

      if current_index < guides.length
        guides[next_guide_index]
      else
        nil
      end
    end

    def next_guide
      return if not current_section
      guide = current_section[0]
      current_guide_index = data.guides.keys.find_index(guide)

      return unless current_guide_index

      next_guide_index = current_guide_index + 1

      if current_guide_index < data.guides.length
        data.guides.entries[next_guide_index]
      else
        nil
      end
    end

    def previous_guide
      return if not current_section
      guide = current_section[0]

      current_guide_index = data.guides.keys.find_index(guide)
      return unless current_guide_index

      previous_guide_index = current_guide_index - 1

      if previous_guide_index >= 0
        data.guides.entries[previous_guide_index]
      else
        nil
      end
    end

    def warning
      return unless current_guide
      return unless current_section
      warning_key = current_guide["warning"]
      warning_key ? WARNINGS[warning_key] : nil
    end

    WARNINGS = {
        "canary"=>  %Q{
          <div class="under_construction_warning">
            <h3>
              <div class="msg">
                WARNING: this guide refers to a feature only available in canary (nightly/unstable) builds of Ember.js.
              </div>
            </h3>
          </div>
        },
        "canary-data"=>  %Q{
          <div class="under_construction_warning">
            <h3>
              <div class="msg">
                WARNING: this guide refers to a feature only available in canary (nightly/unstable) builds of Ember Data.
              </div>
            </h3>
          </div>
        },
        "query-params-warning"=> %Q{
          <div class="under_construction_warning">
            <h3>
              <div class="msg">
                <strong>WARNING:</strong> query params are an experimental feature. You must be using a recent canary build of Ember, and enable the <code>query-params-new</code> feature flag. For more info on enabling feature flags visit <a href="http://emberjs.com/guides/configuring-ember/feature-flags/">the Feature Flags guide</a>
              </div>
            </h3>
          </div>
        }
    }
  end
end

::Middleman::Extensions.register(:toc, TOC)
