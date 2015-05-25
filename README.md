# Guard-CTags-Bundler

[![Build Status](https://secure.travis-ci.org/ivalkeen/guard-ctags-bundler.png)](http://travis-ci.org/ivalkeen/guard-ctags-bundler)

Guard-CTags-Bundler generates [ctags](http://ctags.sourceforge.net) for your project and for gems in your bundle. For project tags file `tags` is generated, for gems tags file `gems.tags` is generated.

Features
-

* Initially developed for Rails projects, but theoretically can be used with any ruby project, that uses Bundler, with minimal configuration changes.
* When you run `bundle install` in your project, `gems.tags` file is automatically is generated or updated.
* When you save one of you project's ruby files, `tags` file is automatically generated or updated.
* Only Linux is tested, but probably will work on Mac

## Install

Make sure you have [Guard](http://github.com/guard/guard) installed.

Install the gem:

    $ gem install guard-ctags-bundler

Add it to your `Gemfile` (inside development group):

    gem 'guard-ctags-bundler'

And then add a basic setup to your `Guardfile`:

    $ guard init ctags-bundler

## Usage

Please, read [Guard usage doc](https://github.com/guard/guard#readme)

## Guardfile Options

``` ruby
:src_path => ".", # source path to be scanned for tags (default .)
:emacs => false, # run ctags in emacs mode and merge tags and gems.tags into TAGS file
:stdlib => true, # run ctags for core and stdlib, generating stdlib.tags (default false)
:binary => 'ctags-exuberant' # name of the ctags binary (default ctags)
:arguments => '-R --languages=ruby --fields=+l' # change the arguments passed to ctags (default '-R --languages=ruby')
:stdlib_file => "stdlib.tags" # name of tags file for stdlib references (default stdlib.tags)
:bundler_tags_file => "gems.tags" # name of tags file for bundler gems references (default gems.tags)
:project_file => "tags" # name of tags file for project references (default tags)
:gemfile => "Gemfil" # name of tags file for project references (default 'Gemfile')
```

For a typical Rails application, `Guardfile` can look like this (default):

    guard 'ctags-bundler', :src_path => ["app", "lib", "spec/support"] do
      watch(/^(app|lib|spec\/support)\/.*\.rb$/)
      watch('Gemfile.lock')
    end

## CTags

[Ctags](http://ctags.sourceforge.net) generates an index (or tag) file of language objects found in source files that allows these items to be quickly and easily located by a text editor or other utility. A tag signifies a language object for which an index entry is available (or, alternatively, the index entry created for that object).

In ubuntu you can install ctags by running

    $ sudo apt-get install exuberant-ctags

## Vim

Vim supports ctags by default. All you need to do is add your `gems.tags` file to the Vim's tag stack.

    set tags+=gems.tags

## Emacs

Ctags can be used with emacs too. Add `:emacs => true` option to your Guardfile and ctags will be generated with `-e` option:

    guard 'ctags-bundler', :emacs => true, :src_path => ["app", "lib", "spec/support"] do
      watch(/^(app|lib|spec\/support)\/.*\.rb$/)
      watch('Gemfile.lock')
    end

Thanks to [Jorge Dias](https://github.com/diasjorge) and [Antono Vasiljev](https://github.com/antono) for emacs support.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Self-Promotion

If you like this project, please follow the repository on [GitHub](https://github.com/ivalkeen/guard-ctags-bundler). You can also consider visiting my [blog](http://www.tkalin.com) and following me on [Twitter](https://twitter.com/ivalkeen) and [Github](https://github.com/ivalkeen).

