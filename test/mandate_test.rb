require "test_helper"

class MandateTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Mandate::VERSION
  end
end
