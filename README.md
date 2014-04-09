# Alias Generator for Posts

Generates redirect pages for posts with aliases set in the YAML Front Matter.

## How to Run
Place `alias_generator.rb` in your `plugins` directory, and ensure
that you can run custom plugins (set `safe:` to `false` in `_config.yml`).
Whenever you generate your Jekyll site, redirect pages will be created 
at the alias path in your output directory; for example,
`_site/post/6301645915/how-i-keep-limited-pressing-running/index.html`.

## How to Use
Place the full path of the alias (place to redirect from) inside the
destination post's YAML Front Matter. One or more aliases may be given.

Example Post Configuration:

    ---
      layout: post
      title: "How I Keep Limited Pressing Running"
      alias: /post/6301645915/how-i-keep-limited-pressing-running/index.html
    ---

Example Post Configuration:

    ---
      layout: post
      title: "How I Keep Limited Pressing Running"
      alias: [/first-alias/index.html, /second-alias/index.html]
    ---

## License

Released under the MIT license.
