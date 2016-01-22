require 'spec_helper'
require_relative '../../lib/middleman-webp/extension'

describe Middleman::WebPExtension do
  before do
    app_mock = stub(initialized: '',
                    instance_available: true,
                    after_configuration: nil,
                    before_build: nil,
                    after_build: nil)
    @extension = Middleman::WebPExtension.new(app_mock)
    @extension.initialize_logger(stub(thor: { say_status: nil }))
  end

  describe '#dependencies_installed?' do
    it 'returns true if required command line tools are found' do
      Shell.any_instance.expects(:find_system_command).with('cwebp').returns('/usr/bin/cwebp')
      Shell.any_instance.expects(:find_system_command).with('gif2webp').returns('/usr/bin/gif2webp')

      @extension.dependencies_installed?.must_equal true
    end

    it 'returns false and displays error if cwebp is missing' do
      Shell.any_instance.expects(:find_system_command).with('cwebp').raises(Shell::Error::CommandNotFound)
      Shell.any_instance.stubs(:find_system_command).with('gif2webp').returns('/usr/bin/gif2webp')

      Middleman::WebP::Logger.any_instance.expects(:error).once
      @extension.dependencies_installed?.must_equal false
    end

    it 'displays error if only gif2webp is missing and returns still true' do
      Shell.any_instance.expects(:find_system_command).with('gif2webp').raises(Shell::Error::CommandNotFound)
      Shell.any_instance.stubs(:find_system_command).with('cwebp').returns('/usr/bin/cwebp')

      Middleman::WebP::Logger.any_instance.expects(:error).once
      @extension.dependencies_installed?.must_equal true
    end
  end
end
