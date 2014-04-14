require 'middleman-core'
require 'middleman-webp/converter'

module Middleman
  class WebPExtension < Extension
    option(:conversion_options, {},
           'Custom conversion options for cwebp/gif2webp')
    option(:ignore, [], 'Ignores files with matching paths')
    def initialize(app, options_hash = {}, &block)
      super

      app.after_build do |builder|
        Middleman::WebP::Converter.new(app, options_hash, builder).convert
      end
    end
  end
end
