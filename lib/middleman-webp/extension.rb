require 'middleman-core'
require 'middleman-webp/converter'

require 'shell'

module Middleman
  ##
  # Middleman extension for converting image assets to WebP alternatives
  #
  # Conversion is run using after_build or before_build according to the
  # configuration, after_build being the default.
  class WebPExtension < Extension
    option(:conversion_options, {},
           'Custom conversion options for cwebp/gif2webp')
    option(:append_extension, false,
           'keep the original filename and extension and append .webp '\
           '(image.png => image.png.webp)')
    option(:ignore, [], 'Ignores files with matching paths')
    option(:verbose, false, 'Display all external command which are executed '\
           'to help debugging.')
    option(:allow_skip, true, 'Skip saving .webp files which are larger than '\
           'their source')
    option(:run_before_build, false, 'Run before build and save .webp files in'\
           ' source dir')

    def initialize(app, options_hash = {}, &block)
      super
      @app = app
    end

    def before_build(builder)
      return unless options.run_before_build

      return unless dependencies_installed?(builder)
      Middleman::WebP::Converter.new(@app, builder, options).convert
    end

    def after_build(builder)
      return if options.run_before_build

      return unless dependencies_installed? builder
      Middleman::WebP::Converter.new(@app, builder, options).convert
    end

    # Internal: Check that cwebp and gif2webp commandline tools are available.
    #
    # Returns true if all is OK.
    def dependencies_installed?(builder)
      warn_if_gif2webp_missing builder
      cwebp_installed? builder
    end

    private

    def warn_if_gif2webp_missing(builder)
      Shell.new.find_system_command('gif2webp')
    rescue Shell::Error::CommandNotFound => e
      builder.trigger :webp, nil, "#{e.message} Please install latest version"\
        ' of webp library and tools to get gif2webp and be able to convert gif'\
        'files also.'
    end

    def cwebp_installed?(builder)
      true if Shell.new.find_system_command('cwebp')
    rescue Shell::Error::CommandNotFound => e
      builder.trigger :error, "ERROR: #{e.message} Please install cwebp and "\
        'gif2webp commandline tools first.'
      false
    end
  end
end
