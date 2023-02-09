# frozen_string_literal: true

module RakeSecrets
  module Types
    class Constant
      def initialize(value)
        @value = value
      end

      def generate
        @value
      end
    end
  end
end
