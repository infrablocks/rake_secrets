# frozen_string_literal: true

require_relative 'types/constant'
require_relative 'types/character_set'
require_relative 'types/alphabetic'
require_relative 'types/alphanumeric'
require_relative 'types/numeric'

module RakeSecrets
  module Types
    class << self
      def constant(value)
        Constant.new(value)
      end

      def character_set(set, opts = {})
        CharacterSet.new(set, opts)
      end

      def alphabetic(opts = {})
        Alphabetic.new(opts)
      end

      def alphanumeric(opts = {})
        Alphanumeric.new(opts)
      end

      def numeric(opts = {})
        Numeric.new(opts)
      end
    end
  end
end
