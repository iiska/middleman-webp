## 1.0.3

- Fix converting large number of files. ([PR
  #24](https://github.com/iiska/middleman-webp/pull/24))

## 1.0.2

- Fix logic for selecting command line args for the most precise filename
  pattern, if multiple patterns would match

## 1.0.1

- Add `required_ruby_version` to gemspec.

## 1.0.0

- Add support for Ruby 2.7, 3,0, 3.1, 3.2
- *Breaks* Drop support for Ruby 2.4

## 0.4.3

- Contract violation fixes from
  [PR #15](https://github.com/iiska/middleman-webp/pull/15)
- *Breaks* Drop support for MRI Ruby 2.0.0

## 0.4.1

- Fix running external conversion tool

## 0.4.0

- Middleman 4.0.0 compatibility
- *Breaks* Middleman 3.*.* support, use gem version 0.3.2 with older
  Middleman versions

## 0.3.0

- Add new option: run_before_build with default value false (ie. default
  behaviour will stay unchanged)

## 0.2.5

- Fixes regression bug with extension config options

## 0.2.4

- Add ```ignore``` option similar to the one in the [asset_hash extension](http://middlemanapp.com/advanced/improving-cacheability/#uniquely-named-assets)
- Allow using Regexp to match files for custom conversion options

## 0.1.0

- First release
