# frozen_string_literal: true

require_relative './character_set'

module RakeSecrets
  module Types
    class Alphabetic
      LOWERCASE_CHARACTERS = ('a'..'z').to_a
      UPPERCASE_CHARACTERS = ('A'..'Z').to_a

      def initialize(opts = {})
        @delegate = CharacterSet.new(
          character_set(opts[:case]),
          length: opts[:length] || 32
        )
      end

      def generate
        @delegate.generate
      end

      private

      def character_set(case_type)
        characters = []
        characters += UPPERCASE_CHARACTERS if %i[upper both].include?(case_type)
        characters += LOWERCASE_CHARACTERS unless case_type == :upper
        characters
      end
    end
  end
end
