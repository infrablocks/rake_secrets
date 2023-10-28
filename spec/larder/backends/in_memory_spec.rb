# frozen_string_literal: true

require 'spec_helper'

describe Larder::Backends::InMemory do
  describe '#store' do
    context 'when no base path and path is relative' do
      it 'stores the content at the path relative to the root' do
        relative_path = 'path/to/secret'
        absolute_path = '/path/to/secret'
        content = 'supersecret'
        storage = described_class.new

        storage.store(relative_path, content)

        expect(storage.retrieve(absolute_path)).to(eq(content))
      end
    end

    context 'when no base path and path is absolute' do
      it 'stores the content at the absolute path' do
        absolute_path = '/path/to/secret'
        content = 'supersecret'
        storage = described_class.new

        storage.store(absolute_path, content)

        expect(storage.retrieve(absolute_path)).to(eq(content))
      end
    end

    context 'when base path and path is relative' do
      it 'stores the content at the path relative to the base bath' do
        relative_path = 'path/to/secret'
        absolute_path = '/base/path/to/secret'
        content = 'supersecret'
        storage = described_class.new(base_path: '/base')

        storage.store(relative_path, content)

        expect(storage.retrieve(absolute_path)).to(eq(content))
      end
    end

    context 'when base path and path is absolute' do
      it 'stores the content at the absolute path' do
        absolute_path = '/path/to/secret'
        content = 'supersecret'
        storage = described_class.new(base_path: '/base')

        storage.store(absolute_path, content)

        expect(storage.retrieve(absolute_path)).to(eq(content))
      end
    end
  end

  describe '#remove' do
    context 'when path is relative' do
      context 'when no base path' do
        it 'removes the content at the path relative to the root when path ' \
           'holds content' do
          relative_path = 'path/to/secret'
          absolute_path = '/path/to/secret'
          content = 'supersecret'
          storage = described_class.new

          storage.store(relative_path, content)
          storage.remove(relative_path)

          expect { storage.retrieve(absolute_path) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
        end

        it 'removes all subpaths relative to the root when path is a ' \
           'directory' do
          relative_path1 = 'path/to/secret1'
          relative_path2 = 'path/to/secret2'
          relative_path3 = 'other/secret'

          absolute_path1 = '/path/to/secret1'
          absolute_path2 = '/path/to/secret2'
          absolute_path3 = '/other/secret'

          content1 = 'supersecret1'
          content2 = 'supersecret2'
          content3 = 'supersecret3'

          parent_relative_path = 'path/to'

          storage = described_class.new

          storage.store(relative_path1, content1)
          storage.store(relative_path2, content2)
          storage.store(relative_path3, content3)

          storage.remove(parent_relative_path)

          expect { storage.retrieve(absolute_path1) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
          expect { storage.retrieve(absolute_path2) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
          expect(storage.retrieve(absolute_path3)).to(eq(content3))
        end

        it 'removes from contents passed at initialisation for path relative ' \
           'to root when path holds content' do
          relative_path = 'path/to/secret'
          absolute_path = '/path/to/secret'
          content = 'its_a_secret'
          storage = described_class.new(
            contents: {
              relative_path => content
            }
          )

          storage.remove(relative_path)

          expect { storage.retrieve(absolute_path) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
        end

        it 'removes from contents passed at initialisation for path relative ' \
           'to root when path is a directory' do
          relative_path1 = 'path/to/secret1'
          relative_path2 = 'path/to/secret2'
          relative_path3 = 'other/secret'

          absolute_path1 = '/path/to/secret1'
          absolute_path2 = '/path/to/secret2'
          absolute_path3 = '/other/secret'

          content1 = 'supersecret1'
          content2 = 'supersecret2'
          content3 = 'supersecret3'

          parent_relative_path = 'path/to'

          storage = described_class.new(
            contents: {
              relative_path1 => content1,
              relative_path2 => content2,
              relative_path3 => content3
            }
          )

          storage.remove(parent_relative_path)

          expect { storage.retrieve(absolute_path1) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
          expect { storage.retrieve(absolute_path2) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
          expect(storage.retrieve(absolute_path3)).to(eq(content3))
        end

        it 'raises a PathDoesNotExistError when the path is not present' do
          path = 'path/to/secret'
          storage = described_class.new

          expect { storage.remove(path) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
        end
      end

      context 'when base path' do
        it 'removes the content at the path relative to the base path when ' \
           'path holds content' do
          relative_path = 'path/to/secret'
          absolute_path = '/base/path/to/secret'
          base_path = '/base'
          content = 'supersecret'
          storage = described_class.new(base_path: base_path)

          storage.store(relative_path, content)
          storage.remove(relative_path)

          expect { storage.retrieve(absolute_path) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
        end

        it 'removes all subpaths relative to the base path when path is a ' \
           'directory' do
          relative_path1 = 'path/to/secret1'
          relative_path2 = 'path/to/secret2'
          relative_path3 = 'other/secret'

          absolute_path1 = '/base/path/to/secret1'
          absolute_path2 = '/base/path/to/secret2'
          absolute_path3 = '/base/other/secret'

          base_path = '/base'

          content1 = 'supersecret1'
          content2 = 'supersecret2'
          content3 = 'supersecret3'

          parent_relative_path = 'path/to'

          storage = described_class.new(base_path: base_path)

          storage.store(relative_path1, content1)
          storage.store(relative_path2, content2)
          storage.store(relative_path3, content3)

          storage.remove(parent_relative_path)

          expect { storage.retrieve(absolute_path1) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
          expect { storage.retrieve(absolute_path2) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
          expect(storage.retrieve(absolute_path3)).to(eq(content3))
        end

        it 'removes from contents passed at initialisation for path relative ' \
           'to base path when path holds content' do
          relative_path = 'path/to/secret'
          absolute_path = '/base/path/to/secret'
          base_path = '/base'
          content = 'its_a_secret'
          storage = described_class.new(
            contents: {
              relative_path => content
            },
            base_path: base_path
          )

          storage.remove(relative_path)

          expect { storage.retrieve(absolute_path) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
        end

        it 'removes from contents passed at initialisation for path relative ' \
           'to base path when path is a directory' do
          relative_path1 = 'path/to/secret1'
          relative_path2 = 'path/to/secret2'
          relative_path3 = 'other/secret'

          absolute_path1 = '/base/path/to/secret1'
          absolute_path2 = '/base/path/to/secret2'
          absolute_path3 = '/base/other/secret'

          content1 = 'supersecret1'
          content2 = 'supersecret2'
          content3 = 'supersecret3'

          base_path = '/base'

          parent_relative_path = 'path/to'

          storage = described_class.new(
            contents: {
              relative_path1 => content1,
              relative_path2 => content2,
              relative_path3 => content3
            },
            base_path: base_path
          )

          storage.remove(parent_relative_path)

          expect { storage.retrieve(absolute_path1) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
          expect { storage.retrieve(absolute_path2) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
          expect(storage.retrieve(absolute_path3)).to(eq(content3))
        end

        it 'raises a PathDoesNotExistError when the path is not present' do
          path = 'path/to/secret'
          base_path = '/base'
          storage = described_class.new(base_path: base_path)

          expect { storage.remove(path) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
        end
      end
    end

    context 'when path is absolute' do
      context 'when no base path' do
        it 'removes the content at the absolute path when path holds content' do
          absolute_path = '/path/to/secret'
          content = 'supersecret'
          storage = described_class.new

          storage.store(absolute_path, content)
          storage.remove(absolute_path)

          expect { storage.retrieve(absolute_path) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
        end

        it 'removes all subpaths when path is a directory' do
          absolute_path1 = '/path/to/secret1'
          absolute_path2 = '/path/to/secret2'
          absolute_path3 = '/other/secret'

          content1 = 'supersecret1'
          content2 = 'supersecret2'
          content3 = 'supersecret3'

          parent_absolute_path = '/path/to'

          storage = described_class.new

          storage.store(absolute_path1, content1)
          storage.store(absolute_path2, content2)
          storage.store(absolute_path3, content3)

          storage.remove(parent_absolute_path)

          expect { storage.retrieve(absolute_path1) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
          expect { storage.retrieve(absolute_path2) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
          expect(storage.retrieve(absolute_path3)).to(eq(content3))
        end

        it 'removes from contents passed at initialisation for absolute path ' \
           'when path holds content' do
          absolute_path = '/path/to/secret'
          content = 'its_a_secret'
          storage = described_class.new(
            contents: {
              absolute_path => content
            }
          )

          storage.remove(absolute_path)

          expect { storage.retrieve(absolute_path) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
        end

        it 'removes from contents passed at initialisation for absolute path ' \
           'when path is a directory' do
          absolute_path1 = '/path/to/secret1'
          absolute_path2 = '/path/to/secret2'
          absolute_path3 = '/other/secret'

          content1 = 'supersecret1'
          content2 = 'supersecret2'
          content3 = 'supersecret3'

          parent_absolute_path = 'path/to'

          storage = described_class.new(
            contents: {
              absolute_path1 => content1,
              absolute_path2 => content2,
              absolute_path3 => content3
            }
          )

          storage.remove(parent_absolute_path)

          expect { storage.retrieve(absolute_path1) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
          expect { storage.retrieve(absolute_path2) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
          expect(storage.retrieve(absolute_path3)).to(eq(content3))
        end

        it 'raises a PathDoesNotExistError when the path is not present' do
          path = '/path/to/secret'
          storage = described_class.new

          expect { storage.remove(path) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
        end
      end

      context 'when base path' do
        it 'removes the content at the path when path holds content' do
          absolute_path = '/base/path/to/secret'
          base_path = '/base'
          content = 'supersecret'
          storage = described_class.new(base_path: base_path)

          storage.store(absolute_path, content)
          storage.remove(absolute_path)

          expect { storage.retrieve(absolute_path) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
        end

        it 'removes all subpaths when path is a directory' do
          absolute_path1 = '/base/path/to/secret1'
          absolute_path2 = '/base/path/to/secret2'
          absolute_path3 = '/base/other/secret'

          base_path = '/base'

          content1 = 'supersecret1'
          content2 = 'supersecret2'
          content3 = 'supersecret3'

          parent_absolute_path = '/base/path/to'

          storage = described_class.new(base_path: base_path)

          storage.store(absolute_path1, content1)
          storage.store(absolute_path2, content2)
          storage.store(absolute_path3, content3)

          storage.remove(parent_absolute_path)

          expect { storage.retrieve(absolute_path1) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
          expect { storage.retrieve(absolute_path2) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
          expect(storage.retrieve(absolute_path3)).to(eq(content3))
        end

        it 'removes from contents passed at initialisation for path when ' \
           'path holds content' do
          absolute_path = '/base/path/to/secret'
          base_path = '/base'
          content = 'its_a_secret'
          storage = described_class.new(
            contents: {
              absolute_path => content
            },
            base_path: base_path
          )

          storage.remove(absolute_path)

          expect { storage.retrieve(absolute_path) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
        end

        it 'removes from contents passed at initialisation for path when ' \
           'path is a directory' do
          absolute_path1 = '/base/path/to/secret1'
          absolute_path2 = '/base/path/to/secret2'
          absolute_path3 = '/base/other/secret'

          content1 = 'supersecret1'
          content2 = 'supersecret2'
          content3 = 'supersecret3'

          base_path = '/base'

          parent_absolute_path = '/base/path/to'

          storage = described_class.new(
            contents: {
              absolute_path1 => content1,
              absolute_path2 => content2,
              absolute_path3 => content3
            },
            base_path: base_path
          )

          storage.remove(parent_absolute_path)

          expect { storage.retrieve(absolute_path1) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
          expect { storage.retrieve(absolute_path2) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
          expect(storage.retrieve(absolute_path3)).to(eq(content3))
        end

        it 'raises a PathDoesNotExistError when the path is not present' do
          path = '/base/path/to/secret'
          base_path = '/base'
          storage = described_class.new(base_path: base_path)

          expect { storage.remove(path) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
        end
      end
    end
  end

  describe '#retrieve' do
    context 'when path is relative' do
      context 'when no base path' do
        it 'retrieves contents at path relative to root when path holds ' \
           'content' do
          relative_path = 'path/to/secret'
          absolute_path = '/path/to/secret'
          content = 'supersecret'
          storage = described_class.new

          storage.store(absolute_path, content)

          expect(storage.retrieve(relative_path))
            .to(eq(content))
        end

        it 'raises a PathIsDirectoryError when path is a directory' do
          nested_path = '/path/to/secret/content'
          relative_path = 'path/to/secret'
          content = 'supersecret'
          storage = described_class.new

          storage.store(nested_path, content)

          expect { storage.retrieve(relative_path) }
            .to(raise_error(Larder::Errors::PathIsDirectoryError))
        end

        it 'retrieves from contents passed at initialisation for path ' \
           'relative to root when path holds content' do
          relative_path = 'path/to/secret'
          absolute_path = '/path/to/secret'
          content = 'its_a_secret'
          storage = described_class.new(
            contents: {
              absolute_path => content
            }
          )

          expect(storage.retrieve(relative_path)).to(eq(content))
        end

        it 'raises a PathIsDirectoryError when path is in contents passed ' \
           'at initialisation but is a directory' do
          nested_path = '/path/to/secret/content'
          relative_path = 'path/to/secret'
          content = 'supersecret'
          storage = described_class.new(
            contents: {
              nested_path => content
            }
          )

          expect { storage.retrieve(relative_path) }
            .to(raise_error(Larder::Errors::PathIsDirectoryError))
        end

        it 'raises a PathDoesNotExistError when the path is not present' do
          relative_path = 'path/to/secret'
          storage = described_class.new

          expect { storage.retrieve(relative_path) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
        end
      end

      context 'when base path' do
        it 'retrieves contents at path relative to base path when path holds ' \
           'content' do
          relative_path = 'path/to/secret'
          absolute_path = '/base/path/to/secret'
          base_path = '/base'
          content = 'supersecret'
          storage = described_class.new(base_path: base_path)

          storage.store(absolute_path, content)

          expect(storage.retrieve(relative_path))
            .to(eq(content))
        end

        it 'raises a PathIsDirectoryError when path is a directory' do
          nested_path = '/base/path/to/secret/content'
          relative_path = 'path/to/secret'
          base_path = '/base'
          content = 'supersecret'
          storage = described_class.new(base_path: base_path)

          storage.store(nested_path, content)

          expect { storage.retrieve(relative_path) }
            .to(raise_error(Larder::Errors::PathIsDirectoryError))
        end

        it 'retrieves from contents passed at initialisation for path ' \
           'relative to base path when path holds content' do
          relative_path = 'path/to/secret'
          absolute_path = '/base/path/to/secret'
          base_path = '/base'
          content = 'its_a_secret'
          storage = described_class.new(
            contents: {
              absolute_path => content
            },
            base_path: base_path
          )

          expect(storage.retrieve(relative_path)).to(eq(content))
        end

        it 'raises a PathIsDirectoryError when path is in contents passed ' \
           'at initialisation but is a directory' do
          nested_path = '/base/path/to/secret/content'
          relative_path = 'path/to/secret'
          base_path = '/base'
          content = 'supersecret'
          storage = described_class.new(
            contents: {
              nested_path => content
            },
            base_path: base_path
          )

          expect { storage.retrieve(relative_path) }
            .to(raise_error(Larder::Errors::PathIsDirectoryError))
        end

        it 'raises a PathDoesNotExistError when the path is not present' do
          relative_path = 'path/to/secret'
          base_path = '/base'
          storage = described_class.new(base_path: base_path)

          expect { storage.retrieve(relative_path) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
        end
      end
    end

    context 'when path is absolute' do
      context 'when no base path' do
        it 'retrieves contents at path when path holds content' do
          absolute_path = '/path/to/secret'
          content = 'supersecret'
          storage = described_class.new

          storage.store(absolute_path, content)

          expect(storage.retrieve(absolute_path))
            .to(eq(content))
        end

        it 'raises a PathIsDirectoryError when path is a directory' do
          nested_path = '/path/to/secret/content'
          absolute_path = '/path/to/secret'
          content = 'supersecret'
          storage = described_class.new

          storage.store(nested_path, content)

          expect { storage.retrieve(absolute_path) }
            .to(raise_error(Larder::Errors::PathIsDirectoryError))
        end

        it 'retrieves from contents passed at initialisation for path ' \
           'when path holds content' do
          absolute_path = '/path/to/secret'
          content = 'its_a_secret'
          storage = described_class.new(
            contents: {
              absolute_path => content
            }
          )

          expect(storage.retrieve(absolute_path)).to(eq(content))
        end

        it 'raises a PathIsDirectoryError when path is in contents passed ' \
           'at initialisation but is a directory' do
          nested_path = '/path/to/secret/content'
          absolute_path = '/path/to/secret'
          content = 'supersecret'
          storage = described_class.new(
            contents: {
              nested_path => content
            }
          )

          expect { storage.retrieve(absolute_path) }
            .to(raise_error(Larder::Errors::PathIsDirectoryError))
        end

        it 'raises a PathDoesNotExistError when the path is not present' do
          absolute_path = '/path/to/secret'
          storage = described_class.new

          expect { storage.retrieve(absolute_path) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
        end
      end

      context 'when base path' do
        it 'retrieves contents at path when path holds ' \
           'content' do
          absolute_path = '/base/path/to/secret'
          base_path = '/base'
          content = 'supersecret'
          storage = described_class.new(base_path: base_path)

          storage.store(absolute_path, content)

          expect(storage.retrieve(absolute_path))
            .to(eq(content))
        end

        it 'raises a PathIsDirectoryError when path is a directory' do
          nested_path = '/base/path/to/secret/content'
          absolute_path = '/base/path/to/secret'
          base_path = '/base'
          content = 'supersecret'
          storage = described_class.new(base_path: base_path)

          storage.store(nested_path, content)

          expect { storage.retrieve(absolute_path) }
            .to(raise_error(Larder::Errors::PathIsDirectoryError))
        end

        it 'retrieves from contents passed at initialisation for path ' \
           'when path holds content' do
          absolute_path = '/base/path/to/secret'
          base_path = '/base'
          content = 'its_a_secret'
          storage = described_class.new(
            contents: {
              absolute_path => content
            },
            base_path: base_path
          )

          expect(storage.retrieve(absolute_path)).to(eq(content))
        end

        it 'raises a PathIsDirectoryError when path is in contents passed ' \
           'at initialisation but is a directory' do
          nested_path = '/base/path/to/secret/content'
          absolute_path = '/base/path/to/secret'
          base_path = '/base'
          content = 'supersecret'
          storage = described_class.new(
            contents: {
              nested_path => content
            },
            base_path: base_path
          )

          expect { storage.retrieve(absolute_path) }
            .to(raise_error(Larder::Errors::PathIsDirectoryError))
        end

        it 'raises a PathDoesNotExistError when the path is not present' do
          absolute_path = '/base/path/to/secret'
          base_path = '/base'
          storage = described_class.new(base_path: base_path)

          expect { storage.retrieve(absolute_path) }.to(
            raise_error(Larder::Errors::PathDoesNotExistError)
          )
        end
      end
    end
  end
end
