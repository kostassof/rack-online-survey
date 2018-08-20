require 'csv'
require 'test/unit'
require 'rack/test'
require 'capybara/dsl'
require './test/helper/test_config'
require './test/lib/test_survey_app'

Capybara.configure do |config|
  config.app = TestSurveyApp.new
  config.default_driver = :selenium_chrome_headless
end

class TestSurveyResults < CapybaraTestCase
  include Rack::Test::Methods

  def app
    Rack::Builder.parse_file("config_test.ru").first
  end

  def test_submit_survey_without_data
    visit "/"
    click_button 'Submit'
    assert page.has_css?('#cnt1')
  end

  def test_submit_survey_without_valid_email
    visit "/"
    choose('product', option: 'yes')
    choose('buyagain', option: 'yes')
    choose('suggest_friends', option: 'yes')
    choose('suggest_relatives', option: 'yes')
    choose('company', option: 'yes')
    fill_in 'email', :with => 'test'
    click_button 'Submit'
    assert page.has_css?('#cnt1')
  end

  def test_submit_survey_with_valid_email
    visit "/"
    choose('product', option: 'yes')
    choose('buyagain', option: 'yes')
    choose('suggest_friends', option: 'yes')
    choose('suggest_relatives', option: 'yes')
    choose('company', option: 'yes')
    fill_in 'email', :with => 'test@example.com'
    click_button 'Submit'
    assert_equal TestSurvey.total_replies, 1
    assert_equal TestSurvey.email_is_present?('test@example.com'), true
    TestSurvey.new_csv_file
  end
end
