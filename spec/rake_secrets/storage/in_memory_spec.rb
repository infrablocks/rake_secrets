# frozen_string_literal: true

require 'spec_helper'

describe RakeSecrets::Storage::InMemory do
  it 'stores the provided content at the provided path' do
    path = 'path/to/secret'
    content = 'supersecret'
    storage = described_class.new

    storage.store(path, content)

    expect(storage.retrieve(path)).to(eq(content))
  end

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

  it 'can be initialised with pre-existing contents' do
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
