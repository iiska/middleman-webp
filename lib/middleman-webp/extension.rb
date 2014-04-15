require 'middleman-core'
require 'middleman-webp/converter'

require 'shell'

module Middleman
  class WebPExtension < Extension
    option(:conversion_options, {},
           'Custom conversion options for cwebp/gif2webp')
    option(:ignore, [], 'Ignores files with matching paths')
    def initialize(app, options_hash = {}, &block)
      super
      @app = app
    end

    def after_build(builder)
      return unless dependencies_installed?(builder)
      Middleman::WebP::Converter.new(@app, options, builder).convert
    end

    # Internal: Check that cwebp and gif2webp commandline tools are available.
    #
    # Returns true if all is OK.
    def dependencies_installed?(builder)
      sh = Shell.new
      begin
        true if sh.find_system_command('cwebp') and sh.find_system_command('gif2webp')
      rescue Exception => e
        builder.say_status :webp, "ERROR: #{e.message} Please install cwebp and gif2webp commandline tools first.", :red
        false
      end
    end
  end
end
