require 'simplecov'

SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
SimpleCov.start do
  add_filter '/spec/'
end

require 'minitest/autorun'
require 'mocha/minitest'
