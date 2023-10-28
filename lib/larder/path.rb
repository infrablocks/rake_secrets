# frozen_string_literal: true

require 'pathname'

module Larder
  class Path
    def initialize(contents)
      @contents = clean(contents)
    end

    def join(other)
      self.class.new(to_pathname.join(other.to_s))
    end

    def ==(other)
      other.class == self.class && other.state == state
    end

    alias eql? ==

    def hash
      [self.class, state].hash
    end

    def to_s
      contents
    end

    protected

    def state
      [contents]
    end

    def to_pathname
      Pathname.new(contents)
    end

    private

    attr_reader :contents

    def clean(contents)
      Pathname.new(contents.to_s).cleanpath.to_s
    end
  end
end
