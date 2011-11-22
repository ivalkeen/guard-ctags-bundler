require "guard/ctags-bundler/version"
require 'guard'
require 'guard/guard'
require 'bundler'
require 'bundler/runtime'

module Guard
  class CtagsBundler < Guard
    def initialize(watchers = [], options = {})
      super(watchers, options)
    end

    def start
      UI.info 'Guard::CtagsBundler is running!'
    end

    def run_on_change(paths)
      if paths.include?('Gemfile.lock')
        UI.info "regenerating bundler tags..."
        generate_bundler_tags
      end
      ruby_files = paths.reject {|f| f == 'Gemfile.lock'}
      if ruby_files.any?
        UI.info "regenerating project tags..."
        generate_project_tags(ruby_files)
      end
    end

    private

    def generate_project_tags(paths)
      system("ctags -f tags #{paths.join(' ')}")
    end

    def generate_bundler_tags
      runtime = Bundler::Runtime.new Dir.pwd, Bundler.definition(true)
      paths = runtime.specs.map(&:full_gem_path).join(' ')
      system("find #{paths.strip} -type f -name \\*.rb | ctags -f gems.tags -L -")
    end
  end
end
