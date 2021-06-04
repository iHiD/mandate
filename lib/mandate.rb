require "mandate/version"
require "mandate/memoize"
require "mandate/call_injector"
require "mandate/initializer_injector"
require "mandate/callbacks"

module Mandate
  def self.included(base)
    base.extend(Memoize)
    base.extend(CallInjector)
    base.extend(InitializerInjector)
  end

  def self.use_notifications!
    Config.instance.use_notifications!
  end

  def self.use_notifications?
    !!Config.instance.use_notifications
  end

  class Config
    include Singleton

    attr_reader :use_notifications

    def use_notifications!
      begin
        require 'active_support/notifications'
      rescue StandardError => e
        puts "ActiveSupport must be in the Gemfile to use notifications"
        raise e
      end

      @use_notifications = true
    end

    # Used in the tests
    def do_not_use_notifications!
      @use_notifications = false
    end
  end
end
