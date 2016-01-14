require 'spec_helper'
require 'pathname'
require_relative '../../lib/middleman-webp/logger'

describe Middleman::WebP::Logger do
  before do
    @thor_mock = stub({say_status: nil})
    @logger = Middleman::WebP::Logger.new(stub({thor: @thor_mock}))
  end

  it "logs info message through Thor with given color" do
    @thor_mock.expects(:say_status).once.with do |action, msg, color|
      msg == 'foobar' && color == :blue
    end
    @logger.info 'foobar', :blue
  end

  [[:error, :red], [:warn, :yellow]].each do |(method, color)|
    it "##{method} logs message with color #{color}" do
      @thor_mock.expects(:say_status).once.with do |action, msg, col|
        msg == "#{method} message" && col == color
      end
      @logger.send method, "#{method} message"
    end
  end

  it "logs error with red" do
    @thor_mock.expects(:say_status).once.with do |action, msg, color|
      msg == 'foobar' && color == :red
    end
    @logger.error 'foobar'
  end
end
