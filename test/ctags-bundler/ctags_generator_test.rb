require 'test_helper'

require 'guard/ctags-bundler/ctags_generator'

class CtagsGeneratorTest < MiniTest::Unit::TestCase
  def setup
    @oldpath = Dir.pwd
    Dir.chdir(test_project_path)
  end

  def teardown
    Dir.chdir(@oldpath)
    clean_tags
  end

  def test_generate_project_tags
    generator.generate_project_tags
    assert File.exists?(test_tags_file)
  end

  def test_generate_project_tags_for_src_path_only
    generator(:src_path => ["app", "lib"]).generate_project_tags
    result = File.read(test_tags_file)
    assert_match("method_of_class_1", result)
    assert_match("method_of_class_2", result)
    refute_match("method_of_class_3", result)
    refute_match("Rake", result)
  end

  def test_generate_bundler_tags
    generator.generate_bundler_tags
    assert File.exists?(test_gems_tags_file)
    result = File.read(test_gems_tags_file)
    assert_match("Rake", result)
    refute_match("method_of_class_1", result)
    refute_match("method_of_class_2", result)
    refute_match("method_of_class_3", result)
  end

  def test_generate_stdlib_tags
    generator.generate_stdlib_tags
    assert File.exists?(test_stdlib_tags_file)
    result = File.read(test_stdlib_tags_file)
    assert_match("DateTime", result)
    assert_match("YAML", result)
    refute_match("method_of_class_1", result)
    refute_match("method_of_class_2", result)
    refute_match("method_of_class_3", result)
  end

  private

  def generator(opts = {})
    ::Guard::CtagsBundler::CtagsGenerator.new(opts)
  end
end
