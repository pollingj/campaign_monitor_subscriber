require 'active_support'
require 'active_support/core_ext/hash/keys'

module Rails
  def self.env
    'production'
  end
end

module ActiveRecord
  class Base
    def self.after_create(&block)
      define_method :after_create do
        block.call(self)
      end
    end

    def self.after_destroy(&block)
      define_method :after_destroy do
        block.call(self)
      end
    end
  end
end

class Monkey < ActiveRecord::Base
  def email
    'monkey@gmail.com'
  end

  def full_name
    'monkey man'
  end

  def user_status
    'new'
  end
end


require 'campaign_monitor_subscriber'
