# frozen_string_literal: true

require 'spec_helper'

describe RakeSecrets::Tasks::Generate do
  include_context 'rake'

  def define_task(opts = {}, &block)
    opts = { namespace: :secrets }.merge(opts)

    namespace opts[:namespace] do
      subject.define(opts, &block)
    end
  end

  it 'adds a generate task in the namespace in which it is created' do
    define_task(id: 'database_password')

    expect(Rake.application)
      .to(have_task_defined('secrets:generate'))
  end

  it 'gives the task a description' do
    define_task(id: 'database_password')

    expect(Rake::Task['secrets:generate'].full_comment)
      .to(eq("Generates and stores the 'database_password' secret."))
  end

  it 'allows multiple generate tasks to be declared' do
    define_task(
      namespace: :secrets1,
      id: 'database_password'
    )
    define_task(
      namespace: :secrets2,
      id: 'database_password'
    )

    expect(Rake.application).to(have_task_defined('secrets1:generate'))
    expect(Rake.application).to(have_task_defined('secrets2:generate'))
  end

  describe 'by default' do
    it 'generates a value based on the specification and stores using ' \
       'the supplied storage backend' do
      specification = RakeSecrets::Types.constant('supersecret')
      backend = RakeSecrets::Storage.in_memory

      stub_output

      define_task(
        id: 'database_password',
        path: 'secrets/database/password',
        specification: specification,
        backend: backend
      )

      Rake::Task['secrets:generate'].invoke

      expect(backend.get('secrets/database/password'))
        .to(eq('supersecret'))
    end
  end

  describe 'when transformer provided' do
    it 'uses the transformer on the generated value before storing' do
      specification = RakeSecrets::Types.constant('supersecret')
      backend = RakeSecrets::Storage.in_memory
      transformer = RakeSecrets::Transformers.erb_template(
        content: "---\ndatabase_password: \"<%= @value %>\"\n"
      )

      stub_output

      define_task(
        id: 'database_password',
        path: 'secrets/database/password',
        specification: specification,
        transformer: transformer,
        backend: backend
      )

      Rake::Task['secrets:generate'].invoke

      expect(backend.get('secrets/database/password'))
        .to(eq("---\ndatabase_password: \"supersecret\"\n"))
    end
  end

  def stub_output
    # rubocop:disable RSpec/AnyInstance
    %i[print puts].each do |method|
      allow_any_instance_of(Kernel).to(receive(method))
      allow($stdout).to(receive(method))
      allow($stderr).to(receive(method))
    end
    # rubocop:enable RSpec/AnyInstance
  end
end
