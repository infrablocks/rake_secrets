# frozen_string_literal: true

require_relative 'base'
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
        paths = matching_paths(path)

        if paths.empty?
          raise(Errors::NoSuchPathError, "Path '#{path}' not in storage.")
        end

        paths.each do |p|
          @persistence.delete(p)
        end
      end

      def retrieve(path)
        unless contains_exact_path?(path)
          raise(Errors::NoSuchPathError, "Path '#{path}' not in storage.")
        end

        @persistence[path]
      end

      private

      def contains_exact_path?(path)
        @persistence.include?(path)
      end

      def matching_paths(path)
        @persistence.select { |k| k == path or k.start_with?(path) }.keys
      end
    end
  end
end
