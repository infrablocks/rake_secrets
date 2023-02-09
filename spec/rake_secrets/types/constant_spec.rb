# frozen_string_literal: true

require 'spec_helper'

describe RakeSecrets::Types::Constant do
  describe '#generate' do
    it 'constantly returns the value passed at creation' do
      definition = described_class.new('supersecret')

      expect(definition.generate).to(eq('supersecret'))
    end
  end
end
