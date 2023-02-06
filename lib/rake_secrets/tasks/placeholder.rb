# frozen_string_literal: true

require 'rake_factory'

module RakeSecrets
  module Tasks
    class Placeholder < RakeFactory::Task
      default_name :placeholder
      default_description 'Create a placeholder secrets for testing access etc.'

      action do
        puts('Creating placeholder secret...')
      end
    end
  end
end
