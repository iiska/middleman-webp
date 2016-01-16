require 'spec_helper'
require 'middleman-core'
require 'middleman-core/cli'
require 'thor'
require_relative '../../lib/middleman-webp/extension'

class MockBuilder
  def thor
    return Middleman::Cli::Build.new
  end
end

describe Middleman::WebPExtension do
  before do
    @builder = MockBuilder.new
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
    it 'does not generate WebP versions by default' do
      app_mock = stub({
                        initialized: '',
                        instance_available: true,
                        after_configuration: nil,
                        before_build: nil,
                        after_build: nil,
                        root: '.',
                        config: {source: 'spec/fixtures/ok-source'}
                      })

      Middleman::WebP::Logger.any_instance.expects(:info).never
        .with do |msg, color|
          msg =~ /Total conversion savings/
        end

      Middleman::WebP::Logger.any_instance.expects(:info).never
        .with do |msg|
          msg =~ /cwebp/
        end

      Middleman::WebP::Logger.any_instance.expects(:info).never
        .with do |msg|
          msg =~ /\.webp \([0-9.]+ % smaller\)/
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
                        verbose: true,
                        root: '.',
                        config: {
                          source: 'spec/fixtures/ok-source',
                          build_dir: 'spec/fixtures/ok-build'
                        }
                      })

      Middleman::WebP::Logger.any_instance.expects(:info).once.with do |msg, c|
        msg =~ /Total conversion savings/
      end

      Middleman::WebP::Logger.any_instance.expects(:info).twice.with do |msg|
        msg =~ /\.webp \([0-9.]+ % smaller\)/
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
      Middleman::WebP::Logger.any_instance.expects(:info).once.with do |msg|
          msg =~ /Total conversion savings/
        end
    end

    it 'generates WebP versions using external tools' do
      app_mock = stub({
                        initialized: '',
                        instance_available: true,
                        after_configuration: nil,
                        before_build: nil,
                        after_build: nil,
                        root: '.',
                        config: {
                          source: 'spec/fixtures/ok-source',
                          build_dir: 'spec/fixtures/ok-build'
                        }
                      })

      Middleman::WebP::Logger.any_instance.expects(:info).twice.with do |msg|
        msg =~ /\.webp \([0-9.]+ % smaller\)/
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
                        root: '.',
                        config: {build_dir: 'spec/fixtures/dummy-build'}
                      })

      Middleman::WebP::Converter.any_instance.
        expects(:exec_convert_tool).times(3)

      Middleman::WebP::Logger.any_instance.expects(:error).times(3).with do |msg|
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
                        root: '.',
                        config: {build_dir: 'spec/fixtures/dummy-build'}
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

      Middleman::WebP::Logger.any_instance.expects(:info).times(3)
        .with { |msg| msg =~ /.*empty.webp skipped/ }.returns(nil)

      @extension = Middleman::WebPExtension.new(app_mock)
      @extension.after_build(@builder)

      Dir.glob('spec/fixtures/dummy-build/**/*.webp').size.must_equal 0
    end
  end

end
