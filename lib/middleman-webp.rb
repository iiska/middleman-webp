require "middleman-core"
require "middleman-webp/version"

::Middleman::Extensions.register(:webp) do
  require "middleman-webp/extension"
  ::Middleman::WebPExtension
end
