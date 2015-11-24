module NgrokRails
  class Middleware
    def initialize(app, options = {})
      port = options[:port]
      subdomain = options[:subdomain]
      @app = app
      require 'socket'
      ENV['NGROK_SUBDOMAIN'] ||= subdomain || "#{ENV['USER']}.#{Socket.gethostname}"
      ENV['NGROK_PORT'] = port.to_s
      puts options.to_json
      puts "Starting ngrok: http://#{ENV['NGROK_SUBDOMAIN']}.ngrok.com"
      require 'spawnling'
      Spawnling.new(:kill => true) do
        exec("./ngrok http -authtoken="1QP44fp2ytyEx1p57SEq_2D8rXBnYgKkNnk53JRhDW" -subdomain=ad-wire 3000 > /dev/null;")
      end
    end

    def call(env)
      env
      @app.call(env)
    end
  end
end

require 'ngrok-rails/railtie' if defined? Rails::Railtie
