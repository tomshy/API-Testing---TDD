require 'minitest/autorun'
require 'vcr'
require 'pry-byebug'
require 'minitest-vcr'
require 'json'
require 'faraday'
# require_relative 'test_helper.rb'

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
end
class ApiTest < Minitest::Test
  def test_success_response
    body = {
      "data": {
      "type": "payouts",
        "id": 1,
          "attributes": {
              "category": "BusinessPayment",
          "amount": 10000,
          "recipient_no": "072264885",
          "recipient_type": "msisdn",
              "posted_at": "2019-03-18T17:22:09.651011Z",
          "recipient_id_type":"national_id",
          "recipient_id_number": "12345567",
          "reference": "12345678"
          }
      }
  }
  VCR.use_cassette("success_test") do  
    response = Faraday.post("https://virtserver.swaggerhub.com/zegetech/mpesaUniAPI/1.0/mpesa/payouts", body.to_json)
    assert_equal 200, response.status, "Should return a success response with status 200"
  end
  end
end