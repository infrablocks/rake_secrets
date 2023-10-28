# frozen_string_literal: true

require_relative './base'
require_relative './path_manager'

module Larder
  class Storage < Base
    def initialize(backend, opts = {})
      super()
      @backend = backend
      @path_manager = opts[:path_manager] || PathManager.new(opts)
    end

    def store(path, content)
      backend.store(
        path_manager.resolve(path),
        content
      )
    end

    def remove(path)
      backend.remove(
        path_manager.resolve(path)
      )
    end

    def retrieve(path)
      backend.retrieve(
        path_manager.resolve(path)
      )
    end

    private

    attr_reader :backend, :path_manager
  end
end
