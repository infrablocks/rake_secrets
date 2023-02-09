# frozen_string_literal: true

module RakeSecrets
  module Transformers
    class Identity
      def transform(value)
        value
      end
    end
  end
end
