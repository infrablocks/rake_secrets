# frozen_string_literal: true

require_relative '../template'

module RakeSecrets
  module Transformers
    class ERBTemplate
      def initialize(opts)
        super()
        @template = Template.new(opts[:content])
      end

      def transform(value)
        @template.render(value:)
      end
    end
  end
end
