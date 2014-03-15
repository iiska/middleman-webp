require "spec_helper"
require_relative "../../lib/middleman-webp/converter"

describe Middleman::WebP::Converter do
  before do
    @converter = Middleman::WebP::Converter.new(nil, nil)
  end

  describe "#number_to_human_size" do
    it "uses human readable unit" do
      @converter.number_to_human_size(100).must_equal "100 B"
      @converter.number_to_human_size(1234).must_equal "1.21 KiB"
      @converter.number_to_human_size(2_634_234).must_equal "2.51 MiB"
    end
  end
end
