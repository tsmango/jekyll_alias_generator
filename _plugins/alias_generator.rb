# jekyll_alias_generator 0.1.0
# 
# Alias Generator for Posts
#
# Generates redirect pages for posts with aliases set in the YAML Front Matter.
#
# Place the full path of the alias (place to redirect from) inside the
# destination post's YAML Front Matter. One or more aliases may be given.
#
# Example Post Configuration:
#
#   ---
#     layout: post
#     title: "How I Keep Limited Pressing Running"
#     alias: /post/6301645915/how-i-keep-limited-pressing-running/index.html
#   ---
#
# Example Post Configuration:
#
#   ---
#     layout: post
#     title: "How I Keep Limited Pressing Running"
#     alias: [/first-alias/index.html, /second-alias/index.html]
#   ---
#
# Author: Thomas Mango
# Site: http://thomasmango.com
# Plugin Source: http://github.com/tsmango/jekyll_alias_generator
# Site Source: http://github.com/tsmango/thomasmango.com
# PLugin License: MIT

require 'open-uri'

module Jekyll

  class AliasGenerator < Generator

    def generate(site)
      @site = site

      site.config['alias'] = site.config['alias'] || {}
      @type = site.config['alias']['type'] || 'html'
      if (@type != 'html' && @type != 'php')
        raise "Unsupported type for alias generator: #{@type}"
      end
      path = File.join File.dirname(__FILE__), 'alias_index.' + @type
      @template = File.read path

      process_posts
      process_pages
    end

    def process_posts
      @site.posts.each do |post|
        generate_aliases(post.url, post.data['alias'])
      end
    end

    def process_pages
      @site.pages.each do |page|
        generate_aliases(page.destination('').gsub(/index\.(html|htm)$/, ''), page.data['alias'])
      end
    end

    def generate_aliases(destination_path, aliases)
      alias_paths ||= Array.new
      alias_paths << aliases
      alias_paths.compact!

      alias_paths.flatten.each do |alias_path|
        alias_path = alias_path.to_s

        alias_dir  = File.extname(alias_path).empty? ? alias_path : File.dirname(alias_path)
        alias_dir  = URI::encode(alias_dir)
        alias_file = File.extname(alias_path).empty? ? "index." + @type : File.basename(alias_path)

        fs_path_to_dir   = File.join(@site.dest, alias_dir)
        alias_index_path = File.join(alias_dir, alias_file)

        FileUtils.mkdir_p(fs_path_to_dir)

        File.open(File.join(fs_path_to_dir, alias_file), 'w') do |file|
          file.write(alias_template(destination_path))
        end

        (alias_index_path.split('/').size + 1).times do |sections|
          @site.static_files << Jekyll::AliasFile.new(@site, @site.dest, alias_index_path.split('/')[0, sections].join('/'), nil)
        end
      end
    end

    def alias_template(destination_path)
      @template.gsub "\#{destination_path}", destination_path
    end
  end

  class AliasFile < StaticFile
    require 'set'

    def destination(dest)
      File.join(dest, @dir)
    end

    def modified?
      return false
    end

    def write(dest)
      return true
    end
  end
end
