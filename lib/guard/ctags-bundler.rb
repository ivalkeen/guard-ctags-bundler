require 'guard/compat/plugin'

module Guard
  class CtagsBundler < Plugin
    autoload 'CtagsGenerator', 'guard/ctags-bundler/ctags_generator'

    def initialize(options = {})
      super
      @ctags_generator = ::Guard::CtagsBundler::CtagsGenerator.new(options)
    end

    def start
      UI.info 'Guard::CtagsBundler is running!'
      @ctags_generator.generate_bundler_tags
      @ctags_generator.generate_project_tags
      @ctags_generator.generate_stdlib_tags if options[:stdlib]
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

    def self.add_callback(*args)
      ::Guard::Plugin::Hooker.add_callback(*args)
    end

    def self.template(plugin_location)
      File.read(template_path(plugin_location))
    end

    def self.template_path(plugin_location)
      File.join(plugin_location, 'lib', 'guard', 'ctags-bundler', 'templates', 'Guardfile')
    end
  end
end
