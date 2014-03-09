require 'test_helper'

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

  def test_non_namespaced_classname
    assert_equal 'CtagsBundler', @plugin.class.non_namespaced_classname
  end

  def test_non_namespaced_name
    assert_equal 'ctagsbundler', @plugin.class.non_namespaced_name
  end

  def test_name
    assert_equal 'ctagsbundler', @plugin.name
  end

  def test_title
    assert_equal 'CtagsBundler', @plugin.title
  end
end
