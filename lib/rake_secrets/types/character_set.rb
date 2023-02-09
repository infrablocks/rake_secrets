# frozen_string_literal: true

require 'securerandom'

module RakeSecrets
  module Types
    class CharacterSet
      def initialize(character_set, opts = {})
        @character_set = character_set
        @character_count = character_set.length
        @length = opts[:length] || 32
      end

      def generate
        (1..@length)
          .collect { @character_set[random_index] }
          .join
      end

      private

      def random_index
        SecureRandom.random_number(@character_count)
      end
    end
  end
end
