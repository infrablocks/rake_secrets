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

    it 'removes all subpaths when provided path is a directory' do
      path1 = 'path/to/secret1'
      path2 = 'path/to/secret2'
      path3 = 'other/secret'

      content1 = 'supersecret1'
      content2 = 'supersecret2'
      content3 = 'supersecret3'

      parent_path = 'path/to'

      storage = described_class.new

      storage.store(path1, content1)
      storage.store(path2, content2)
      storage.store(path3, content3)

      storage.remove(parent_path)

      expect { storage.retrieve(path1) }.to(
        raise_error(RakeSecrets::Errors::NoSuchPathError)
      )
      expect { storage.retrieve(path2) }.to(
        raise_error(RakeSecrets::Errors::NoSuchPathError)
      )
      expect(storage.retrieve(path3)).to(eq(content3))
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
