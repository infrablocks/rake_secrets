# frozen_string_literal: true

module Larder
  module Errors
    class PathIsDirectoryError < StandardError
      attr_reader :path

      def initialize(msg, path)
        super(msg)
        @path = path
      end
    end
  end
end
