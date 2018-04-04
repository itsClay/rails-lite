require 'rack'

app = Proc.new do |env|
  req = Rack::Request.new(env)
  path = req.get_header('REQUEST_PATH')
  res = Rack::Response.new
  res['Content-Type'] = 'text/html'
  # just going to output the path
  res.write(path)
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)