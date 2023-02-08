# frozen_string_literal: true

require 'rake_factory'

module RakeSecrets
  module Transformers
    class UnsupportedOperationError < StandardError

    end

    class Base
      def transform(_value)
        raise(UnsupportedOperationError, '#transform not supported.')
      end
    end
  end
end
