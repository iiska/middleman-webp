require "middleman-core"

::Middleman::Extensions.register(:webp) do
  require "middleman-webp/extension"
  ::Middleman::WebP
end
