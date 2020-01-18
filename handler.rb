require 'rack'

app = Proc.new do |env|
  [
    200,
    { 'Content->type' => 'text/plain' },
    ["Welcome aboard!\n"]
  ]
end

Rack::Handler::WEBrick.run app