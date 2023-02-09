# frozen_string_literal: true

require 'fileutils'

require_relative './base'
require_relative '../errors'

module RakeSecrets
  module Storage
    class FileSystem < Base
      def store(path, content)
        FileUtils.mkdir_p(File.dirname(path))
        File.write(path, content)
      rescue SystemCallError, IOError
        raise(
          RakeSecrets::Errors::StoreError,
          "Failed to store at path: '#{path}'."
        )
      end

      def remove(path)
        ensure_path_exists(path)

        File.delete(path)
      rescue SystemCallError
        raise(
          RakeSecrets::Errors::RemoveError,
          "Failed to remove from path: '#{path}'."
        )
      end

      def retrieve(path)
        ensure_path_exists(path)

        File.read(path)
      rescue SystemCallError
        raise(
          RakeSecrets::Errors::RetrieveError,
          "Failed to retrieve from path: '#{path}'."
        )
      end

      private

      def ensure_path_exists(path)
        return if File.exist?(path)

        raise(Errors::NoSuchPathError, "Path '#{path}' not in storage.")
      end
    end
  end
end
