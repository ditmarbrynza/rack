class Runtime

  def initialize(app)
    @app = app
  end

  def call(env)
    p self.class
    p @app
    start = Time.now
    status, headers, body = @app.call(env)
    headers['X-Runtime'] = "%fs" % (Time.now - start)
    [status, headers, body]
  end

end