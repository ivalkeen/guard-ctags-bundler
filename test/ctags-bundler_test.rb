require 'test_helper'

require 'guard/compat/test/helper'

require 'guard/ctags-bundler'

class CtagsBundlerTest < MiniTest::Unit::TestCase
  def setup
    @plugin = Guard::CtagsBundler.new
    @gem_root_path = File.expand_path(File.join('..', '..'), __FILE__)
    template_path = File.join('..', '..', 'lib', 'guard', 'ctags-bundler', 'templates', 'Guardfile')
    @template_path = File.expand_path(template_path, __FILE__)
  end

  def test_template_path
    assert_equal @template_path, @plugin.class.template_path(@gem_root_path)
  end

  def test_template
    template = File.read(@template_path)
    assert_equal template, @plugin.class.template(@gem_root_path)
  end
end
