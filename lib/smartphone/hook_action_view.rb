require 'action_pack'
require 'action_view'

module ActionView
  class PathSet
    alias find_template_without_smartphone find_template #:nodoc:
    alias initialize_without_smartphone initialize #:nodoc:

    attr_accessor :controller

    def initialize(*args)
      if args.first.kind_of?(ActionController::Base)
        @controller = args.shift
      end
      initialize_without_smartphone(*args)
    end

    # hook ActionView::PathSet#find_template
    def find_template(original_template_path, format = nil, html_fallback = true) #:nodoc:
      if controller and controller.kind_of?(ActionController::Base) and controller.request.sphone?
        return original_template_path if original_template_path.respond_to?(:render)
        template_path = original_template_path.sub(/^\//, '')

        template_candidates = sphone_template_candidates(controller)
        format_postfix      = format ? ".#{format}" : ""

        each do |load_path|
          template_candidates.each do |template_postfix|
            if template = load_path["#{template_path}_#{template_postfix}#{format_postfix}"]
              return template
            end
          end
        end
      end

      return find_template_without_smartphone(original_template_path, format, html_fallback)
    end

    # collect cadidates of sphone_template
    def sphone_template_candidates(controller)
      candidates = []
      c = controller.request.sphone.class
      while c != Smartphone::Sphone::AbstractSphone
        candidates << "sphone_"+c.to_s.split(/::/).last.downcase
        c = c.superclass
      end
      candidates << "sphone"
    end
  end

  class Base #:nodoc:
    delegate :default_url_options, :to => :controller unless respond_to?(:default_url_options)

    # nothing to do
    def view_paths=(paths)
      @view_paths = self.class.process_view_paths(paths, controller)
    end

    def self.process_view_paths(value, controller = nil)
      if controller && controller.is_a?(ActionController::Base)
        ActionView::PathSet.new(controller, Array(value))
      else
        ActionView::PathSet.new(Array(value))
      end
    end

    def sphone_template_candidates
      candidates = []
      c = controller.request.sphone.class
      while c != Smartphone::Sphone::AbstractSphone
        candidates << "smartphone_"+c.to_s.split(/::/).last.downcase
        c = c.superclass
      end
      candidates << "smartphone"
    end

    def sphone_template_partial sphone_path
      # ActionView::PartialTemplate#extract_partial_name_and_path の動作を模倣
      if sphone_path.include?('/')
        path = File.dirname(sphone_path)
        partial_name = File.basename(sphone_path)
      else
        path = self.controller.class.controller_path
        partial_name = sphone_path
      end
      File.join(path, "_#{partial_name}")
    end

    def sphone_path template_path, type
      "#{template_path}_#{type}"
    end

    def sphone_template_path(template_path, partial=false)
      if controller.is_a?(ActionController::Base) && d = controller.request.sphone
        sphone_template_candidates.each do |v|
          dpath = sphone_path template_path, v
          if partial
            full_path = sphone_template_partial dpath
          else
            full_path = dpath
          end
          if template_exists?(full_path)
            return dpath
          end
        end
      end
      return nil
    end
  end
end
