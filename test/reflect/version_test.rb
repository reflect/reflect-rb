require "./test/test_helper"

class ReflectVersionTest < Minitest::Test
  def test_version
    assert_equal Reflect::VERSION, "0.2.0"
  end
end
