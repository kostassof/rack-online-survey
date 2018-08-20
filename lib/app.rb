# app.rb
require_relative 'survey'
require_relative 'render_template'

class App
  include RenderTemplate

  def call(env)
    request_cookies = Rack::Utils.parse_cookies(env)
    handle_request(Rack::Request.new(env), request_cookies)
  end

  private

  def handle_request(request, request_cookies)
    case request.path
    when '/'
      set_warning(request_cookies)
      Rack::Response.new(render('index.html.erb'))
    when '/submit_form'
      if request.params.empty? || Survey.email_is_present?(request.params["email"])
        Rack::Response.new(render('not_applicable.html.erb'))
      else
        submit_form_response(request.params)
      end
    else
      Rack::Response.new(render('not_found.html.erb'), 404)
    end
  end

  def submit_form_response(request_params)
    response = Rack::Response.new
    response.body = [render('thank_you.html.erb')]
    response.set_cookie('form_submitted', DateTime.now)
    Survey.new(request_params)
    response.finish
  end

  def set_warning(request_cookies)
    @error = if request_cookies.has_key? 'form_submitted'
               "You have recently submitted your answers!"
             else
               nil
             end
    @error
  end
end
