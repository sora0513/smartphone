require 'action_pack'

class ActionController::Base
  include Smartphone::Helpers

  class << self
    def view_paths=(value)
      @view_paths = ActionView::Base.process_view_paths(value) if value
    end
  end

  def view_paths=(value)
    @view_paths = ActionView::Base.process_view_paths(value, controller) if value
  end
end
