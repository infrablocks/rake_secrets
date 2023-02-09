# frozen_string_literal: true

require_relative '../errors'

module RakeSecrets
  module Storage
    class Base
      def store(_path, _content)
        raise(Errors::UnsupportedOperationError, '#store not supported.')
      end

      def remove(_path)
        raise(Errors::UnsupportedOperationError, '#remove not supported.')
      end

      def retrieve(_path)
        raise(Errors::UnsupportedOperationError, '#retrieve not supported.')
      end
    end
  end
end
