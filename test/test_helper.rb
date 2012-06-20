require 'minitest/autorun'
require 'purdytest'

def test_project_path
  File.expand_path("test_project", File.dirname(__FILE__))
end

def test_tags_file
  File.join(test_project_path, "tags")
end

def test_gems_tags_file
  File.join(test_project_path, "gems.tags")
end

def clean_tags
  [test_tags_file, test_gems_tags_file].each do |file|
    File.delete(file) if File.exists?(file)
  end
end
