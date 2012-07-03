class Guard::Ctags::Bundler::CtagsGenerator
  def initialize(opts = {})
    @opts = opts
  end

  def generate_project_tags
    generate_tags(@opts[:src_path] || ".", "tags")
  end

  def generate_bundler_tags
    # this code doesn't work with recent bundler versions
    #definition = Bundler::Definition.build("Gemfile", "Gemfile.lock", nil)
    #runtime = Bundler::Runtime.new(Dir.pwd, definition)
    #paths = runtime.requested_specs.map(&:full_gem_path)
    #generate_tags(paths, "gems.tags")

    # this is ugly, but should work with every bundler version
    paths = `ruby -e "require('bundler'); puts(Bundler.load.specs.map(&:full_gem_path).join(' '))"`
    generate_tags(paths.strip, "gems.tags")
  end

  private

  def generate_tags(path, tag_file)
    if path.instance_of?(Array)
      path = path.join(' ').strip
    end

    cmd = "find #{path} -type f -name \\*.rb | ctags -f #{tag_file} -L -"
    cmd << " -e" if @opts[:emacs]
    system(cmd)
    system("cat tags gems.tags > TAGS") if @opts[:emacs]
  end
end
