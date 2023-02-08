# frozen_string_literal: true

require 'rake_factory'

require_relative '../transformers'

module RakeSecrets
  module Tasks
    class Generate < RakeFactory::Task
      default_name :generate
      default_description(RakeFactory::DynamicValue.new do |t|
        "Generates and stores the '#{t.id}' secret."
      end)

      parameter :id, required: true
      parameter :specification, required: true
      parameter :backend, required: true
      parameter :path, required: true
      parameter :transformer, default: Transformers.identity

      action do
        puts("Generating '#{id}' secret...")
        secret = specification.generate
        transformed = transformer.transform(secret)
        backend.store(path, transformed)
      end
    end
  end
end
