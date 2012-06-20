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

    def run_on_changes(paths)
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
      generate_tags(paths, "tags")
    end

    def generate_bundler_tags
      runtime = ::Bundler::Runtime.new Dir.pwd, ::Bundler.definition
      paths = runtime.specs.map(&:full_gem_path)
      generate_tags(paths, "gems.tags")
    end

    def generate_tags(paths, tag_file)
      paths = paths.join(' ').strip
      cmd = "find #{paths} -type f -name \\*.rb | ctags -f #{tag_file} -L -"
      cmd << " -e" if options[:emacs]
      system(cmd)
    end
  end
end
