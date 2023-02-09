# frozen_string_literal: true

require 'spec_helper'

describe RakeSecrets::Storage::FileSystem do
  describe '#store' do
    it 'stores the provided content at the provided path on disk' do
      path = './secret'
      content = 'supersecret'
      storage = described_class.new

      stub_file_write(path)

      storage.store(path, content)

      expect(File).to(have_received(:write).with(path, content))
    end
  end

  describe '#remove' do
    it 'removes the content at the provided path when the path exists' do
      path = 'path/to/secret'
      storage = described_class.new

      stub_file_exists(path)
      stub_file_delete(path)

      storage.remove(path)

      expect(File).to(have_received(:delete).with(path))
    end

    it 'raises a NoSuchPathError when the path does not exist' do
      path = 'non/existing/path'
      storage = described_class.new

      stub_file_not_exists(path)
      stub_file_delete(path)

      expect { storage.remove(path) }.to(
        raise_error(RakeSecrets::Errors::NoSuchPathError)
      )
    end
  end

  describe '#retrieve' do
    it 'retrieves the content at the provided path when the path exists' do
      path = 'path/to/secret'
      content = 'somesecret'
      storage = described_class.new

      stub_file_exists(path)
      stub_file_read(path, content)

      retrieved = storage.retrieve(path)

      expect(retrieved).to(eq(content))
    end

    it 'raises a NoSuchPathError when the path does not exist' do
      path = 'non/existing/path'
      storage = described_class.new

      stub_file_not_exists(path)
      stub_file_read(path)

      expect { storage.remove(path) }.to(
        raise_error(RakeSecrets::Errors::NoSuchPathError)
      )
    end
  end

  def stub_file_exists(path)
    allow(File).to(receive(:exist?).with(path).and_return(true))
  end

  def stub_file_not_exists(path)
    allow(File).to(receive(:exist?).with(path).and_return(false))
  end

  def stub_file_write(path)
    allow(File).to(receive(:write).with(path, anything))
  end

  def stub_file_delete(path)
    allow(File).to(receive(:delete).with(path))
  end

  def stub_file_read(path, content = '')
    allow(File).to(receive(:read).with(path).and_return(content))
  end
end
