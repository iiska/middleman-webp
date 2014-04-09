require 'middleman-core'
require 'middleman-webp/converter'

module Middleman
  class WebPExtension < Extension
    option(:conversion_options, {},
           'Custom conversion options for cwebp/gif2webp')
    def initialize(app, options_hash = {}, &block)
      super

      args = options.conversion_options
      app.after_build do |builder|
        Middleman::WebP::Converter.new(app, args, builder).convert
      end
    end
  end
end
