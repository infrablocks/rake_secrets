# frozen_string_literal: true

require 'spec_helper'

describe RakeSecrets::Storage::InMemory do
  describe '#store' do
    it 'stores the provided content at the provided path' do
      path = 'path/to/secret'
      content = 'supersecret'
      storage = described_class.new

      storage.store(path, content)

      expect(storage.retrieve(path)).to(eq(content))
    end
  end

  describe '#remove' do
    it 'removes the content at the provided path' do
      path = 'path/to/secret'
      content = 'supersecret'
      storage = described_class.new

      storage.store(path, content)
      storage.remove(path)

      expect { storage.retrieve(path) }.to(
        raise_error(RakeSecrets::Errors::NoSuchPathError)
      )
    end

    it 'raises a NoSuchPathError when the provided path is not present' do
      path = 'path/to/secret'
      storage = described_class.new

      expect { storage.remove(path) }.to(
        raise_error(RakeSecrets::Errors::NoSuchPathError)
      )
    end

    it 'removes from contents passed at initialisation when provided' do
      path = 'path/to/secret'
      content = 'its_a_secret'
      storage = described_class.new(
        contents: {
          path => content
        }
      )

      storage.remove(path)

      expect { storage.retrieve(path) }.to(
        raise_error(RakeSecrets::Errors::NoSuchPathError)
      )
    end
  end

  describe '#retrieve' do
    it 'uses contents passed at initialisation when provided' do
      path = 'path/to/secret'
      content = 'its_a_secret'
      storage = described_class.new(
        contents: {
          path => content
        }
      )

      expect(storage.retrieve(path)).to(eq(content))
    end
  end
end
