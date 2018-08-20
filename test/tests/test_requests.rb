require 'test/unit'
require 'rack/test'
require 'capybara/dsl'
require './lib/app'
require './test/helper/test_config'

Capybara.configure do |config|
  config.app = App.new
  config.default_driver = :selenium_chrome_headless
end

class TestRequests < CapybaraTestCase
  include Rack::Test::Methods

  def app
    Rack::Builder.parse_file("config.ru").first
  end

  def test_index
    get "/"
    assert last_response.ok?
  end

  def test_admin
    get "/admin"
    assert last_response.status == 401
  end

  def test_not_existing
    get "/survey"
    assert last_response.status == 404
  end
end
