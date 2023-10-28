# frozen_string_literal: true

require_relative './path'

module Larder
  class PathManager
    def initialize(opts = {})
      @base_path = Path.new(opts[:base_path] || '/')
    end

    def resolve(path)
      @base_path.join(Path.new(path))
    end
  end
end
