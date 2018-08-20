require 'erb'
require 'chartkick'

module RenderTemplate
  include Chartkick::Helper

  class LayoutRenderer
  end

  def render(filename)
    layout_to_render_path = File.expand_path("../../views/#{filename}", __FILE__)
    layout_to_render = ERB.new(File.read(layout_to_render_path))

    app_layout_path = File.expand_path("../../views/application.html.erb", __FILE__)
    app_layout = ERB.new(File.read(app_layout_path))

    app_layout.def_method(LayoutRenderer, 'render', filename)

    result = LayoutRenderer.new.render do
      layout_to_render.result(binding) # call the regular erb #result method
    end

    result
  end
end
