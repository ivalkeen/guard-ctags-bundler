require "guard/ctags-bundler/version"
require 'guard'
require 'guard/guard'
require 'rubygems'

module Guard
  class CtagsBundler < Guard
    BUNDLER = "__bundler__"

    def initialize(watchers = [], options = {})
      super(watchers, options)
    end

    def start
      UI.info 'Guard::CtagsBundler is running!'
    end

    def run_on_change(paths)
      if paths == [BUNDLER]
        UI.info "regenerating bundler tags..."
        generate_bundler_tags
      else 
        UI.info "regenerating project tags..."
        generate_project_tags(paths)
      end
    end

    private

    def generate_project_tags(paths)
      Thread.new do
        system("find #{paths.join(' ')} -type f -name \\*.rb | ctags -f tags -L -")
      end
    end

    def generate_bundler_tags
      Thread.new do
        paths = `ruby -e "require('bundler'); puts(Bundler.load.specs.map(&:full_gem_path).join(' '))"`
        system("find #{paths.strip} -type f -name \\*.rb | ctags -f gems.tags -L -")
      end
    end
  end
end
