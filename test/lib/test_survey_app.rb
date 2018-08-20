require './lib/render_template'

class TestSurvey
  def initialize(answers)
    @answers = answers.values
    save_to_json
  end

  def self.email_is_present?(email)
    csv_text = File.read('test/public/test_answers.csv')
    csv = CSV.parse(csv_text, :headers => true)
    !csv.find {|row| row['Email'] == email}.nil?
  end

  def self.total_replies
    CSV.foreach('test/public/test_answers.csv', headers: true).count
  end

  def self.new_csv_file
    FileUtils.rm_f('test/public/test_answers.csv')
    headers = ['Question1', 'Question2', 'Question3', 'Question4', 'Question5', 'Email']
    CSV.open('test/public/test_answers.csv', 'a+') do |row|
      row << headers
    end
  end

  private

  def save_to_json
    CSV.open('test/public/test_answers.csv', 'a+') do |row|
      row << @answers
    end
  end
end


class TestSurveyApp
  include RenderTemplate

  def call(env)
    @request = Rack::Request.new(env)
    case @request.path
    when '/'
      Rack::Response.new(render('index.html.erb'))
    when '/submit_form'
      if @request.params.empty? || TestSurvey.email_is_present?(@request.params["email"])
        Rack::Response.new(render('not_applicable.html.erb'))
      else
        TestSurvey.new(@request.params)
        Rack::Response.new(render('thank_you.html.erb'))
      end
    else
      Rack::Response.new(render('not_found.html.erb'), 404)
    end
  end
end


