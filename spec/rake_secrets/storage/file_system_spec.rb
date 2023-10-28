# frozen_string_literal: true

require 'spec_helper'

describe RakeSecrets::Storage::FileSystem do
  describe '#store' do
    it 'stores the provided content at the provided path on disk' do
      path = './secret'
      content = 'supersecret'
      storage = described_class.new

      stub_make_directory
      stub_file_write(path)

      storage.store(path, content)

      expect(File).to(have_received(:write).with(path, content))
    end

    it 'ensures parent directory exists' do
      path = 'deeply/nested/path'
      content = 'supersecret'
      storage = described_class.new

      stub_make_directory
      stub_file_write(path)

      storage.store(path, content)

      expect(FileUtils).to(have_received(:mkdir_p).with('deeply/nested'))
    end

    it 'creates parent directory before trying to write the file' do
      path = 'deeply/nested/path'
      content = 'supersecret'
      storage = described_class.new

      stub_make_directory
      stub_file_write(path)

      storage.store(path, content)

      expect(FileUtils)
        .to(have_received(:mkdir_p)
              .with('deeply/nested')
              .ordered)
      expect(File)
        .to(have_received(:write)
              .with(path, content)
              .ordered)
    end

    [
      Errno::EACCES,
      Errno::EISDIR,
      Errno::ENOSPC,
      IOError
    ].each do |error_class|
      it 'raises a StoreError containing the underlying error when ' \
         "File.write raises a #{error_class} error" do
        path = './secret'
        content = 'supersecret'
        error = error_class.new('Something went wrong')

        storage = described_class.new

        stub_make_directory
        stub_file_write(path, outcome: error)

        expect { storage.store(path, content) }.to(
          raise_error(RakeSecrets::Errors::StoreError) do |e|
            expect(e.cause).to(eq(error))
          end
        )
      end
    end
  end

  describe '#remove' do
    it 'removes the content at the provided path when the path exists and ' \
       'represents a file' do
      path = 'path/to/secret'
      storage = described_class.new

      stub_file_exists(path)
      stub_file_delete(path)

      storage.remove(path)

      expect(File).to(have_received(:delete).with(path))
    end

    it 'recursively removes the directory at the provided path when the ' \
       'path exists and represents a directory', pending: 'directory delete' do
      path = 'path/to/secret'
      storage = described_class.new

      stub_file_exists(path)
      stub_file_delete(path)

      storage.remove(path)

      expect(File).to(have_received(:delete).with(path))

      raise
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

    [
      Errno::ENOENT,
      Errno::EACCES,
      Errno::EPERM,
      Errno::EBUSY,
      Errno::EISDIR,
      Errno::ENOTEMPTY
    ].each do |error_class|
      it 'raises a RemoveError containing the underlying error when ' \
         "File.delete raises a #{error_class} error" do
        path = 'path/to/secret'
        error = error_class.new('Something went wrong')

        storage = described_class.new

        stub_file_exists(path)
        stub_file_delete(path, outcome: error)

        expect { storage.remove(path) }.to(
          raise_error(RakeSecrets::Errors::RemoveError) do |e|
            expect(e.cause).to(eq(error))
          end
        )
      end
    end
  end

  describe '#retrieve' do
    it 'retrieves the content at the provided path when the path exists' do
      path = 'path/to/secret'
      content = 'somesecret'
      storage = described_class.new

      stub_file_exists(path)
      stub_file_read(path, { content: content })

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

    [
      Errno::ENOENT,
      Errno::EACCES,
      Errno::EPERM,
      Errno::EBUSY,
      Errno::EISDIR,
      Errno::ENOTEMPTY
    ].each do |error_class|
      it 'raises a RetrieveError containing the underlying error when ' \
         "File.read raises a #{error_class} error" do
        path = 'path/to/secret'
        error = error_class.new('Something went wrong')

        storage = described_class.new

        stub_file_exists(path)
        stub_file_read(path, outcome: error)

        expect { storage.retrieve(path) }.to(
          raise_error(RakeSecrets::Errors::RetrieveError) do |e|
            expect(e.cause).to(eq(error))
          end
        )
      end
    end
  end

  def stub_file_exists(path)
    allow(File).to(receive(:exist?).with(path).and_return(true))
  end

  def stub_file_not_exists(path)
    allow(File).to(receive(:exist?).with(path).and_return(false))
  end

  def stub_make_directory
    allow(FileUtils).to(receive(:mkdir_p))
  end

  def stub_file_write(path, opts = {})
    opts = { outcome: :success }.merge(opts)
    if opts[:outcome].is_a?(StandardError)
      allow(File).to(receive(:write)
                       .with(path, anything)
                       .and_raise(opts[:outcome]))
    else
      allow(File).to(receive(:write).with(path, anything))
    end
  end

  def stub_file_delete(path, opts = {})
    opts = { outcome: :success }.merge(opts)
    if opts[:outcome].is_a?(StandardError)
      allow(File).to(receive(:delete)
                       .with(path)
                       .and_raise(opts[:outcome]))
    else
      allow(File).to(receive(:delete).with(path))
    end
  end

  def stub_file_read(path, opts = {})
    opts = { outcome: :success, content: '' }.merge(opts)
    if opts[:outcome].is_a?(StandardError)
      allow(File).to(receive(:read)
                       .with(path)
                       .and_raise(opts[:outcome]))
    else
      allow(File).to(receive(:read).with(path).and_return(opts[:content]))
    end
  end
end
