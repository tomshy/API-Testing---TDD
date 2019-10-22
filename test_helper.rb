# frozen_string_literal: true

require 'minitest/autorun'
require 'vcr'
require 'pry-byebug'
require 'minitest-vcr'
require 'faraday'

require 'minitest/reporters'

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = false
  config.cassette_library_dir = File.expand_path('cassettes', __dir__)
  config.hook_into :webmock
  config.ignore_request { ENV['DISABLE_VCR'] }
  config.ignore_localhost = true
  config.default_cassette_options = {
    record: :new_episodes
  }
end

MinitestVcr::Spec.configure!

class Minitest::Test
  fixtures_yaml = Dir.entries('test/fixtures').reject { |f| File.directory? f }.map do |file|
    YAML.safe_load(ERB.new(File.read(File.expand_path("fixtures/#{file}", __dir__))).result)
  end.inject(:merge)
  FIXTURES = Hashie::Mash.new(fixtures_yaml).freeze
  GATEWAY_URL = ENV['GATEWAY_URL']
  def setup
    cassette_file = "#{class_name.delete_suffix('Test').snakecase}/#{name}"
    VCR.insert_cassette cassette_file
  end

  def teardown
    VCR.eject_cassette
  end
end
