require 'spec_helper'
require 'pathname'
require_relative '../../lib/middleman-webp/options'

describe Middleman::WebP::Options do
  describe '#for' do
    it 'returns cwebp args when given file matches option file pattern' do
      path = Pathname.new('test_image.jpg')
      options = Middleman::WebP::Options.new '*.jpg' => {
        lossless: true,
        q: 85
      }

      args = options.for(path)
      args.must_match(/^(-q 85|-lossless) (-q 85|-lossless)$/)
    end

    it 'returns empty string when no options are defined' do
      path = Pathname.new('test_image.jpg')
      options = Middleman::WebP::Options.new

      args = options.for(path)
      args.must_be_empty
    end
  end
end
