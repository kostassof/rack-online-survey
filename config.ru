# config.ru
require_relative 'lib/app'
require_relative 'lib/admin'

use Rack::Reloader, 0
use Rack::Static, :urls => ['/images', '/views/js']

admin_app = Rack::Builder.new do
  opaque = "5ebe2294ecd0e0f08eab7690d2a6ee69"

  use Rack::Auth::Digest::MD5, 'admin', opaque do |username|
    'secret'
  end

  run Admin.new
end

run Rack::URLMap.new({ "/admin"  => admin_app, "/" => App.new })
