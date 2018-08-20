class Admin
  include RenderTemplate

  def call(env)
    @replies = Survey.replies
    @total_replies = Survey.total_replies
    @positive_negative_replies_count = Survey.positive_negative_replies_count
    Rack::Response.new(render('admin.html.erb'))
  end
end
