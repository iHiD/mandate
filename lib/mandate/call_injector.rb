module Mandate
  module CallInjector
    def self.extended(base)
      class << base
        def call(*args)
          new(*args).call
        end
      end
    end
  end
end

