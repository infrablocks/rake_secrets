# frozen_string_literal: true

require_relative './base'

module RakeSecrets
  module Transformers
    class Identity < Base
      def transform(value)
        value
      end
    end
  end
end
