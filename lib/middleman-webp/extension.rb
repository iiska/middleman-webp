require "middleman-core"
require "middleman-webp/converter"

module Middleman
  class WebPExtension < Extension
    def initialize(app, options, &block)
      super

      app.after_build do |builder|
        Middleman::WebP::Converter.new(app, builder).convert
      end
    end
  end
end
