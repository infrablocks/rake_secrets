# frozen_string_literal: true

require 'larder/storage'
require 'larder/backends'
require 'larder/path_manager'

module Larder
  def self.in_memory(opts = {})
    path_manager = Larder::PathManager.new(base_path: '/secrets')
    backend = Larder::Backends::InMemory.new(
      contents: opts[:contents],
      path_manager: path_manager
    )
    Larder::Storage.new(
      backend,
      path_manager: path_manager
    )
  end
end
