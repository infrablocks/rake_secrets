# frozen_string_literal: true

require_relative './base'

module RakeSecrets
  module Storage
    class InMemory < Base
      def initialize(persistence = {})
        super()
        @persistence = persistence
      end

      def store(path, content)
        @persistence[path] = content
      end

      def remove(path)
        @persistence.delete(path)
      end

      def get(path)
        @persistence[path]
      end
    end
  end
end
