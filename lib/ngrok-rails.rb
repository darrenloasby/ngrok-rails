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
        exec("/usr/local/bin/ngrok http -authtoken='#{ENV['NGROK_TOKEN']}' -subdomain='adwire' 3000 > /dev/null;")
      end
    end

    def call(env)
      env
      @app.call(env)
    end
  end
end

require 'ngrok-rails/railtie' if defined? Rails::Railtie
