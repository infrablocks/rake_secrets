# frozen_string_literal: true

require 'rake_factory'

module RakeSecrets
  module Storage
    class UnsupportedOperationError < StandardError

    end

    class Base
      def store(_path, _content)
        raise(UnsupportedOperationError, '#store not supported.')
      end

      def remove(_path)
        raise(UnsupportedOperationError, '#remove not supported.')
      end

      def get(_path)
        raise(UnsupportedOperationError, '#get not supported.')
      end
    end
  end
end
