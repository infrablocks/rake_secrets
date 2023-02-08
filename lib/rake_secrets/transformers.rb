# frozen_string_literal: true

require_relative 'transformers/erb_template'
require_relative 'transformers/identity'

module RakeSecrets
  module Transformers
    class << self
      def erb_template(opts)
        ERBTemplate.new(opts)
      end

      def identity
        Identity.new
      end
    end
  end
end
