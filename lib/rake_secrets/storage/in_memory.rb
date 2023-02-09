# frozen_string_literal: true

require_relative './base'
require_relative '../errors'

module RakeSecrets
  module Storage
    class InMemory < Base
      def initialize(opts = {})
        super()
        @persistence = opts[:contents] || {}
      end

      def store(path, content)
        @persistence[path] = content
      end

      def remove(path)
        @persistence.delete(path)
      end

      def retrieve(path)
        unless @persistence.include?(path)
          raise(Errors::NoSuchPathError, "Path '#{path}' not in storage.")
        end

        @persistence[path]
      end
    end
  end
end
