# frozen_string_literal: true

require_relative './base'
require_relative '../errors'

module RakeSecrets
  module Storage
    class FileSystem < Base
      def store(path, content)
        File.write(path, content)
      end

      def remove(path)
        ensure_path_exists(path)

        File.delete(path)
      end

      def retrieve(path)
        ensure_path_exists(path)

        File.read(path)
      end

      private

      def ensure_path_exists(path)
        return if File.exist?(path)

        raise(Errors::NoSuchPathError, "Path '#{path}' not in storage.")
      end
    end
  end
end
