# Middleman::Webp

[![Gem Version](https://badge.fury.io/rb/middleman-webp.svg)](http://badge.fury.io/rb/middleman-webp)
[![Build Status](https://travis-ci.org/iiska/middleman-webp.svg?branch=master)](https://travis-ci.org/iiska/middleman-webp)
[![Coverage Status](https://img.shields.io/coveralls/iiska/middleman-webp.svg)](https://coveralls.io/r/iiska/middleman-webp?branch=master)
[![Dependency Status](https://gemnasium.com/iiska/middleman-webp.svg)](https://gemnasium.com/iiska/middleman-webp)

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

- Fedora: ```yum install libwebp-tools```
- Ubuntu: ```apt-get install webp```
- OS X: ```brew install webp --with-giflib```
- Or install from the Google's WebP site:
  https://developers.google.com/speed/webp/download

Add this line to your Middleman site's Gemfile:

    gem 'middleman-webp'

And then execute:

    $ bundle

And activate :webp extension in your config.rb:

``` ruby
activate :webp
```

### Custom conversion options

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

### Ignoring some of the image files at you site

If there are some image files that you don't want to convert to the
webp alternatives, you could ignore them using ```ignore``` option
matching those paths.

``` ruby
activate :webp do |webp|
  webp.ignore = '**/*.gif'
end
```

Ignore option accepts one or an array of String globs, Regexps or
Procs.

### Append the .webp extension instead of replacing the original extension

If you want the output images to be named **sample.png.webp**
instead of **sample.webp**, set the option `append_extension` to true.

``` ruby
activate :webp do |webp|
  webp.append_extension = true
end
```

### Forcing generation of .webp files even if they are larger

By default Middleman::WebP will only keep .webp versions if they are smaller
than original ones.

If you want avoid this behavior and always save .webp version even if they are
larger, disable allow_skip option.

``` ruby
activate :webp do |webp|
  webp.allow_skip = false
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

## Contributors

- [Johannes Schleifenbaum](https://github.com/jojosch)
- [Ryan Townsend](https://github.com/ryantownsend)
