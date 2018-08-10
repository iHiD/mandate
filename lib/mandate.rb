require "mandate/version"
require "mandate/memoize"
require "mandate/call_injector"
require "mandate/initializer_injector"

module Mandate
  def self.included(base)
    base.extend(Memoize)
    base.extend(CallInjector)
    base.extend(InitializerInjector)
  end
end
