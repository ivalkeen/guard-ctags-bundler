require 'rbconfig'
#require 'bundler'
#require 'bundler/runtime'

module Guard
  class CtagsBundler < Plugin
    class CtagsGenerator
      def initialize(opts = {})
        @opts = opts
      end

      def generate_project_tags
        generate_tags(@opts[:src_path] || ".", custom_path_for(@opts.fetch(:project_file, "tags")))
      end

      def generate_bundler_tags
        # FIXME: Using bundler API cases issues when guard is executed in the non-bundler environment
        #::Bundler.configure # in case we're not running guard from inside Bundler
        #definition = ::Bundler::Definition.build("Gemfile", "Gemfile.lock", nil)
        #runtime = ::Bundler::Runtime.new(Dir.pwd, definition)
        #paths = runtime.requested_specs.map(&:full_gem_path)

        gemfile = @opts.fetch(:gemfile, 'Gemfile')
        lockfile = "#{gemfile}.lock"
        # this is ugly, but should work with every bundler version
        cmd = <<-CMD
          require('bundler')
          require('bundler/runtime')
          ::Bundler.configure
          definition = ::Bundler::Definition.build('#{gemfile}', '#{lockfile}', nil)
          runtime = ::Bundler::Runtime.new(Dir.pwd, definition)
          paths = runtime.requested_specs.map(&:full_gem_path)
          puts(paths.join(' '))
        CMD
        paths = `ruby -e "#{cmd}"`

        generate_tags(paths.strip, custom_path_for(@opts.fetch(:bundler_tags_file, "gems.tags")))
      end

      def generate_stdlib_tags
        generate_tags(stdlib_path, custom_path_for(@opts.fetch(:stdlib_file, "stdlib.tags")))
      end

      private

      def generate_tags(path, tag_file)
        if path.instance_of?(Array)
          path = path.join(' ').strip
        end
        system("mkdir -p ./#{@opts[:custom_path]}") if @opts[:custom_path]
        cmd = "#{@opts[:binary] || 'ctags'} -f #{tag_file} #{@opts[:arguments] || '-R --languages=ruby'} --exclude='.#*'"
        cmd << " -e" if @opts[:emacs]
        cmd << " #{path}"
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
