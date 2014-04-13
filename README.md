# Middleman::Webp

This is [Middleman][middleman] extension that generates WebP versions
of each image used in site during build.

WebP is image format developed by Google and it usually generates
smaller files than regular jpeg or png formats.

Browser's supporting WebP will include Accepts header to the image
file requests so you can refer to jpegs or pngs in your HTML and use
for example .htaccess configuration to provide smaller alternatives
for browser's supporting WebP.

See my blog post
["Introducing WebP extension for Middleman"][blog-post] for more
details why I think using WebP matters.

[middleman]: http://middlemanapp.com
[blog-post]: http://byteplumbing.net/2014/03/introducing-webp-extension-for-middleman/

## Installation

Middleman-webp depends on cwep and gif2webp commandline tools, so
install those first for your system.

- Fedora: yum install libwebp-tools
- Ubuntu: apt-get install webp
- OS X: brew install webp

Add this line to your Middleman site's Gemfile:

    gem 'middleman-webp'

And then execute:

    $ bundle

And activate :webp extension in your config.rb:

``` ruby
activate :webp
```

Options for conversion are defined using
[Ruby's glob syntax](http://www.ruby-doc.org/core-2.1.1/Dir.html#method-c-glob)
or [Regexp](http://www.ruby-doc.org/core-2.1.1/Regexp.html) for
matching image files and hashes containing args supported by cwebp:

``` ruby
activate :webp do |webp|
  webp.conversion_options = {
    "icons/*.png" => {lossless: true},
    "photos/**/*.jpg" => {q: 100},
    /[0-9]/.+gif$/ => {lossy: true}
  }
end
```

## Configuring your site to provide WebP alternatives

Configure web server to serve WebP images if they are available and
browser has set the HTTP Accept header.

Look for [this example how to do it in .htaccess][htaccess].

[htaccess]: https://github.com/vincentorback/WebP-images-with-htaccess

## Contributing

1. Fork it ( http://github.com/iiska/middleman-webp/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
