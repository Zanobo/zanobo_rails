source 'https://rubygems.org'

# Declare your gem's dependencies in zanobo_rails.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]


#
# = Asset compilation
#
# Note the "staging" env used to keep asset comp gems out of memory
#
group :development, :test, :staging do

  # Stylesheet Assets
  gem 'sass-rails', '~> 5.0'          # Sass compiler
  gem 'bootstrap-sass', '~> 3.3.3'
  gem 'font-awesome-rails'            # FA icons

  # Javascript Assets
  gem 'coffee-script-source', '1.8.0' # normally 1.9 loaded by coffee-rails, but fixes regression error https://github.com/josh/ruby-coffee-script/issues/31
  gem 'coffee-rails', '~> 4.1.0'      # CoffeeScript compiler

end
