# frozen_string_literal: true

require 'spec_helper'
require 'set'

describe RakeSecrets::Types::Alphabetic do
  describe '#generate' do
    describe 'by default' do
      it 'generates strings of length 32' do
        definition = described_class.new

        all_results = (1..1000).collect { definition.generate }
        all_result_lengths = all_results.collect(&:length)
        unique_result_lengths = Set.new(all_result_lengths)

        expect(unique_result_lengths).to(eq(Set.new([32])))
      end

      it 'generates unique strings' do
        definition = described_class.new

        all_results = (1..1000).collect { definition.generate }
        unique_results = Set.new(all_results)

        expect(unique_results.length).to(eq(1000))
      end

      it 'generates strings containing only a-z' do
        definition = described_class.new

        all_results = (1..1000).collect { definition.generate }
        all_characters = all_results.inject([]) do |chars, r|
          chars + r.chars
        end
        unique_characters = Set.new(all_characters)
        expected_characters = Set.new(
          %w[
            a b c d e f g h i j k l m n o p q r s t u v w x y z
          ]
        )

        expect(unique_characters.subset?(expected_characters))
          .to(be(true))
      end
    end

    describe 'when length option passed' do
      it 'generates strings of the specified length' do
        definition = described_class.new(length: 20)

        all_results = (1..1000).collect { definition.generate }
        all_result_lengths = all_results.collect(&:length)
        unique_result_lengths = Set.new(all_result_lengths)

        expect(unique_result_lengths).to(eq(Set.new([20])))
      end
    end

    describe 'when case option is :lower' do
      it 'generates strings containing only a-z' do
        definition = described_class.new(case: :lower)

        all_results = (1..1000).collect { definition.generate }
        all_characters = all_results.inject([]) do |chars, r|
          chars + r.chars
        end
        unique_characters = Set.new(all_characters)
        expected_characters = Set.new(
          %w[
            a b c d e f g h i j k l m n o p q r s t u v w x y z
          ]
        )

        expect(unique_characters.subset?(expected_characters))
          .to(be(true))
      end
    end

    describe 'when case option is :upper' do
      it 'generates strings containing only A-Z' do
        definition = described_class.new(case: :upper)

        all_results = (1..1000).collect { definition.generate }
        all_characters = all_results.inject([]) do |chars, r|
          chars + r.chars
        end
        unique_characters = Set.new(all_characters)
        expected_characters = Set.new(
          %w[
            A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
          ]
        )

        expect(unique_characters.subset?(expected_characters))
          .to(be(true))
      end
    end

    describe 'when case option is :both' do
      it 'generates strings containing only a-z and A-Z' do
        definition = described_class.new(case: :both)

        all_results = (1..1000).collect { definition.generate }
        all_characters = all_results.inject([]) do |chars, r|
          chars + r.chars
        end
        unique_characters = Set.new(all_characters)
        expected_characters = Set.new(
          %w[
            a b c d e f g h i j k l m n o p q r s t u v w x y z
            A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
          ]
        )

        expect(unique_characters.subset?(expected_characters))
          .to(be(true))
      end
    end

    describe 'when case option not recognised' do
      it 'generates strings containing only a-z' do
        definition = described_class.new(case: :incorrect)

        all_results = (1..1000).collect { definition.generate }
        all_characters = all_results.inject([]) do |chars, r|
          chars + r.chars
        end
        unique_characters = Set.new(all_characters)
        expected_characters = Set.new(
          %w[
            a b c d e f g h i j k l m n o p q r s t u v w x y z
          ]
        )

        expect(unique_characters.subset?(expected_characters))
          .to(be(true))
      end
    end
  end
end
