require "spec_helper"
require "middleman-core"
require "middleman-core/cli"
require "thor"
require_relative "../../lib/middleman-webp/extension"

describe Middleman::WebPExtension do
  before do
    @builder = stub(thor: Middleman::Cli::Build.new)
  end

  after do
    # Remove temporarily created files
    Dir.glob("spec/fixtures/ok-build/**/*.webp").each do |file|
      File.unlink(file)
    end
    Dir.glob("spec/fixtures/ok-source/**/*.webp").each do |file|
      File.unlink(file)
    end
  end

  describe "#before_build" do
    it "does not generate WebP versions by default" do
      app_mock = stub(initialized: "",
        instance_available: true,
        after_configuration: nil,
        before_build: nil,
        after_build: nil,
        root: ".",
        config: {source: "spec/fixtures/ok-source"})

      @builder.expects(:trigger).never.with do |event|
        [:webp, :created, :error, :deleted].include? event
      end

      @extension = Middleman::WebPExtension.new(app_mock)
      @extension.before_build(@builder)

      value(Dir.glob("spec/fixtures/ok-source/**/*.webp").size).must_equal 0
    end

    it "generates WebP versions using external tools when option is set" do
      app_mock = stub(initialized: "",
        instance_available: true,
        after_configuration: nil,
        before_build: nil,
        after_build: nil,
        verbose: true,
        root: ".",
        config: {
          source: "spec/fixtures/ok-source",
          build_dir: "spec/fixtures/ok-build"
        })

      @builder.expects(:trigger).twice.with do |event, msg|
        event == :created && msg =~ /\.webp \([0-9.]+ % smaller\)/
      end

      @builder.expects(:trigger).once.with do |event, _target, msg|
        event == :webp && msg =~ /Total conversion savings/
      end

      @extension = Middleman::WebPExtension.new(app_mock) do |webp|
        webp.run_before_build = true
      end
      @extension.before_build(@builder)

      value(Dir.glob("spec/fixtures/ok-source/**/*.webp").size).must_equal 2
    end
  end

  describe "#after_build" do
    before do
      @builder.expects(:trigger).once.with do |event, _target, msg|
        event == :webp && msg =~ /Total conversion savings/
      end
    end

    it "generates WebP versions using external tools" do
      app_mock = stub(initialized: "",
        instance_available: true,
        after_configuration: nil,
        before_build: nil,
        after_build: nil,
        root: ".",
        config: {
          source: "spec/fixtures/ok-source",
          build_dir: "spec/fixtures/ok-build"
        })

      @builder.expects(:trigger).twice.with do |event, msg|
        event == :created && msg =~ /\.webp \([0-9.]+ % smaller\)/
      end

      @extension = Middleman::WebPExtension.new(app_mock)
      @extension.after_build(@builder)

      value(Dir.glob("spec/fixtures/ok-build/**/*.webp").size).must_equal 2
    end

    it "shows errors if files couldn't be converted" do
      app_mock = stub(initialized: "",
        instance_available: true,
        after_configuration: nil,
        before_build: nil,
        after_build: nil,
        root: ".",
        config: {build_dir: "spec/fixtures/dummy-build"})

      Middleman::WebP::Converter.any_instance
        .expects(:exec_convert_tool).times(3)

      @builder.expects(:trigger).times(3).with do |event, msg|
        event == :error && msg =~ /Converting .*empty\.(jpg|gif|png) failed/
      end

      @extension = Middleman::WebPExtension.new(app_mock)
      @extension.after_build(@builder)
    end

    it "rejects file if it is larger than original" do
      app_mock = stub(initialized: "",
        instance_available: true,
        after_configuration: nil,
        before_build: nil,
        after_build: nil,
        root: ".",
        config: {build_dir: "spec/fixtures/dummy-build"})

      Middleman::WebP::Converter.any_instance
        .expects(:exec_convert_tool).times(3).with do |_src, dst|
        if /spec\/fixtures\/dummy-build\/.*webp$/.match?(dst.to_s)
          File.open(dst, "w") do |f|
            f << "Making it larger than empty dummy original"
          end
          true
        else
          false
        end
      end

      @builder.expects(:trigger).times(3).with do |event, msg|
        event == :deleted && msg =~ /.*empty.webp skipped/
      end.returns(nil)

      @extension = Middleman::WebPExtension.new(app_mock)
      @extension.after_build(@builder)

      value(Dir.glob("spec/fixtures/dummy-build/**/*.webp").size).must_equal 0
    end
  end
end
