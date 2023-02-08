# frozen_string_literal: true

require_relative 'types/constant'
require_relative 'types/character_set'

module RakeSecrets
  module Types
    class << self
      def constant(value)
        Constant.new(value)
      end
    end
  end
end
