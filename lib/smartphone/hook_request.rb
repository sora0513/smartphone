require 'smartphone/request_with_sphone'

class ActionController::Request
  include Smartphone::RequestWithSphone
end
