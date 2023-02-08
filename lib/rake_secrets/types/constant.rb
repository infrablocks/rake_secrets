# frozen_string_literal: true

require_relative './base'

module RakeSecrets
  module Types
    class Constant < Base
      def initialize(value)
        super()
        @value = value
      end

      def generate
        @value
      end
    end
  end
end
