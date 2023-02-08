# frozen_string_literal: true

module RakeSecrets
  module Types
    class UnsupportedOperationError < StandardError

    end

    class Base
      def generate
        raise(UnsupportedOperationError, '#generate not supported')
      end
    end
  end
end
