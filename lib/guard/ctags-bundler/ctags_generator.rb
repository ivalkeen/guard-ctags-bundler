require 'rbconfig'
require 'bundler'
require 'bundler/runtime'

module Guard
  class CtagsBundler
    class CtagsGenerator
      def initialize(opts = {})
        @opts = opts
      end

      def generate_project_tags
        generate_tags(@opts[:src_path] || ".", custom_path_for("tags"))
      end

      def generate_bundler_tags
        ::Bundler.configure # in case we're not running guard from inside Bundler
        definition = ::Bundler::Definition.build("Gemfile", "Gemfile.lock", nil)
        runtime = ::Bundler::Runtime.new(Dir.pwd, definition)
        paths = runtime.requested_specs.map(&:full_gem_path)
        generate_tags(paths, custom_path_for("gems.tags") )
      end

      def generate_stdlib_tags
        generate_tags(stdlib_path, custom_path_for("stdlib.tags"))
      end

      private

      def generate_tags(path, tag_file)
        if path.instance_of?(Array)
          path = path.join(' ').strip
        end
        system("mkdir -p ./#{@opts[:custom_path]}") if @opts[:custom_path]
        cmd = "find #{path} -type f -name \\*.rb | ctags -f #{tag_file} -L -"
        cmd << " -e" if @opts[:emacs]
        system(cmd)
        if @opts[:emacs]
          if @opts[:stdlib]
            system("cat #{custom_path_for("tags")} #{custom_path_for("gems.tags")} #{custom_path_for("stdlib.tags")} > TAGS")
          else
            system("cat #{custom_path_for("tags")} #{custom_path_for("gems.tags")} > TAGS")
          end
        end
      end

      def custom_path_for(file)
        if @opts[:custom_path]
          return "./#{@opts[:custom_path]}/#{file}"
        else
          return file
        end
      end

      def stdlib_path
        # hack for rubinius, as it breaks MRI and JRuby directory structure
        if defined?(RUBY_ENGINE) && RUBY_ENGINE == "rbx"
          RbConfig::CONFIG['libdir']
        else
          RbConfig::CONFIG['rubylibdir']
        end
      end
    end
  end
end
