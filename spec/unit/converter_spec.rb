require "spec_helper"
require "pathname"
require_relative "../../lib/middleman-webp/converter"

describe Middleman::WebP::Converter do
  before do
    @converter = Middleman::WebP::Converter.new(nil, {}, nil)
  end

  describe "#change_percentage" do
    it "returns how many percents smaller destination file is" do
      @converter.change_percentage(10000, 8746).must_equal "12.54 %"
    end

    it "omits zeroes in the end of decimal part" do
      @converter.change_percentage(100, 76).must_equal "24 %"
    end

    it "returns 0% when original and new size are both 0" do
      @converter.change_percentage(0, 0).must_equal "0 %"
    end
  end

  describe "#number_to_human_size" do
    it "uses human readable unit" do
      @converter.number_to_human_size(100).must_equal "100 B"
      @converter.number_to_human_size(1234).must_equal "1.21 KiB"
      @converter.number_to_human_size(2_634_234).must_equal "2.51 MiB"
    end

    it 'handles zero size properly' do
      @converter.number_to_human_size(0).must_equal '0 B'
    end
  end

  describe "#tool_for" do
    it "uses gif2webp for gif files" do
      path = Pathname.new("/some/path/image.gif")
      @converter.tool_for(path).must_equal "gif2webp"
    end

    it "uses cwebp for jpeg, png and tiff files" do
      path = Pathname.new("/some/path/image.jpg")
      @converter.tool_for(path).must_equal "cwebp"
      path = Pathname.new("/some/path/image.png")
      @converter.tool_for(path).must_equal "cwebp"
      path = Pathname.new("/some/path/image.tiff")
      @converter.tool_for(path).must_equal "cwebp"
    end
  end
end
