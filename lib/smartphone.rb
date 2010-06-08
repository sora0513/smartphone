$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

module Smartphone
  autoload :RequestWithSphone, 'smartphone/request_with_sphone'

  module Sphone
    autoload :Iphone,      'smartphone/sphone/iphone'
    autoload :Ipad,        'smartphone/sphone/ipad'
    autoload :Android,     'smartphone/sphone/android'

    def self.sphones
      @sphones ||= constants
    end

    def self.sphones=(ary)
      @sphones = ary
    end
  end
end

%w(
  smartphone/version.rb
  smartphone/sphone/abstract_sphone.rb
  smartphone/sphone/display.rb
).each do |lib|
  require File.expand_path(File.join(File.dirname(__FILE__), lib))
end

if defined? RAILS_ENV
  Dir[File.expand_path(File.join(File.dirname(__FILE__), 'smartphone/*.rb'))].sort.each { |lib|
    require lib
  }
end