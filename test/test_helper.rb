$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

gem 'minitest'
require 'minitest/autorun'
require 'minitest/unit'
require 'mocha/minitest'

require "mandate"
