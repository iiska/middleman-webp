require 'spec_helper'
require 'middleman-core/cli'
require_relative '../../lib/middleman-webp/extension'

describe Middleman::WebPExtension do
  before do
    @builder = Middleman::Cli::Build.new
    @builder.stubs(:say_status).with do |action, msg, opts|
      action == :webp and msg =~ /Please install latest version of webp/
    end
  end

  after do
    # Remove temporarily created files
    Dir.glob('spec/fixtures/ok-build/**/*.webp').each do |file|
      File.unlink(file)
    end
    Dir.glob('spec/fixtures/ok-source/**/*.webp').each do |file|
      File.unlink(file)
    end
  end

  describe '#before_build' do
    it 'does not generate WebP versions using external tools' do
      app_mock = stub({
                        initialized: '',
                        instance_available: true,
                        after_configuration: nil,
                        before_build: nil,
                        after_build: nil,
                        inst: stub(source_dir: 'spec/fixtures/ok-source')
                      })

      @builder.expects(:say_status).never.with do |action, msg, opts|
        action == :webp and msg =~ /Total conversion savings/
      end

      @builder.expects(:say_status).never.with do |action, msg, opts|
        action == :run and msg =~ /cwebp/
      end

      @builder.expects(:say_status).never.with do |action, msg, opts|
        action == :webp and msg =~ /\.webp \([0-9.]+ % smaller\)/
      end

      @extension = Middleman::WebPExtension.new(app_mock)
      @extension.before_build(@builder)

      Dir.glob('spec/fixtures/ok-source/**/*.webp').size.must_equal 0
    end

    it 'generates WebP versions using external tools when option is set' do
      app_mock = stub({
                        initialized: '',
                        instance_available: true,
                        after_configuration: nil,
                        before_build: nil,
                        after_build: nil,
                        inst: stub(source_dir: 'spec/fixtures/ok-source')
                      })

      @builder.expects(:say_status).once.with do |action, msg, opts|
        action == :webp and msg =~ /Total conversion savings/
      end

      @builder.expects(:say_status).twice.with do |action, msg, opts|
        action == :run and msg =~ /cwebp/
      end

      @builder.expects(:say_status).twice.with do |action, msg, opts|
        action == :webp and msg =~ /\.webp \([0-9.]+ % smaller\)/
      end

      @extension = Middleman::WebPExtension.new(app_mock) do |webp|
        webp.run_before_build = true
      end
      @extension.before_build(@builder)

      Dir.glob('spec/fixtures/ok-source/**/*.webp').size.must_equal 2
    end
  end

  describe '#after_build' do
    before do
      @builder.expects(:say_status).once.with do |action, msg, opts|
          action == :webp and msg =~ /Total conversion savings/
        end
    end

    it 'generates WebP versions using external tools' do
      app_mock = stub({
                        initialized: '',
                        instance_available: true,
                        after_configuration: nil,
                        before_build: nil,
                        after_build: nil,
                        inst: stub(build_dir: 'spec/fixtures/ok-build')
                      })

      @builder.expects(:say_status).twice.with do |action, msg, opts|
        action == :run and msg =~ /cwebp/
      end

      @builder.expects(:say_status).twice.with do |action, msg, opts|
        action == :webp and msg =~ /\.webp \([0-9.]+ % smaller\)/
      end

      @extension = Middleman::WebPExtension.new(app_mock)
      @extension.after_build(@builder)

      Dir.glob('spec/fixtures/ok-build/**/*.webp').size.must_equal 2
    end

    it 'shows errors if files couldn\'t be converted' do
      app_mock = stub({
                        initialized: '',
                        instance_available: true,
                        after_configuration: nil,
                        before_build: nil,
                        after_build: nil,
                        inst: stub(build_dir: 'spec/fixtures/dummy-build')
                      })

      Middleman::WebP::Converter.any_instance.
        expects(:exec_convert_tool).times(3)

      @builder.expects(:say_status).times(3).with do |action, msg, opts|
        msg =~ /Converting .*empty\.(jpg|gif|png) failed/
      end

      @extension = Middleman::WebPExtension.new(app_mock)
      @extension.after_build(@builder)
    end

    it 'rejects file if it is larger than original' do
      app_mock = stub({
                        initialized: '',
                        instance_available: true,
                        after_configuration: nil,
                        before_build: nil,
                        after_build: nil,
                        inst: stub(build_dir: 'spec/fixtures/dummy-build')
                      })

      Middleman::WebP::Converter.any_instance.
        expects(:exec_convert_tool).times(3).with do |src, dst|
        if dst.to_s =~ /spec\/fixtures\/dummy-build\/.*webp$/
          File.open(dst, 'w') do |f|
            f << 'Making it larger than empty dummy original'
          end
          true
        else
          false
        end
      end

      @builder.expects(:say_status).times(3).with do |action, msg, opts|
        action == :webp and msg =~ /.*empty.webp skipped/
      end

      @extension = Middleman::WebPExtension.new(app_mock)
      @extension.after_build(@builder)

      Dir.glob('spec/fixtures/dummy-build/**/*.webp').size.must_equal 0
    end
  end

end
