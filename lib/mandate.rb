require "mandate/version"
require "mandate/memoize"

module Mandate
  def self.included(base)
    base.extend(Memoize)
  end

  # Your code goes here...
end
