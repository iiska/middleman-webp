require 'spec_helper'
require_relative '../../lib/middleman-webp/pathname_matcher'

describe Middleman::WebP::PathnameMatcher do
  describe '#matches?' do
    it 'returns true when given file matches pattern' do
      patterns = ['**/*.jpg', /jpg$/, ->(path) { path.end_with?('jpg') }]
      files = [
        'images/sample.jpg',
        Pathname.new('images/another.jpg'),
        File.new('spec/fixtures/dummy-build/empty.jpg')
      ]

      patterns.each do |p|
        matcher = Middleman::WebP::PathnameMatcher.new(p)
        files.each do |f|
          value(matcher.matches?(f)).must_equal true, "Pattern: #{p.inspect}, "\
          "file: #{f.inspect}"
        end
      end
    end

    it 'returns false when given file won\'t match pattern' do
      patterns = ['**/*.jpg', /jpg$/, ->(path) { path.end_with?('jpg') }]
      files = [
        'images/sample.png',
        Pathname.new('images/another.png'),
        File.new('spec/fixtures/dummy-build/empty.png')
      ]

      patterns.each do |p|
        matcher = Middleman::WebP::PathnameMatcher.new(p)
        files.each do |f|
          value(matcher.matches?(f)).must_equal false, "Pattern: #{p.inspect}, "\
          "file: #{f.inspect}"
        end
      end
    end

    it 'defaults to pattern \'**/*\' and matches all when pattern is nil' do
      paths = [
        'something/anything.foo',
        Pathname.new('images/another.png'),
        'a/b/c/d/e/f/g'
      ]

      matcher = Middleman::WebP::PathnameMatcher.new
      paths.each do |p|
        value(matcher.matches?(p)).must_equal true
      end
    end

    it 'handles nil path gracefully and returns false' do
      Middleman::WebP::PathnameMatcher.new('*.jpg').matches? nil
    end
  end
end
