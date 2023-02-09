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
        ensure_path_exists(path)

        @persistence.delete(path)
      end

      def retrieve(path)
        ensure_path_exists(path)

        @persistence[path]
      end

      private

      def ensure_path_exists(path)
        return if @persistence.include?(path)

        raise(Errors::NoSuchPathError, "Path '#{path}' not in storage.")
      end
    end
  end
end
