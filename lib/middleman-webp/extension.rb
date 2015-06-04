require 'middleman-core'
require 'middleman-webp/converter'

require 'shell'

module Middleman
  class WebPExtension < Extension
    option(:conversion_options, {},
           'Custom conversion options for cwebp/gif2webp')
    option(:append_extension, false,
           'keep the original filename and extension and append .webp (image.png => image.png.webp)')
    option(:ignore, [], 'Ignores files with matching paths')
    option(:verbose, false, 'Display all external command which are executed '\
           'to help debugging.')
    option(:allow_skip, true, 'Skip saving .webp files which are larger than their source')
    option(:run_before_build, false, 'Run before build and save .webp files in source dir')

    def initialize(app, options_hash = {}, &block)
      super
      @app = app
    end

    def before_build(builder)
      return unless options[:run_before_build]
      return unless dependencies_installed?(builder)
      Middleman::WebP::Converter.new(@app, options, builder).convert
    end

    def after_build(builder)
      return if options[:run_before_build]
      return unless dependencies_installed?(builder)
      Middleman::WebP::Converter.new(@app, options, builder).convert
    end

    # Internal: Check that cwebp and gif2webp commandline tools are available.
    #
    # Returns true if all is OK.
    def dependencies_installed?(builder)
      sh = Shell.new

      begin
        sh.find_system_command('gif2webp')
      rescue Shell::Error::CommandNotFound => e
        builder.say_status :webp, "#{e.message} Please install latest version of webp library and tools to get gif2webp and be able to convert gif files also.", :red
      end

      begin
        true if sh.find_system_command('cwebp')
      rescue Shell::Error::CommandNotFound => e
        builder.say_status :webp, "ERROR: #{e.message} Please install cwebp and gif2webp commandline tools first.", :red
        false
      end
    end
  end
end
