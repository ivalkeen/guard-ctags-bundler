require "guard/ctags-bundler/ctags_generator"
require 'guard'
require 'guard/guard'
require 'bundler'
require 'bundler/runtime'

module Guard
  class CtagsBundler < Guard
    def initialize(watchers = [], options = {})
      super(watchers, options)
      @ctags_generator = ::Guard::Ctags::Bundler::CtagsGenerator.new(options)
    end

    def start
      UI.info 'Guard::CtagsBundler is running!'
      @ctags_generator.generate_bundler_tags
      @ctags_generator.generate_project_tags
    end

    def run_on_changes(paths)
      if paths.include?('Gemfile.lock')
        UI.info "regenerating bundler tags..."
        @ctags_generator.generate_bundler_tags
      end

      ruby_files = paths.reject {|f| f == 'Gemfile.lock'}

      if ruby_files.any?
        UI.info "regenerating project tags..."
        @ctags_generator.generate_project_tags
      end
    end
  end
end
