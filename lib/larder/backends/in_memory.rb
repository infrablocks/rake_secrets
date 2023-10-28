# frozen_string_literal: true

require 'pathname'

require_relative '../base'
require_relative '../errors'

module Larder
  module Backends
    class InMemory < Base
      def initialize(opts = {})
        super()
        @path_manager = opts[:path_manager] || PathManager.new(opts)
        @persistence = normalise_paths(opts[:contents] || {})
      end

      def store(path, content)
        path = normalise_path(path)
        @persistence[path] = content
      end

      def remove(path)
        path = normalise_path(path)
        paths = matching_paths(path)

        raise(path_does_not_exist_error(path)) if paths.empty?

        paths.each do |p|
          @persistence.delete(p)
        end
      end

      def retrieve(path)
        path = normalise_path(path)

        if contains_path_as_directory?(path)
          raise(path_is_directory_error(path))
        end

        unless contains_path_as_file?(path)
          raise(path_does_not_exist_error(path))
        end

        @persistence[path]
      end

      private

      def normalise_paths(contents)
        contents.transform_keys { |key| normalise_path(key) }
      end

      def normalise_path(path)
        @path_manager.resolve(path)
      end

      def contains_path_as_file?(path)
        @persistence.include?(path)
      end

      def contains_path_as_directory?(path)
        paths = matching_paths(path)
        !(paths.empty? || paths.include?(path))
      end

      def matching_paths(path)
        @persistence
          .select { |k| k == path or k.descend.include?(path) }
          .keys
      end

      def path_does_not_exist_error(path)
        Errors::PathDoesNotExistError.new(
          "Path '#{path}' not in storage.", path
        )
      end

      def path_is_directory_error(path)
        Errors::PathIsDirectoryError.new(
          "Can't retrieve content as path '#{path}' is a directory",
          path
        )
      end
    end
  end
end
