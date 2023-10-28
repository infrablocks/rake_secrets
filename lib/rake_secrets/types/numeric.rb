# frozen_string_literal: true

require_relative 'character_set'

module RakeSecrets
  module Types
    class Numeric
      NUMBER_CHARACTERS = ('0'..'9').to_a

      def initialize(opts = {})
        @delegate = CharacterSet.new(
          NUMBER_CHARACTERS,
          length: opts[:length] || 32
        )
      end

      def generate
        @delegate.generate
      end
    end
  end
end
