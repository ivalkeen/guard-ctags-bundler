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
        generate_tags(@opts[:src_path] || ".", "tags")
      end

      def generate_bundler_tags
        ::Bundler.configure # in case we're not running guard from inside Bundler
        definition = ::Bundler::Definition.build("Gemfile", "Gemfile.lock", nil)
        runtime = ::Bundler::Runtime.new(Dir.pwd, definition)
        paths = runtime.requested_specs.map(&:full_gem_path)
        generate_tags(paths, "gems.tags")
      end

      def generate_stdlib_tags
        generate_tags(RbConfig::CONFIG['libdir'], "stdlib.tags")
      end

      private

      def generate_tags(path, tag_file)
        if path.instance_of?(Array)
          path = path.join(' ').strip
        end

        cmd = "find #{path} -type f -name \\*.rb | ctags -f #{tag_file} -L -"
        cmd << " -e" if @opts[:emacs]
        system(cmd)
        if @opts[:emacs]
          if @opts[:stdlib]
            system("cat tags gems.tags stdlib.tags > TAGS")
          else
            system("cat tags gems.tags > TAGS")
          end
        end
      end
    end
  end
end
