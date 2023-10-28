# frozen_string_literal: true

require 'spec_helper'

describe Larder::Path do
  describe '#join' do
    it 'concatenates left with right when left is absolute and right is ' \
       'relative' do
      left_path = described_class.new('/base')
      right_path = described_class.new('path/to/thing')
      expected_path = described_class.new('/base/path/to/thing')

      concatenated_path = left_path.join(right_path)

      expect(concatenated_path).to(eq(expected_path))
    end

    it 'concatenates left with right when left is relative and right is ' \
       'relative' do
      left_path = described_class.new('base')
      right_path = described_class.new('path/to/thing')
      expected_path = described_class.new('base/path/to/thing')

      concatenated_path = left_path.join(right_path)

      expect(concatenated_path).to(eq(expected_path))
    end

    it 'returns right when left is absolute and right is absolute' do
      left_path = described_class.new('/base')
      right_path = described_class.new('/path/to/thing')
      expected_path = described_class.new('/path/to/thing')

      concatenated_path = left_path.join(right_path)

      expect(concatenated_path).to(eq(expected_path))
    end

    it 'returns right when left is relative and right is absolute' do
      left_path = described_class.new('base')
      right_path = described_class.new('/path/to/thing')
      expected_path = described_class.new('/path/to/thing')

      concatenated_path = left_path.join(right_path)

      expect(concatenated_path).to(eq(expected_path))
    end

    it 'removes preceding ./ at start of right when present' do
      left_path = described_class.new('base')
      right_path = described_class.new('./path/to/thing')
      expected_path = described_class.new('base/path/to/thing')

      concatenated_path = left_path.join(right_path)

      expect(concatenated_path).to(eq(expected_path))
    end

    it 'removes preceding ./ at start of left when present' do
      left_path = described_class.new('./base')
      right_path = described_class.new('path/to/thing')
      expected_path = described_class.new('base/path/to/thing')

      concatenated_path = left_path.join(right_path)

      expect(concatenated_path).to(eq(expected_path))
    end

    it 'resolves single .. at start of right when present and enough ' \
       'directories for resolution' do
      left_path = described_class.new('/base1/base2')
      right_path = described_class.new('../path/to/thing')
      expected_path = described_class.new('/base1/path/to/thing')

      concatenated_path = left_path.join(right_path)

      expect(concatenated_path).to(eq(expected_path))
    end

    it 'resolves multiple .. at start of right when present and enough ' \
       'directories for resolution' do
      left_path = described_class.new('/base1/base2')
      right_path = described_class.new('../../path/to/thing')
      expected_path = described_class.new('/path/to/thing')

      concatenated_path = left_path.join(right_path)

      expect(concatenated_path).to(eq(expected_path))
    end

    it 'resolves multiple .. at start of right when present and not enough ' \
       'directories for resolution as far as root directory' do
      left_path = described_class.new('/base1/base2')
      right_path = described_class.new('../../../path/to/thing')
      expected_path = described_class.new('/path/to/thing')

      concatenated_path = left_path.join(right_path)

      expect(concatenated_path).to(eq(expected_path))
    end

    it 'resolves .. within right when present' do
      left_path = described_class.new('/base1/base2')
      right_path = described_class.new('path/../to/thing')
      expected_path = described_class.new('/base1/base2/to/thing')

      concatenated_path = left_path.join(right_path)

      expect(concatenated_path).to(eq(expected_path))
    end

    it 'resolves .. at end of right when present' do
      left_path = described_class.new('/base1/base2')
      right_path = described_class.new('path/to/thing/..')
      expected_path = described_class.new('/base1/base2/path/to')

      concatenated_path = left_path.join(right_path)

      expect(concatenated_path).to(eq(expected_path))
    end

    it 'retains .. at start of left when present' do
      left_path = described_class.new('../base1/base2')
      right_path = described_class.new('path/to/thing')
      expected_path = described_class.new('../base1/base2/path/to/thing')

      concatenated_path = left_path.join(right_path)

      expect(concatenated_path).to(eq(expected_path))
    end

    it 'resolves .. within left when present' do
      left_path = described_class.new('/base1/../base2')
      right_path = described_class.new('path/to/thing')
      expected_path = described_class.new('/base2/path/to/thing')

      concatenated_path = left_path.join(right_path)

      expect(concatenated_path).to(eq(expected_path))
    end

    it 'resolves .. at end of left when present' do
      left_path = described_class.new('/base1/base2/..')
      right_path = described_class.new('path/to/thing')
      expected_path = described_class.new('/base1/path/to/thing')

      concatenated_path = left_path.join(right_path)

      expect(concatenated_path).to(eq(expected_path))
    end

    it 'removes / at end of right when present' do
      left_path = described_class.new('/base1/base2')
      right_path = described_class.new('path/to/thing/')
      expected_path = described_class.new('/base1/base2/path/to/thing')

      concatenated_path = left_path.join(right_path)

      expect(concatenated_path).to(eq(expected_path))
    end

    it 'removes // at start of left when present' do
      left_path = described_class.new('//base/')
      right_path = described_class.new('path/to/thing')
      expected_path = described_class.new('/base/path/to/thing')

      concatenated_path = left_path.join(right_path)

      expect(concatenated_path).to(eq(expected_path))
    end

    it 'removes // within left when present' do
      left_path = described_class.new('/base1//base2')
      right_path = described_class.new('path/to/thing')
      expected_path = described_class.new('/base1/base2/path/to/thing')

      concatenated_path = left_path.join(right_path)

      expect(concatenated_path).to(eq(expected_path))
    end

    it 'removes // at end of left when present' do
      left_path = described_class.new('/base1/base2//')
      right_path = described_class.new('path/to/thing')
      expected_path = described_class.new('/base1/base2/path/to/thing')

      concatenated_path = left_path.join(right_path)

      expect(concatenated_path).to(eq(expected_path))
    end

    it 'removes // at start of right when present' do
      left_path = described_class.new('/base')
      right_path = described_class.new('//path/to/thing')
      expected_path = described_class.new('/path/to/thing')

      concatenated_path = left_path.join(right_path)

      expect(concatenated_path).to(eq(expected_path))
    end

    it 'removes // within right when present' do
      left_path = described_class.new('/base1/base2')
      right_path = described_class.new('path//to/thing')
      expected_path = described_class.new('/base1/base2/path/to/thing')

      concatenated_path = left_path.join(right_path)

      expect(concatenated_path).to(eq(expected_path))
    end

    it 'removes // at end of right when present' do
      left_path = described_class.new('/base1/base2')
      right_path = described_class.new('path/to/thing//')
      expected_path = described_class.new('/base1/base2/path/to/thing')

      concatenated_path = left_path.join(right_path)

      expect(concatenated_path).to(eq(expected_path))
    end
  end

  describe '#==' do
    it 'returns true when left and right have identical path string' do
      left_path = described_class.new('/path/to/thing')
      right_path = described_class.new('/path/to/thing')

      expect(left_path == right_path).to(be(true))
    end

    it 'returns true when left starts with /.. and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('/../path/to/thing')
      right_path = described_class.new('/path/to/thing')

      expect(left_path == right_path).to(be(true))
    end

    it 'returns true when left contains .. and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('/path/to/other/../thing')
      right_path = described_class.new('/path/to/thing')

      expect(left_path == right_path).to(be(true))
    end

    it 'returns true when left ends with .. and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('/path/to/other/..')
      right_path = described_class.new('/path/to')

      expect(left_path == right_path).to(be(true))
    end

    it 'returns true when right starts with /.. and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('/path/to/thing')
      right_path = described_class.new('/../path/to/thing')

      expect(left_path == right_path).to(be(true))
    end

    it 'returns true when right contains .. and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('/path/to/thing')
      right_path = described_class.new('/path/to/other/../thing')

      expect(left_path == right_path).to(be(true))
    end

    it 'returns true when right ends with .. and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('/path/to')
      right_path = described_class.new('/path/to/other/..')

      expect(left_path == right_path).to(be(true))
    end

    it 'returns true when left starts with ./ and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('./path/to/thing')
      right_path = described_class.new('path/to/thing')

      expect(left_path == right_path).to(be(true))
    end

    it 'returns true when left contains ./ and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('path/./to/thing')
      right_path = described_class.new('path/to/thing')

      expect(left_path == right_path).to(be(true))
    end

    it 'returns true when left ends with /. and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('path/to/thing/.')
      right_path = described_class.new('path/to/thing')

      expect(left_path == right_path).to(be(true))
    end

    it 'returns true when right starts with ./ and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('path/to/thing')
      right_path = described_class.new('./path/to/thing')

      expect(left_path == right_path).to(be(true))
    end

    it 'returns true when right contains ./ and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('path/to/thing')
      right_path = described_class.new('path/./to/thing')

      expect(left_path == right_path).to(be(true))
    end

    it 'returns true when right ends with /. and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('path/to/thing')
      right_path = described_class.new('path/to/thing/.')

      expect(left_path == right_path).to(be(true))
    end

    it 'returns true when left starts with // and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('//path/to/thing')
      right_path = described_class.new('/path/to/thing')

      expect(left_path == right_path).to(be(true))
    end

    it 'returns true when left contains // and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('path//to/thing')
      right_path = described_class.new('path/to/thing')

      expect(left_path == right_path).to(be(true))
    end

    it 'returns true when left ends with // and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('path/to/thing//')
      right_path = described_class.new('path/to/thing')

      expect(left_path == right_path).to(be(true))
    end

    it 'returns true when right starts with // and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('/path/to/thing')
      right_path = described_class.new('//path/to/thing')

      expect(left_path == right_path).to(be(true))
    end

    it 'returns true when right contains // and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('path/to/thing')
      right_path = described_class.new('path/to//thing')

      expect(left_path == right_path).to(be(true))
    end

    it 'returns true when right ends with // and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('path/to/thing')
      right_path = described_class.new('path/to/thing//')

      expect(left_path == right_path).to(be(true))
    end

    it 'returns false when left and right represent different paths' do
      left_path = described_class.new('/path1/to1/thing1')
      right_path = described_class.new('/path2/to2/thing2')

      expect(left_path == right_path).to(be(false))
    end

    it 'returns false when right has a different class to left' do
      left_path = described_class.new('path/to/thing')
      right_path = Object.new

      expect(left_path == right_path).to(be(false))
    end
  end

  describe '#eql?' do
    it 'returns true when left and right have identical path string' do
      left_path = described_class.new('/path/to/thing')
      right_path = described_class.new('/path/to/thing')

      expect(left_path.eql?(right_path)).to(be(true))
    end

    it 'returns true when left starts with /.. and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('/../path/to/thing')
      right_path = described_class.new('/path/to/thing')

      expect(left_path.eql?(right_path)).to(be(true))
    end

    it 'returns true when left contains .. and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('/path/to/other/../thing')
      right_path = described_class.new('/path/to/thing')

      expect(left_path.eql?(right_path)).to(be(true))
    end

    it 'returns true when left ends with .. and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('/path/to/other/..')
      right_path = described_class.new('/path/to')

      expect(left_path.eql?(right_path)).to(be(true))
    end

    it 'returns true when right starts with /.. and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('/path/to/thing')
      right_path = described_class.new('/../path/to/thing')

      expect(left_path.eql?(right_path)).to(be(true))
    end

    it 'returns true when right contains .. and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('/path/to/thing')
      right_path = described_class.new('/path/to/other/../thing')

      expect(left_path.eql?(right_path)).to(be(true))
    end

    it 'returns true when right ends with .. and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('/path/to')
      right_path = described_class.new('/path/to/other/..')

      expect(left_path.eql?(right_path)).to(be(true))
    end

    it 'returns true when left starts with ./ and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('./path/to/thing')
      right_path = described_class.new('path/to/thing')

      expect(left_path.eql?(right_path)).to(be(true))
    end

    it 'returns true when left contains ./ and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('path/./to/thing')
      right_path = described_class.new('path/to/thing')

      expect(left_path.eql?(right_path)).to(be(true))
    end

    it 'returns true when left ends with /. and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('path/to/thing/.')
      right_path = described_class.new('path/to/thing')

      expect(left_path.eql?(right_path)).to(be(true))
    end

    it 'returns true when right starts with ./ and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('path/to/thing')
      right_path = described_class.new('./path/to/thing')

      expect(left_path.eql?(right_path)).to(be(true))
    end

    it 'returns true when right contains ./ and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('path/to/thing')
      right_path = described_class.new('path/./to/thing')

      expect(left_path.eql?(right_path)).to(be(true))
    end

    it 'returns true when right ends with /. and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('path/to/thing')
      right_path = described_class.new('path/to/thing/.')

      expect(left_path.eql?(right_path)).to(be(true))
    end

    it 'returns true when left starts with // and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('//path/to/thing')
      right_path = described_class.new('/path/to/thing')

      expect(left_path.eql?(right_path)).to(be(true))
    end

    it 'returns true when left contains // and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('path//to/thing')
      right_path = described_class.new('path/to/thing')

      expect(left_path.eql?(right_path)).to(be(true))
    end

    it 'returns true when left ends with // and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('path/to/thing//')
      right_path = described_class.new('path/to/thing')

      expect(left_path.eql?(right_path)).to(be(true))
    end

    it 'returns true when right starts with // and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('/path/to/thing')
      right_path = described_class.new('//path/to/thing')

      expect(left_path.eql?(right_path)).to(be(true))
    end

    it 'returns true when right contains // and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('path/to/thing')
      right_path = described_class.new('path/to//thing')

      expect(left_path.eql?(right_path)).to(be(true))
    end

    it 'returns true when right ends with // and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('path/to/thing')
      right_path = described_class.new('path/to/thing//')

      expect(left_path.eql?(right_path)).to(be(true))
    end

    it 'returns false when left and right represent different paths' do
      left_path = described_class.new('/path1/to1/thing1')
      right_path = described_class.new('/path2/to2/thing2')

      expect(left_path.eql?(right_path)).to(be(false))
    end

    it 'returns false when right has a different class to left' do
      left_path = described_class.new('path/to/thing')
      right_path = Object.new

      expect(left_path.eql?(right_path)).to(be(false))
    end
  end

  describe '#hash' do
    it 'returns same hash when left and right have identical path string' do
      left_path = described_class.new('/path/to/thing')
      right_path = described_class.new('/path/to/thing')

      expect(left_path.hash).to(eq(right_path.hash))
    end

    it 'returns true when left starts with /.. and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('/../path/to/thing')
      right_path = described_class.new('/path/to/thing')

      expect(left_path.hash).to(eq(right_path.hash))
    end

    it 'returns same hash when left contains .. and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('/path/to/other/../thing')
      right_path = described_class.new('/path/to/thing')

      expect(left_path.hash).to(eq(right_path.hash))
    end

    it 'returns same hash when left ends with .. and left and right ' \
       'represent same path after resolving' do
      left_path = described_class.new('/path/to/other/..')
      right_path = described_class.new('/path/to')

      expect(left_path.hash).to(eq(right_path.hash))
    end

    it 'returns same hash when right starts with /.. and left and right ' \
       'represent same path after resolving' do
      left_path = described_class.new('/path/to/thing')
      right_path = described_class.new('/../path/to/thing')

      expect(left_path.hash).to(eq(right_path.hash))
    end

    it 'returns same hash when right contains .. and left and right ' \
       'represent same path after resolving' do
      left_path = described_class.new('/path/to/thing')
      right_path = described_class.new('/path/to/other/../thing')

      expect(left_path.hash).to(eq(right_path.hash))
    end

    it 'returns same hash when right ends with .. and left and right ' \
       'represent same path after resolving' do
      left_path = described_class.new('/path/to')
      right_path = described_class.new('/path/to/other/..')

      expect(left_path.hash).to(eq(right_path.hash))
    end

    it 'returns same hash when left starts with ./ and left and right ' \
       'represent same path after resolving' do
      left_path = described_class.new('./path/to/thing')
      right_path = described_class.new('path/to/thing')

      expect(left_path.hash).to(eq(right_path.hash))
    end

    it 'returns same hash when left contains ./ and left and right represent ' \
       'same path after resolving' do
      left_path = described_class.new('path/./to/thing')
      right_path = described_class.new('path/to/thing')

      expect(left_path.hash).to(eq(right_path.hash))
    end

    it 'returns same hash when left ends with /. and left and right ' \
       'represent same path after resolving' do
      left_path = described_class.new('path/to/thing/.')
      right_path = described_class.new('path/to/thing')

      expect(left_path.hash).to(eq(right_path.hash))
    end

    it 'returns same hash when right starts with ./ and left and right ' \
       'represent same path after resolving' do
      left_path = described_class.new('path/to/thing')
      right_path = described_class.new('./path/to/thing')

      expect(left_path.hash).to(eq(right_path.hash))
    end

    it 'returns same hash when right contains ./ and left and right ' \
       'represent same path after resolving' do
      left_path = described_class.new('path/to/thing')
      right_path = described_class.new('path/./to/thing')

      expect(left_path.hash).to(eq(right_path.hash))
    end

    it 'returns same hash when right ends with /. and left and right ' \
       'represent same path after resolving' do
      left_path = described_class.new('path/to/thing')
      right_path = described_class.new('path/to/thing/.')

      expect(left_path.hash).to(eq(right_path.hash))
    end

    it 'returns same hash when left starts with // and left and right ' \
       'represent same path after resolving' do
      left_path = described_class.new('//path/to/thing')
      right_path = described_class.new('/path/to/thing')

      expect(left_path.hash).to(eq(right_path.hash))
    end

    it 'returns same hash when left contains // and left and right ' \
       'represent same path after resolving' do
      left_path = described_class.new('path//to/thing')
      right_path = described_class.new('path/to/thing')

      expect(left_path.hash).to(eq(right_path.hash))
    end

    it 'returns same hash when left ends with // and left and right ' \
       'represent same path after resolving' do
      left_path = described_class.new('path/to/thing//')
      right_path = described_class.new('path/to/thing')

      expect(left_path.hash).to(eq(right_path.hash))
    end

    it 'returns same hash when right starts with // and left and right ' \
       'represent same path after resolving' do
      left_path = described_class.new('/path/to/thing')
      right_path = described_class.new('//path/to/thing')

      expect(left_path.hash).to(eq(right_path.hash))
    end

    it 'returns same hash when right contains // and left and right ' \
       'represent same path after resolving' do
      left_path = described_class.new('path/to/thing')
      right_path = described_class.new('path/to//thing')

      expect(left_path.hash).to(eq(right_path.hash))
    end

    it 'returns same hash when right ends with // and left and right ' \
       'represent same path after resolving' do
      left_path = described_class.new('path/to/thing')
      right_path = described_class.new('path/to/thing//')

      expect(left_path.hash).to(eq(right_path.hash))
    end

    it 'returns different hash when left and right represent different ' \
       'paths' do
      left_path = described_class.new('/path1/to1/thing1')
      right_path = described_class.new('/path2/to2/thing2')

      expect(left_path.hash).not_to(eq(right_path.hash))
    end

    it 'returns different hash when right has a different class to left' do
      left_path = described_class.new('path/to/thing')
      right_path = Object.new

      expect(left_path.hash).not_to(eq(right_path.hash))
    end
  end

  describe '#to_s' do
    it 'returns path string unchanged when already clean' do
      path = described_class.new('path/to/thing')

      expect(path.to_s).to(eq('path/to/thing'))
    end

    it 'removes // from start of path string' do
      path = described_class.new('//path/to/thing')

      expect(path.to_s).to(eq('/path/to/thing'))
    end

    it 'removes // from within path string' do
      path = described_class.new('path//to/thing')

      expect(path.to_s).to(eq('path/to/thing'))
    end

    it 'removes // from end of path string' do
      path = described_class.new('path/to/thing//')

      expect(path.to_s).to(eq('path/to/thing'))
    end

    it 'removes ./ from start of path string' do
      path = described_class.new('./path/to/thing')

      expect(path.to_s).to(eq('path/to/thing'))
    end

    it 'removes ./ from within path string' do
      path = described_class.new('path/./to/thing')

      expect(path.to_s).to(eq('path/to/thing'))
    end

    it 'removes /. from end of path string' do
      path = described_class.new('path/to/thing/.')

      expect(path.to_s).to(eq('path/to/thing'))
    end

    it 'removes /.. from start of path string' do
      path = described_class.new('/../path/to/thing')

      expect(path.to_s).to(eq('/path/to/thing'))
    end

    it 'removes .. from within path string' do
      path = described_class.new('path/../to/thing')

      expect(path.to_s).to(eq('to/thing'))
    end

    it 'removes .. from end of path string' do
      path = described_class.new('path/to/thing/..')

      expect(path.to_s).to(eq('path/to'))
    end
  end
end
