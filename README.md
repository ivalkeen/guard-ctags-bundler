Guard-CTags-Bundler
=====

Guard-CTags-Bundler generates [ctags](http://ctags.sourceforge.net) for your project and for gems in your bundle. For project tags file `tags` is generated, for gems tags file `gems.tags` is generated.

When you run `bundle install` in your project, `gems.tags` file is automatically is generated or updated. When you save one of you project files, `tags` file is automatically generated or updated.

## Install

Make sure you have [Guard](http://github.com/guard/guard) installed.

Install the gem:

    $ gem install guard-ctags-bundler

Add it to your `Gemfile` (inside development group):

    gem 'guard-ctags-bundler'

And then add a basic setup to your `Guardfile`:

    $ guard init ctags-bundler


## CTags

[Ctags](http://ctags.sourceforge.net) generates an index (or tag) file of language objects found in source files that allows these items to be quickly and easily located by a text editor or other utility. A tag signifies a language object for which an index entry is available (or, alternatively, the index entry created for that object). 

In ubuntu you can install ctags by running

    $ sudo apt-get install exuberant-ctags

## Vim

Vim supports ctags by default. All you need to do is add your `gems.tags` file to the Vim's tag stack.

    set tags+=gems.tags
