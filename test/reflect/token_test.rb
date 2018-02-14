require './test/test_helper'

require 'json'
require 'jwe'
require 'ostruct'
require 'securerandom'

class TokenTest < Minitest::Test
  extend Minitest::Spec::DSL

  describe 'token generation' do
    let(:kp) {
      secret_key = SecureRandom.uuid
      secret_key_bytes = secret_key.scan(/[0-9a-f]{4}/).map { |x| x.to_i(16) }.pack('n*')

      OpenStruct.new(
        :access_key => SecureRandom.uuid,
        :secret_key => secret_key,
        :secret_key_bytes => secret_key_bytes,
      )
    }

    it 'generates' do
      token = Reflect::ProjectTokenBuilder.new(kp.access_key)
        .build(kp.secret_key)

      header_json, _, _, _ = JWE::Serialization::Compact.decode(token)
      header = JSON.parse(header_json)
      assert_equal kp.access_key, header['kid']

      JWE.decrypt(token, kp.secret_key_bytes)
    end

    it 'expires at the right time' do
      expiration = Time.now + 15*60

      token = Reflect::ProjectTokenBuilder.new(kp.access_key)
        .expiration(expiration)
        .build(kp.secret_key)

      header_json, _, _, _ = JWE::Serialization::Compact.decode(token)
      header = JSON.parse(header_json)
      assert_equal kp.access_key, header['kid']

      jwt = JSON.parse(JWE.decrypt(token, kp.secret_key_bytes))
      assert_operator jwt['nbf'], :<=, Time.now.to_i
      assert_equal expiration.to_i, jwt['exp']
    end

    it 'handles all claims' do
      parameter = Reflect::Parameter.new('user-id', '==', '1234')

      token = Reflect::ProjectTokenBuilder.new(kp.access_key)
        .add_view_identifier('SecUr3View1D')
        .set_attribute('user-id', 1234)
        .set_attribute('user-name', 'Billy Bob')
        .add_parameter(parameter)
        .build(kp.secret_key)

      header_json, _, _, _ = JWE::Serialization::Compact.decode(token)
      header = JSON.parse(header_json)
      assert_equal kp.access_key, header['kid']

      jwt = JSON.parse(JWE.decrypt(token, kp.secret_key_bytes))

      assert_equal 1, jwt[Reflect::ProjectTokenBuilder::VIEW_IDENTIFIERS_CLAIM_NAME].length
      assert_includes jwt[Reflect::ProjectTokenBuilder::VIEW_IDENTIFIERS_CLAIM_NAME], 'SecUr3View1D'

      assert_equal 1, jwt[Reflect::ProjectTokenBuilder::PARAMETERS_CLAIM_NAME].length
      assert_includes jwt[Reflect::ProjectTokenBuilder::PARAMETERS_CLAIM_NAME], {'field' => 'user-id', 'op' => '==', 'value' => '1234'}

      assert_equal 2, jwt[Reflect::ProjectTokenBuilder::ATTRIBUTES_CLAIM_NAME].length
      assert_equal 1234, jwt[Reflect::ProjectTokenBuilder::ATTRIBUTES_CLAIM_NAME]['user-id']
      assert_equal 'Billy Bob', jwt[Reflect::ProjectTokenBuilder::ATTRIBUTES_CLAIM_NAME]['user-name']
    end
  end

end
