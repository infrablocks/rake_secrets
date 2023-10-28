# frozen_string_literal: true

require 'fileutils'

require_relative '../base'
require_relative '../errors'

module Larder
  module Backends
    class FileSystem < Base
      def store(path, content)
        make_parent_directory(path)
        write_file_at_path(path, content)
      rescue SystemCallError, IOError
        raise_store_error_for_path(path)
      end

      def remove(path)
        ensure_path_exists(path)
        remove_path(path)
      rescue SystemCallError
        raise_remove_error_for_path(path)
      end

      def retrieve(path)
        ensure_path_exists(path)
        read_file_at_path(path)
      rescue SystemCallError
        raise_retrieve_error_for_path(path)
      end

      private

      def make_parent_directory(path)
        FileUtils.mkdir_p(File.dirname(path))
      end

      def write_file_at_path(path, content)
        File.write(path, content)
      end

      def read_file_at_path(path)
        File.read(path)
      end

      def ensure_path_exists(path)
        return if File.exist?(path)

        raise(Errors::PathDoesNotExistError.new(
                "Path '#{path}' not in storage.",
                path
              ))
      end

      def remove_path(path)
        if File.directory?(path)
          FileUtils.rm_rf(path)
        else
          File.delete(path)
        end
      end

      def raise_store_error_for_path(path)
        raise(
          Errors::StoreError,
          "Failed to store at path: '#{path}'."
        )
      end

      def raise_remove_error_for_path(path)
        raise(
          Errors::RemoveError,
          "Failed to remove from path: '#{path}'."
        )
      end

      def raise_retrieve_error_for_path(path)
        raise(
          Errors::RetrieveError,
          "Failed to retrieve from path: '#{path}'."
        )
      end
    end
  end
end
