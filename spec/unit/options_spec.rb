require 'spec_helper'
require 'pathname'
require_relative '../../lib/middleman-webp/options'

describe Middleman::WebP::Options do
  describe '#allow_skip' do
    it "should default to true" do
      options = Middleman::WebP::Options.new
      options.allow_skip.must_equal(true)
    end
    
    it "should allow setting to true" do
      options = Middleman::WebP::Options.new(allow_skip: false)
      options.allow_skip.must_equal(false)
    end
  end
  
  describe '#for' do
    it 'returns cwebp args when given file matches option file pattern glob' do
      path = Pathname.new('test_image.jpg')
      options_hash = {
        conversion_options: {
          '*.jpg' => {
            lossless: true,
            q: 85
          }
        }
      }
      options = Middleman::WebP::Options.new options_hash

      args = options.for(path)
      args.must_match(/^(-q 85|-lossless) (-q 85|-lossless)$/)
    end

    it 'returns empty string when no options are defined' do
      path = Pathname.new('test_image.jpg')
      options = Middleman::WebP::Options.new

      args = options.for(path)
      args.must_be_empty
    end

    it 'returns cwebp args when given file matches option pattern regexp' do
      path = Pathname.new('test_image.jpg')
      options_hash = {
        conversion_options: {
          /jpg$/ => {
            q: 85
          }
        }
      }
      options = Middleman::WebP::Options.new options_hash

      args = options.for(path)
      args.must_match(/^-q 85$/)
    end
  end
end
