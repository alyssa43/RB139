require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use!

require_relative '../lib/rb139'

class Rb139Test < Minitest::Test
end