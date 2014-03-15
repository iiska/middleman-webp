# Middleman::Webp

This is [Middleman][middleman] extension that generates WebP versions
of each image used in site during build.

WebP is image format developed by Google and it usually generates
smaller files than regular jpeg or png formats.

Browser's supporting WebP will include Accepts header to the image
file requests so you can refer to jpegs or pngs in your HTML and use
for example .htaccess configuration to provide smaller alternatives
for browser's supporting WebP.

[middleman]: http://middlemanapp.com

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

## Configuring your site to provide WebP alternatives

TODO: Write about .htaccess aproach

TODO: Write about Modernizr


## Contributing

1. Fork it ( http://github.com/iiska/middleman-webp/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
