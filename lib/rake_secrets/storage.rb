# frozen_string_literal: true

require_relative 'storage/in_memory'

module RakeSecrets
  module Storage
    class << self
      def in_memory(initial = {})
        InMemory.new(initial)
      end
    end
  end
end
