# frozen_string_literal: true

module Helpers
  module Fixtures
    PATH = File.join(
      Gem.loaded_specs['aws-lex-conversation'].full_gem_path,
      'spec',
      'fixtures'
    ).freeze

    def read_fixture(*path)
      File.read(File.join(PATH, *path))
    end

    def parse_fixture(*path)
      JSON.parse(read_fixture(*path))
    end
  end
end
