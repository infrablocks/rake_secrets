# frozen_string_literal: true

require 'spec_helper'

describe RakeSecrets::Types::CharacterSet do
  describe '#generate' do
    describe 'by default' do
      it 'generates strings of length 32' do
        definition = described_class.new(('a'..'f').to_a)

        all_results = (1..1000).collect { definition.generate }
        all_result_lengths = all_results.collect(&:length)
        unique_result_lengths = Set.new(all_result_lengths)

        expect(unique_result_lengths).to(eq(Set.new([32])))
      end

      it 'generates unique strings' do
        definition = described_class.new(('a'..'f').to_a)

        all_results = (1..1000).collect { definition.generate }
        unique_results = Set.new(all_results)

        expect(unique_results.length).to(eq(1000))
      end

      it 'generates strings containing only characters from the provided set' do
        definition = described_class.new(('a'..'f').to_a)

        all_results = (1..1000).collect { definition.generate }
        all_characters = all_results.inject([]) do |chars, r|
          chars + r.chars
        end
        unique_characters = Set.new(all_characters)
        expected_characters = Set.new(%w[a b c d e f])

        expect(unique_characters.subset?(expected_characters))
          .to(be(true))
      end
    end

    describe 'when length option passed' do
      it 'generates strings of the specified length' do
        definition = described_class.new(('a'..'f').to_a, length: 20)

        all_results = (1..1000).collect { definition.generate }
        all_result_lengths = all_results.collect(&:length)
        unique_result_lengths = Set.new(all_result_lengths)

        expect(unique_result_lengths).to(eq(Set.new([20])))
      end
    end
  end
end
