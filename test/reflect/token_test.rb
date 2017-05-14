require './test/test_helper'

class TokenTest < Minitest::Test
  extend Minitest::Spec::DSL

  describe "token generation" do
    let(:secret) { "muffin_assassin" }

    it "generates a token with no parameters" do
      expected = "=2=HDOT6E9fPju40km0WeQmGKW/ryNNPX529POBSdhr4lI=" 

      assert_equal Reflect.generate_token(secret), expected
    end

    it "generates a token with parameters" do
      parameters = [
        Reflect::Parameter.new("field1", ">=", "abc"),
        Reflect::Parameter.new("field2", "<", "123")
      ]
      expected = "=2=mYK0xsboM6he5NcV3fHg2IP39BYb6E7Tv4JVwBVUy58="

      assert_equal Reflect.generate_token(secret, parameters), expected
    end
  end

end
