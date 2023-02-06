# frozen_string_literal: true

require 'spec_helper'

describe RakeSecrets::Tasks::Placeholder do
  include_context 'rake'

  def define_task(opts = {}, &block)
    opts = { namespace: :secrets }.merge(opts)

    namespace opts[:namespace] do
      subject.define(opts, &block)
    end
  end

  it 'adds a placeholder task in the namespace in which it is created' do
    define_task

    expect(Rake.application)
      .to(have_task_defined('secrets:placeholder'))
  end

  it 'gives the task a description' do
    define_task

    expect(Rake::Task['secrets:placeholder'].full_comment)
      .to(eq('Create a placeholder secrets for testing access etc.'))
  end

  it 'allows multiple placeholder tasks to be declared' do
    define_task(namespace: :secrets1)
    define_task(namespace: :secrets2)

    expect(Rake.application).to(have_task_defined('secrets1:placeholder'))
    expect(Rake.application).to(have_task_defined('secrets2:placeholder'))
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
