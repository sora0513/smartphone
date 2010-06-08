module Smartphone
  module Rack
    class Request < ::Rack::Request
      include ::Smartphone::RequestWithSphone
    end
  end
end
