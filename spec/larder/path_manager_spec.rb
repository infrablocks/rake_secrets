# frozen_string_literal: true

require 'spec_helper'

describe Larder::PathManager do
  describe '#resolve' do
    context 'when no base path' do
      it 'returns a path unchanged for an absolute path' do
        absolute_path_string = '/path/to/file'
        path_manager = described_class.new

        path = path_manager.resolve(absolute_path_string)

        expect(path).to(eq(Larder::Path.new(absolute_path_string)))
      end

      it 'returns a path relative to the root for a relative path' do
        relative_path_string = 'path/to/file'
        absolute_path_string = '/path/to/file'
        path_manager = described_class.new

        path = path_manager.resolve(relative_path_string)

        expect(path).to(eq(Larder::Path.new(absolute_path_string)))
      end
    end

    context 'when base path' do
      it 'returns a path unchanged for an absolute path' do
        absolute_path_string = '/base/path/to/file'
        base_path_string = '/base'
        path_manager = described_class.new(base_path: base_path_string)

        path = path_manager.resolve(absolute_path_string)

        expect(path).to(eq(Larder::Path.new(absolute_path_string)))
      end

      it 'returns a path relative to the base path for a relative path' do
        relative_path_string = 'path/to/file'
        absolute_path_string = '/base/path/to/file'
        base_path_string = '/base'
        path_manager = described_class.new(base_path: base_path_string)

        path = path_manager.resolve(relative_path_string)

        expect(path).to(eq(Larder::Path.new(absolute_path_string)))
      end
    end
  end
end
