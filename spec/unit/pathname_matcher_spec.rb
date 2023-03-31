require "spec_helper"
require_relative "../../lib/middleman-webp/pathname_matcher"

describe Middleman::WebP::PathnameMatcher do
  describe "#matches?" do
    it "returns true when given file matches pattern" do
      patterns = ["**/*.jpg", /jpg$/, ->(path) { path.end_with?("jpg") }]
      files = [
        "images/sample.jpg",
        Pathname.new("images/another.jpg"),
        File.new("spec/fixtures/dummy-build/empty.jpg")
      ]

      patterns.each do |p|
        matcher = Middleman::WebP::PathnameMatcher.new(p)
        files.each do |f|
          value(matcher.matches?(f)).must_equal true, "Pattern: #{p.inspect}, " \
          "file: #{f.inspect}"
        end
      end
    end

    it "returns false when given file won't match pattern" do
      patterns = ["**/*.jpg", /jpg$/, ->(path) { path.end_with?("jpg") }]
      files = [
        "images/sample.png",
        Pathname.new("images/another.png"),
        File.new("spec/fixtures/dummy-build/empty.png")
      ]

      patterns.each do |p|
        matcher = Middleman::WebP::PathnameMatcher.new(p)
        files.each do |f|
          value(matcher.matches?(f)).must_equal false, "Pattern: #{p.inspect}, " \
          "file: #{f.inspect}"
        end
      end
    end

    it "defaults to pattern '**/*' and matches all when pattern is nil" do
      paths = [
        "something/anything.foo",
        Pathname.new("images/another.png"),
        "a/b/c/d/e/f/g"
      ]

      matcher = Middleman::WebP::PathnameMatcher.new
      paths.each do |p|
        value(matcher.matches?(p)).must_equal true
      end
    end

    it "handles nil path gracefully and returns false" do
      Middleman::WebP::PathnameMatcher.new("*.jpg").matches? nil
    end
  end

  describe "#<=>" do
    it "sorts by pattern length" do
      patterns = ["*.jpg", "really_long_example_name.jpg", %r{^images/.*\.jpg$}]
      matchers = patterns.map { |p| Middleman::WebP::PathnameMatcher.new(p) }

      sorted_matchers = matchers.sort

      value(sorted_matchers.map(&:pattern)).must_equal(patterns.sort_by { |p| p.to_s.length })
    end

    it "sorts proc pattern smaller than string" do
      patterns = ["*.jpg", proc { |p| p == "jpg" }, %r{^images/.*\.jpg$}]
      matchers = patterns.map { |p| Middleman::WebP::PathnameMatcher.new(p) }
      min_value = matchers.min

      value(min_value.pattern).must_equal(patterns[1])
    end

    it "considers any procs equal" do
      proc1 = proc { |p| p == "jpg" }
      proc2 = proc { |p| p == "png" }
      matcher1 = Middleman::WebP::PathnameMatcher.new(proc1)
      matcher2 = Middleman::WebP::PathnameMatcher.new(proc2)

      value(matcher1 <=> matcher2).must_equal 0
    end
  end
end
