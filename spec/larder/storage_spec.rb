# frozen_string_literal: true

require 'spec_helper'

describe Larder::Storage do
  describe '#store' do
    context 'when no base path' do
      context 'when path is relative' do
        it 'resolves path relative to root before storing' do
          relative_path = 'path/to/secret'
          absolute_path = '/path/to/secret'
          content = 'supersecret'

          path_manager = Larder::PathManager.new
          backend = stub_backend

          storage = described_class.new(
            backend, path_manager: path_manager
          )

          storage.store(relative_path, content)

          expect(backend)
            .to(have_received(:store)
                  .with(Larder::Path.new(absolute_path), content))
        end
      end

      context 'when path is absolute' do
        it 'uses path as is when storing' do
          absolute_path = '/path/to/secret'
          content = 'supersecret'

          path_manager = Larder::PathManager.new
          backend = stub_backend

          storage = described_class.new(
            backend, path_manager: path_manager
          )

          storage.store(absolute_path, content)

          expect(backend)
            .to(have_received(:store)
                  .with(Larder::Path.new(absolute_path), content))
        end
      end
    end

    context 'when base path' do
      context 'when path is relative' do
        it 'resolves path relative to the base path before storing' do
          relative_path = 'path/to/secret'
          absolute_path = '/base/path/to/secret'
          content = 'supersecret'

          path_manager = Larder::PathManager.new(base_path: '/base')
          backend = stub_backend

          storage = described_class.new(
            backend, path_manager: path_manager
          )

          storage.store(relative_path, content)

          expect(backend)
            .to(have_received(:store)
                  .with(Larder::Path.new(absolute_path), content))
        end
      end

      context 'when path is absolute' do
        it 'uses path as is when storing' do
          absolute_path = '/path/to/secret'
          content = 'supersecret'

          path_manager = Larder::PathManager.new(base_path: '/base')
          backend = stub_backend

          storage = described_class.new(
            backend, path_manager: path_manager
          )

          storage.store(absolute_path, content)

          expect(backend)
            .to(have_received(:store)
                  .with(Larder::Path.new(absolute_path), content))
        end
      end
    end
  end

  describe '#remove' do
    context 'when no base path' do
      context 'when path is relative' do
        it 'resolves path relative to root before removing' do
          relative_path = 'path/to/secret'
          absolute_path = '/path/to/secret'

          path_manager = Larder::PathManager.new
          backend = stub_backend

          storage = described_class.new(
            backend, path_manager: path_manager
          )

          storage.remove(relative_path)

          expect(backend)
            .to(have_received(:remove)
                  .with(Larder::Path.new(absolute_path)))
        end
      end

      context 'when path is absolute' do
        it 'uses path as is when removing' do
          absolute_path = '/path/to/secret'

          path_manager = Larder::PathManager.new
          backend = stub_backend

          storage = described_class.new(
            backend, path_manager: path_manager
          )

          storage.remove(absolute_path)

          expect(backend)
            .to(have_received(:remove)
                  .with(Larder::Path.new(absolute_path)))
        end
      end
    end

    context 'when base path' do
      context 'when path is relative' do
        it 'resolves path relative to the base path before removing' do
          relative_path = 'path/to/secret'
          absolute_path = '/base/path/to/secret'

          path_manager = Larder::PathManager.new(base_path: '/base')
          backend = stub_backend

          storage = described_class.new(
            backend, path_manager: path_manager
          )

          storage.remove(relative_path)

          expect(backend)
            .to(have_received(:remove)
                  .with(Larder::Path.new(absolute_path)))
        end
      end

      context 'when path is absolute' do
        it 'uses path as is when removing' do
          absolute_path = '/path/to/secret'

          path_manager = Larder::PathManager.new(base_path: '/base')
          backend = stub_backend

          storage = described_class.new(
            backend, path_manager: path_manager
          )

          storage.remove(absolute_path)

          expect(backend)
            .to(have_received(:remove)
                  .with(Larder::Path.new(absolute_path)))
        end
      end
    end
  end

  describe '#retrieve' do
    context 'when no base path' do
      context 'when path is relative' do
        it 'resolves path relative to root before retrieving' do
          relative_path = 'path/to/secret'
          absolute_path = '/path/to/secret'

          path_manager = Larder::PathManager.new
          backend = stub_backend

          storage = described_class.new(
            backend, path_manager: path_manager
          )

          storage.retrieve(relative_path)

          expect(backend)
            .to(have_received(:retrieve)
                  .with(Larder::Path.new(absolute_path)))
        end
      end

      context 'when path is absolute' do
        it 'uses path as is when retrieving' do
          absolute_path = '/path/to/secret'

          path_manager = Larder::PathManager.new
          backend = stub_backend

          storage = described_class.new(
            backend, path_manager: path_manager
          )

          storage.retrieve(absolute_path)

          expect(backend)
            .to(have_received(:retrieve)
                  .with(Larder::Path.new(absolute_path)))
        end
      end
    end

    context 'when base path' do
      context 'when path is relative' do
        it 'resolves path relative to the base path before retrieving' do
          relative_path = 'path/to/secret'
          absolute_path = '/base/path/to/secret'

          path_manager = Larder::PathManager.new(base_path: '/base')
          backend = stub_backend

          storage = described_class.new(
            backend, path_manager: path_manager
          )

          storage.retrieve(relative_path)

          expect(backend)
            .to(have_received(:retrieve)
                  .with(Larder::Path.new(absolute_path)))
        end
      end

      context 'when path is absolute' do
        it 'uses path as is when retrieving' do
          absolute_path = '/path/to/secret'

          path_manager = Larder::PathManager.new(base_path: '/base')
          backend = stub_backend

          storage = described_class.new(
            backend, path_manager: path_manager
          )

          storage.retrieve(absolute_path)

          expect(backend)
            .to(have_received(:retrieve)
                  .with(Larder::Path.new(absolute_path)))
        end
      end
    end
  end

  def stub_backend
    backend = instance_double(Larder::Base)
    allow(backend).to(receive(:store))
    allow(backend).to(receive(:remove))
    allow(backend).to(receive(:retrieve))
    backend
  end
end
