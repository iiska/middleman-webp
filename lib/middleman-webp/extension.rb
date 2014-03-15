require "middleman-core"
require "middleman-webp/converter"

module Middleman
  module WebP
    def self.included(app, options, &block)
      app.after_configuration do
        app.after_build do |builder|
          Middleman::WebP::Converter.new(app, builder).convert
        end
      end
    end
  end
end
