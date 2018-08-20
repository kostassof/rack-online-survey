# config_test.ru
require_relative 'lib/render_template'

use Rack::Reloader, 0
use Rack::Static, :urls => ['/images', '/views/js']

run Rack::URLMap.new({ "/" => TestApp.new })
